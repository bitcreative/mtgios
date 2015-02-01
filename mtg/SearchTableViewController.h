//
// Created by Omar Estrella on 1/26/15.
// Copyright (c) 2015 Omar Estrella. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchTableViewController : UITableViewController<UITableViewDelegate, UITextFieldDelegate>

@property (nonatomic, strong) NSMutableArray *manaCosts;

@property (weak, nonatomic) IBOutlet UITextField *containsTextField;

@end