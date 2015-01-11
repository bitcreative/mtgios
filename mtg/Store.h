//
//  Store.h
//  mtg
//
//  Created by Omar Estrella on 1/3/15.
//  Copyright (c) 2015 Omar Estrella. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CloudKit/CloudKit.h>

#import <PromiseKit.h>
#import <AFNetworking+PromiseKit.h>

static NSString *const FavoritesRecordType = @"Favorites";

static NSString *const NotificationFavoritesUpdated = @"FavoritesUpdated";

@interface Store : NSObject

@property (nonatomic) CKAccountStatus status;

+ (Store *)sharedStore;

- (void)loadData;

- (NSArray *)sets;
- (NSDictionary *)setWithName:(NSString *)set;
- (NSURL *)imageURLForSet:(NSString *)set;
- (NSURL *)imageURLForCard:(NSDictionary *)card inSet:(NSDictionary *)set;

- (PMKPromise *)pricesForCard:(NSDictionary *)card inSet:(NSDictionary *)set;
- (PMKPromise *)addFavoriteCard:(NSDictionary *)card;
- (PMKPromise *)removeFavoriteCard:(NSDictionary *)card;
- (BOOL)isCardFavorite:(NSDictionary *)card;
- (NSArray *)favorites;

- (NSDictionary *)cardWithMultiverseId:(NSString *)id;
- (NSArray *)cardsForSet:(NSString *)set;
- (NSDictionary *)setForCard:(NSDictionary *)card;
- (NSDictionary *)setForCardMultiverseId:(NSString *)id;

- (NSNumber *)totalCards;

@end
