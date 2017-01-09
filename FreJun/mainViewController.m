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
#import "eventInvitaionViewController.h"
#import "SWTableViewCell.h"
#import "SearchResultsViewController.h"
#import "Amplitude.h"
#import "EditEventTableViewController.h"
#import "dataclass.h"
#import "UIBarButtonItem+WEPopover.h"
#import "Classes/WEPopoverContentViewController.h"
#import <AVFoundation/AVFoundation.h>

CGFloat kResizeThumbSize = 45.0f;
@interface mainViewController ()<NSURLConnectionDelegate,SWTableViewCellDelegate,UISearchResultsUpdating, UISearchControllerDelegate,AVAudioPlayerDelegate>
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
    BOOL playing;
    AVAudioPlayer *player;
    NSString *notificationeventId;
    NSString *notificationTitle;
    
    BOOL scrolledToCurrentDate;
}
@property (strong, nonatomic) NSMutableArray *data;
@property (strong, nonatomic) UISearchController *controller;
@property (strong, nonatomic) NSArray *results;
@end

@implementation mainViewController

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

    dataclass *obj = [dataclass getInstance];
    NSString *url = [NSString stringWithFormat:@"%@?userID=%@",directoryEventList,[[NSUserDefaults standardUserDefaults] stringForKey:@"userID"]];
    NSLog(@"%@",url);
    url = [url stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    NSURL *queryUrl = [NSURL URLWithString:url];
    //NSLog(@"%@",queryUrl);
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *data4 = [NSData dataWithContentsOfURL: queryUrl];
        NSError* error;
        //NSLog(@"bholi %@",data4);
        NSString* newStr = [[NSString alloc] initWithData:data4 encoding:NSUTF8StringEncoding];
        //NSLog(@"string is : %@",newStr);
        if(data4){
            json = [NSJSONSerialization
                             JSONObjectWithData:data4
                             options:kNilOptions
                             error:&error];
            //NSLog(@"my value is%@",json);
            dispatch_async(dispatch_get_main_queue(), ^{
                if (json) {
                    [loadingView setHidden:YES];
                    
                    finalData = [[NSMutableArray alloc]init];
                    NSMutableArray *dates = [[NSMutableArray alloc]init];
                    NSArray *dates2 = [[NSMutableArray alloc]init];
                    int check;
                    
                    for (int i = 0; i < json.count ; i++) {
                        if ([[[json objectAtIndex:i] objectForKey:@"startTime"] length] > 11) {
                            
                        NSString *date = [[[json objectAtIndex:i] objectForKey:@"startTime"] substringToIndex:10];
                        [dates addObject:date];
                        }}
                    dates2 = [dates valueForKeyPath:@"@distinctUnionOfObjects.self"];
                    obj.dates = dates2;
                    for (int i = 0; i < dates2.count; i++) {
                        
                        NSString *date = dates2[i];
                        NSMutableArray *temp = [[NSMutableArray alloc]init];
                        NSMutableDictionary *tempDict = [[NSMutableDictionary alloc]init];
                        
                        for (int j = 0; j < json.count; j++) {
                            if ([[[json objectAtIndex:j] objectForKey:@"startTime"] length] > 11) {
                                
                            NSString *dateSelected = [[[json objectAtIndex:j] objectForKey:@"startTime"] substringToIndex:10];
                            
                            if ([date isEqualToString:dateSelected]) {
                                [temp addObject:[json objectAtIndex:j]];
                                //NSLog(@"efewf");
                            }
                            }
                        }
                        
                        [tempDict setObject:date forKey:@"date"];
                        [tempDict setObject:temp forKey:@"events"];
                        [finalData addObject:tempDict];
                    }
                    
                    NSSortDescriptor *dateDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"date"
                                                                                     ascending:YES];
                    NSArray *sortDescriptors = [NSArray arrayWithObject:dateDescriptor];
                    NSArray *sortedEventArray = [finalData sortedArrayUsingDescriptors:sortDescriptors];
                    // NSLog(@"final data sorted is %@",sortedEventArray);
                    finalData = [[NSMutableArray alloc] initWithArray:sortedEventArray];
                    // NSLog(@"final data is %@",finalData);
                    obj.events = json;
                    obj.eventsforCalendar = json;
                    obj.sortedEvents = finalData;
                    [[NSUserDefaults standardUserDefaults] setObject:finalData forKey:@"offlineData"];
                    [[NSUserDefaults standardUserDefaults] setObject:json forKey:@"offlineEvents"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    [self.tableView reloadData];
                    if (!scrolledToCurrentDate) {
                        if ([finalData count] > 0) {
                       [self nearestDate:finalData];
                        }}

                    //NSLog(@"choolaaaaa");
                }
                
                else{
                        //NSLog(@"choolaaaaa 2");
                        [loadingView setHidden:YES];
                        obj.sortedEvents = [[NSUserDefaults standardUserDefaults] objectForKey:@"offlineData"];
                        obj.events = [[NSUserDefaults standardUserDefaults] objectForKey:@"offlineEvents"];
                        obj.eventsforCalendar = [[NSUserDefaults standardUserDefaults] objectForKey:@"offlineEvents"];
                        finalData = [[NSMutableArray alloc]initWithArray: obj.sortedEvents];
                        json = obj.events;
                        [self.tableView reloadData];
                    
                        // loading = NO;
                        // [self alertStatus:@"Please try again after some time." :@"Connection Failed!"];
                    }

            });
            
            
        }
        else{
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [loadingView setHidden:YES];
                obj.sortedEvents = [[NSUserDefaults standardUserDefaults] objectForKey:@"offlineData"];
                obj.events = [[NSUserDefaults standardUserDefaults] objectForKey:@"offlineEvents"];
                obj.eventsforCalendar = [[NSUserDefaults standardUserDefaults] objectForKey:@"offlineEvents"];
                finalData = [[NSMutableArray alloc]initWithArray: obj.sortedEvents];
                json = obj.events;
                [self.tableView reloadData];
                // loading = NO;
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Connection Failed!" message:@"Please check your Internet Connection." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [alertView show];

                //NSLog(@"poopo");
            });}
    });


}

