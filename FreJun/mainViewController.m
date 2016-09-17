//
//  mainViewController.m
//  FreJun
//
//  Created by GOTESO on 10/08/16.
//  Copyright © 2016 GOTESO. All rights reserved.
//

#import "mainViewController.h"
#import "SACalendar.h"
#import "NotificationsTableViewController.h"
#import "SettingsTableViewController.h"
#import "AddEventTableViewController.h"
#import "mainTableViewCell.h"
#import "DateUtil.h"
#import "calenderViewController.h"
#import "eventDetailsViewController.h"
#import "SWTableViewCell.h"
#import "SearchResultsViewController.h"
#import "Amplitude.h"
CGFloat kResizeThumbSize = 45.0f;
@interface mainViewController ()<NSURLConnectionDelegate,SWTableViewCellDelegate,UISearchResultsUpdating, UISearchControllerDelegate>
{
    SACalendar *frejunCalendar;
    SACalendar *frejunCalendar2;
    CGFloat tempHeight;
    
    BOOL isResizingLR;
    BOOL isResizingUL;
    BOOL isResizingUR;
    BOOL isResizingLL;
    CGPoint touchStart;
    float navBarHeight;
    UIView *numberBadge;
    NSArray *events;
    
    NSMutableData *mutableData;
    int deleteStatus;
    NSArray *json;
    NSMutableArray *finalData;
    BOOL loading;
    UIView *loadingView;
}
@property (strong, nonatomic) NSMutableArray *data;
@property (strong, nonatomic) UISearchController *controller;
@property (strong, nonatomic) NSArray *results;
@end

@implementation mainViewController

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
    dispatch_async(dispatch_get_main_queue(), ^{
        [loadingView setHidden:YES];
    });
    if (deleteStatus == 0) {
    NSString *responseStringWithEncoded = [[NSString alloc] initWithData: mutableData encoding:NSUTF8StringEncoding];
    NSError *error;
    json = [NSJSONSerialization
            JSONObjectWithData:mutableData
            options:kNilOptions
            error:&error];
        dataclass *obj = [dataclass getInstance];
        finalData = [[NSMutableArray alloc]init];
        NSMutableArray *dates = [[NSMutableArray alloc]init];
        NSArray *dates2 = [[NSMutableArray alloc]init];
        int check;

        for (int i = 0; i < json.count ; i++) {
            NSString *date = [[[json objectAtIndex:i] objectForKey:@"startTime"] substringToIndex:10];
            [dates addObject:date]; }
        dates2 = [dates valueForKeyPath:@"@distinctUnionOfObjects.self"];
        obj.dates = dates2;
        for (int i = 0; i < dates2.count; i++) {
            
            NSString *date = dates2[i];
            NSMutableArray *temp = [[NSMutableArray alloc]init];
            NSMutableDictionary *tempDict = [[NSMutableDictionary alloc]init];
            
            for (int j = 0; j < json.count; j++) {
                
                NSString *dateSelected = [[[json objectAtIndex:j] objectForKey:@"startTime"] substringToIndex:10];
                
                if ([date isEqualToString:dateSelected]) {
                    [temp addObject:[json objectAtIndex:j]];
                    NSLog(@"efewf");
                }
            }
            
            [tempDict setObject:date forKey:@"date"];
            [tempDict setObject:temp forKey:@"events"];
            [finalData addObject:tempDict];
        }
        NSLog(@"final data is %@",finalData);
        obj.events = json;
        obj.sortedEvents = finalData;
        [self.tableView reloadData];

    }
    if (deleteStatus == 1) {
        [self loadData];
    }
}

