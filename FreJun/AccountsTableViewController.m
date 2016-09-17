//
//  AccountsTableViewController.m
//  FreJun
//
//  Created by GOTESO on 19/08/16.
//  Copyright © 2016 GOTESO. All rights reserved.
//

#import "AccountsTableViewController.h"
#import "accountsTableViewCell.h"
#import "Amplitude.h"
@interface AccountsTableViewController (){
    
    NSArray *accounts;
    NSArray *colors;
}


@end

@implementation AccountsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[Amplitude instance] logEvent:@"Accounts"];
    self.navigationItem.title = @"Accounts";
    accounts = [[NSArray alloc]init];
    accounts = @[@"demo1@gmail.com",@"demo2@gmail.com",@"demo3@gmail.com"];
    self.view.backgroundColor = [UIColor colorWithRed:243.0/255.0 green:243.0/255.0 blue:243.0/255.0 alpha:1];
    //self.tableView.contentInset = UIEdgeInsetsMake(40, 0, 0, 0);
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    colors = [[NSArray alloc]initWithObjects:@"color1.jpg",@"color2.jpg",@"color3.jpg",@"color4.jpg",@"color5.jpg", nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    else{
    return 1;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    
    if (indexPath.section == 1) {
    
        static NSString *cellid=@"accountsTableViewCell";
        accountsTableViewCell *cell = (accountsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellid];
        if (cell==nil) {
            NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"accountsTableViewCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        dataclass *obj = [dataclass getInstance];
        cell.title.text = obj.emailTitle;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
     }
    else{
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (cell==nil) {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        }
        cell.textLabel.text = @"Add new account";
        cell.textLabel.textColor = [UIColor colorWithRed:28.0/255.0 green:87.0/255.0 blue:255.0/255.0 alpha:1.0];
        
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.0001;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        return 0;
    }
    else{
    return 31;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    

    if (section == 1) {
        UIView *sectionView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,31)];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(50, 0, self.view.frame.size.width, 31)];
        label.text = @"Google Accounts";
        label.textColor = [UIColor colorWithRed:109.0/255.0 green:109.0/255.0 blue:114.0/255.0 alpha:1];
        label.font = [UIFont systemFontOfSize:13];
        [sectionView addSubview:label];
        
        UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(15, 5, 20, 20)];
        image.image = [UIImage imageNamed:@"google-icon"];;
        [sectionView addSubview:image];
        
        return  sectionView;
    }
    
    UIView *emptyview;
    return emptyview;
    
}


@end
