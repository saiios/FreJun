//
//  NotificationsTableViewController.m
//  FreJun
//
//  Created by GOTESO on 19/08/16.
//  Copyright © 2016 GOTESO. All rights reserved.
//

#import "NotificationsTableViewController.h"

@interface NotificationsTableViewController ()<NSURLConnectionDelegate>{
    
    BOOL loading;
    UIView *loadingView;
    NSMutableData *mutableData;
    NSArray *buttons;
    NSArray *timestamps;
}


@end

@implementation NotificationsTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    dataclass *obj = [dataclass getInstance];
    obj.NotificationCount = @"0";
    [[NSUserDefaults standardUserDefaults] setObject:@0 forKey:@"notificationCount"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    self.navigationItem.title = @"Notifications";
    buttons = [[NSArray alloc]init];
    buttons = @[@"demo1@gmail.com accepted invite",@"demo2@gmail.com declined invite",@"demo3@gmail.com accepted invite"];
    timestamps = [[NSArray alloc] initWithObjects:@"2 hours ago",@"2 days ago",@"1 month ago", nil];
    self.view.backgroundColor = [UIColor colorWithRed:243.0/255.0 green:243.0/255.0 blue:243.0/255.0 alpha:1];
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    
    [self initNotifications];
}

-(void)initNotifications
{
    dataclass *obj = [dataclass getInstance];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:directoryNotifications]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    
    [request setHTTPMethod:@"POST"];
    NSString *postString = [NSString stringWithFormat:@"email=%@&userID=%@",obj.emailTitle,[[NSUserDefaults standardUserDefaults] stringForKey:@"userID"]];
    NSData *parameterData = [postString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    [request setHTTPBody:parameterData];
    [request setHTTPMethod:@"POST"];
    [request addValue: @"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
                                      {
                                          // do something with the data
                                          NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data
                                                                                               options:kNilOptions
                                                                                                 error:&error];
                                          
                                         // NSArray* latestLoans = [json objectForKey:@"loans"];
                                          
                                          NSLog(@"loans: %@", json);
                                          [loadingView setHidden:YES];

                                      }];
    [dataTask resume];
    
/*
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if( connection )
    {
        mutableData = [NSMutableData new];
        [loadingView setHidden:YES];
    }
 */
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell==nil)
    {
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
    cell.selectionStyle= UITableViewCellSelectionStyleNone;
    
    return cell;
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
    NSString *responseStringWithEncoded = [[NSString alloc] initWithData: mutableData encoding:NSUTF8StringEncoding];
    NSError* error;
    NSDictionary *json = [NSJSONSerialization
                          JSONObjectWithData:mutableData
                          options:kNilOptions
                          error:&error];
    
    NSLog(@"Response from Server : %@", responseStringWithEncoded);

    
}

@end
