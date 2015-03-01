//
//  CardRulingsTableViewCell.m
//  mtg
//
//  Created by Omar Estrella on 2/28/15.
//  Copyright (c) 2015 Omar Estrella. All rights reserved.
//

#import "CardRulingsTableViewCell.h"

@implementation CardRulingsTableViewCell

- (void)setupForCard:(NSDictionary *)card atIndexPath:(NSIndexPath *)indexPath {
    self.card = card;

    NSArray *rulings = card[@"rulings"];
    NSDictionary *ruling = rulings[(uint) indexPath.row];

    [self updatedAttributedText:ruling[@"text"]];

    self.rulingsDate.text = ruling[@"date"];
}

@end
