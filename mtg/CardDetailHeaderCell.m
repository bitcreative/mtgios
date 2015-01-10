//
//  CardDetailHeaderCell.m
//  mtg
//
//  Created by Omar Estrella on 1/5/15.
//  Copyright (c) 2015 Omar Estrella. All rights reserved.
//

#import <Underscore.h>

#import "CardDetailHeaderCell.h"
#import "SDWebImageManager.h"
#import "Store.h"

#define _ Underscore

@implementation CardDetailHeaderCell {
    NSInteger manaCount;
};

//- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];

    if (self) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
        [self addGestureRecognizer:tap];
        tap.cancelsTouchesInView = NO;
    }

    return self;
}

- (void)tap {
    NSLog(@"tapppppped");
}

#pragma mark - Setup

- (void)setupForCard:(NSDictionary *)card inSet:(NSDictionary *)set {
    self.name.text = card[@"name"];
    self.type.text = card[@"type"];

    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    NSURL *url = [[Store sharedStore] imageURLForCard:card inSet:set];

    UIVisualEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];

    [self setupMana:card];

    [manager downloadImageWithURL:url
                          options:SDWebImageContinueInBackground
                         progress:nil
                        completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageUrl) {
                            if (image) {
                                effectView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
                                [self.contentView insertSubview:effectView belowSubview:self.name];
                                self.cardImage.image = image;
                            } else { NSLog(@"@Loading issue: %@", [error localizedDescription]); }
                        }];
}

- (void)setupMana:(NSDictionary *)card {
    NSString *manaCost = card[@"manaCost"];

    NSRange range = NSMakeRange(0, manaCost.length);
    NSRegularExpression *colorlessRegex = [NSRegularExpression regularExpressionWithPattern:@"\\{(\\d)\\}"
                                                                                    options:0
                                                                                      error:nil];
    NSRegularExpression *colorRegex = [NSRegularExpression regularExpressionWithPattern:@"\\{([^\\d])\\}"
                                                                               options:0
                                                                                 error:nil];
    NSArray *colorlessMatches = [colorlessRegex matchesInString:manaCost options:0 range:range];
    NSArray *colorMatches = [colorRegex matchesInString:manaCost options:0 range:range];

    if (colorlessMatches) {
        [self downloadManaImages:colorlessMatches forCard:card];
    }

    if (colorMatches) {
        [self downloadManaImages:colorMatches forCard:card];
    }
}

- (void)downloadManaImages:(NSArray *)matches forCard:(NSDictionary *)card {
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    NSString *manaCost = card[@"manaCost"];
    NSString *imageFmt = @"http://mtgimage.com/symbol/mana/%@/48.png";

    _.array(matches).map(^(NSTextCheckingResult *result) {
        return [manaCost substringWithRange:[result rangeAtIndex:1]];
    }).each(^(NSString *mana) {
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:imageFmt, [mana lowercaseString]]];
        [manager downloadImageWithURL:url
                              options:SDWebImageContinueInBackground
                             progress:nil
                            completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageUrl) {
                                if (image) {
                                    NSInteger xPos = 18 * manaCount;
                                    manaCount += 1;

                                    CGRect frame = CGRectMake(xPos, 4, 16, 16);
                                    UIImageView *view = [[UIImageView alloc] initWithFrame:frame];

                                    view.image = image;
                                    view.contentMode = UIViewContentModeScaleToFill;

                                    [self.manaContainer addSubview:view];

                                } else {
                                    NSLog(@"%@", [error localizedDescription]);
                                }
                            }];
    });
}

@end
