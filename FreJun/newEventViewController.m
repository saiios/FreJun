//
//  newEventViewController.m
//  FreJun
//
//  Created by GOTESO on 16/08/16.
//  Copyright © 2016 GOTESO. All rights reserved.
//

#import "newEventViewController.h"

@interface newEventViewController (){

NSMutableArray *arrayForBool;
NSArray *sectionTitleArray;

}

@end

@implementation newEventViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    arrayForBool=[[NSMutableArray alloc]init];
    sectionTitleArray=[[NSArray alloc]initWithObjects:
                       @"Time Zone",
                       @"Default Meeting Duration",
                       @"Default ETD Alert",
                       @"Default ETA Alert",
                       @"Alerts Sounds",
                       @"Would you like to notify about your ETA if running late?",
                       nil];
    
    for (int i=0; i<[sectionTitleArray count]; i++) {
        [arrayForBool addObject:[NSNumber numberWithBool:NO]];
    }
    [arrayForBool replaceObjectAtIndex:5 withObject:[NSNumber numberWithBool:YES]];
    _expandableTableView.dataSource=self;
    _expandableTableView.delegate=self;
    _expandableTableView.bounces = NO;
    _expandableTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    _expandableTableView.showsVerticalScrollIndicator = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
