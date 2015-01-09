//
//  CardDetailHeaderCell.h
//  mtg
//
//  Created by Omar Estrella on 1/5/15.
//  Copyright (c) 2015 Omar Estrella. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CardDetailHeaderCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *cardImage;
@property (strong, nonatomic) IBOutlet UILabel *name;
@property (strong, nonatomic) IBOutlet UILabel *type;
@property (strong, nonatomic) IBOutlet UIView *manaContainer;

@property BOOL loaded;

- (void)setupForCard:(NSDictionary *)card inSet:(NSDictionary *)set;

@end
