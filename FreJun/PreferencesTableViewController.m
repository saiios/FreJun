//
//  PreferencesTableViewController.m
//  FreJun
//
//  Created by GOTESO on 22/08/16.
//  Copyright © 2016 GOTESO. All rights reserved.
//

#import "PreferencesTableViewController.h"

@interface PreferencesTableViewController (){
    
    NSMutableArray *arrayForBool;
    NSArray *sectionTitleArray;
    
    NSArray *timeZone;
    NSArray *defaultMeetingDuration;
    NSArray *ETDAlert;
    NSArray *ETAAlert;
    NSArray *alertsSounds;
    NSArray *defaults;
    NSArray *selectedOptions;
    
    NSArray *preferences;
}

@end

@implementation PreferencesTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"Preferences";
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    timeZone = [[NSArray alloc]init];
    defaultMeetingDuration = [[NSArray alloc]initWithObjects:@"15 minutes",@"30 minutes",@"45 minutes",@"60 minutes",@"90 minutes",@"2 hours",@"3 hours", nil];
    ETDAlert = [[NSArray alloc]initWithObjects:@"5 min before departure",@"10 minutes before departure",@"15 minutes before departure",@"30 minutes before departure",@"1 hour before departure",@"2 hours before departure",@"1 day before departure", nil];
    ETAAlert = [[NSArray alloc]initWithObjects:@"5 min before appointment",@"10 minutes before appointment",@"15 minutes before appointment",@"30 minutes before appointment",@"1 hour before appointment",@"2 hours before appointment",@"1 day before appointment", nil];
    alertsSounds = [[NSArray alloc]initWithObjects:@"Sound 1",@"Sound 2",@"Sound 3",@"Sound 4",@"Sound 5",@"Sound 6",@"Always vibrate", nil];
    defaults = [[NSArray alloc]initWithObjects:@"Default", nil];
    selectedOptions = [[NSArray alloc]initWithObjects:@"Current location",@"15 minutes",@"15 min before duration",@"15 min before appointment",@"Sound 1",@"", nil];
    preferences = [[NSArray alloc]initWithObjects:timeZone,defaultMeetingDuration,ETDAlert,ETAAlert,alertsSounds,defaults, nil];
    
    arrayForBool=[[NSMutableArray alloc]init];
    sectionTitleArray=[[NSArray alloc]initWithObjects:
                       @"Time Zone",
                       @"Default Meeting Duration",
                       @"Default ETD Alert",
                       @"Default ETA Alert",
                       @"Alerts Sounds",
                       @"Would you like to notify about your ETA if running late?",
                       nil];
    
    for (int i=0; i<[sectionTitleArray count]; i++) {
        [arrayForBool addObject:[NSNumber numberWithBool:NO]];
    }
    [arrayForBool replaceObjectAtIndex:5 withObject:[NSNumber numberWithBool:YES]];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.contentInset = UIEdgeInsetsMake(35, 0, 0, 0);

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) switchChanged:(id)sender {
    UISwitch* switchControl = sender;
    NSLog( @"The switch is %@", switchControl.on ? @"ON" : @"OFF" );
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 5) {
        return 1;
    }
    else if ([[arrayForBool objectAtIndex:section] boolValue]) {
        return [[preferences objectAtIndex:section] count];
    }
    else
        return 0;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 5) {
        static NSString *cellid=@"hello2";
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellid];
        if (cell==nil) {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellid];
        }
        cell.textLabel.text=[[preferences objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        //cell.textLabel.font=[UIFont systemFontOfSize:15.0f];
        cell.backgroundColor=[UIColor whiteColor];
        //cell.imageView.image=[UIImage imageNamed:@"handle.png"];
        cell.selectionStyle=UITableViewCellSelectionStyleNone ;
        
        UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectZero];
        cell.accessoryView = switchView;
        [switchView setOn:NO animated:NO];
        [switchView addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
        UIView* separatorLineView = [[UIView alloc] initWithFrame:CGRectMake(0 , 49, self.tableView.frame.size.width, 1)];
        separatorLineView.backgroundColor = [UIColor colorWithRed:235.0/255.0 green:235.0/255.0 blue:235.0/255.0 alpha:1];
        [cell.contentView addSubview:separatorLineView];
        return cell;
        
    }
    
    static NSString *cellid=@"hello";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellid];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellid];
    }
    
    
    BOOL manyCells  = [[arrayForBool objectAtIndex:indexPath.section] boolValue];
    /********** If the section supposed to be closed *******************/
    if(!manyCells)
    {
        cell.backgroundColor=[UIColor clearColor];
        
        cell.textLabel.text=@"";
    }
    /********** If the section supposed to be Opened *******************/
    else
    {
        cell.textLabel.text=[[preferences objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        //cell.textLabel.font=[UIFont systemFontOfSize:15.0f];
        cell.backgroundColor=[UIColor whiteColor];
        //cell.imageView.image=[UIImage imageNamed:@"handle.png"];
        cell.selectionStyle=UITableViewCellSelectionStyleNone ;
    }
    cell.textLabel.textColor=[UIColor colorWithRed:28.0/255.0 green:87.0/255.0 blue:255.0/255.0 alpha:1.0];
    
    /********** Add a custom Separator with cell *******************/
    UIView* separatorLineView = [[UIView alloc] initWithFrame:CGRectMake(15, 49, self.tableView.frame.size.width-15, 1)];
    separatorLineView.backgroundColor = [UIColor colorWithRed:235.0/255.0 green:235.0/255.0 blue:235.0/255.0 alpha:1];
    [cell.contentView addSubview:separatorLineView];
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [sectionTitleArray count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 5) {
        
    }
    else{
        /*************** Close the section, once the data is selected ***********************************/
        [arrayForBool replaceObjectAtIndex:indexPath.section withObject:[NSNumber numberWithBool:NO]];
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 5) {
        return 50;
    }
    else if ([[arrayForBool objectAtIndex:indexPath.section] boolValue]) {
        return 50;
    }
    return 0;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section == 5) {
        return 35;
    }
    return 50;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.0001;
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView *sectionView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 280,50)];
    sectionView.tag=section;
    sectionView.backgroundColor = [UIColor whiteColor];
    UILabel *viewLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 0, self.tableView.frame.size.width-10, 50)];
    viewLabel.backgroundColor=[UIColor whiteColor];
    if (section == 5) {
        viewLabel.backgroundColor=[UIColor clearColor];
        sectionView.backgroundColor = [UIColor colorWithRed:243.0/255.0 green:243.0/255.0 blue:243.0/255.0 alpha:1];
        sectionView.frame = CGRectMake(0, 0, 280,35);
        viewLabel.frame = CGRectMake(10, 0, self.tableView.frame.size.width-10, 35);
        viewLabel.font=[UIFont systemFontOfSize:10];
        viewLabel.adjustsFontSizeToFitWidth = YES;
        viewLabel.textColor = [UIColor colorWithRed:109.0/255.0 green:109.0/255.0 blue:114.0/255.0 alpha:1];
    }
    //viewLabel.textColor=[UIColor blackColor];
    //viewLabel.font=[UIFont systemFontOfSize:15];
    viewLabel.text=[sectionTitleArray objectAtIndex:section];
    [sectionView addSubview:viewLabel];
    /********** Add a custom Separator with Section view *******************/
    UIView* separatorLineView = [[UIView alloc] initWithFrame:CGRectMake(15, 49, self.tableView.frame.size.width-15, 1)];
    if (section == 4) {
        separatorLineView.frame = CGRectMake(0, 49, self.tableView.frame.size.width, 1);
    }
    if (section == 5) {
        separatorLineView.frame = CGRectMake(0, 34, self.tableView.frame.size.width, 1);
    }
    
    separatorLineView.backgroundColor = [UIColor colorWithRed:200.0/255.0 green:199.0/255.0 blue:204.0/255.0 alpha:1.0];
    [sectionView addSubview:separatorLineView];
    
    UILabel *selected = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width-10, 50)];
    selected.textAlignment = NSTextAlignmentRight;
    selected.text = selectedOptions[section];
    [sectionView addSubview:selected];
    
    /********** Add UITapGestureRecognizer to SectionView   **************/
    
    UITapGestureRecognizer  *headerTapped   = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sectionHeaderTapped:)];
    [sectionView addGestureRecognizer:headerTapped];
    return  sectionView;
    
    
}
- (void)sectionHeaderTapped:(UITapGestureRecognizer *)gestureRecognizer{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:gestureRecognizer.view.tag];
    if (indexPath.section == 5) {
        
    }
    else{
        if (indexPath.row == 0) {
            BOOL collapsed  = [[arrayForBool objectAtIndex:indexPath.section] boolValue];
            for (int i=0; i<[sectionTitleArray count]; i++) {
                if (indexPath.section==i) {
                    [arrayForBool replaceObjectAtIndex:i withObject:[NSNumber numberWithBool:!collapsed]];
                }
            }
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:gestureRecognizer.view.tag] withRowAnimation:UITableViewRowAnimationAutomatic];
            
        }
    }
}


@end