-(void)nearestDate:(NSArray *)dates{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd"];
    NSDate *today = [dateFormatter dateFromString:[[NSString stringWithFormat:@"%@",[NSDate date]] substringToIndex:10]];
    int finalDate = 0;
    int index = 0;
    if ([dates count] > 0) {
        
        finalDate = [self daysBetween:today and:[dateFormatter dateFromString:[[dates lastObject] objectForKey:@"date"]]];
        
        if (finalDate < 0) {
            finalDate = 0;
        }
    }
    //NSLog(@"Date 1: %@ and Date 2: %@", today, [dateFormatter dateFromString:[[dates objectAtIndex:0] objectForKey:@"date"]]);
    for (int i=0; i<dates.count; i++) {
        
        int diff = [self daysBetween:today and:[dateFormatter dateFromString:[[dates objectAtIndex:i] objectForKey:@"date"]]];
        NSLog(@"Diff is : %d", diff);
        if (diff>0 && diff<finalDate) {
            finalDate = diff;
            index = i;
        }
    }
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index]
                          atScrollPosition:UITableViewScrollPositionTop
                                  animated:YES];
    scrolledToCurrentDate = YES;
    
    
}

- (int)daysBetween:(NSDate *)dt1 and:(NSDate *)dt2 {
    NSUInteger unitFlags = NSDayCalendarUnit;
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [calendar components:unitFlags fromDate:dt1 toDate:dt2 options:0];
    return [components day]+1;
}