-(void)loadingView{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [loadingView setHidden:NO];
    });
    loadingView = [[UIView alloc]initWithFrame:CGRectMake(100, 400, 80, 80)];
    loadingView.center = self.view.center;
    loadingView.backgroundColor = [UIColor colorWithWhite:0. alpha:0.85];
    loadingView.layer.cornerRadius = 5;
    
    UIActivityIndicatorView *activityView=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activityView.center = CGPointMake(loadingView.frame.size.width / 2.0, 35);
    [activityView startAnimating];
    activityView.tag = 100;
    [loadingView addSubview:activityView];
    
    UILabel* lblLoading = [[UILabel alloc]initWithFrame:CGRectMake(0, 48, 80, 30)];
    lblLoading.text = @"Loading...";
    lblLoading.textColor = [UIColor whiteColor];
    lblLoading.font = [UIFont fontWithName:lblLoading.font.fontName size:15];
    lblLoading.textAlignment = NSTextAlignmentCenter;
    [loadingView addSubview:lblLoading];
    
    [self.view addSubview:loadingView];
    [loadingView setHidden:YES];
    
}

-(void)loadData{
    deleteStatus = 0;
    json = [[NSArray alloc]init];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:directoryEventList]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    
    [request setHTTPMethod:@"POST"];
    NSString *postString = [NSString stringWithFormat:@"userID=%@",[[NSUserDefaults standardUserDefaults] stringForKey:@"userID"]];
    NSData *parameterData = [postString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    [request setHTTPBody:parameterData];
    [request setHTTPMethod:@"POST"];
    [request addValue: @"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if( connection )
    {
        mutableData = [NSMutableData new];
        //[loadingView setHidden:YES];
    }

}

- (void)viewDidLoad {
    [super viewDidLoad];
    events = [[NSArray alloc]initWithObjects:
              @{@"allday":@"YES",
                @"Title":@"Task 1",
                @"Priority":@"3",
                @"State":@"1" },
              
              @{@"allday":@"NO",
                @"Title":@"Call Roman",
                @"Priority":@"1",
                @"State":@"2" },
              
              @{@"allday":@"NO",
                @"Title":@"Another one task",
                @"Priority":@"0",
                @"State":@"2" },
              
              @{@"allday":@"NO",
                @"Title":@"Some event",
                @"Priority":@"2",
                @"State":@"0" },
              
              @{@"allday":@"NO",
                @"Title":@"Buy something else",
                @"Priority":@"0",
                @"State":@"2" },
              
              @{@"allday":@"NO",
                @"Title":@"Meeting with BrandedMe",
                @"Priority":@"2",
                @"State":@"0" },
              
              @{@"allday":@"NO",
                @"Title":@"Home Dinner",
                @"Priority":@"0",
                @"State":@"1" },
              nil];

    [[Amplitude instance] logEvent:@"Homepage"];
    dataclass *obj = [dataclass getInstance];
    navBarHeight = self.navigationController.navigationBar.frame.size.height+[UIApplication sharedApplication].statusBarFrame.size.height;
    self.navigationItem.title = obj.emailTitle;
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    self.tableView = [[UITableView alloc]init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.contentInset = UIEdgeInsetsMake(-navBarHeight, 0, 0, 0);
    frejunCalendar = [[SACalendar alloc]initWithFrame:CGRectMake(10, 0, self.view.frame.size.width - 20, (self.view.frame.size.height-navBarHeight)/2)
                                      scrollDirection:ScrollDirectionVertical
                                        pagingEnabled:YES];
    frejunCalendar.delegate = self;
    
    SearchResultsViewController *searchResults = (SearchResultsViewController *)self.controller.searchResultsController;
    [self addObserver:searchResults forKeyPath:@"results" options:NSKeyValueObservingOptionNew context:nil];

}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    numberBadge = [[UIView alloc]initWithFrame:CGRectMake(18, 10, 22, 22)];
    numberBadge.backgroundColor = [UIColor redColor];
    numberBadge.layer.cornerRadius = numberBadge.frame.size.width/2;
    UILabel *number = [[UILabel alloc]initWithFrame:CGRectMake(0.5, 0.5, numberBadge.frame.size.width-1, numberBadge.frame.size.height-1)];
    number.font = [UIFont systemFontOfSize:12];
    number.textColor = [UIColor whiteColor];
    dataclass *obj = [dataclass getInstance];
    number.text = obj.NotificationCount;
    number.textAlignment = NSTextAlignmentCenter;
    number.adjustsFontSizeToFitWidth = YES;
    [numberBadge addSubview:number];
    [self.navigationController.navigationBar addSubview:numberBadge];
}
-(void)viewWillDisappear:(BOOL)animated{
    dispatch_async(dispatch_get_main_queue(), ^{
        [loadingView setHidden:NO];
    });
    [super viewWillDisappear:animated];
    [numberBadge removeFromSuperview];

}

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [[self navigationController] setNavigationBarHidden:NO];
    [self loadData];
}

