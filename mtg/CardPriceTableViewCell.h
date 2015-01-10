//
//  CardPriceTableViewCell.h
//  mtg
//
//  Created by Omar Estrella on 1/8/15.
//  Copyright (c) 2015 Omar Estrella. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CardPriceTableViewCell : UITableViewCell

- (void)setupForCard:(NSDictionary *)card inSet:(NSDictionary *)set;

@end