-(void)fetchPref{
    
    dataclass *obj = [dataclass getInstance];
    NSString *url = [NSString stringWithFormat:@"%@?email=%@&userID=%@",directoryFetchPref,obj.emailTitle,[[NSUserDefaults standardUserDefaults] stringForKey:@"userID"]];
    NSLog(@"%@",url);
    url = [url stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    NSURL *queryUrl = [NSURL URLWithString:url];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *data2 = [NSData dataWithContentsOfURL: queryUrl];
        NSError* error;
        //NSLog(@"bholi %@",data2);
        NSString* newStr = [[NSString alloc] initWithData:data2 encoding:NSUTF8StringEncoding];
        //NSLog(@"string is : %@",newStr);
        if(data2){
            NSArray *pref = [NSJSONSerialization
                             JSONObjectWithData:data2
                             options:kNilOptions
                             error:&error];
            //NSLog(@"%@",pref);
            dispatch_async(dispatch_get_main_queue(), ^{
                    [loadingView setHidden:YES];
                    if ([newStr isEqualToString:@"no data"]) {
                        obj.pref = [[NSMutableDictionary alloc]initWithObjectsAndKeys:@0,@"sound",@15,@"defaultEtdAlert",@0,@"timezone",@15,@"defaultEtaAlert",@30,@"defaultMeetDuration", nil];
                    }
                    else{
                        
                        obj.pref = [[NSMutableDictionary alloc]initWithDictionary:[pref objectAtIndex:0]];
                        
                    }
            });
        }
    });

    
}

-(void)delayEmail:(NSString *)event{
    
    NSString *url = [NSString stringWithFormat:@"%@?eventid=%@",directorydelay,event];
    NSLog(@"%@",url);
    url = [url stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    NSURL *queryUrl = [NSURL URLWithString:url];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *data2 = [NSData dataWithContentsOfURL: queryUrl];
        NSError* error;
        //NSLog(@"bholi %@",data2);
        NSString* newStr = [[NSString alloc] initWithData:data2 encoding:NSUTF8StringEncoding];
        //NSLog(@"string is : %@",newStr);
        if(data2){
            NSArray *pref = [NSJSONSerialization
                             JSONObjectWithData:data2
                             options:kNilOptions
                             error:&error];
            NSLog(@"%@",pref);

        }
        else{
            
            NSLog(@"There is some issue notifying the Invitees.");
        }
    });
    
    
}

-(void)thirtyHoursSchedular:(NSString *)event{
    
    NSString *url = [NSString stringWithFormat:@"%@?eventid=%@",directorythirtyHours,event];
    NSLog(@"%@",url);
    url = [url stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    NSURL *queryUrl = [NSURL URLWithString:url];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *data2 = [NSData dataWithContentsOfURL: queryUrl];
        NSError* error;
        //NSLog(@"bholi %@",data2);
        NSString* newStr = [[NSString alloc] initWithData:data2 encoding:NSUTF8StringEncoding];
        //NSLog(@"string is : %@",newStr);
        if(data2){
            NSArray *pref = [NSJSONSerialization
                             JSONObjectWithData:data2
                             options:kNilOptions
                             error:&error];
            NSLog(@"%@",pref);
            
        }
        else{
            
            NSLog(@"There is some issue notifying the Invitees.");
        }
    });
    
    
}

-(void)threeHoursSchedular:(NSString *)event{
    
    NSString *url = [NSString stringWithFormat:@"%@?eventid=%@",directorythreeHours,event];
    NSLog(@"%@",url);
    url = [url stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    NSURL *queryUrl = [NSURL URLWithString:url];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *data2 = [NSData dataWithContentsOfURL: queryUrl];
        NSError* error;
        //NSLog(@"bholi %@",data2);
        NSString* newStr = [[NSString alloc] initWithData:data2 encoding:NSUTF8StringEncoding];
        //NSLog(@"string is : %@",newStr);
        if(data2){
            NSArray *pref = [NSJSONSerialization
                             JSONObjectWithData:data2
                             options:kNilOptions
                             error:&error];
            NSLog(@"%@",pref);
            
        }
        else{
            
            NSLog(@"There is some issue notifying the Invitees.");
        }
    });
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    dataclass *obj = [dataclass getInstance];
    obj.sortedEvents = [[NSUserDefaults standardUserDefaults] objectForKey:@"offlineData"];
    obj.events = [[NSUserDefaults standardUserDefaults] objectForKey:@"offlineEvents"];
    obj.eventsforCalendar = [[NSUserDefaults standardUserDefaults] objectForKey:@"offlineEvents"];
    finalData = [[NSMutableArray alloc]initWithArray: obj.sortedEvents];

    [[Amplitude instance] logEvent:@"Homepage"];
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData) name:@"refreshData" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTitle) name:@"refreshTitle" object:nil];
    
    [self NotificationInit];
    
    [NSTimer scheduledTimerWithTimeInterval:30 target:self selector:@selector(refreshData) userInfo:nil repeats:YES];
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    numberBadge = [[UIView alloc]initWithFrame:CGRectMake(14, 10, 22, 22)];
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
    
    popoverClass = [WEPopoverController class];
    currentPopoverCellIndex = -1;
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
    [self fetchPref];
}

