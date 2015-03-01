//
//  CardTextCollectionViewCell.m
//  mtg
//
//  Created by Omar Estrella on 1/6/15.
//  Copyright (c) 2015 Omar Estrella. All rights reserved.
//

#import <SDWebImage/SDWebImageManager.h>
#import "CardTextTableViewCell.h"

@implementation CardTextTableViewCell

- (PMKPromise *)updatedAttributedText:(NSString *)text {
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    NSString *cardString = text;
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:cardString];
    NSRegularExpression *symbolRegex = [NSRegularExpression regularExpressionWithPattern:@"\\{([^}]+)\\}"
                                                                                 options:NSRegularExpressionCaseInsensitive
                                                                                   error:nil];
    NSArray *matches = [symbolRegex matchesInString:cardString options:nil range:NSMakeRange(0, cardString.length)];
    NSInteger matchesCount = matches.count;
    __block NSInteger totalCount = 0;

    return [PMKPromise new:^(PMKPromiseFulfiller fulfill, PMKPromiseRejecter reject) {
        if (matchesCount > 0) {
            for (NSTextCheckingResult *result in matches.reverseObjectEnumerator) {
                NSString *symbol = [[cardString substringWithRange:result.range]
                        stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"{}"]];
                symbol = [symbol stringByReplacingOccurrencesOfString:@"/" withString:@""];
                NSString *formatString = @"http://mtgimage.com/symbol/mana/%@/64.png";
                if ([symbol isEqualToString:@"T"]) {
                    formatString = @"http://mtgimage.com/symbol/other/%@/64.png";
                }
                NSTextAttachment *symbolAttachment = [[NSTextAttachment alloc] init];
                NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:formatString, symbol]];
                [manager downloadImageWithURL:url
                                      options:SDWebImageContinueInBackground
                                     progress:nil
                                    completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageUrl) {
                                        if (image) {
                                            symbolAttachment.image = image;
                                            symbolAttachment.bounds = CGRectMake(0, -2, 14, 14);
                                            [string replaceCharactersInRange:result.range
                                                        withAttributedString:[NSAttributedString attributedStringWithAttachment:symbolAttachment]];
                                            totalCount += 1;
                                        } else { NSLog(@"%@, %@", error.localizedDescription, url.absoluteString); }

                                        if (totalCount == matchesCount) {
                                            self.cardText.adjustsFontSizeToFitWidth = NO;
                                            self.cardText.attributedText = string;

                                            fulfill(self);
                                        }
                                    }];

                self.cardText.attributedText = string;
            }
        } else {
            self.cardText.text = cardString;
            self.cardText.attributedText = string;

            fulfill(self);
        }
    }];


}

- (PMKPromise *)setupForIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        return [self updatedAttributedText:self.card[@"text"]];
    } else if (indexPath.section == 2) {
        if (!self.card[@"flavor"]) {
            self.cardText.text = @"No flavor text";
        } else {
            self.cardText.text = self.card[@"flavor"];
        }
    }

    return [PMKPromise new:^(PMKPromiseFulfiller fulfill, PMKPromiseRejecter reject) {
        fulfill(self);
    }];
}

@end
