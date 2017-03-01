//
//  PreferencesTableViewController.m
//  FreJun
//
//  Created by GOTESO on 22/08/16.
//  Copyright © 2016 GOTESO. All rights reserved.
//

#import "UserPrefrencesTableViewController.h"
#import <AVFoundation/AVFoundation.h>
@interface UserPrefrencesTableViewController ()<NSURLConnectionDelegate,AVAudioPlayerDelegate>{
    
    BOOL loading;
    UIView *loadingView;
    NSMutableData *mutableData;
    NSMutableDictionary *data;
    NSMutableArray *selectedOptions;
    
    NSMutableArray *arrayForBool;
    NSArray *sectionTitleArray;
    
    NSArray *timeZone;
    NSArray *defaultMeetingDuration;
    NSArray *ETDAlert;
    NSArray *ETAAlert;
    NSArray *alertsSounds;
    NSArray *alertsSoundsCaf;
    NSArray *defaults;
    
    NSArray *preferences;
    NSArray *widths;
    
    int check;
    AVAudioPlayer* player;
    BOOL playing;
    NSString *sound;
    UISwitch *defaultSwitch;
    int defaultNotify;
}

@end

@implementation UserPrefrencesTableViewController
-(id)initWithStyle:(UITableViewStyle)style{
    
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UITableView *tableView = [[UITableView alloc]initWithFrame:self.tableView.frame style:UITableViewStyleGrouped];
    self.tableView = tableView;
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc]init];
    [editButton setTitle:@"Done"];
    [editButton setTarget:self];
    [editButton setAction:@selector(done)];
    self.navigationItem.rightBarButtonItem = editButton;
    
    selectedOptions = [[NSMutableArray alloc]init];
    self.navigationItem.title = @"Preferences";
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    timeZone = [[NSArray alloc]init];
    defaultMeetingDuration = [[NSArray alloc]initWithObjects:@"15 minutes",@"30 minutes",@"45 minutes",@"60 minutes",@"90 minutes",@"2 hours",@"3 hours", nil];
    ETDAlert = [[NSArray alloc]initWithObjects:@"5 min before departure",@"10 minutes before departure",@"15 minutes before departure",@"30 minutes before departure",@"1 hour before departure",@"2 hours before departure",@"1 day before departure", nil];
    ETAAlert = [[NSArray alloc]initWithObjects:@"5 min before appointment",@"10 minutes before appointment",@"15 minutes before appointment",@"30 minutes before appointment",@"1 hour before appointment",@"2 hours before appointment",@"1 day before appointment", nil];
    alertsSounds = [[NSArray alloc]initWithObjects:@"Sound 1",@"Sound 2",@"Sound 3",@"Always vibrate", nil];
    alertsSoundsCaf = [[NSArray alloc]initWithObjects:@"sound1.caf",@"sound2.caf",@"sound3.caf",@"none", nil];
    defaults = [[NSArray alloc]initWithObjects:@"Default", nil];
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
    widths = [[NSArray alloc]initWithObjects:@82,@192,@133,@133,@99, @100,nil];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    /*
    check = 0;
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:directoryFetchPref]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    
    [request setHTTPMethod:@"POST"];
    dataclass *obj = [dataclass getInstance];
    
    NSString *postString = [NSString stringWithFormat:@"email=%@&userID=%@",obj.emailTitle,[[NSUserDefaults standardUserDefaults] stringForKey:@"userID"]];
    NSData *parameterData = [postString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    [request setHTTPBody:parameterData];
    [request setHTTPMethod:@"POST"];
    [request addValue: @"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if( connection )
    {
        mutableData = [NSMutableData new];
        [loadingView setHidden:YES];
    } */
    
    dataclass *obj = [dataclass getInstance];
    NSString *url = [NSString stringWithFormat:@"%@?email=%@&userID=%@",directoryFetchPref,obj.emailTitle,[[NSUserDefaults standardUserDefaults] stringForKey:@"userID"]];
    NSLog(@"%@",url);
    url = [url stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    NSURL *queryUrl = [NSURL URLWithString:url];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *data2 = [NSData dataWithContentsOfURL: queryUrl];
        NSError* error;
        NSLog(@"bholi %@",data2);
        NSString* newStr = [[NSString alloc] initWithData:data2 encoding:NSUTF8StringEncoding];
        NSLog(@"string is : %@",newStr);
        if(data2){
            NSArray *json = [NSJSONSerialization
                                  JSONObjectWithData:data2
                                  options:kNilOptions
                                  error:&error];
            NSLog(@"%@",json);
            dispatch_async(dispatch_get_main_queue(), ^{
                if (1) {
                    [loadingView setHidden:YES];
                    if ([newStr isEqualToString:@"no data"]) {
                        data = [[NSMutableDictionary alloc]initWithObjectsAndKeys:@0,@"sound",@15,@"defaultEtdAlert",@0,@"timezone",@15,@"defaultEtaAlert",@30,@"defaultMeetDuration", nil];
                    }

                    else{
                        data = [[NSMutableDictionary alloc]initWithDictionary:[json objectAtIndex:0]];
                    }
                    
                    defaultNotify = [[data objectForKey:@"defaultNotify"] intValue];
                    if (defaultNotify == 1) {
                        [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"switch"];
                    }
                    else{
                        [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"switch"];
                    }
                    [[NSUserDefaults standardUserDefaults] synchronize];


                    
                    int first = [[data objectForKey:@"defaultMeetDuration"] intValue];
                    int index1;
                    switch(first)
                    {
                        case 15 :
                            index1 = 0;
                            break;
                        case 30 :
                            index1 = 1;
                            break;
                        case 45 :
                            index1 = 2;
                            break;
                        case 60 :
                            index1 = 3;
                            break;
                        case 90 :
                            index1 = 4;
                            break;
                        case 120 :
                            index1 = 5;
                            break;
                        case 180 :
                            index1 = 6;
                            break;
                        default :
                            index1 = 0;
                    }
                    
                    int second = [[data objectForKey:@"defaultEtdAlert"] intValue];
                    int index2;
                    switch(second)
                    {
                        case 5 :
                            index2 = 0;
                            break;
                        case 10 :
                            index2 = 1;
                            break;
                        case 15 :
                            index2 = 2;
                            break;
                        case 30 :
                            index2 = 3;
                            break;
                        case 60 :
                            index2 = 4;
                            break;
                        case 120 :
                            index2 = 5;
                            break;
                        case 1440 :
                            index2 = 6;
                            break;
                        default :
                            index2 = 0;
                    }
                    
                    int third = [[data objectForKey:@"defaultEtaAlert"] intValue];
                    int index3;
                    switch(third)
                    {
                        case 5 :
                            index3 = 0;
                            break;
                        case 10 :
                            index3 = 1;
                            break;
                        case 15 :
                            index3 = 2;
                            break;
                        case 30 :
                            index3 = 3;
                            break;
                        case 60 :
                            index3 = 4;
                            break;
                        case 120 :
                            index3 = 5;
                            break;
                        case 1440 :
                            index3 = 6;
                            break;
                        default :
                            index3 = 0;
                    }
                    [selectedOptions addObject:@""];
                    [selectedOptions addObject:[NSString stringWithFormat:@"%d",index1]];
                    [selectedOptions addObject:[NSString stringWithFormat:@"%d",index2]];
                    [selectedOptions addObject:[NSString stringWithFormat:@"%d",index3]];
                    [selectedOptions addObject:[NSString stringWithFormat:@"%@",[data objectForKey:@"sound"]]];
                    [self.tableView reloadData];

                }
            });
            
        }
        else{
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [loadingView setHidden:YES];
                // loading = NO;
                // [self alertStatus:@"Please try again after some time." :@"Connection Failed!"];

            });}
    });

    
    
}