-(void)refreshData{
    
    [self loadData];
}

-(void)refreshTitle{
    
    dataclass *obj = [dataclass getInstance];
    self.navigationItem.title = obj.emailTitle;
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
    
    UISwipeGestureRecognizer * swiperight = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swiperight:)];
    swiperight.direction=UISwipeGestureRecognizerDirectionLeft ;
    [_calendarBackGroundView addGestureRecognizer:swiperight];

    
    [self blackBar];

}

- (WEPopoverContainerViewProperties *)improvedContainerViewProperties {
    
    WEPopoverContainerViewProperties *props = [[WEPopoverContainerViewProperties alloc] init];
    NSString *bgImageName = nil;
    CGFloat bgMargin = 0.0;
    CGFloat bgCapSize = 0.0;
    CGFloat contentMargin = 4.0;
    
    bgImageName = @"popoverBg.png";
    
    // These constants are determined by the popoverBg.png image file and are image dependent
    bgMargin = 13; // margin width of 13 pixels on all sides popoverBg.png (62 pixels wide - 36 pixel background) / 2 == 26 / 2 == 13
    bgCapSize = 31; // ImageSize/2  == 62 / 2 == 31 pixels
    
    props.backgroundMargins = UIEdgeInsetsMake(bgMargin, bgMargin, bgMargin, bgMargin);
    props.leftBgCapSize = bgCapSize;
    props.topBgCapSize = bgCapSize;
    props.bgImageName = bgImageName;
    
    props.contentMargins = UIEdgeInsetsMake(contentMargin, contentMargin, contentMargin, contentMargin - 1);
    
    props.arrowMargin = 4.0;
    
    props.upArrowImageName = @"popoverArrowUp.png";
    props.downArrowImageName = @"popoverArrowDown.png";
    props.leftArrowImageName = @"popoverArrowLeft.png";
    props.rightArrowImageName = @"popoverArrowRight.png";
    return props;	
}

- (IBAction)showPopover:(id)sender {
       if (!self.popoverController) {
        
        UIViewController *contentViewController = [[WEPopoverContentViewController alloc] initWithStyle:UITableViewStylePlain];
        self.popoverController = [[popoverClass alloc] initWithContentViewController:contentViewController];
        self.popoverController.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.3];
        self.popoverController.delegate = self;
        self.popoverController.passthroughViews = [NSArray arrayWithObject:self.navigationController.navigationBar];
        
        [self.popoverController presentPopoverFromBarButtonItem:sender
                                       permittedArrowDirections:(UIPopoverArrowDirectionUp)
                                                       animated:YES];
        
    } else {
        [self.popoverController dismissPopoverAnimated:YES];
        self.popoverController = nil;
    }
}

#pragma mark -
#pragma mark WEPopoverControllerDelegate implementation

- (void)popoverControllerDidDismissPopover:(WEPopoverController *)thePopoverController {
    //Safe to release the popover here
    self.popoverController = nil;
}

- (BOOL)popoverControllerShouldDismissPopover:(WEPopoverController *)thePopoverController {
    //The popover is automatically dismissed if you click outside it, unless you return NO here
    return YES;
}

-(void)playNotificationSound{
    [player stop];
    //AudioServicesPlaySystemSound(1009);
    dataclass *obj = [dataclass getInstance];
    NSString *sound;
    
    sound = [NSString stringWithFormat:@"sound%@.mp3", obj.pref[@"sound"]];
    
    if (obj.pref[@"sound"] == NULL) {
        sound = @"sound1.mp3";
    }
    
    // Construct URL to sound file
    NSString *path = [NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] resourcePath],sound];
    NSURL *soundUrl = [NSURL fileURLWithPath:path];
    
    // Create audio player object and initialize with URL to sound
    NSError *error;
    player = [[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl error:&error];
    NSLog(@"error is : %@",error);
    [player play];
}

