//
// Created by Omar Estrella on 1/26/15.
// Copyright (c) 2015 Omar Estrella. All rights reserved.
//

#import "SearchTableViewController.h"
#import "CostSettingsTableViewController.h"

@implementation SearchTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView.delegate = self;

    self.manaCosts = [[NSMutableArray alloc] init];
}

- (void)viewWillAppear:(BOOL)animated {
    [self updateManaCostText];

    [super viewWillAppear:animated];
}

- (void)updateManaCostText {
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];

    if (self.manaCosts.count > 0) {
        [self.manaCosts sortUsingComparator:^NSComparisonResult(NSNumber *a, NSNumber *b) {
            return [a compare:b];
        }];

        NSString *text = [self.manaCosts componentsJoinedByString:@", "];

        if ([self.manaCosts containsObject:@(7)]) {
            text = [text stringByReplacingOccurrencesOfString:@"7" withString:@"7+"];
        }

        cell.textLabel.text = text;
    } else {
        cell.textLabel.text = @"Any";
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        [self performSegueWithIdentifier:@"showCostSettings" sender:self];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    CostSettingsTableViewController *vc = (CostSettingsTableViewController *) segue.destinationViewController;
    vc.manaCosts = self.manaCosts;

    [super prepareForSegue:segue sender:self];
}

@end