-(void)viewDidLayoutSubviews{
    
    [super viewDidLayoutSubviews];
    
    self.calendarBackGroundView.frame = CGRectMake(0, navBarHeight, self.view.frame.size.width, (self.view.frame.size.height-navBarHeight)/2);
    [self.calendarBackGroundView addSubview:frejunCalendar];
    self.calendarBackGroundView.clipsToBounds = YES;
    self.tableViewBackground.frame = CGRectMake(0, (self.view.frame.size.height-navBarHeight)/2 + navBarHeight, self.view.frame.size.width, (self.view.frame.size.height-navBarHeight)/2);
    self.tableView.frame = CGRectMake(0, 0, self.view.frame.size.width, (self.view.frame.size.height-navBarHeight)/2);
    [self.tableViewBackground addSubview:self.tableView];
    self.dragButton.center = CGPointMake(self.view.center.x, ((self.view.frame.size.height-navBarHeight)/2 + navBarHeight));
    CAGradientLayer *gradient3 = [CAGradientLayer layer];
    gradient3.frame = self.calendarBackGroundView.bounds;
    gradient3.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithRed:32.0/255.0 green:81.0/255.0 blue:183.0/255.0 alpha:1.0] CGColor], (id)[[UIColor colorWithRed:51.0/255.0 green:179.0/255.0 blue:105.0/255.0 alpha:1.0] CGColor], nil];
    [self.calendarBackGroundView.layer insertSublayer:gradient3 atIndex:0];
    UISwipeGestureRecognizer * swipeleft=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeleft:)];
    swipeleft.direction=UISwipeGestureRecognizerDirectionRight ;
    [_calendarBackGroundView addGestureRecognizer:swipeleft];
    [self blackBar];

}

-(void)swipeleft:(UISwipeGestureRecognizer*)gestureRecognizer
{
    //Do what you want here
    NSLog(@"swiped");
    CATransition* transition = [CATransition animation];
    transition.duration = .3;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionMoveIn;
    transition.subtype= kCATransitionFromLeft;
    [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];    SettingsTableViewController* infoController = [[SettingsTableViewController alloc]initWithStyle:UITableViewStyleGrouped];
    [self.navigationController pushViewController:infoController animated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)blackBar{
    
    [self.dragButton addTarget:self action:@selector(wasDragged:withEvent:)
                    forControlEvents:UIControlEventTouchDragInside];
    
    [self.dragButton addTarget:self action:@selector(finishedDragging:withEvent:)
                    forControlEvents:UIControlEventTouchDragExit|UIControlEventTouchUpInside];
}

- (void)wasDragged:(UIButton *)button withEvent:(UIEvent *)event
{
    // get the touch
    UITouch *touch = [[event touchesForView:button] anyObject];
    
    // get delta
    CGPoint previousLocation = [touch previousLocationInView:button];
    CGPoint location = [touch locationInView:button];
    CGFloat delta_x = location.x - previousLocation.x;
    CGFloat delta_y = location.y - previousLocation.y;
    
    if (button.center.y+delta_y < (self.view.frame.size.height-navBarHeight)/2 + navBarHeight) {
    // move button
    button.center = CGPointMake(button.center.x,
                                button.center.y + delta_y);
    self.calendarBackGroundView.frame = CGRectMake(0, navBarHeight, self.view.frame.size.width, self.calendarBackGroundView.frame.size.height + delta_y);
    self.tableViewBackground.frame = CGRectMake(0, self.tableViewBackground.frame.origin.y + delta_y, self.view.frame.size.width, self.tableViewBackground.frame.size.height);
    self.tableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-navBarHeight);
    }
}

