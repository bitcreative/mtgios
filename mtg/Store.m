//
//  Store.m
//  mtg
//
//  Created by Omar Estrella on 1/3/15.
//  Copyright (c) 2015 Omar Estrella. All rights reserved.
//

#import <Underscore.h>
#import <TFHpple.h>

#import "Store.h"
#import "Promise.h"

#define _ Underscore

@implementation Store {
@private
    NSDictionary *cards;
    NSMutableArray *favorites;
    CKDatabase *privateDatabase;
}

+ (Store *)sharedStore {
    static Store *sharedStore = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedStore = [self new];
    });
    return sharedStore;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        CKContainer *container = [CKContainer defaultContainer];
        [container accountStatusWithCompletionHandler:^(CKAccountStatus status, NSError *error) {
            if (error) {
                NSLog(@"%@", [error localizedDescription]);
            }

            NSLog(@"status: %d", status);

            self.status = status;

            privateDatabase = [container privateCloudDatabase];

            [self setupSubscribe];
            [self loadFavorites];
        }];
    }
    return self;
}

- (void)loadData {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"AllSets" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    cards = _.dict(dict).filterValues(^(NSDictionary *set) {
        NSString *type = set[@"type"];
        return (BOOL) ([type isEqualToString:@"expansion"] || [type isEqualToString:@"core"]);
    }).unwrap;
}

- (void)loadFavorites {
    NSPredicate *predicate = [NSPredicate predicateWithValue:YES];
    CKQuery *query = [[CKQuery alloc] initWithRecordType:FavoritesRecordType predicate:predicate];
    [privateDatabase performQuery:query
                     inZoneWithID:nil
                completionHandler:^(NSArray *records, NSError *error) {
                    if (error) {
                        NSLog(@"%@", [error localizedDescription]);
                    } else {
                        NSLog(@"%@", records);
                        favorites = _.array(records).map(^(CKRecord *record) {
                            return [record.recordID recordName];
                        }).unwrap.mutableCopy;
                    }
                }];
}

- (void)setupSubscribe {
    CKSubscription *favoritesSubscription = [[CKSubscription alloc]
            initWithRecordType:FavoritesRecordType
                     predicate:[NSPredicate predicateWithValue:YES]
                       options:CKSubscriptionOptionsFiresOnRecordCreation | CKSubscriptionOptionsFiresOnRecordDeletion];

    [privateDatabase saveSubscription:favoritesSubscription
                    completionHandler:^(CKSubscription *subscription, NSError *error) {
                        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
                        if (subscription) {
                            dict[@"subscription"] = subscription;
                        }
                        if (error) {
                            dict[@"error"] = error;
                        }
                        [[NSNotificationCenter defaultCenter]
                                postNotificationName:NotificationFavoritesUpdated
                                              object:self
                                            userInfo:dict];
                    }];
}

- (NSArray *)sets {
    return _.array([cards allValues]).sort(^(NSDictionary *a, NSDictionary *b) {
        return [a[@"name"] localizedCompare:b[@"name"]];
    }).map(^(NSDictionary *set) {
        return set[@"code"];
    }).unwrap;

}

- (NSDictionary *)setWithName:(NSString *)set {
    return cards[set];
}

- (NSURL *)imageURLForSet:(NSString *)set {
    NSString *url = [NSString stringWithFormat:@"http://mtgimage.com/symbol/set/%@/c/256.gif", [set lowercaseString]];
    return [NSURL URLWithString:url];
}

