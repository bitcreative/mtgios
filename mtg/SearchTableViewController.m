//
// Created by Omar Estrella on 1/26/15.
// Copyright (c) 2015 Omar Estrella. All rights reserved.
//

#import "SearchTableViewController.h"
#import "CostSearchTableViewController.h"
#import "Store.h"
#import "Underscore.h"
#import "SearchResultsTableViewController.h"

#define _ Underscore

@implementation SearchTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView.delegate = self;
    self.containsTextField.delegate = self;

    self.manaCosts = [[NSMutableArray alloc] init];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    tap.cancelsTouchesInView = NO;
    [self.tableView addGestureRecognizer:tap];
}

- (void)viewWillAppear:(BOOL)animated {
    [self updateManaCostText];

    [super viewWillAppear:animated];
}

- (void)dismissKeyboard {
    [self.containsTextField resignFirstResponder];
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
    Store *store = [Store sharedStore];
    if ([segue.identifier isEqualToString:@"showCostSettings"]) {
        CostSearchTableViewController *vc = (CostSearchTableViewController *)segue.destinationViewController;
        vc.manaCosts = self.manaCosts;
    } else if ([segue.identifier isEqualToString:@"searchResults"]) {
        NSArray *manaPredicates = _.array(self.manaCosts).map(^(NSNumber *cost) {
            NSString *format = @"cmc == %@";
            if ([cost isEqualToNumber:@7]) {
                format = @"cmc >= %@";
            }
            return [NSPredicate predicateWithFormat:format, cost];
        }).unwrap;

        NSCompoundPredicate *manaPredicate = [NSCompoundPredicate orPredicateWithSubpredicates:manaPredicates];
        NSArray *array = [[store allCards] filteredArrayUsingPredicate:manaPredicate];

        SearchResultsTableViewController *vc = (SearchResultsTableViewController *)segue.destinationViewController;
        vc.cards = array;
    }

    [super prepareForSegue:segue sender:self];
}

@end