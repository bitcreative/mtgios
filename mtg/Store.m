//
//  Store.m
//  mtg
//
//  Created by Omar Estrella on 1/3/15.
//  Copyright (c) 2015 Omar Estrella. All rights reserved.
//

#import <Underscore.h>

#import "Store.h"

#define _ Underscore

@implementation Store {
    @private
    NSDictionary *cards;
}

+ (Store *)sharedStore {
    static Store *sharedStore = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedStore = [self new];
    });
    return sharedStore;
}

- (void)loadData {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"AllSets" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    cards = _.dict(dict).filterValues(^(NSDictionary *set) {
        NSString *type = set[@"type"];
        return (BOOL)([type isEqualToString:@"expansion"] || [type isEqualToString:@"core"]);
    }).unwrap;
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

@end