- (NSURL *)imageURLForCard:(NSDictionary *)card inSet:(NSDictionary *)set {
    NSString *url = [NSString stringWithFormat:@"http://mtgimage.com/set/%@/%@.jpg", set[@"code"], card[@"name"]];
    return [NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
}

- (PMKPromise *)pricesForCard:(NSDictionary *)card inSet:(NSDictionary *)set {
    NSString *setCode = set[@"code"];

    NSString *setName = set[@"name"];
    setName = [[setName stringByReplacingOccurrencesOfString:@" " withString:@"-"] lowercaseString];

    NSString *cardName = card[@"name"];
    cardName = [[cardName stringByReplacingOccurrencesOfString:@" " withString:@"-"] lowercaseString];

    NSString *urlString = [NSString stringWithFormat:@"http://shop.tcgplayer.com/magic/%@/%@", setName, cardName];

    return [PMKPromise new:^(PMKPromiseFulfiller fulfill, PMKPromiseRejecter reject) {
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        [manager GET:urlString parameters:nil
             success:^(AFHTTPRequestOperation *operation, NSData *data) {
//                 TFHpple *parser = [TFHpple hppleWithHTMLData:data];
//                 NSString *high = @"//p[@class='high']|p[@class='median']|p[@class='low']";
//                 NSString *median = @"//p[@class='median']";
//                 NSString *low = @"//p[@class='low']";
//
//                 NSArray *highNodes = [parser searchWithXPathQuery:high];
//                 NSArray *medianNodes = [parser searchWithXPathQuery:median];
//                 NSArray *lowNodes = [parser searchWithXPathQuery:low];
//
//                 NSArray *array = _.array(lowNodes).zipWith(medianNodes, ^(TFHppleElement *one, TFHppleElement *two) {
//                     NSMutableArray *mutableArray = [@[] mutableCopy];
//                     [mutableArray addObjectsFromArray:@[one.text, two.text]];
//                     return mutableArray;
//                 }).zipWith(highNodes, ^(NSArray *currentArray, TFHppleElement *two) {
//                     NSMutableArray *mutableArray = [currentArray mutableCopy];
//                     [mutableArray addObject:two.text];
//                     NSLog(@"%@", mutableArray);
//                     return mutableArray;
//                 }).unwrap;

                 NSArray *array = @[
                         @[@"Low: $0.00", @"Median: $1.00", @"High: $3.00"],
                         @[@"Low: $2.00", @"Median: $3.00", @"High: $6.00"]
                 ];

                 fulfill(array);
             }
             failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                 reject(nil);
             }];
    }];
}

- (PMKPromise *)addFavoriteCard:(NSDictionary *)card {
    NSNumber *multiverseid = card[@"multiverseid"];
    CKRecordID *recordId = [[CKRecordID alloc] initWithRecordName:multiverseid.stringValue];
    CKRecord *record = [[CKRecord alloc] initWithRecordType:FavoritesRecordType recordID:recordId];
    record[@"name"] = card[@"name"];
    return [PMKPromise new:^(PMKPromiseFulfiller fulfill, PMKPromiseRejecter reject) {
        [privateDatabase saveRecord:record completionHandler:^(CKRecord *savedRecord, NSError *error) {
            if (error) {
                NSLog(@"%@", [error localizedDescription]);
                reject(error);
            } else {
                NSLog(@"Saved record");
                [favorites addObject:multiverseid.stringValue];
                fulfill(savedRecord);
            }
        }];
    }];
}

- (PMKPromise *)removeFavoriteCard:(NSDictionary *)card {
    NSNumber *multiverseid = card[@"multiverseid"];
    CKRecordID *recordId = [[CKRecordID alloc] initWithRecordName:multiverseid.stringValue];
    return [PMKPromise new:^(PMKPromiseFulfiller fulfill, PMKPromiseRejecter reject) {
        [privateDatabase deleteRecordWithID:recordId
                          completionHandler:^(CKRecordID *deletedRecordId, NSError *error) {
                              if (error) {
                                  NSLog(@"%@", [error localizedDescription]);
                                  reject(error);
                              } else {
                                  NSLog(@"Removed favorite");
                                  [favorites removeObject:multiverseid.stringValue];
                                  fulfill(deletedRecordId);
                              }
                          }];
    }];
}

- (BOOL)isCardFavorite:(NSDictionary *)card {
    NSNumber *multiverseid = card[@"multiverseid"];
    CKRecordID *recordId = [[CKRecordID alloc] initWithRecordName:multiverseid.stringValue];
    [privateDatabase fetchRecordWithID:recordId completionHandler:^(CKRecord *record, NSError *error) {
        if (error) {
            NSLog(@"%@", [error localizedDescription]);
        } else {
            if (![favorites containsObject:multiverseid.stringValue]) {
                [favorites addObject:multiverseid];
            }
        }
    }];
    return [favorites containsObject:multiverseid.stringValue];
}

- (NSArray *)cardsForSet:(NSString *)set {
    return cards[set][@"cards"];
}

- (NSNumber *)totalCards {
    return _.dict(cards).values.map(^(NSDictionary *set) {
        return set[@"cards"];
    }).reduce(@0, ^(NSNumber *curr, NSArray *setCards) {
        return @(curr.integerValue + setCards.count);
    });
}

- (NSArray *)priceNodeValues:(NSArray *)nodes {
    return _.array(nodes).map(^(TFHppleElement *elem) {
        return elem.text;
    }).unwrap;
}

@end
