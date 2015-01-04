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

@implementation CardCollectionViewCell {
    SDWebImageDownloaderOperation *operation;
}

- (void)prepareForReuse {
    if (operation) {
        [operation cancel];
    }
    
    self.imageView.image = nil;
}

- (void)setupCellAtIndexPath:(NSIndexPath *)indexPath {
    Store *store = [Store sharedStore];
    
    NSString *setName = [store sets][(uint)indexPath.section];
    NSDictionary *card = [store cardsForSet:setName][(uint)indexPath.row];
    
    NSString *urlString = [NSString stringWithFormat:@"http://mtgimage.com/set/%@/%@.jpg", setName, card[@"name"]];
    NSURL *url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    operation = [[SDWebImageManager sharedManager]
                 downloadImageWithURL:url
                 options:SDWebImageContinueInBackground
                 progress:nil
                 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheTYpe, BOOL finished, NSURL *imageUrl) {
                     if (image) {
                         CGFloat scale = self.bounds.size.width / image.size.width;
                         CGSize size = {image.size.width * scale, image.size.height * scale};
                         UIImage *resizedImage = [image imageToFitSize:size method:MGImageResizeScale];
                         self.imageView.image = resizedImage;
                     } else {
                         NSLog(@"%@", [error localizedDescription]);
                     }
                 }];
}

@end
