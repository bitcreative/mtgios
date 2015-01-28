//
//  CostSearchTableViewController.m
//  mtg
//
//  Created by Omar Estrella on 1/26/15.
//  Copyright (c) 2015 Omar Estrella. All rights reserved.
//

#import "CostSearchTableViewController.h"

@interface CostSearchTableViewController ()

@end

@implementation CostSearchTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView.delegate = self;
    self.tableView.dataSource = self;

    self.tableView.editing = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 8;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];

    NSInteger number = indexPath.row;
    NSString *text = [NSString stringWithFormat:@"%d", number];
    if (number >= 7) {
        text = [text stringByAppendingString:@"+"];
    }

    cell.textLabel.text = text;

    if ([self.manaCosts containsObject:@(indexPath.row)]) {
        [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:nil];
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.manaCosts addObject:@(indexPath.row)];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.manaCosts removeObject:@(indexPath.row)];
}

@end
