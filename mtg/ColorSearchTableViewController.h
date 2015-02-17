//
//  ColorSearchTableViewController.h
//  mtg
//
//  Created by Omar Estrella on 2/12/15.
//  Copyright (c) 2015 Omar Estrella. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ColorSearchTableViewController : UITableViewController

@property (nonatomic, strong) NSMutableArray *include;
@property (nonatomic, strong) NSMutableArray *exclude;

@end
