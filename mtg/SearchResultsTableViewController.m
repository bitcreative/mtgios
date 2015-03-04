//
// Created by Omar Estrella on 1/27/15.
// Copyright (c) 2015 Omar Estrella. All rights reserved.
//

#import "SearchResultsTableViewController.h"
#import "Underscore.h"
#import "CardDetailViewController.h"
#import "Store.h"

#define _ Underscore

@implementation SearchResultsTableViewController

#pragma mark - UITableViewDataSource

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.textLabel.text = self.cards[(uint)indexPath.row][@"name"];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.cards.count;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    CardDetailViewController *vc = (CardDetailViewController *)segue.destinationViewController;
    NSIndexPath *path = [self.tableView indexPathForCell:(UITableViewCell *)sender];
    NSDictionary *card = self.cards[(uint)path.row];
    NSDictionary *set = [[Store sharedStore] setForCard:card];
    vc.card = card;
    vc.set = set;

}

@end