- (void)finishedDragging:(UIButton *)button withEvent:(UIEvent *)event
{
    //doesn't get called
    NSLog(@"finished dragging");
    
    if (button.center.y < (self.view.frame.size.height-navBarHeight)/3) {
        
        button.center = CGPointMake(button.center.x, navBarHeight+2.8);
        self.calendarBackGroundView.frame = CGRectMake(0, navBarHeight, self.view.frame.size.width, 0);
        self.tableViewBackground.frame = CGRectMake(0, navBarHeight, self.view.frame.size.width, self.view.frame.size.height-70);
        self.tableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-navBarHeight);
        
    }
    else if (button.center.y > (self.view.frame.size.height-navBarHeight)/2 + navBarHeight*2){
        
        button.center = CGPointMake(button.center.x, self.view.frame.size.height);
        self.calendarBackGroundView.frame = CGRectMake(0, navBarHeight, self.view.frame.size.width, self.view.frame.size.height-navBarHeight);
        self.tableViewBackground.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 0);
        self.tableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-navBarHeight);
       // frejunCalendar.frame = CGRectMake(0, 0, self.view.frame.size.width-20, 500);
        
    }
    else{
        
        button.center = CGPointMake(button.center.x, (self.view.frame.size.height-navBarHeight)/2 + navBarHeight);
        self.calendarBackGroundView.frame = CGRectMake(0, navBarHeight, self.view.frame.size.width, (self.view.frame.size.height-navBarHeight)/2);
        self.tableViewBackground.frame = CGRectMake(0, (self.view.frame.size.height-navBarHeight)/2 + navBarHeight, self.view.frame.size.width, (self.view.frame.size.height-navBarHeight)/2);
        self.tableView.frame = CGRectMake(0, 0, self.view.frame.size.width, (self.view.frame.size.height-navBarHeight)/2);
        //frejunCalendar.frame = CGRectMake(0, 0, self.view.frame.size.width-20, 250);
    }
}

- (void)pan:(UIPanGestureRecognizer *)aPan; {
    CGPoint currentPoint = [aPan locationInView:self.calendarBackGroundView];
    NSLog(@"hj");
    [UIView animateWithDuration:0.01f
                     animations:^{
                         CGRect oldFrame = _calendarBackGroundView.frame;
                         _calendarBackGroundView.frame = CGRectMake(oldFrame.origin.x, currentPoint.y, oldFrame.size.width, ([UIScreen mainScreen].bounds.size.height - currentPoint.y));
                     }];
}
- (IBAction)notifications:(id)sender {
    
        NotificationsTableViewController* infoController = [[NotificationsTableViewController alloc]initWithStyle:UITableViewStyleGrouped];
        [self.navigationController pushViewController:infoController animated:YES];
}

