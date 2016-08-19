//
//  preferencesViewController.h
//  FreJun
//
//  Created by GOTESO on 15/08/16.
//  Copyright © 2016 GOTESO. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface preferencesViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *expandableTableView;
@end
