//
//  eventRequestViewController.m
//  FreJun
//
//  Created by GOTESO on 17/08/16.
//  Copyright © 2016 GOTESO. All rights reserved.
//
#define leftMargin 15
#define multiplier 0.8
#import "eventRequestViewController.h"

@interface eventRequestViewController ()

@end

@implementation eventRequestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"Event Details";
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc]init];
    [editButton setTitle:@"Edit"];
    self.navigationItem.rightBarButtonItem = editButton;
    CGFloat fullWidth = self.view.frame.size.width - leftMargin*2;
    
    //Scroll View
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:self.view.frame];
    //scrollView.backgroundColor = [UIColor colorWithRed:243.0/255.0 green:243.0/255.0 blue:243.0/255.0 alpha:1];
    [self.view addSubview:scrollView];
    scrollView.backgroundColor = [UIColor whiteColor];
    
    //Empty View
    UIView* emptyView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 35*multiplier)];
    emptyView.backgroundColor = [UIColor colorWithRed:235.0/255.0 green:235.0/255.0 blue:235.0/255.0 alpha:1];
    [scrollView addSubview:emptyView];
    
    //Event Name Label
    UILabel *eventName = [[UILabel alloc]initWithFrame:CGRectMake(leftMargin, 50*multiplier, fullWidth, 18*multiplier)];
    eventName.font = [eventName.font fontWithSize:17*multiplier];
    eventName.text = @"Another One Event";
    [scrollView addSubview:eventName];
    
    //Address 1 Label
    UILabel *address1 = [[UILabel alloc]initWithFrame:CGRectMake(leftMargin, eventName.frame.origin.y+eventName.frame.size.height+9*multiplier, fullWidth, 15*multiplier)];
    address1.font = [address1.font fontWithSize:14*multiplier];
    address1.text = @"Another One Event";
    address1.textColor = [UIColor grayColor];
    [scrollView addSubview:address1];
    
    //Address 2 Label
    UILabel *address2 = [[UILabel alloc]initWithFrame:CGRectMake(leftMargin, address1.frame.origin.y+address1.frame.size.height+7*multiplier, fullWidth, 15*multiplier)];
    address2.font = [address2.font fontWithSize:14*multiplier];
    address2.text = @"Another One Event";
    address2.textColor = [UIColor grayColor];
    [scrollView addSubview:address2];
    
    //Day Label
    UILabel *day = [[UILabel alloc]initWithFrame:CGRectMake(leftMargin, address2.frame.origin.y+address2.frame.size.height+16*multiplier, fullWidth, 15*multiplier)];
    day.font = [day.font fontWithSize:14*multiplier];
    day.text = @"Another One Event";
    day.textColor = [UIColor lightGrayColor];
    [scrollView addSubview:day];
    
    //Time 1 Label
    UILabel *time1 = [[UILabel alloc]initWithFrame:CGRectMake(leftMargin, day.frame.origin.y+day.frame.size.height+4*multiplier, fullWidth, 15*multiplier)];
    time1.font = [time1.font fontWithSize:14*multiplier];
    time1.text = @"Another One Event";
    time1.textColor = [UIColor lightGrayColor];
    [scrollView addSubview:time1];
    
    //Time 2 Label
    UILabel *time2 = [[UILabel alloc]initWithFrame:CGRectMake(leftMargin, time1.frame.origin.y+time1.frame.size.height+4*multiplier, fullWidth, 15*multiplier)];
    time2.font = [time2.font fontWithSize:14*multiplier];
    time2.text = @"Another One Event";
    time2.textColor = [UIColor lightGrayColor];
    [scrollView addSubview:time2];
    
    //line separator
    UIView* separatorLineView = [[UIView alloc]initWithFrame:CGRectMake(leftMargin, time2.frame.origin.y+time2.frame.size.height+18*multiplier, fullWidth+leftMargin, 1)];
    separatorLineView.backgroundColor = [UIColor colorWithRed:235.0/255.0 green:235.0/255.0 blue:235.0/255.0 alpha:1];
    [scrollView addSubview:separatorLineView];
    
    //Calender Label
    UILabel *calender = [[UILabel alloc]initWithFrame:CGRectMake(leftMargin, separatorLineView.frame.origin.y+separatorLineView.frame.size.height+12*multiplier, 80*multiplier, 18*multiplier)];
    calender.font = [calender.font fontWithSize:17*multiplier];
    calender.text = @"Calender";
    [scrollView addSubview:calender];
    
    //Calender Text Label
    UILabel *calenderText = [[UILabel alloc]initWithFrame:CGRectMake(leftMargin + calender.frame.size.width + 40*multiplier, separatorLineView.frame.origin.y+separatorLineView.frame.size.height+12*multiplier, fullWidth - calender.frame.size.width - 40*multiplier, 18*multiplier)];
    calenderText.font = [calenderText.font fontWithSize:17*multiplier];
    calenderText.textAlignment = NSTextAlignmentRight;
    calenderText.text = @"demo@example.com";
    CGSize constraintSize = CGSizeMake(MAXFLOAT, calenderText.frame.size.height);
    CGSize labelSize = [calenderText.text sizeWithFont:calenderText.font constrainedToSize:constraintSize];
    if (labelSize.width > calenderText.frame.size.width) {
        calenderText.adjustsFontSizeToFitWidth= YES;
    }
    else{
        calenderText.frame = CGRectMake(fullWidth-labelSize.width+13, calenderText.frame.origin.y, labelSize.width, calenderText.frame.size.height);
    }
    calenderText.textColor = [UIColor grayColor];
    [scrollView addSubview:calenderText];
    
    //dot View
    UIView* dotView = [[UIView alloc]initWithFrame:CGRectMake(calenderText.frame.origin.x - 20, calenderText.center.y-4, 10, 10)];
    dotView.layer.cornerRadius = dotView.frame.size.height/2;
    dotView.backgroundColor = [UIColor colorWithRed:100.0/255.0 green:218.0/255.0 blue:54.0/255.0 alpha:1];
    [scrollView addSubview:dotView];
    
    //line separator 2
    UIView* separatorLineView2 = [[UIView alloc]initWithFrame:CGRectMake(leftMargin, calenderText.frame.origin.y+calenderText.frame.size.height+18*multiplier, fullWidth+leftMargin, 1)];
    separatorLineView2.backgroundColor = [UIColor colorWithRed:235.0/255.0 green:235.0/255.0 blue:235.0/255.0 alpha:1];
    [scrollView addSubview:separatorLineView2];
    
    //ETDReminder Label
    UILabel *ETDReminder = [[UILabel alloc]initWithFrame:CGRectMake(leftMargin, separatorLineView2.frame.origin.y+separatorLineView2.frame.size.height+12*multiplier, 195*multiplier, 18*multiplier)];
    ETDReminder.font = [ETDReminder.font fontWithSize:17*multiplier];
    ETDReminder.text = @"Reminder based on ETD";
    [scrollView addSubview:ETDReminder];
    
    //ETDReminder Text Label
    UILabel *ETDReminderText = [[UILabel alloc]initWithFrame:CGRectMake(leftMargin+ ETDReminder.frame.size.width + 10*multiplier, separatorLineView2.frame.origin.y+separatorLineView2.frame.size.height+12*multiplier, fullWidth- ETDReminder.frame.size.width - 10*multiplier, 18*multiplier)];
    ETDReminderText.font = [ETDReminderText.font fontWithSize:17*multiplier];
    ETDReminderText.textAlignment = NSTextAlignmentRight;
    ETDReminderText.adjustsFontSizeToFitWidth= YES;
    ETDReminderText.text = @"45 min before";
    ETDReminderText.textColor = [UIColor grayColor];
    [scrollView addSubview:ETDReminderText];
    
    //line separator 3
    UIView* separatorLineView3 = [[UIView alloc]initWithFrame:CGRectMake(leftMargin, ETDReminderText.frame.origin.y+ETDReminderText.frame.size.height+18*multiplier, fullWidth+leftMargin, 1)];
    separatorLineView3.backgroundColor = [UIColor colorWithRed:235.0/255.0 green:235.0/255.0 blue:235.0/255.0 alpha:1];
    [scrollView addSubview:separatorLineView3];
    
    //eventReminder Label
    UILabel *eventReminder = [[UILabel alloc]initWithFrame:CGRectMake(leftMargin, separatorLineView3.frame.origin.y+separatorLineView3.frame.size.height+12*multiplier, 210*multiplier, 18*multiplier)];
    eventReminder.font = [eventReminder.font fontWithSize:17*multiplier];
    eventReminder.text = @"Reminder before the event";
    [scrollView addSubview:eventReminder];
    
    //eventReminder Text Label
    UILabel *eventReminderText = [[UILabel alloc]initWithFrame:CGRectMake(leftMargin+ eventReminder.frame.size.width + 10*multiplier, separatorLineView3.frame.origin.y+separatorLineView3.frame.size.height+12*multiplier, fullWidth- eventReminder.frame.size.width - 10*multiplier, 18*multiplier)];
    eventReminderText.font = [eventReminder.font fontWithSize:17*multiplier];
    eventReminderText.textAlignment = NSTextAlignmentRight;
    eventReminderText.adjustsFontSizeToFitWidth= YES;
    eventReminderText.text = @"30 min before";
    eventReminderText.textColor = [UIColor grayColor];
    [scrollView addSubview:eventReminderText];
    
    //line separator 4
    UIView* separatorLineView4 = [[UIView alloc]initWithFrame:CGRectMake(leftMargin, eventReminderText.frame.origin.y+eventReminderText.frame.size.height+18*multiplier, fullWidth+leftMargin, 1)];
    separatorLineView4.backgroundColor = [UIColor colorWithRed:235.0/255.0 green:235.0/255.0 blue:235.0/255.0 alpha:1];
    [scrollView addSubview:separatorLineView4];
    
    //invitation from Label
    UILabel *inviteesLabel = [[UILabel alloc]initWithFrame:CGRectMake(leftMargin, separatorLineView4.frame.origin.y+separatorLineView4.frame.size.height+12*multiplier, 130*multiplier, 18*multiplier)];
    inviteesLabel.font = [inviteesLabel.font fontWithSize:17*multiplier];
    inviteesLabel.text = @"Invitation from";
    [scrollView addSubview:inviteesLabel];
    
    //Invitess Email Labels
    UILabel *invitationText = [[UILabel alloc]initWithFrame:CGRectMake(leftMargin+ inviteesLabel.frame.size.width + 10*multiplier, separatorLineView4.frame.origin.y+separatorLineView4.frame.size.height+12*multiplier, fullWidth- inviteesLabel.frame.size.width - 10*multiplier, 18*multiplier)];
    invitationText.font = [invitationText.font fontWithSize:17*multiplier];
    invitationText.textAlignment = NSTextAlignmentRight;
    invitationText.adjustsFontSizeToFitWidth= YES;
    invitationText.text = @"30 min before";
    invitationText.textColor = [UIColor grayColor];
    [scrollView addSubview:invitationText];
    
    //line separator 5
    UIView* separatorLineView5 = [[UIView alloc]initWithFrame:CGRectMake(leftMargin, inviteesLabel.frame.origin.y+inviteesLabel.frame.size.height+18*multiplier, fullWidth+leftMargin, 1)];
    separatorLineView5.backgroundColor = [UIColor colorWithRed:235.0/255.0 green:235.0/255.0 blue:235.0/255.0 alpha:1];
    [scrollView addSubview:separatorLineView5];
    
     //Edited by Label
    UILabel *editedBy = [[UILabel alloc]initWithFrame:CGRectMake(leftMargin, separatorLineView5.frame.origin.y+separatorLineView5.frame.size.height+12*multiplier, 80*multiplier, 18*multiplier)];
    editedBy.font = [editedBy.font fontWithSize:17*multiplier];
    editedBy.text = @"Edited by";
    [scrollView addSubview:editedBy];
    
    //name Label
    UILabel *name = [[UILabel alloc]initWithFrame:CGRectMake(leftMargin, editedBy.frame.origin.y+editedBy.frame.size.height+11*multiplier, fullWidth, 12*multiplier)];
    name.font = [name.font fontWithSize:12*multiplier];
    name.text = @"Another One Event";
    name.textColor = [UIColor lightGrayColor];
    [scrollView addSubview:name];
    
    //Time 3 Label
    UILabel *time3 = [[UILabel alloc]initWithFrame:CGRectMake(leftMargin, name.frame.origin.y+name.frame.size.height+3*multiplier, fullWidth, 12*multiplier)];
    time3.font = [time3.font fontWithSize:12*multiplier];
    time3.text = @"Another One Event";
    time3.textColor = [UIColor lightGrayColor];
    [scrollView addSubview:time3];
    
    //Adjusting the size of Scroll View
    scrollView.contentSize = CGSizeMake(self.view.frame.size.width, time3.frame.origin.y + time3.frame.size.height + 20);
    if (scrollView.contentSize.height < scrollView.frame.size.height-self.navigationController.navigationBar.frame.size.height-20) {
        scrollView.frame = CGRectMake(0, 0, self.view.frame.size.width, time3.frame.origin.y + time3.frame.size.height + 20+self.navigationController.navigationBar.frame.size.height+20);
    }
    
    //Bottom Buttons
    UIView* bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-44*multiplier , fullWidth+2*leftMargin, 88*multiplier)];
    bottomView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.7];
    [self.view addSubview:bottomView];
    
    UIButton *acceptButton = [[UIButton alloc] initWithFrame:CGRectMake(33*multiplier, 8*multiplier, 65*multiplier, 28*multiplier)];
    [acceptButton setTitle:@"Accept" forState:UIControlStateNormal];
    acceptButton.titleLabel.font = [UIFont systemFontOfSize:17*multiplier];
    [acceptButton setBackgroundColor:[UIColor colorWithRed:28.0/255.0 green:87.0/255.0 blue:255.0/255.0 alpha:1]];
    [acceptButton setTintColor:[UIColor whiteColor]];
    acceptButton.layer.cornerRadius = 3;
    [bottomView addSubview:acceptButton];
    
    UIButton *maybeButton = [[UIButton alloc] initWithFrame:CGRectMake(33*multiplier, 8*multiplier, 65*multiplier, 28*multiplier)];
    [maybeButton setTitle:@"Maybe" forState:UIControlStateNormal];
    maybeButton.titleLabel.font = [UIFont systemFontOfSize:17*multiplier];
    [maybeButton setBackgroundColor:[UIColor colorWithRed:28.0/255.0 green:87.0/255.0 blue:255.0/255.0 alpha:1]];
    [maybeButton setTintColor:[UIColor whiteColor]];
    maybeButton.layer.cornerRadius = 3;
    maybeButton.center = CGPointMake(self.view.center.x, maybeButton.center.y);
    [bottomView addSubview:maybeButton];
    
    UIButton *declineButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width-33*multiplier-65*multiplier, 8*multiplier, 65*multiplier, 28*multiplier)];
    [declineButton setTitle:@"Decline" forState:UIControlStateNormal];
    declineButton.titleLabel.font = [UIFont systemFontOfSize:17*multiplier];
    [declineButton setBackgroundColor:[UIColor colorWithRed:28.0/255.0 green:87.0/255.0 blue:255.0/255.0 alpha:1]];
    [declineButton setTintColor:[UIColor whiteColor]];
    declineButton.layer.cornerRadius = 3;
    [bottomView addSubview:declineButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
