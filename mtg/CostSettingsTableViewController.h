//
//  CostSettingsTableViewController.h
//  mtg
//
//  Created by Omar Estrella on 1/26/15.
//  Copyright (c) 2015 Omar Estrella. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SearchTableViewController;

@interface CostSettingsTableViewController : UITableViewController<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *manaCosts;

@end
