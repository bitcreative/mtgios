//
//  CardPriceTableViewCell.m
//  mtg
//
//  Created by Omar Estrella on 1/8/15.
//  Copyright (c) 2015 Omar Estrella. All rights reserved.
//

#import "CardPriceTableViewCell.h"
#import "Store.h"
#import "PriceView.h"

@implementation CardPriceTableViewCell

- (void)setupForCard:(NSDictionary *)card inSet:(NSDictionary *)set {
    NSArray *colors = @[
            [UIColor colorWithRed:0.602 green:0.797 blue:0.614 alpha:1.000],
            [UIColor colorWithRed:0.589 green:0.648 blue:0.856 alpha:1.000],
            [UIColor colorWithRed:0.883 green:0.553 blue:0.512 alpha:1.000]
    ];

    [[Store sharedStore] pricesForCard:card inSet:set].then(^(NSArray *prices) {
        NSArray *normal = prices.firstObject;
        NSArray *foil = prices.lastObject;

        CGFloat centerOffset = 20;
        CGFloat spacing = 20;
        CGFloat priceWidth = (CGRectGetWidth(self.contentView.frame) / 3) - spacing;
        CGFloat priceHeight = CGRectGetHeight(self.contentView.frame) - centerOffset;
        NSInteger count = 0;

        for (NSString *value in normal) {
            PriceView *price = [[[NSBundle mainBundle] loadNibNamed:@"PriceView" owner:self options:nil] firstObject];
            price.backgroundColor = colors[(uint)count];
            price.priceLabel.text = value;

            price.layer.cornerRadius = 4;
            price.layer.masksToBounds = YES;

//            (screensize - 3 * width) / 4
            price.frame = CGRectMake((priceWidth + spacing) * count + (spacing / 2), centerOffset / 2,
                    priceWidth, priceHeight);

            count += 1;

            [self.contentView addSubview:price];
        }

        [self layoutIfNeeded];
    });
}

@end
