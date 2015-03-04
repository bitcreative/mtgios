//
// Created by Omar Estrella on 3/4/15.
// Copyright (c) 2015 Omar Estrella. All rights reserved.
//

#import <HockeySDK/BITHockeyManager.h>
#import <HockeySDK/BITFeedbackManager.h>
#import "MoreTableViewController.h"


@implementation MoreTableViewController {

}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 0) {
        BITFeedbackManager *manager = [BITHockeyManager sharedHockeyManager].feedbackManager;

        manager.requireUserName = BITFeedbackUserDataElementOptional;
        manager.requireUserEmail = BITFeedbackUserDataElementRequired;

        [manager showFeedbackComposeView];
    }
}

@end