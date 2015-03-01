//
//  CardRulingsTableViewCell.h
//  mtg
//
//  Created by Omar Estrella on 2/28/15.
//  Copyright (c) 2015 Omar Estrella. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardTextTableViewCell.h"

@interface CardRulingsTableViewCell : CardTextTableViewCell

@property (weak, nonatomic) NSDictionary *card;

@property (weak, nonatomic) IBOutlet UILabel *cardText;
@property (weak, nonatomic) IBOutlet UILabel *rulingsDate;

- (void)setupForCard:(NSDictionary *)card atIndexPath:(NSIndexPath *)indexPath;

@end
