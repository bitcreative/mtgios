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

@implementation CardDetailViewController

- (void)viewDidLoad {
    CSStickyHeaderFlowLayout *layout = (id)self.collectionViewLayout;
    layout.parallaxHeaderReferenceSize = CGSizeMake(self.view.frame.size.width, 80);

    UINib *header = [UINib nibWithNibName:@"CardDetailHeaderCell" bundle:nil];
    [self.collectionView registerNib:header
          forSupplementaryViewOfKind:CSStickyHeaderParallaxHeader
                 withReuseIdentifier:@"mainHeader"];

    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;

    [self.collectionView reloadData];
}

#pragma mark - UICollectionViewDataSource

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 100;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:CSStickyHeaderParallaxHeader]) {
        CardDetailHeaderCell *cell = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                                            withReuseIdentifier:@"mainHeader"
                                                                                   forIndexPath:indexPath];
        if (!cell.loaded) {
            [cell setupForCard:self.card inSet:self.set];
            cell.loaded = YES;
        }
        return cell;
    } else if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        NSLog(@"other");
    } else {
        // other custom supplementary views
    }
    return nil;
}

@end