-(void)NotificationInit{
    
   // [self playNotificationSound];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(inviteCall:)
                                                 name:@"invite"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(etdCall:)
                                                 name:@"etd"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(etaCall:)
                                                 name:@"eta"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(delayCall:)
                                                 name:@"delay"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(eta_responseCall:)
                                                 name:@"eta_response"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reminderCall:)
                                                 name:@"reminder"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(travelCall:)
                                                 name:@"travel"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(travel2Call:)
                                                 name:@"travel2"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(travel3Call:)
                                                 name:@"travel3"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(travel4Call:)
                                                 name:@"travel4"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notesCall:)
                                                 name:@"notes"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reminderScreenCall:)
                                                 name:@"reminderScreen"
                                               object:nil];
}

-(void)notesCall:(NSNotification *) notification{
    
    NSLog(@"cholla %@",notification.userInfo[@"gcm.notification.message"]);
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:notification.userInfo[@"aps"][@"alert"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alertView show];
    [self playNotificationSound];
}

-(void)inviteCall:(NSNotification *) notification{
    
    NSLog(@"cholla %@",notification.userInfo[@"gcm.notification.message"]);
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:notification.userInfo[@"aps"][@"alert"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alertView show];
    [self playNotificationSound];
}
-(void)etdCall:(NSNotification *) notification{
    
    NSLog(@"cholla %@",notification.userInfo[@"gcm.notification.message"]);
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:notification.userInfo[@"aps"][@"alert"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alertView show];
    [self playNotificationSound];
}
-(void)etaCall:(NSNotification *) notification{
    
    notificationeventId = notification.userInfo[@"eventid"];
    notificationTitle = notification.userInfo[@"aps"][@"alert"];
    [NSTimer scheduledTimerWithTimeInterval:10.0
                                     target:self selector:@selector(etaCall2) userInfo:nil repeats:NO];
    
    //notification.userInfo[@"aps"][@"alert"]
    notificationeventId = notification.userInfo[@"eventid"];
}

-(void)etaCall2{
    
    NSString *message = @"You are running a bit late, do you want to notify your invitees about it?";
    message = notificationTitle;
    NSString *eventID = notificationeventId;
    
    UIAlertController *alert2 =
    [UIAlertController alertControllerWithTitle:nil
                                        message:message
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *dismissAction = [UIAlertAction actionWithTitle:@"No"
                                                            style:UIAlertActionStyleDefault
                                                          handler:nil];
    UIAlertAction *startAction = [UIAlertAction actionWithTitle:@"Yes"
                                                          style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction * action) {
                                                            //Call function here
                                                            [self delayEmail:eventID];
                                                        }];
    [alert2 addAction:startAction];
    [alert2 addAction:dismissAction];
    
    UIViewController *presentingViewController = [[[UIApplication sharedApplication] delegate] window].rootViewController;
    while (presentingViewController.presentedViewController != nil) {
        presentingViewController = presentingViewController.presentedViewController;
    }
    
    [presentingViewController presentViewController:alert2 animated:YES completion:nil];
    
    [self playNotificationSound];
}

