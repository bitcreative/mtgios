//
//  CardDetailHeaderCell.m
//  mtg
//
//  Created by Omar Estrella on 1/5/15.
//  Copyright (c) 2015 Omar Estrella. All rights reserved.
//

#import "CardDetailHeaderCell.h"
#import "SDWebImageManager.h"
#import "Store.h"

@implementation CardDetailHeaderCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setupForCard:(NSDictionary *)card inSet:(NSDictionary *)set {
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    NSURL *url = [[Store sharedStore] imageURLForCard:card inSet:set];

    UIVisualEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    [self addSubview:effectView];

    [manager downloadImageWithURL:url
                          options:SDWebImageContinueInBackground
                         progress:nil
                        completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageUrl) {
                            if (image) {
                                effectView.frame = CGRectMake(0, 0, self.frame.size.width, image.size.height);
                                self.cardImage.image = image;
                            } else { NSLog(@"@Loading issue: %@", [error localizedDescription]); }
                        }];
}

@end
