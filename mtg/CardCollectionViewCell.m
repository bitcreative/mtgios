//
//  CardCollectionViewCell.m
//  mtg
//
//  Created by Omar Estrella on 1/3/15.
//  Copyright (c) 2015 Omar Estrella. All rights reserved.
//

#import <SDWebImageManager.h>
#import <SDWebImageDownloaderOperation.h>

#import "Store.h"
#import "CardCollectionViewCell.h"
#import "UIImage+ProportionalFill.h"
#import "CardsCollectionViewController.h"

@implementation CardCollectionViewCell {
    SDWebImageDownloaderOperation *operation;
}

- (void)prepareForReuse {
    if (operation) {
        [operation cancel];
    }

    self.imageView.image = nil;
}

- (void)setupCellAtIndexPath:(NSIndexPath *)indexPath forSet:(NSDictionary *)set card:(NSDictionary *)card {
    SDWebImageManager *manager = [SDWebImageManager sharedManager];

    __block BOOL setOpacity = NO;

    self.card = card;

    NSURL *url = [[Store sharedStore] imageURLForCard:card inSet:set];

    operation = [manager
            downloadImageWithURL:url
                         options:SDWebImageContinueInBackground
                        progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                            if (!setOpacity) {
                                self.imageView.layer.opacity = 0;
                                setOpacity = YES;
                            }
                        }
                       completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageUrl) {
                           if (image) {
                               CGFloat scale = self.bounds.size.width / image.size.width;
                               CGSize size = {image.size.width * scale, image.size.height * scale};
                               UIImage *resizedImage = [image imageToFitSize:size method:MGImageResizeScale];
                               self.imageView.image = resizedImage;
                               self.imageView.layer.masksToBounds = YES;
                               self.imageView.layer.cornerRadius = 2;

                               [UIView animateWithDuration:0.8 animations:^{
                                   self.imageView.layer.opacity = 1.0;
                               }];
                           } else {
                               NSLog(@"%@", [error localizedDescription]);
                           }
                       }];
}

@end