-(void)delayCall:(NSNotification *) notification{
    
    NSLog(@"cholla %@",notification.userInfo[@"aps"][@"alert"]);
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:notification.userInfo[@"gcm.notification.message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alertView show];
    [self playNotificationSound];
}
-(void)eta_responseCall:(NSNotification *) notification{
    
    NSLog(@"cholla %@",notification.userInfo[@"gcm.notification.message"]);
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:notification.userInfo[@"aps"][@"alert"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alertView show];
}
-(void)reminderCall:(NSNotification *) notification{
    
 //   NSLog(@"cholla %@",notification.userInfo[@"gcm.notification.message"]);
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:notification.userInfo[@"custom"][@"a"][@"subtitle"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alertView show];
    [self playNotificationSound];
}
-(void)reminderScreenCall:(NSNotification *) notification{
    
    //   NSLog(@"cholla %@",notification.userInfo[@"gcm.notification.message"]);
    dataclass *obj = [dataclass getInstance];
    obj.selectedEvent = notification.userInfo[@"custom"][@"a"][@"eventDetails"];
    eventDetailsViewController* infoController = [self.storyboard instantiateViewControllerWithIdentifier:@"eventDetails"];
    [self.navigationController pushViewController:infoController animated:YES];
   // UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:notification.userInfo[@"custom"][@"a"][@"subtitle"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    //[alertView show];
    [self playNotificationSound];
}
-(void)travelCall:(NSNotification *) notification{
    
    UIAlertController *alert =
    [UIAlertController alertControllerWithTitle:nil
                                        message:@"Did you make your travel arrangements for this event?"
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *dismissAction = [UIAlertAction actionWithTitle:@"Options"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              //Call function here
                                                              UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"Options" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
                                                              
                                                              [actionSheet addAction:[UIAlertAction actionWithTitle:@"Remind me later" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                                                                  
                                                                  // Cancel button tappped.
                                                                  [self dismissViewControllerAnimated:YES completion:^{
                                                                  }];
                                                              }]];
                                                              
                                                              [actionSheet addAction:[UIAlertAction actionWithTitle:@"ignore" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                                                                  
                                                                  // Distructive button tapped.
                                                                  [self dismissViewControllerAnimated:YES completion:^{
                                                                  }];
                                                              }]];
                                                              
                                                              [actionSheet addAction:[UIAlertAction actionWithTitle:@"Show travel options" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                                                                  
                                                                  // OK button tapped.
                                                                  
                                                                  [self dismissViewControllerAnimated:YES completion:^{
                                                                  }];
                                                              }]];
                                                              
                                                              // Present action sheet.
                                                              [self presentViewController:actionSheet animated:YES completion:nil];
                                                          }];
    UIAlertAction *startAction = [UIAlertAction actionWithTitle:@"I'm driving"
                                                          style:UIAlertActionStyleDefault
                                                        handler:nil];
    [alert addAction:dismissAction];
    [alert addAction:startAction];
    
    
    UIViewController *presentingViewController = [[[UIApplication sharedApplication] delegate] window].rootViewController;
    while (presentingViewController.presentedViewController != nil) {
        presentingViewController = presentingViewController.presentedViewController;
    }
    
    [presentingViewController presentViewController:alert animated:YES completion:nil];
    [self playNotificationSound];
}

-(void)travel2Call:(NSNotification *) notification{
    
//    NSLog(@"cholla %@",notification.userInfo[@"gcm.notification.message"]);
//    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:notification.userInfo[@"aps"][@"alert"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
//    [alertView show];
    
    
    UIAlertController *alert =
    [UIAlertController alertControllerWithTitle:nil
                                        message:notification.userInfo[@"aps"][@"alert"]
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *dismissAction = [UIAlertAction actionWithTitle:@"No"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              //Call function here
                                                              UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
                                                              
                                                              [actionSheet addAction:[UIAlertAction actionWithTitle:@"Ignore" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
                                                                  // Distructive button tapped.
                                                                  [self dismissViewControllerAnimated:YES completion:^{
                                                                  }];
                                                              }]];
                                    
                                                              [actionSheet addAction:[UIAlertAction actionWithTitle:@"Show Travel Options" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
                                                                  // OK button tapped.
        
                                                                  [self dismissViewControllerAnimated:YES completion:^{
                                                                  }];
                                                              }]];
                                    
                                    // Present action sheet.
                                    [self presentViewController:actionSheet animated:YES completion:nil];}];
    UIAlertAction *startAction = [UIAlertAction actionWithTitle:@"Yes"
                                                          style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction * action) {
                                                            //Call function here
                                                            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"You need to start immediately." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                                                                [alertView show];
                                                        }];
    [alert addAction:startAction];
    [alert addAction:dismissAction];
    
    UIViewController *presentingViewController = [[[UIApplication sharedApplication] delegate] window].rootViewController;
    while (presentingViewController.presentedViewController != nil) {
        presentingViewController = presentingViewController.presentedViewController;
    }
    
    [presentingViewController presentViewController:alert animated:YES completion:nil];

    
    [self playNotificationSound];
}

