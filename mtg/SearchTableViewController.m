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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        [self performSegueWithIdentifier:@"showCostSettings" sender:self];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    CostSettingsTableViewController *vc = (CostSettingsTableViewController *)segue.destinationViewController;
    vc.manaCosts = self.manaCosts;
    
    [super prepareForSegue:segue sender:self];
}

@end