//
//  newEventViewController.h
//  FreJun
//
//  Created by GOTESO on 16/08/16.
//  Copyright © 2016 GOTESO. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface newEventViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *expandableTableView;
@end