-(void)travel3Call:(NSNotification *) notification{
    
    UIAlertController *alert =
    [UIAlertController alertControllerWithTitle:nil
                                        message:notification.userInfo[@"aps"][@"alert"]
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *dismissAction = [UIAlertAction actionWithTitle:@"No"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              //Call function here
                                                              [self askForTravelAssist:notification.userInfo[@"eventid"]];
                                                          }];
    UIAlertAction *startAction = [UIAlertAction actionWithTitle:@"Yes"
                                                          style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction * action) { [self thirtyHoursSchedular:notification.userInfo[@"eventid"]]; }];
    [alert addAction:startAction];
    [alert addAction:dismissAction];
    
    UIViewController *presentingViewController = [[[UIApplication sharedApplication] delegate] window].rootViewController;
    while (presentingViewController.presentedViewController != nil) {
        presentingViewController = presentingViewController.presentedViewController;
    }
    
    [presentingViewController presentViewController:alert animated:YES completion:nil];
    
    
    [self playNotificationSound];
}

-(void)askForTravelAssist:(NSString *)event{
    
    UIAlertController *alert =
    [UIAlertController alertControllerWithTitle:nil
                                        message:@"Did you make your travel arrangements for this event?"
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *dismissAction = [UIAlertAction actionWithTitle:@"Options"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              //Call function here
                                                              UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
                                                              
                                                              [actionSheet addAction:[UIAlertAction actionWithTitle:@"Remind me later" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                                                                  
                                                                  // Cancel button tappped.
                                                                  [self dismissViewControllerAnimated:YES completion:^{
                                                                  }];
                                                              }]];
                                                              
                                                              [actionSheet addAction:[UIAlertAction actionWithTitle:@"Ignore" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                                                                  
                                                                  // Distructive button tapped.
                                                                  [self dismissViewControllerAnimated:YES completion:^{
                                                                  }];
                                                              }]];
                                                              
                                                              [actionSheet addAction:[UIAlertAction actionWithTitle:@"Show Travel Options" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                                                                  
                                                                  // OK button tapped.
                                                                  
                                                                  [self dismissViewControllerAnimated:YES completion:^{
                                                                  }];
                                                              }]];
                                                              
                                                              // Present action sheet.
                                                              [self presentViewController:actionSheet animated:YES completion:nil];
                                                          }];
    UIAlertAction *startAction = [UIAlertAction actionWithTitle:@"I'm driving"
                                                          style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction * action) { [self thirtyHoursSchedular:event]; }];
    [alert addAction:dismissAction];
    [alert addAction:startAction];
    
    
    UIViewController *presentingViewController = [[[UIApplication sharedApplication] delegate] window].rootViewController;
    while (presentingViewController.presentedViewController != nil) {
        presentingViewController = presentingViewController.presentedViewController;
    }
    
    [presentingViewController presentViewController:alert animated:YES completion:nil];
}