- (IBAction)addEvent:(id)sender {
    AddEventTableViewController* infoController = [self.storyboard instantiateViewControllerWithIdentifier:@"addevent"];
    [self.navigationController pushViewController:infoController animated:YES];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[finalData[section] objectForKey:@"events"] count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellid=@"mainTableViewCell";
    mainTableViewCell *cell = (mainTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellid];
    if (cell==nil) {
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"mainTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    //title = [json[indexPath.row] objectForKey:@"eventName"];
    NSString *title = [[finalData[indexPath.section] objectForKey:@"events"][indexPath.row] objectForKey:@"eventName"];
    if (title.length == 0) {
        title = @"No title";
    }
    cell.title.text = title;
    cell.title.frame = CGRectMake(cell.title.frame.origin.x, 0, [title sizeWithFont:cell.textLabel.font constrainedToSize:CGSizeMake(MAXFLOAT, cell.frame.size.height)].width, cell.frame.size.height);
    
    
    int priorityLevel = [[[finalData[indexPath.section] objectForKey:@"events"][indexPath.row] objectForKey:@"priority"] intValue];
    switch(priorityLevel)
    {
        case 0 :
            cell.priorityLabel.text = @"";
            break;
        case 1 :
            cell.priorityLabel.text = @"!";
            break;
        case 2 :
            cell.priorityLabel.text = @"!!";
            break;
        case 3 :
            cell.priorityLabel.text = @"!!!";
            break;
        default :
            cell.priorityLabel.text = @"";
    }
    //cell.priorityLabel.text = [events[indexPath.row] objectForKey:@"Priority"];
    cell.priorityLabel.frame = CGRectMake(cell.title.frame.origin.x + cell.title.frame.size.width+20, 0, 35, cell.frame.size.height);
    
    cell.accessoryType = [[events[indexPath.row] objectForKey:@"state"] boolValue] ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;

    
    // Add utility buttons
    NSMutableArray *leftUtilityButtons = [NSMutableArray new];
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    
    [leftUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:25.0/255.0 green:181.0/255.0 blue:90.0/255.0 alpha:1]
                                                icon:[UIImage imageNamed:@"shar.png"]];
    [leftUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:248.0/255.0 green:159.0/255.0 blue:52.0/255.0 alpha:1]
                                                icon:[UIImage imageNamed:@"penc.png"]];
    [leftUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:232.0/255.0 green:83.0/255.0 blue:73.0/255.0 alpha:1]
                                                icon:[UIImage imageNamed:@"dust.png"]];
    
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:0.78f green:0.78f blue:0.8f alpha:1.0]
                                                title:@"More"];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:1.0f green:0.231f blue:0.188 alpha:1.0f]
                                                title:@"Delete"];
    
    //cell.leftUtilityButtons = leftUtilityButtons;
    cell.rightUtilityButtons = leftUtilityButtons;
    cell.delegate = self;
    
    
    return cell;

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    dataclass *obj = [dataclass getInstance];
    obj.selectedEvent = [finalData[indexPath.section] objectForKey:@"events"][indexPath.row];
    eventDetailsViewController* infoController = [self.storyboard instantiateViewControllerWithIdentifier:@"eventDetails"];
    [self.navigationController pushViewController:infoController animated:YES];
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return finalData.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *sectionHeaderView;
    
    sectionHeaderView = [[UIView alloc] initWithFrame:
                         CGRectMake(0, 0, tableView.frame.size.width, 30)];
    
    
    sectionHeaderView.backgroundColor = [UIColor colorWithRed:243.0/255.0 green:243.0/255.0 blue:243.0/255.0 alpha:1];;
    
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:
                            CGRectMake(10,0, sectionHeaderView.frame.size.width, sectionHeaderView.frame.size.height)];
    
    headerLabel.backgroundColor = [UIColor clearColor];
    [headerLabel setTextColor:[UIColor lightGrayColor]];
    [headerLabel setFont:[UIFont systemFontOfSize:12]];
    [sectionHeaderView addSubview:headerLabel];
    headerLabel.text = [finalData[section] objectForKey:@"date"];
    NSDate *dateFromString = [[NSDate alloc] init];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    dateFromString = [dateFormatter dateFromString:[finalData[section] objectForKey:@"date" ]];
    [dateFormatter setDateFormat:@"EEEE,MMMM d,yyyy"];
    NSLog(@"%@",[dateFormatter stringFromDate:dateFromString]);
    headerLabel.text = [dateFormatter stringFromDate:dateFromString];
    
//    switch (section) {
//        case 0:
//            headerLabel.text = @"Section 1";
//            return sectionHeaderView;
//            break;
//        case 1:
//            headerLabel.text = @"Section 2";
//            return sectionHeaderView;
//            break;
//        case 2:
//            headerLabel.text = @"Section 3";
//            return sectionHeaderView;
//            break;
//        default:
//            break;
//    }
    
    return sectionHeaderView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.0001;
}

