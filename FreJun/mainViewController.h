//
//  mainViewController.h
//  FreJun
//
//  Created by GOTESO on 10/08/16.
//  Copyright © 2016 GOTESO. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface mainViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *notificationsCountLabel;
@property (weak, nonatomic) IBOutlet UIView *calendarBackGroundView;
@property (weak, nonatomic) IBOutlet UILabel *weekDescriptionLabel;
@property (weak, nonatomic) IBOutlet UIButton *dragButton;
@property (weak, nonatomic) IBOutlet UIView *tableView;
@end
