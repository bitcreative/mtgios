//
//  ViewController.m
//  mtg
//
//  Created by Omar Estrella on 1/3/15.
//  Copyright (c) 2015 Omar Estrella. All rights reserved.
//

#import <CSStickyHeaderFlowLayout.h>

#import "CardsViewController.h"
#import "CardCollectionHeaderView.h"
#import "CardCollectionViewCell.h"

#import "Store.h"

@interface CardsViewController () {
    Store *store;
}

@end

@implementation CardsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    store = [Store sharedStore];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;

    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark - UICollectionViewDataSource

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CardCollectionViewCell *cell = (CardCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"card" forIndexPath:indexPath];
    [cell setupCellAtIndexPath:indexPath];
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [store cardsForSet:[[store sets] objectAtIndex:section]].count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return [store sets].count;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        CardCollectionHeaderView *cell = (CardCollectionHeaderView *)[collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                                            withReuseIdentifier:@"header"
                                                                                    forIndexPath:indexPath];
        NSDictionary *set = [store setWithName:[[store sets] objectAtIndex:indexPath.section]];
        cell.label.text = set[@"name"];
        return cell;
    }
    
    return nil;
}

#pragma mark - UICollectionFlowLayoutDelegate

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = self.collectionView.contentSize.width;
    CGFloat size = width / 4;
    return CGSizeMake(size, size + 40);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 8;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(8, 8, 8, 8);
}

#pragma mark - UICollectionViewDelegate

@end