-(void) SACalendar:(SACalendar*)calendar didSelectDate:(int)day month:(int)month year:(int)year
{
    NSLog(@"Date Selected : %02i/%02i/%04i",day,month,year);
    NSString *date = [NSString stringWithFormat:@"%04i-%02i-%02i",year,month,day];
    NSLog(@"date here %@",date);
    dataclass *obj = [dataclass getInstance];
    for (int i = 0; i < finalData.count; i++) {
        if ([[finalData[i] objectForKey:@"date"] isEqualToString:date]) {
            obj.events = [finalData[i] objectForKey:@"events"];
            obj.selectedDate = date;
            NSDate *dateFromString = [[NSDate alloc] init];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
            dateFromString = [dateFormatter dateFromString:date];
            [dateFormatter setDateFormat:@"EEEE,MMMM d,yyyy"];
            obj.selectedDate = [dateFormatter stringFromDate:dateFromString];
            calenderViewController* infoController = [self.storyboard instantiateViewControllerWithIdentifier:@"calender"];
            [self.navigationController pushViewController:infoController animated:YES];
        }
    }
   
}

/**
 *  Delegate method : get called user has scroll to a new month
 */
-(void) SACalendar:(SACalendar *)calendar didDisplayCalendarForMonth:(int)month year:(int)year{
    NSLog(@"Displaying : %@ %04i",[DateUtil getMonthString:month],year);
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    
    switch (index) {
        case 0:
        {
            NSString * message = @"The most sophisticated calendar app with a built-in personal assistant to manage a busy life. Check www.frejun.com now !!";
            NSArray * shareItems = @[message];
            
            UIActivityViewController * avc = [[UIActivityViewController alloc] initWithActivityItems:shareItems applicationActivities:nil];
            [self presentViewController:avc animated:YES completion:nil];
            break;
        }
        case 1:
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"No Permissions" message:@"You are not authorised to edit this Event." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alertView show];
            break;
        }
        case 2:
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [loadingView setHidden:NO];
            });
            NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:directoryDeleteEvent]
                                                                   cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                               timeoutInterval:60.0];
            
            [request setHTTPMethod:@"POST"];
            NSString *postString = [NSString stringWithFormat:@"eventID=%@",[[finalData[indexPath.section] objectForKey:@"events"][indexPath.row] objectForKey:@"eventID"]];
            NSData *parameterData = [postString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
            [request setHTTPBody:parameterData];
            [request setHTTPMethod:@"POST"];
            [request addValue: @"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
            NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
            if( connection )
            {
                deleteStatus = 1;
            }

            break;
        }
        case 3:
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Twitter Sharing" message:@"Just shared the pattern image on Twitter" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alertView show];
        }
        default:
            break;
    }
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
//    [self filterContentForSearchText:searchString
//                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
//                                      objectAtIndex:[self.searchDisplayController.searchBar
//                                                     selectedScopeButtonIndex]]];
    
    return YES;
}

# pragma mark - Search Results Updater

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    
    // filter the search results
    //NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF contains [cd] %@", self.controller.searchBar.text];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"eventName contains [c] %@", self.controller.searchBar.text];
    self.results = [json filteredArrayUsingPredicate:predicate];
    
    // NSLog(@"Search Results are: %@", [self.results description]);
}

- (IBAction)searchButtonPressed:(id)sender {
    
    // present the search controller
    [self presentViewController:self.controller animated:YES completion:nil];
    
}

- (UISearchController *)controller {
    
    if (!_controller) {
        
        // instantiate search results table view
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        SearchResultsViewController *resultsController = [storyboard instantiateViewControllerWithIdentifier:@"SearchResults"];
        
        // create search controller
        _controller = [[UISearchController alloc]initWithSearchResultsController:resultsController];
        _controller.searchResultsUpdater = self;
        
        // optional: set the search controller delegate
        _controller.delegate = self;
        
    }
    return _controller;
}

@end
