//
//  NotificationsTableViewController.m
//  FreJun
//
//  Created by GOTESO on 19/08/16.
//  Copyright © 2016 GOTESO. All rights reserved.
//

#import "NotificationsTableViewController.h"

@interface NotificationsTableViewController (){
    
    NSArray *buttons;
    NSArray *timestamps;
}


@end

@implementation NotificationsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Notifications";
    buttons = [[NSArray alloc]init];
    buttons = @[@"demo1@gmail.com accepted invite",@"demo2@gmail.com declined invite",@"demo3@gmail.com accepted invite"];
    timestamps = [[NSArray alloc] initWithObjects:@"2 hours ago",@"2 days ago",@"1 month ago", nil];
    self.view.backgroundColor = [UIColor colorWithRed:243.0/255.0 green:243.0/255.0 blue:243.0/255.0 alpha:1];
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(cell.contentView.frame.size.width - 70, 0, 60, cell.contentView.frame.size.height)];
    label.textAlignment = NSTextAlignmentRight;
    label.text = timestamps[indexPath.row];
    label.font = [UIFont systemFontOfSize:10];
    label.textColor = [UIColor lightGrayColor];
    [cell.contentView addSubview:label];
    
    UILabel *infoLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, cell.contentView.frame.size.width - 95, cell.contentView.frame.size.height)];
    infoLabel.text = buttons[indexPath.row];
    infoLabel.font = [UIFont systemFontOfSize:14];
    infoLabel.adjustsFontSizeToFitWidth = YES;
    [cell.contentView addSubview:infoLabel];

    
    return cell;
}

@end
