//
//  calenderViewController.m
//  FreJun
//
//  Created by GOTESO on 16/08/16.
//  Copyright © 2016 GOTESO. All rights reserved.
//

#import "calenderViewController.h"
#import "calenderTableViewCell.h"

@interface calenderViewController (){
    
    NSArray *events;
}

@end

@implementation calenderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    events = [[NSArray alloc]initWithObjects:
              @{@"allday":@"YES",
                @"Title":@"Task 1",
                @"Priority":@"3",
                @"State":@"1" },
              
              @{@"allday":@"NO",
                @"Title":@"Call Roman",
                @"Priority":@"1",
                @"State":@"2" },
              
              @{@"allday":@"NO",
                @"Title":@"Another one task",
                @"Priority":@"0",
                @"State":@"2" },
              
              @{@"allday":@"NO",
                @"Title":@"Some event",
                @"Priority":@"0",
                @"State":@"0" },
              
              @{@"allday":@"NO",
                @"Title":@"Buy something else",
                @"Priority":@"0",
                @"State":@"2" },
              
              @{@"allday":@"NO",
                @"Title":@"Meeting with BrandedMe",
                @"Priority":@"2",
                @"State":@"0" },
              
              @{@"allday":@"NO",
                @"Title":@"Home Dinner",
                @"Priority":@"0",
                @"State":@"1" },
                nil];
    
    self.navigationItem.title = @"Preferences";
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    _tableView.dataSource=self;
    _tableView.delegate=self;
    _tableView.bounces = NO;
    _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.contentInset = UIEdgeInsetsMake(35, 0, -1, 0);
    //_expandableTableView.backgroundColor = [UIColor colorWithRed:243.0/255.0 green:243.0/255.0 blue:243.0/255.0 alpha:1];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

        return 7;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellid=@"cell";
    calenderTableViewCell *cell=(calenderTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellid];
    if (cell==nil) {
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"cell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
//    UILabel *allday = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 30, cell.frame.size.height)];
//    allday.textAlignment = NSTextAlignmentRight;
//    [cell addSubview:allday];
//
    if ([[[events objectAtIndex:indexPath.row] objectForKey:@"allday"]  isEqual: @"NO"]) {
        cell.allday.text = @"";
    }

    
//            /********** Add a custom Separator with cell *******************/
//    UIView* separatorLineView = [[UIView alloc] initWithFrame:CGRectMake(15, 49, _tableView.frame.size.width-15, 1)];
//    separatorLineView.backgroundColor = [UIColor colorWithRed:235.0/255.0 green:235.0/255.0 blue:235.0/255.0 alpha:1];
//    [cell.contentView addSubview:separatorLineView];
//
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 200;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 45;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView *sectionView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 280,50)];
    return  sectionView;
    
    
}
- (void)sectionHeaderTapped:(UITapGestureRecognizer *)gestureRecognizer{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:gestureRecognizer.view.tag];

}


@end
