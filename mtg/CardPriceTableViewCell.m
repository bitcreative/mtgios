//
//  CardPriceTableViewCell.m
//  mtg
//
//  Created by Omar Estrella on 1/8/15.
//  Copyright (c) 2015 Omar Estrella. All rights reserved.
//

#import "CardPriceTableViewCell.h"
#import "Store.h"

@implementation CardPriceTableViewCell

- (void)setupForCard:(NSDictionary *)card inSet:(NSDictionary *)set {
    [[Store sharedStore] pricesForCard:card inSet:set].then(^(NSArray *prices) {
        NSLog(@"prices: %@", prices);

    });
}

@end
