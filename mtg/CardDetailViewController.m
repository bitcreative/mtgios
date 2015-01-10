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
#import "Store.h"

@implementation CardDetailViewController

- (void)viewDidLoad {
    Store *store = [Store sharedStore];

    self.tableView.delegate = self;
    self.tableView.dataSource = self;


    if (store.status == CKAccountStatusAvailable) {
        self.favoriteButton.target = self;
        self.favoriteButton.action = @selector(toggleFavorite);

        if([store isCardFavorite:self.card]) {
            self.favoriteButton.image = [UIImage imageNamed:@"favorites.png"];
        }

        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(favoritesUpdate:)
                                                     name:NotificationFavoritesUpdated
                                                   object:[Store sharedStore]];
    } else {
        NSMutableArray *items = self.navigationItem.rightBarButtonItems.mutableCopy;
        [items removeObject:self.favoriteButton];
        [self.navigationItem setRightBarButtonItems:items animated:NO];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self];

    [super viewWillDisappear:animated];
}

- (void)favoritesUpdate:(NSNotification *)notification {
    NSLog(@"favorite called");
    NSLog(@"%@", [notification userInfo]);
}

- (void)toggleFavorite {
    Store *store = [Store sharedStore];
    if(![store isCardFavorite:self.card]) {
        self.favoriteButton.image = [UIImage imageNamed:@"favorites.png"];
        [store addFavoriteCard:self.card].catch(^(NSError *error) {
            self.favoriteButton.image = [UIImage imageNamed:@"favorites_empty.png"];
        });
    } else {
        self.favoriteButton.image = [UIImage imageNamed:@"favorites_empty.png"];
        [store removeFavoriteCard:self.card].catch(^(NSError *error) {
            self.favoriteButton.image = [UIImage imageNamed:@"favorites.png"];
        });
    }
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1 || indexPath.section == 2) {
        CardTextTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"textCell"
                                                                                forIndexPath:indexPath];
        NSString *text;
        if (indexPath.section == 1) {
            text = self.card[@"text"];
        } else if (indexPath.section == 2) {
            text = self.card[@"flavor"];
            if (!text) {
                text = @"No flavor text";
            }
        }

        cell.cardText.text = text;
        return cell;
    } else if (indexPath.section == 3) {
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

        if (!self.headerCell) {
            self.headerCell = cell;
        }

        return cell;
    }

    NSString *text;

    if (section == 1) {
        text = @"Text";
    } else if (section == 2) {
        text = @"Flavor";
    } else if (section == 3) {
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
    return 4;
}

@end
