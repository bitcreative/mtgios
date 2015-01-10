//
//  CardDetailViewController.m
//  mtg
//
//  Created by Omar Estrella on 1/4/15.
//  Copyright (c) 2015 Omar Estrella. All rights reserved.
//

#import <CSStickyHeaderFlowLayout/CSStickyHeaderFlowLayout.h>

#import "CardDetailViewController.h"
#import "CardDetailHeaderCell.h"
#import "CardDetailTextHeaderCell.h"
#import "CardTextTableViewCell.h"
#import "CardPriceTableViewCell.h"

@implementation CardDetailViewController

- (void)viewDidLoad {
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        CardTextTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"textCell"
                                                                                forIndexPath:indexPath];
        cell.cardText.text = self.card[@"text"];
        return cell;
    } else if (indexPath.section == 2) {
        CardPriceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"priceCell"
                                                                       forIndexPath:indexPath];
        [cell setupForCard:self.card inSet:self.set];
    }

    return [[UITableViewCell alloc] init];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        CardDetailHeaderCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"cardDetailHeader"];
        [cell setupForCard:self.card inSet:self.set];
        return cell;
    }

    NSString *text;

    if (section == 1) {
        text = @"Text";
    } else if (section == 2) {
        text = @"Prices";
    }

    CardDetailTextHeaderCell *cell = (CardDetailTextHeaderCell *)[self.tableView dequeueReusableCellWithIdentifier:@"cardDetailTextHeader"];
    cell.headerLabel.text = text;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 120;
    }
    return 30;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    }
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

@end
