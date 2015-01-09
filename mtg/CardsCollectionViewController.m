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
}

@end

@implementation CardsCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    store = [Store sharedStore];
    set = [store setWithName:self.setName];

    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;

    self.title = set[@"name"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UICollectionViewDataSource

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CardCollectionViewCell *cell = (CardCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"card"
                                                                                                       forIndexPath:indexPath];
    [cell setupCellAtIndexPath:indexPath forSet:set];
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [store cardsForSet:self.setName].count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

#pragma mark - UICollectionFlowLayoutDelegate

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = self.collectionView.contentSize.width;
    CGFloat size = width / 4;
    return CGSizeMake(size, size + 50);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 8;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(8, 8, 0, 8);
}

#pragma mark - UICollectionViewDelegate


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    CardDetailViewController *vc = (CardDetailViewController *)[segue destinationViewController];
    CardCollectionViewCell *cell = (CardCollectionViewCell *)sender;
    vc.set = set;
    vc.card = cell.card;
}

@end
