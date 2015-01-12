//
//  ViewController.m
//  mtg
//
//  Created by Omar Estrella on 1/3/15.
//  Copyright (c) 2015 Omar Estrella. All rights reserved.
//

#import <CSStickyHeaderFlowLayout.h>

#import "CardsCollectionViewController.h"
#import "CardCollectionHeaderView.h"
#import "CardCollectionViewCell.h"

#import "Store.h"
#import "CardDetailViewController.h"

@interface CardsCollectionViewController () {
    Store *store;
    NSDictionary *set;
    BOOL isFavorites;
    NSMutableArray *cardsToRemove;
    NSMutableArray *cardsToAdd;
}

@end

@implementation CardsCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    store = [Store sharedStore];

    if (self.setName) {
        set = [store setWithName:self.setName];
        self.title = set[@"name"];
    } else {
        if ([self.navigationItem.title isEqualToString:@"Favorites"]) {
            isFavorites = YES;

            cardsToRemove = [@[] mutableCopy];
            cardsToAdd = [@[] mutableCopy];

            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(favoritesUpdate:)
                                                         name:NotificationFavoritesUpdated
                                                       object:nil];
        }
    }

    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    if (isFavorites) {
        [self.collectionView deleteItemsAtIndexPaths:cardsToRemove];
        [self.collectionView insertItemsAtIndexPaths:cardsToAdd];

        [cardsToRemove removeAllObjects];
        [cardsToAdd removeAllObjects];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)favoritesUpdate:(NSNotification *)notification {
    if (self.isViewLoaded) {
        NSDictionary *data = [notification userInfo];
        NSNumber *index = data[@"index"];
        if ([data[@"operation"] integerValue] == FavoritesRemoved) {
            if (index) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index.integerValue inSection:0];
                [cardsToRemove addObject:indexPath];
            }
        } else if ([data[@"operation"] integerValue] == FavoritesAdded) {
            if (index) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index.integerValue inSection:0];
                [cardsToAdd addObject:indexPath];
            }
        }
    }
}

#pragma mark - UICollectionViewDataSource

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CardCollectionViewCell *cell = (CardCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"card"
                                                                                                       forIndexPath:indexPath];
    if (isFavorites) {
        if ([store favorites].count - 1 < indexPath.row) {
            return cell;
        }

        NSString *cardId = [store favorites][(uint)indexPath.row];
        if (!set) {
            NSDictionary *cardSet = [store setForCardMultiverseId:cardId];
            NSDictionary *card = [store cardWithMultiverseId:cardId];
            [cell setupCellAtIndexPath:indexPath forSet:cardSet card:card];
        }
    } else {
        NSDictionary *card = set[@"cards"][(uint)indexPath.row];
        [cell setupCellAtIndexPath:indexPath forSet:set card:card];
    }
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (isFavorites) {
        return [store favorites].count;
    }

    return [store cardsForSet:self.setName].count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

#pragma mark - UICollectionFlowLayoutDelegate

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize imageSize = { 480, 680 };
    CGFloat width = self.view.frame.size.width;
    CGFloat size = width / 2;
    CGFloat ratio = imageSize.width / imageSize.height;
    return CGSizeMake(size - 12, size / ratio);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 4;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(2, 8, 0, 8);
}

#pragma mark - UICollectionViewDelegate


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    CardDetailViewController *vc = (CardDetailViewController *)[segue destinationViewController];
    CardCollectionViewCell *cell = (CardCollectionViewCell *)sender;
    vc.card = cell.card;

    if (isFavorites) {
        vc.set = [store setForCard:cell.card];
    } else {
        vc.set = set;
    }
}

@end
