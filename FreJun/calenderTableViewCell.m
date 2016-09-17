//
//  calenderTableViewCell.m
//  FreJun
//
//  Created by GOTESO on 20/08/16.
//  Copyright © 2016 GOTESO. All rights reserved.
//

#import "calenderTableViewCell.h"

@implementation calenderTableViewCell

@synthesize time1 = _time1;
@synthesize time2 = _time2;
@synthesize allDayLabel = _allDayLabel;
@synthesize title = _title;
@synthesize priorityLabel = _priorityLabel;
@synthesize colorView = _colorView;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    _colorView.layer.cornerRadius = 6.5;
    // Configure the view for the selected state
}

@end
