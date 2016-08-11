//
//  mainViewController.m
//  FreJun
//
//  Created by GOTESO on 10/08/16.
//  Copyright © 2016 GOTESO. All rights reserved.
//

#import "mainViewController.h"
#import "SACalendar.h"
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
}

@end

@implementation mainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //self.tableView.scrollEnabled = NO;
    self.notificationsCountLabel.layer.cornerRadius = 7.5;
    self.notificationsCountLabel.clipsToBounds = YES;
    
    CAGradientLayer *gradient3 = [CAGradientLayer layer];
    gradient3.frame = self.calendarBackGroundView.bounds;
    gradient3.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithRed:32.0/255.0 green:81.0/255.0 blue:183.0/255.0 alpha:1.0] CGColor], (id)[[UIColor colorWithRed:51.0/255.0 green:179.0/255.0 blue:105.0/255.0 alpha:1.0] CGColor], nil];
    [self.calendarBackGroundView.layer insertSublayer:gradient3 atIndex:0];
    
    CAGradientLayer *gradient4 = [CAGradientLayer layer];
    gradient4.frame = CGRectMake(0, self.calendarBackGroundView.frame.size.height, self.calendarBackGroundView.frame.size.width, self.calendarBackGroundView.frame.size.height);
    gradient4.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithRed:32.0/255.0 green:81.0/255.0 blue:183.0/255.0 alpha:1.0] CGColor], (id)[[UIColor colorWithRed:51.0/255.0 green:179.0/255.0 blue:105.0/255.0 alpha:1.0] CGColor], nil];
    [self.calendarBackGroundView.layer insertSublayer:gradient4 atIndex:0];

    self.calendarBackGroundView.clipsToBounds = YES;
    
    frejunCalendar = [[SACalendar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width - 20, (self.view.frame.size.height-70)/2)
                                      scrollDirection:ScrollDirectionVertical
                                        pagingEnabled:YES];
    frejunCalendar.delegate = self;
    [self.calendarBackGroundView addSubview:frejunCalendar];
    [self.calendarBackGroundView setBackgroundColor:[UIColor yellowColor]];
    
    frejunCalendar.translatesAutoresizingMaskIntoConstraints = NO;
    self.calendarBackGroundView.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSDictionary *views = NSDictionaryOfVariableBindings(frejunCalendar);
    
    NSArray *horizontalConstraints =[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[frejunCalendar]-10-|" options:0 metrics:nil views:views];
    NSArray *verticalConstraints =[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[frejunCalendar]|" options:0 metrics:nil views:views];
    
    
    [self.calendarBackGroundView addConstraints:horizontalConstraints];
    [self.calendarBackGroundView addConstraints:verticalConstraints];
    
    tempHeight = frejunCalendar.bounds.size.height-20;
    [self.calendarBackGroundView bringSubviewToFront:self.weekDescriptionLabel];
    
    [self blackBar];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//    UITouch *touch = [[event allTouches] anyObject];
//    touchStart = [[touches anyObject] locationInView:self.calendarBackGroundView];
//    isResizingLR = (self.calendarBackGroundView.bounds.size.width - touchStart.x < kResizeThumbSize && self.calendarBackGroundView.bounds.size.height - touchStart.y < kResizeThumbSize);
//    isResizingUL = (touchStart.x <kResizeThumbSize && touchStart.y <kResizeThumbSize);
//    isResizingUR = (self.calendarBackGroundView.bounds.size.width-touchStart.x < kResizeThumbSize && touchStart.y<kResizeThumbSize);
//    isResizingLL = (touchStart.x <kResizeThumbSize && self.calendarBackGroundView.bounds.size.height -touchStart.y <kResizeThumbSize);
//}
//
//- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
//    CGPoint touchPoint = [[touches anyObject] locationInView:self.calendarBackGroundView];
//    CGPoint previous = [[touches anyObject] previousLocationInView:self.calendarBackGroundView];
//    
//    CGFloat deltaWidth = touchPoint.x - previous.x;
//    CGFloat deltaHeight = touchPoint.y - previous.y;
//    
//    // get the frame values so we can calculate changes below
//    CGFloat x = self.calendarBackGroundView.frame.origin.x;
//    CGFloat y = self.calendarBackGroundView.frame.origin.y;
//    CGFloat width = self.calendarBackGroundView.frame.size.width;
//    CGFloat height = self.calendarBackGroundView.frame.size.height;
//    
//    if (isResizingLR) {
//        self.calendarBackGroundView.frame = CGRectMake(x, y, width, touchPoint.y+deltaWidth);
//        NSLog(@"here");
//        [self twoCalender];
//    } else if (isResizingUL) {
//        self.calendarBackGroundView.frame = CGRectMake(x, y, width, height-deltaHeight);
//    } else if (isResizingUR) {
//        self.calendarBackGroundView.frame = CGRectMake(x, y, width, height-deltaHeight);
//    } else if (isResizingLL) {
//        self.calendarBackGroundView.frame = CGRectMake(x, y, width, height+deltaHeight);
//    } else {
//        // not dragging from a corner -- move the view
//       // self.calendarBackGroundView.center = CGPointMake(self.calendarBackGroundView.center.x + touchPoint.x - touchStart.x,
//       //                           self.calendarBackGroundView.center.y + touchPoint.y - touchStart.y);
//    }
//}
//
//-(void)twoCalender{
//    
//    [UIView animateWithDuration:.5 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
//        
//       // self.calendarBackGroundView.frame = CGRectMake(0, 5, 320,15);
//       // self.headerView.frame  = CGRectMake(0, 5, 320,15);
//        
//    } completion:^(BOOL finished) {
//        
//        [UIView animateWithDuration:.5 delay:2.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
//            
//            self.calendarBackGroundView.frame = CGRectMake(0, 70, 320,500);
//           // self.headerView.frame  = CGRectMake(0, 5, 320,0);
//            
//        } completion:^(BOOL finished) {
//            
//        }];
//        
//    }];
//    
//}

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
    
    // move button
    button.center = CGPointMake(button.center.x,
                                button.center.y + delta_y);
    self.calendarBackGroundView.frame = CGRectMake(0, 70, self.view.frame.size.width, self.calendarBackGroundView.frame.size.height + delta_y);
    self.tableView.frame = CGRectMake(0, self.tableView.frame.origin.y + delta_y, self.view.frame.size.width, self.tableView.frame.size.height - delta_y);
    
    NSLog(@"was dragged");
}

- (void)finishedDragging:(UIButton *)button withEvent:(UIEvent *)event
{
    //doesn't get called
    NSLog(@"finished dragging");
    
    if (button.center.y < (self.view.frame.size.height-70)/2) {
        
        button.center = CGPointMake(button.center.x, 70);
        self.calendarBackGroundView.frame = CGRectMake(0, 70, self.view.frame.size.width, 0);
        self.tableView.frame = CGRectMake(0, 70, self.view.frame.size.width, self.view.frame.size.height-70);
        //frejunCalendar.frame = CGRectMake(0, 0, self.view.frame.size.width-20, 0);
        
    }
    else if (button.center.y > (self.view.frame.size.height-70)/2 + 140){
        
        button.center = CGPointMake(button.center.x, self.view.frame.size.height);
        self.calendarBackGroundView.frame = CGRectMake(0, 70, self.view.frame.size.width, self.view.frame.size.height-70);
        self.tableView.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 0);
        //frejunCalendar.frame = CGRectMake(0, 0, self.view.frame.size.width-20, 500);
        
    }
    else{
        
        button.center = CGPointMake(button.center.x, (self.view.frame.size.height-70)/2 + 70);
        self.calendarBackGroundView.frame = CGRectMake(0, 70, self.view.frame.size.width, (self.view.frame.size.height-70)/2);
                self.tableView.frame = CGRectMake(0, (self.view.frame.size.height-70)/2 + 70, self.view.frame.size.width, (self.view.frame.size.height-70)/2);
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
- (IBAction)addEvent:(id)sender {
    
    NSString * storyboardName = @"Main";
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
    UIViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"addEvent"];
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    [self.view.window.layer addAnimation:transition forKey:nil];
    [self presentViewController:vc animated:NO completion:nil];
    
}


@end
