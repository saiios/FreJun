//
//  SettingsTableViewController.m
//  FreJun
//
//  Created by GOTESO on 19/08/16.
//  Copyright © 2016 GOTESO. All rights reserved.
//

#import "SettingsTableViewController.h"
#import "AccountsTableViewController.h"
#import "PreferencesTableViewController.h"

@interface SettingsTableViewController (){
    
    NSArray *buttons;
}


@end

@implementation SettingsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Settings";
    buttons = [[NSArray alloc]init];
    buttons = @[@"Accounts",@"Preferences",@"Chat with us"];
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
    cell.textLabel.text = buttons[indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle= UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        
        AccountsTableViewController* infoController = [[AccountsTableViewController alloc]initWithStyle:UITableViewStyleGrouped];
        [self.navigationController pushViewController:infoController animated:YES];
    }
    else if (indexPath.row == 1){
        
        PreferencesTableViewController* infoController = [[PreferencesTableViewController alloc]initWithStyle:UITableViewStyleGrouped];
        [self.navigationController pushViewController:infoController animated:YES];
    }
}

@end
