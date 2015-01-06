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

- (void)setupCellAtIndexPath:(NSIndexPath *)indexPath forSet:(NSDictionary *)set {
    SDWebImageManager *manager = [SDWebImageManager sharedManager];

    __block BOOL setOpacity = NO;

    NSString *code = set[@"code"];
    NSDictionary *card = set[@"cards"][(uint) indexPath.row];

    self.card = card;

    NSString *urlString = [NSString stringWithFormat:@"http://mtgimage.com/set/%@/%@.jpg", code, card[@"name"]];
    NSURL *url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];

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


                               [UIView animateWithDuration:0.8 animations:^{
                                   self.imageView.layer.opacity = 1.0;
                               }];
                           } else {
                               NSLog(@"%@", [error localizedDescription]);
                           }
                       }];
}

@end
