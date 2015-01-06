//
//  Store.h
//  mtg
//
//  Created by Omar Estrella on 1/3/15.
//  Copyright (c) 2015 Omar Estrella. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Store : NSObject

+ (Store *)sharedStore;

- (void)loadData;

- (NSArray *)sets;
- (NSDictionary *)setWithName:(NSString *)set;
- (NSURL *)imageURLForSet:(NSString *)set;
- (NSArray *)cardsForSet:(NSString *)set;
- (NSURL *)imageURLForCard:(NSDictionary *)card inSet:(NSDictionary *)set;

- (NSNumber *)totalCards;

@end
