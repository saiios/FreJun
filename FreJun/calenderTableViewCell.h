//
//  calenderTableViewCell.h
//  FreJun
//
//  Created by GOTESO on 20/08/16.
//  Copyright © 2016 GOTESO. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface calenderTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *time1;
@property (weak, nonatomic) IBOutlet UILabel *time2;
@property (weak, nonatomic) IBOutlet UILabel *allDayLabel;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *priorityLabel;
@property (weak, nonatomic) IBOutlet UIView *colorView;

@end
