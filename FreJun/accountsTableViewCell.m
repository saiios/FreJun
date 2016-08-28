//
//  accountsTableViewCell.m
//  FreJun
//
//  Created by GOTESO on 26/08/16.
//  Copyright © 2016 GOTESO. All rights reserved.
//

#import "accountsTableViewCell.h"

@implementation accountsTableViewCell
@synthesize title = _title;
@synthesize dot = _dot;
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
