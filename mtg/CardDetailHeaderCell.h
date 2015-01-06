//
//  CardDetailHeaderCell.h
//  mtg
//
//  Created by Omar Estrella on 1/5/15.
//  Copyright (c) 2015 Omar Estrella. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CardDetailHeaderCell : UICollectionReusableView

@property (weak, nonatomic) IBOutlet UIImageView *cardImage;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *type;
@property (weak, nonatomic) IBOutlet UIView *manaContainer;

@property BOOL loaded;

- (void)setupForCard:(NSDictionary *)card inSet:(NSDictionary *)set;

@end
