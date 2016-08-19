//
//  settingsViewController.m
//  FreJun
//
//  Created by GOTESO on 12/08/16.
//  Copyright © 2016 GOTESO. All rights reserved.
//

#import "settingsViewController.h"
#import "SACalendar/SACalendar.h"

@interface settingsViewController (){
    
    NSArray *buttons;
}

@end

@implementation settingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.scrollEnabled = NO;
    buttons = [[NSArray alloc]init];
    buttons = @[@"Accounts",@"Preferences",@"Chat with us"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//tableView methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView1 cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    cell.textLabel.text = buttons[indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView1 didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
}

@end
