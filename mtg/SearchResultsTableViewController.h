//
// Created by Omar Estrella on 1/27/15.
// Copyright (c) 2015 Omar Estrella. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SearchResultsTableViewController : UITableViewController<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray *cards;

@end