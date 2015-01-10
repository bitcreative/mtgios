//
//  CardDetailViewController.h
//  mtg
//
//  Created by Omar Estrella on 1/4/15.
//  Copyright (c) 2015 Omar Estrella. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CardDetailHeaderCell;

@interface CardDetailViewController : UITableViewController<UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>

@property (weak, nonatomic) NSDictionary *set;
@property (weak, nonatomic) NSDictionary *card;
@property (strong, nonatomic) CardDetailHeaderCell *headerCell;

@end
