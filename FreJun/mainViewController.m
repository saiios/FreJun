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
}

@end

@implementation mainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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
    number.text = @"00";
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
    return 15;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }

    cell.textLabel.text = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
    
     return cell;

}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.0001;
}

@end
