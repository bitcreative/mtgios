//
//  ColorSearchTableViewController.m
//  mtg
//
//  Created by Omar Estrella on 2/12/15.
//  Copyright (c) 2015 Omar Estrella. All rights reserved.
//

#import "ColorSearchTableViewController.h"
#import "CostSearchTableViewCell.h"

@interface ColorSearchTableViewController ()

@end

@implementation ColorSearchTableViewController {
    NSArray *colors;
    NSDictionary *shortCode;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView.delegate = self;
    self.tableView.dataSource = self;

    self.tableView.editing = YES;

    colors = @[@"Red", @"White", @"Green", @"Black", @"Blue"];
    shortCode = @{
            @"Red": @"r",
            @"White": @"w",
            @"Green": @"g",
            @"Black": @"b",
            @"Blue": @"u"
    };
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return @"Include";
        case 1:
            return @"Exclude";
        default:
            return @"Color";
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CostSearchTableViewCell *cell = (CostSearchTableViewCell *) [tableView dequeueReusableCellWithIdentifier:@"cell"
                                                                                                forIndexPath:indexPath];

    NSString *color = colors[(uint) indexPath.row];
    NSString *imageName = [NSString stringWithFormat:@"mana_%@", shortCode[color]];
    NSData *data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:imageName ofType:@"png"]];

    cell.colorLabel.text = color;
    cell.colorImage.image = [UIImage imageWithData:data];

    if (indexPath.section == 0) {
        if ([self.include containsObject:color]) {
            [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:nil];
        }
    } else if (indexPath.section == 1) {
        if ([self.exclude containsObject:color]) {
            [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:nil];
        }
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        [self.include addObject:colors[(uint)indexPath.row]];
    } else if (indexPath.section == 1) {
        [self.exclude addObject:colors[(uint)indexPath.row]];
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        [self.include removeObject:colors[(uint)indexPath.row]];
    } else if (indexPath.section == 1) {
        [self.exclude removeObject:colors[(uint)indexPath.row]];
    }
}

@end