- (void) switchChanged:(id)sender {
    UISwitch* switchControl = sender;
    NSLog( @"The switch is %@", switchControl.on ? @"ON" : @"OFF" );
    if (switchControl.on) {
        [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"switch"];
    }
    else{
        [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"switch"];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
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
        
        UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
        cell.textLabel.text=[[preferences objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        //cell.textLabel.font=[UIFont systemFontOfSize:15.0f];
        cell.backgroundColor=[UIColor whiteColor];
        //cell.imageView.image=[UIImage imageNamed:@"handle.png"];
        cell.selectionStyle=UITableViewCellSelectionStyleNone ;
        
        defaultSwitch = [[UISwitch alloc] initWithFrame:CGRectZero];
        cell.accessoryView = defaultSwitch;
        [defaultSwitch setOn:NO animated:NO];
        [defaultSwitch addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
        if ([[[NSUserDefaults standardUserDefaults] stringForKey:@"switch"] boolValue]) {
            [defaultSwitch setOn:YES animated:NO];
        }
        UIView* separatorLineView = [[UIView alloc] initWithFrame:CGRectMake(0 , 49, self.tableView.frame.size.width, 1)];
        separatorLineView.backgroundColor = [UIColor colorWithRed:235.0/255.0 green:235.0/255.0 blue:235.0/255.0 alpha:1];
        [cell.contentView addSubview:separatorLineView];
        return cell;
        
    }
    
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
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
    
    /*********** Tick *************/
    if (indexPath.section == 1) {
    int first = [[data objectForKey:@"defaultMeetDuration"] intValue];
    int index;
    switch(first)
    {
        case 15 :
            index = 0;
            break;
        case 30 :
            index = 1;
            break;
        case 45 :
            index = 2;
            break;
        case 60 :
            index = 3;
            break;
        case 90 :
            index = 4;
            break;
        case 120 :
            index = 5;
            break;
        case 180 :
            index = 6;
            break;
        default :
            index = 0;
    } if (indexPath.row == index) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
        
    } }
    
    if (indexPath.section == 2) {
        int first = [[data objectForKey:@"defaultEtdAlert"] intValue];
        int index;
        switch(first)
        {
            case 5 :
                index = 0;
                break;
            case 10 :
                index = 1;
                break;
            case 15 :
                index = 2;
                break;
            case 30 :
                index = 3;
                break;
            case 60 :
                index = 4;
                break;
            case 120 :
                index = 5;
                break;
            case 1440 :
                index = 6;
                break;
            default :
                index = 0;
        } if (indexPath.row == index) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        } else{
            cell.accessoryType = UITableViewCellAccessoryNone;
            
        }}
    
    if (indexPath.section == 3) {
        int first = [[data objectForKey:@"defaultEtaAlert"] intValue];
        int index;
        switch(first)
        {
            case 5 :
                index = 0;
                break;
            case 10 :
                index = 1;
                break;
            case 15 :
                index = 2;
                break;
            case 30 :
                index = 3;
                break;
            case 60 :
                index = 4;
                break;
            case 120 :
                index = 5;
                break;
            case 1440 :
                index = 6;
                break;
            default :
                index = 0;
        } if (indexPath.row == index) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }else{
            cell.accessoryType = UITableViewCellAccessoryNone;
            
        } }
    
    if (indexPath.section == 4) {
        if (indexPath.row == [[data objectForKey:@"sound"] intValue]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        else{
            cell.accessoryType = UITableViewCellAccessoryNone;

        }}

    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [sectionTitleArray count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 5) {
        return;
    }
    [selectedOptions replaceObjectAtIndex:indexPath.section withObject:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
    if (indexPath.section == 4) {
        
    [data setObject:[NSString stringWithFormat:@"%ld",indexPath.row] forKey:@"sound"];
        if (indexPath.row == 0) {
            //AudioServicesPlaySystemSound(1004);
            sound = @"sound1.mp3";
            [self playSound];
        }
        else if (indexPath.row == 1){
            
            //AudioServicesPlaySystemSound(1008);
            sound = @"sound2.mp3";
            [self playSound];
        }
        else if (indexPath.row == 2){
            
            //AudioServicesPlaySystemSound(1009);
            sound = @"sound3.mp3";
            [self playSound];
        }
        else{
            
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        }
    }
    if (indexPath.section == 1) {
        int index;
        switch(indexPath.row)
        {
            case 0 :
                index = 15;
                break;
            case 1 :
                index = 30;
                break;
            case 2 :
                index = 45;
                break;
            case 3 :
                index = 60;
                break;
            case 4 :
                index = 90;
                break;
            case 5 :
                index = 120;
                break;
            case 6 :
                index = 180;
                break;
            default :
                index = 0;
        }
        
        [data setObject:[NSString stringWithFormat:@"%d",index] forKey:@"defaultMeetDuration"];
    }
    
    if (indexPath.section == 2) {
        int index;
        switch(indexPath.row)
        {
            case 0 :
                index = 5;
                break;
            case 1 :
                index = 10;
                break;
            case 2 :
                index = 15;
                break;
            case 3 :
                index = 30;
                break;
            case 4 :
                index = 60;
                break;
            case 5 :
                index = 120;
                break;
            case 6 :
                index = 1440;
                break;
            default :
                index = 0;
        }
        
        [data setObject:[NSString stringWithFormat:@"%d",index] forKey:@"defaultEtdAlert"];
    }
    
    if (indexPath.section == 3) {
        int index;
        switch(indexPath.row)
        {
            case 0 :
                index = 5;
                break;
            case 1 :
                index = 10;
                break;
            case 2 :
                index = 15;
                break;
            case 3 :
                index = 30;
                break;
            case 4 :
                index = 60;
                break;
            case 5 :
                index = 120;
                break;
            case 6 :
                index = 1440;
                break;
            default :
                index = 0;
        }
        
        [data setObject:[NSString stringWithFormat:@"%d",index] forKey:@"defaultEtaAlert"];
    }
    
    
        /*************** Close the section, once the data is selected ***********************************/

        [arrayForBool replaceObjectAtIndex:indexPath.section withObject:[NSNumber numberWithBool:NO]];

        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationAutomatic];

    
    
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
    
    UILabel *selected = [[UILabel alloc]initWithFrame:CGRectMake([widths[section] intValue]+15, 0, self.tableView.frame.size.width-25-[widths[section] intValue], 50)];
    selected.textAlignment = NSTextAlignmentRight;
    //selected.adjustsFontSizeToFitWidth = YES;
    if (section == 0) {
        selected.text = @"Current location";
    }
    if (selectedOptions.count > 0) {
    if (section == 1) {
        selected.text = [defaultMeetingDuration objectAtIndex:[selectedOptions[1] intValue]];
    }
    else if (section == 2){
        selected.text = [ETDAlert objectAtIndex:[selectedOptions[2] intValue]];
        selected.font = [UIFont systemFontOfSize:10.5];
    }
    else if (section == 3){
        selected.text = [ETAAlert objectAtIndex:[selectedOptions[3] intValue]];
        selected.font = [UIFont systemFontOfSize:10.5];
    }
    else if (section == 4){
        selected.text = [alertsSounds objectAtIndex:[selectedOptions[4] intValue]];
    }
    }
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

#pragma mark NSURLConnection delegates

-(void) connection:(NSURLConnection *) connection didReceiveResponse:(NSURLResponse *)response
{
    [mutableData setLength:0];
    NSLog(@"response %@",response);
}

-(void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [mutableData appendData:data];
    NSLog(@"dara got");
}

-(void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    //serverResponse.text = NO_CONNECTION;
    NSLog(@"45455 %@",error);
    return;
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if (check == 1) {
        check = 0;
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    dataclass *obj = [dataclass getInstance];
    dispatch_async(dispatch_get_main_queue(), ^{
        [loadingView setHidden:YES];
    });
    NSString *responseStringWithEncoded = [[NSString alloc] initWithData: mutableData encoding:NSUTF8StringEncoding];
    NSError* error;
    NSMutableDictionary *json = [NSJSONSerialization
                          JSONObjectWithData:mutableData
                          options:kNilOptions
                          error:&error];
    
    NSLog(@"Response from Server : %@", responseStringWithEncoded);
    if ([responseStringWithEncoded isEqualToString:@"No Preference Data"]) {
        data = [[NSMutableDictionary alloc]initWithObjectsAndKeys:@0,@"sound",@15,@"defaultEtdAlert",@0,@"timezone",@15,@"defaultEtaAlert",@30,@"defaultMeetDuration", nil];
    }
    else{
        data = [[NSMutableDictionary alloc]initWithDictionary:json];
    }

        int first = [[data objectForKey:@"defaultMeetDuration"] intValue];
        int index1;
        switch(first)
        {
            case 15 :
                index1 = 0;
                break;
            case 30 :
                index1 = 1;
                break;
            case 45 :
                index1 = 2;
                break;
            case 60 :
                index1 = 3;
                break;
            case 90 :
                index1 = 4;
                break;
            case 120 :
                index1 = 5;
                break;
            case 180 :
                index1 = 6;
                break;
            default :
                index1 = 0;
        }
    
        int second = [[data objectForKey:@"defaultEtdAlert"] intValue];
        int index2;
        switch(second)
        {
            case 5 :
                index2 = 0;
                break;
            case 10 :
                index2 = 1;
                break;
            case 15 :
                index2 = 2;
                break;
            case 30 :
                index2 = 3;
                break;
            case 60 :
                index2 = 4;
                break;
            case 120 :
                index2 = 5;
                break;
            case 1440 :
                index2 = 6;
                break;
            default :
                index2 = 0;
        }
    
        int third = [[data objectForKey:@"defaultEtaAlert"] intValue];
        int index3;
        switch(third)
        {
            case 5 :
                index3 = 0;
                break;
            case 10 :
                index3 = 1;
                break;
            case 15 :
                index3 = 2;
                break;
            case 30 :
                index3 = 3;
                break;
            case 60 :
                index3 = 4;
                break;
            case 120 :
                index3 = 5;
                break;
            case 1440 :
                index3 = 6;
                break;
            default :
                index3 = 0;
        }
    [selectedOptions addObject:@""];
    [selectedOptions addObject:[NSString stringWithFormat:@"%d",index1]];
    [selectedOptions addObject:[NSString stringWithFormat:@"%d",index2]];
    [selectedOptions addObject:[NSString stringWithFormat:@"%d",index3]];
    [selectedOptions addObject:[NSString stringWithFormat:@"%@",[data objectForKey:@"sound"]]];
    [self.tableView reloadData];
}

-(void)done{
    check = 1;
    
    /*
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:directorypref]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    
    [request setHTTPMethod:@"POST"];
    dataclass *obj = [dataclass getInstance];
    NSString *email = obj.emailTitle;
    NSString *userID = [[NSUserDefaults standardUserDefaults] stringForKey:@"userID"];
    NSString *defaultEtaAlert = [data objectForKey:@"defaultEtaAlert"];
    NSString *defaultEtdAlert = [data objectForKey:@"defaultEtdAlert"];
    NSString *defaultMeetDuration = [data objectForKey:@"defaultMeetDuration"];
    NSString *sound = [data objectForKey:@"sound"];
    
    NSString *postString = [NSString stringWithFormat:@"email=%@&userID=%@&defaultEtaAlert=%@&defaultEtdAlert=%@&defaultMeetDuration=%@&sound=%@&timezone=0&defaultNotify=0",email,userID,defaultEtaAlert,defaultEtdAlert,defaultMeetDuration,sound];
    NSData *parameterData = [postString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    [request setHTTPBody:parameterData];
    [request setHTTPMethod:@"POST"];
    [request addValue: @"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if( connection )
    {
        //mutableData = [NSMutableData new];
        [loadingView setHidden:YES];
    } */
    
    dataclass *obj = [dataclass getInstance];
    NSString *email = obj.emailTitle;
    NSString *userID = [[NSUserDefaults standardUserDefaults] stringForKey:@"userID"];
    NSString *defaultEtaAlert = [data objectForKey:@"defaultEtaAlert"];
    NSString *defaultEtdAlert = [data objectForKey:@"defaultEtdAlert"];
    NSString *defaultMeetDuration = [data objectForKey:@"defaultMeetDuration"];
    NSString *sound = [data objectForKey:@"sound"];
    NSString *allDay = defaultSwitch.on ? @"1" : @"0";
    NSString *url = [NSString stringWithFormat:@"%@?email=%@&userID=%@&defaultEtaAlert=%@&defaultEtdAlert=%@&defaultMeetDuration=%@&sound=%@&timezone=0&defaultNotify=%@",directorypref,email,userID,defaultEtaAlert,defaultEtdAlert,defaultMeetDuration,sound,allDay];
    NSLog(@"%@",url);
    url = [url stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    NSURL *queryUrl = [NSURL URLWithString:url];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *data = [NSData dataWithContentsOfURL: queryUrl];
        NSError* error;
        NSLog(@"bholi %@",data);
        NSString* newStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"string is : %@",newStr);
        if(data){
          NSDictionary *json = [NSJSONSerialization
                    JSONObjectWithData:data
                    options:kNilOptions
                    error:&error];
            NSLog(@"%@",json);
            dispatch_async(dispatch_get_main_queue(), ^{
                if (1) {
                    [loadingView setHidden:YES];
                    [self.navigationController popViewControllerAnimated:YES];
                }
            });
            
        }
        else{
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [loadingView setHidden:YES];
                // loading = NO;
                // [self alertStatus:@"Please try again after some time." :@"Connection Failed!"];
                
            });}
    });


}

-(void)playSound{
    
    
    if (playing) {
        [player stop];
    }
    playing = YES;
    // Construct URL to sound file
    NSString *path = [NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] resourcePath],sound];
    NSURL *soundUrl = [NSURL fileURLWithPath:path];
    
    // Create audio player object and initialize with URL to sound
    player = [[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl error:nil];
    [player play];

}

@end
