//
// Created by Omar Estrella on 1/27/15.
// Copyright (c) 2015 Omar Estrella. All rights reserved.
//

#import "SearchResultsTableViewController.h"
#import "Underscore.h"

#define _ Underscore

@implementation SearchResultsTableViewController

#pragma mark - UITableViewDataSource

- (void)viewDidLoad {
    NSMutableArray *cardNames = [@[] mutableCopy];
    self.cards = _.array(self.cards).filter(^(NSDictionary *card) {
        NSString *name = card[@"name"];
        if (![cardNames containsObject:name]) {
            [cardNames addObject:name];
            return YES;
        }

        return NO;
    }).unwrap;

    [super viewDidLoad];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    NSLog(@"%d", self.cards.count);
    cell.textLabel.text = self.cards[(uint)indexPath.row][@"name"];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.cards.count;
}

@end