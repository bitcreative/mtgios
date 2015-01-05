//
//  SetTableViewCell.m
//  mtg
//
//  Created by Omar Estrella on 1/4/15.
//  Copyright (c) 2015 Omar Estrella. All rights reserved.
//

#import "SetTableViewCell.h"
#import "Store.h"
#import "SDWebImageManager.h"
#import "UIImage+ProportionalFill.h"
#import "SDWebImageDownloaderOperation.h"

@implementation SetTableViewCell {
    SDWebImageDownloaderOperation *operation;
}

- (void)prepareForReuse {
    if (operation) {
        [operation cancel];
    }

    self.setImage.image = nil;
    self.setImage.layer.opacity = 0;
}

- (void)setupCell:(NSIndexPath *)indexPath {
    Store *store = [Store sharedStore];
    uint row = (uint)indexPath.row;
    NSDictionary *set = [store setWithName:[store sets][row]];
    NSURL *imageUrl = [[Store sharedStore] imageURLForSet:set[@"code"]];

    self.label.text = set[@"name"];
    self.date.text = [NSString stringWithFormat:@"Released on %@", set[@"releaseDate"]];

    operation = [[SDWebImageManager sharedManager]
            downloadImageWithURL:imageUrl
                         options:SDWebImageContinueInBackground
                        progress:nil
                       completed:^(UIImage *image, NSError *error, SDImageCacheType cacheTYpe, BOOL finished, NSURL *url) {
                           if (image) {
                               CGFloat scale = self.setImage.bounds.size.width / image.size.width;
                               CGSize size = {image.size.width * scale, image.size.height * scale};
                               CGRect frame = CGRectMake(self.setImage.frame.origin.x, self.setImage.frame.origin.x,
                                       size.width, size.height);
                               UIImage *resizedImage = [image imageToFitSize:size method:MGImageResizeScale];
                               self.setImage.frame = frame;
                               self.setImage.image = resizedImage;

                               [UIView animateWithDuration:0.5 animations:^{
                                   self.setImage.layer.opacity = 1.0;
                               }];
                           } else {
                               self.setImage.image = nil;
                           }
                       }];
}

@end