-(void)travel4Call:(NSNotification *) notification{
    [self askForTravelAssist:notification.userInfo[@"eventid"]];
    [self playNotificationSound];
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

-(void)swiperight:(UISwipeGestureRecognizer*)gestureRecognizer
{
    AddEventTableViewController* infoController = [self.storyboard instantiateViewControllerWithIdentifier:@"addevent"];
    [self.navigationController pushViewController:infoController animated:YES];
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
    NSLog(@"count row : %ld %lu",(long)section,[[finalData[section] objectForKey:@"events"] count]);
    
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
    
    cell.priorityLabel.frame = CGRectMake(cell.title.frame.origin.x + cell.title.frame.size.width+20, 0, 35, cell.frame.size.height);
    
    if([[[finalData[indexPath.section] objectForKey:@"events"][indexPath.row] objectForKey:@"invitee_check"]  isEqual: @"needsAction"]){
        
        cell.priorityLabel.text = @"Unaccepted invite";
            cell.priorityLabel.frame = CGRectMake(cell.title.frame.origin.x + cell.title.frame.size.width+20, 0, 90, cell.frame.size.height);
        cell.priorityLabel.adjustsFontSizeToFitWidth = YES;
        //cell.priorityLabel.textColor = [UIColor yellowColor];
        
    }
    //cell.priorityLabel.text = [events[indexPath.row] objectForKey:@"Priority"];

    
    cell.accessoryType = [[[finalData[indexPath.section] objectForKey:@"events"][indexPath.row] objectForKey:@"state"] boolValue] ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;

    
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
    if ( [[obj.selectedEvent objectForKey:@"invitee_check"] isEqual: @"needsAction"]) {
        
        eventInvitaionViewController* infoController = [self.storyboard instantiateViewControllerWithIdentifier:@"eventInvitation"];
        [self.navigationController pushViewController:infoController animated:YES];
    }
    else{
    eventDetailsViewController* infoController = [self.storyboard instantiateViewControllerWithIdentifier:@"eventDetails"];
        [self.navigationController pushViewController:infoController animated:YES]; }
    
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
            NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
            dataclass *obj = [dataclass getInstance];
            if ([[[finalData[indexPath.section] objectForKey:@"events"][indexPath.row] objectForKey:@"email"] isEqualToString: obj.emailTitle]) {
                
                obj.selectedEvent = [finalData[indexPath.section] objectForKey:@"events"][indexPath.row];
                EditEventTableViewController* infoController = [self.storyboard instantiateViewControllerWithIdentifier:@"editevent"];
                [self.navigationController pushViewController:infoController animated:YES];
                
            }
            else{
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"No Permissions" message:@"You are not authorised to edit this event." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alertView show];
            }
            break;
        }
        case 2:
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [loadingView setHidden:NO];
            });
            NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
            dataclass *obj = [dataclass getInstance];
            if ([[[finalData[indexPath.section] objectForKey:@"events"][indexPath.row] objectForKey:@"email"] isEqualToString: obj.emailTitle]) {
            NSString *url = [NSString stringWithFormat:@"%@?id=%@",directoryDeleteEvent,[[finalData[indexPath.section] objectForKey:@"events"][indexPath.row] objectForKey:@"eventID"]];
            NSLog(@"%@",url);
            url = [url stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
            NSURL *queryUrl = [NSURL URLWithString:url];
            [[finalData[indexPath.section] objectForKey:@"events"] removeObjectAtIndex:indexPath.row];
            [self.tableView reloadData];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSData *data = [NSData dataWithContentsOfURL: queryUrl];
                NSError* error;
                NSLog(@"bholi %@",data);
                NSString* newStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                NSLog(@"string is : %@",newStr);
                if(data){
                    json = [NSJSONSerialization
                            JSONObjectWithData:data
                            options:kNilOptions
                            error:&error];
                    NSLog(@"%@",json);
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (1) {
                            [loadingView setHidden:YES];
                            //[self loadData];
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
            else{
                
               // UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"No Permissions" message:@"You are not authorised to delete this event." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
               // [alertView show];
                
                NSString *url = [NSString stringWithFormat:@"%@?email=%@&action=declined&eventid=%@",directoryaccept,[[finalData[indexPath.section] objectForKey:@"events"][indexPath.row] objectForKey:@"relatedEmail"],[[finalData[indexPath.section] objectForKey:@"events"][indexPath.row] objectForKey:@"eventID"]];
                NSLog(@"%@",url);
                url = [url stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
                NSURL *queryUrl = [NSURL URLWithString:url];
                [[finalData[indexPath.section] objectForKey:@"events"] removeObjectAtIndex:indexPath.row];
                [self.tableView reloadData];
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    NSData *data2 = [NSData dataWithContentsOfURL: queryUrl];
                    NSError* error;
                    //NSLog(@"bholi %@",data2);
                    NSString* newStr = [[NSString alloc] initWithData:data2 encoding:NSUTF8StringEncoding];
                    //NSLog(@"string is : %@",newStr);
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.navigationController popViewControllerAnimated:YES]; });
                    if(data2){
                        NSArray *pref = [NSJSONSerialization
                                         JSONObjectWithData:data2
                                         options:kNilOptions
                                         error:&error];
                        NSLog(@"%@",pref);
                        dispatch_async(dispatch_get_main_queue(), ^{
                            //  [loadingView setHidden:YES];
                            
                          //  [self.navigationController popViewControllerAnimated:YES];
                            
                        });
                    }
                });

                
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
