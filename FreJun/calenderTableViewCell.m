//
//  calenderTableViewCell.m
//  FreJun
//
//  Created by GOTESO on 16/08/16.
//  Copyright © 2016 GOTESO. All rights reserved.
//

#import "calenderTableViewCell.h"

@implementation calenderTableViewCell
@synthesize allday;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
        allday.textAlignment = NSTextAlignmentRight;
        [self addSubview:allday];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
