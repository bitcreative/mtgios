//
// Created by Omar Estrella on 1/4/15.
// Copyright (c) 2015 Omar Estrella. All rights reserved.
//

#import "SetsTableViewController.h"
#import "Store.h"
#import "SetTableViewCell.h"
#import "CardsCollectionViewController.h"


@implementation SetsTableViewController {
    NSInteger count;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView.dataSource = self;
    self.tableView.delegate = self;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SetTableViewCell *cell = (SetTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"setCell"];
    [cell setupCell:indexPath];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[Store sharedStore] sets].count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    CardsCollectionViewController *vc = (CardsCollectionViewController *)[segue destinationViewController];
    UITableViewCell *cell = (UITableViewCell *)sender;
    vc.setName = [[Store sharedStore] sets][(uint)[self.tableView indexPathForCell:cell].row];
}

@end