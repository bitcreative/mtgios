//
// Created by Omar Estrella on 1/26/15.
// Copyright (c) 2015 Omar Estrella. All rights reserved.
//

#import "SearchTableViewController.h"
#import "CostSearchTableViewController.h"
#import "Store.h"
#import "Underscore.h"
#import "SearchResultsTableViewController.h"
#import "ColorSearchTableViewController.h"

#define _ Underscore

@implementation SearchTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView.delegate = self;
    self.containsTextField.delegate = self;

    self.manaCosts = [[NSMutableArray alloc] init];
    self.includeColors = [[NSMutableArray alloc] init];
    self.excludeColors = [[NSMutableArray alloc] init];

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
        CostSearchTableViewController *vc = (CostSearchTableViewController *) segue.destinationViewController;
        vc.manaCosts = self.manaCosts;
    } else if ([segue.identifier isEqualToString:@"showColorSettings"]) {
        ColorSearchTableViewController *vc = (ColorSearchTableViewController *) segue.destinationViewController;
        vc.include = self.includeColors;
        vc.exclude = self.excludeColors;
    } else if ([segue.identifier isEqualToString:@"searchResults"]) {
        NSPredicate *finalPredicate;
        NSArray *cards = [store allCards];
        NSMutableArray *predicates = [NSMutableArray array];

        if (self.manaCosts.count > 0) {
            NSArray *manaPredicates = _.array(self.manaCosts).map(^(NSNumber *cost) {
                NSString *format = @"cmc == %@";
                if ([cost isEqualToNumber:@7]) {
                    format = @"cmc >= %@";
                }
                return [NSPredicate predicateWithFormat:format, cost];
            }).unwrap;

            [predicates addObject:[NSCompoundPredicate orPredicateWithSubpredicates:manaPredicates]];
        }

        if (self.containsTextField.text.length > 0) {
            NSString *textContains = self.containsTextField.text;
            NSArray *textPredicates = _.array(@[@"name", @"description"]).map(^(NSString *prop) {
                return [NSPredicate predicateWithFormat:@"%K CONTAINS[cd] %@", prop, textContains];
            }).unwrap;

            [predicates addObject:[NSCompoundPredicate orPredicateWithSubpredicates:textPredicates]];
        }

        if (self.includeColors.count > 0) {
            NSPredicate *includePredicate = [NSPredicate predicateWithFormat:@"ANY %@ IN[cd] colors", self.includeColors];
            [predicates addObject:includePredicate];
        }

        if (self.excludeColors.count > 0) {
            NSCompoundPredicate *excludePredicate = [NSCompoundPredicate
                    notPredicateWithSubpredicate:[NSPredicate predicateWithFormat:@"ANY %@ IN[cd] colors", self.excludeColors]];
            [predicates addObject:excludePredicate];
        }

        if (predicates.count > 0) {
            finalPredicate = [NSCompoundPredicate andPredicateWithSubpredicates:predicates];
            NSLog(@"%@", finalPredicate);
            cards = [cards filteredArrayUsingPredicate:finalPredicate];
        }

        SearchResultsTableViewController *vc = (SearchResultsTableViewController *)segue.destinationViewController;
        vc.cards = cards;
    }

    [super prepareForSegue:segue sender:self];
}

@end