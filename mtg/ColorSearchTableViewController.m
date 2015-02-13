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

    return cell;
}

@end
