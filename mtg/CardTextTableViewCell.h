//
//  CardTextCollectionViewCell.h
//  mtg
//
//  Created by Omar Estrella on 1/6/15.
//  Copyright (c) 2015 Omar Estrella. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Promise.h"

@interface CardTextTableViewCell : UITableViewCell

@property (weak, nonatomic) NSDictionary *card;
@property BOOL loaded;

@property (weak, nonatomic) IBOutlet UILabel *cardText;

- (PMKPromise *)setupForIndexPath:(NSIndexPath *)indexPath;

@end
