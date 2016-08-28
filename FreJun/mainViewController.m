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
CGFloat kResizeThumbSize = 45.0f;
@interface mainViewController (){
    
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
}

@end

@implementation mainViewController

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

    
    
    navBarHeight = self.navigationController.navigationBar.frame.size.height+[UIApplication sharedApplication].statusBarFrame.size.height;
    self.navigationItem.title = @"example@example.com";
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    self.tableView = [[UITableView alloc]init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.contentInset = UIEdgeInsetsMake(-navBarHeight, 0, 0, 0);
    frejunCalendar = [[SACalendar alloc]initWithFrame:CGRectMake(10, 0, self.view.frame.size.width - 20, (self.view.frame.size.height-navBarHeight)/2)
                                      scrollDirection:ScrollDirectionVertical
                                        pagingEnabled:YES];
    frejunCalendar.delegate = self;
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    numberBadge = [[UIView alloc]initWithFrame:CGRectMake(95, 5, 14, 14)];
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
    
    [super viewWillDisappear:animated];
    [numberBadge removeFromSuperview];
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
    swipeleft.direction=UISwipeGestureRecognizerDirectionLeft;
    [_calendarBackGroundView addGestureRecognizer:swipeleft];
    [self blackBar];

}

-(void)swipeleft:(UISwipeGestureRecognizer*)gestureRecognizer
{
    //Do what you want here
    NSLog(@"swiped");
    SettingsTableViewController* infoController = [[SettingsTableViewController alloc]initWithStyle:UITableViewStyleGrouped];
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
    return events.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellid=@"mainTableViewCell";
    mainTableViewCell *cell = (mainTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellid];
    if (cell==nil) {
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"mainTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.title.text = [events[indexPath.row] objectForKey:@"Title"];
    cell.title.frame = CGRectMake(cell.title.frame.origin.x, 0, [[events[indexPath.row] objectForKey:@"Title"] sizeWithFont:cell.textLabel.font constrainedToSize:CGSizeMake(MAXFLOAT, cell.frame.size.height)].width, cell.frame.size.height);
    
    cell.priorityLabel.text = [events[indexPath.row] objectForKey:@"Priority"];
    cell.priorityLabel.frame = CGRectMake(cell.title.frame.origin.x + cell.title.frame.size.width+20, 0, 35, cell.frame.size.height);
    
    cell.accessoryType = [[events[indexPath.row] objectForKey:@"state"] boolValue] ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;

    return cell;

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    eventDetailsViewController* infoController = [self.storyboard instantiateViewControllerWithIdentifier:@"eventDetails"];
    [self.navigationController pushViewController:infoController animated:YES];
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 3;
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
    
    switch (section) {
        case 0:
            headerLabel.text = @"Section 1";
            return sectionHeaderView;
            break;
        case 1:
            headerLabel.text = @"Section 2";
            return sectionHeaderView;
            break;
        case 2:
            headerLabel.text = @"Section 3";
            return sectionHeaderView;
            break;
        default:
            break;
    }
    
    return sectionHeaderView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.0001;
}

-(void) SACalendar:(SACalendar*)calendar didSelectDate:(int)day month:(int)month year:(int)year
{
    NSLog(@"Date Selected : %02i/%02i/%04i",day,month,year);
    calenderViewController* infoController = [self.storyboard instantiateViewControllerWithIdentifier:@"calender"];
    [self.navigationController pushViewController:infoController animated:YES];
}

/**
 *  Delegate method : get called user has scroll to a new month
 */
-(void) SACalendar:(SACalendar *)calendar didDisplayCalendarForMonth:(int)month year:(int)year{
    NSLog(@"Displaying : %@ %04i",[DateUtil getMonthString:month],year);
}


@end
