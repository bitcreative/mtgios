//
//  CardDetailViewController.m
//  mtg
//
//  Created by Omar Estrella on 1/4/15.
//  Copyright (c) 2015 Omar Estrella. All rights reserved.
//

#import <CSStickyHeaderFlowLayout/CSStickyHeaderFlowLayout.h>
#import <SDWebImage/SDWebImageManager.h>

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

        if ([store isCardFavorite:self.card]) {
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

}

- (void)toggleFavorite {
    Store *store = [Store sharedStore];
    if (![store isCardFavorite:self.card]) {
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

- (void)updatedAttributedTextForCell:(CardTextTableViewCell *)cell {
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    NSString *cardString = self.card[@"text"];
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:cardString];
    NSRegularExpression *symbolRegex = [NSRegularExpression regularExpressionWithPattern:@"\\{([^}]+)\\}"
                                                                                 options:NSRegularExpressionCaseInsensitive
                                                                                   error:nil];
    NSArray *matches = [symbolRegex matchesInString:cardString options:nil range:NSMakeRange(0, cardString.length)];
    NSInteger matchesCount = matches.count;
    __block NSInteger totalCount = 0;

    if (matchesCount > 0) {
        for (NSTextCheckingResult *result in matches.reverseObjectEnumerator) {
            NSString *symbol = [[cardString substringWithRange:result.range]
                    stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"{}"]];
            symbol = [symbol stringByReplacingOccurrencesOfString:@"/" withString:@""];
            NSString *formatString = @"http://mtgimage.com/symbol/mana/%@/64.png";
            if ([symbol isEqualToString:@"T"]) {
                formatString = @"http://mtgimage.com/symbol/other/%@/64.png";
            }
            NSTextAttachment *symbolAttachment = [[NSTextAttachment alloc] init];
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:formatString, symbol]];
            [manager downloadImageWithURL:url
                                  options:SDWebImageContinueInBackground
                                 progress:nil
                                completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageUrl) {
                                    if (image) {
                                        symbolAttachment.image = image;
                                        symbolAttachment.bounds = CGRectMake(0, -2, 14, 14);
                                        [string replaceCharactersInRange:result.range
                                                    withAttributedString:[NSAttributedString attributedStringWithAttachment:symbolAttachment]];
                                        totalCount += 1;
                                    } else { NSLog(@"%@, %@", error.localizedDescription, url.absoluteString); }

                                    if (totalCount == matchesCount) {
                                        cell.cardText.adjustsFontSizeToFitWidth = YES;
                                        cell.cardText.attributedText = string;
                                        totalCount = 0;
                                    }
                                }];
        }
    }
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1 || indexPath.section == 2) {
        CardTextTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"textCell"
                                                                      forIndexPath:indexPath];
        NSMutableAttributedString *text;
        if (indexPath.section == 1) {
            text = [[NSMutableAttributedString alloc] initWithString:self.card[@"text"]];
            [self updatedAttributedTextForCell:cell];
        } else if (indexPath.section == 2) {
            if (!self.card[@"flavor"]) {
                text = [[NSMutableAttributedString alloc] initWithString:@"No flavor text"];
            } else {
                text = [[NSMutableAttributedString alloc] initWithString:self.card[@"flavor"]];
            }
        }

        cell.cardText.attributedText = text;
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

    NSMutableAttributedString *text;

    if (section == 1) {
        text = [[NSMutableAttributedString alloc] initWithString:@"Text"];
    } else if (section == 2) {
        text = [[NSMutableAttributedString alloc] initWithString:@"Flavor"];
    } else if (section == 3) {
        NSString *string = @"Prices (from TCGPlayer)";
        NSRange range = NSMakeRange(6, string.length - 6);
        text = [[NSMutableAttributedString alloc] initWithString:string];
        [text addAttribute:NSFontAttributeName
                     value:[UIFont fontWithName:@"HelveticaNeue-Thin" size:11]
                     range:range];
    }

    CardDetailTextHeaderCell *cell = (CardDetailTextHeaderCell *) [self.tableView dequeueReusableCellWithIdentifier:@"cardDetailTextHeader"];
    cell.headerLabel.attributedText = text;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 120;
    }
    return 35;
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
