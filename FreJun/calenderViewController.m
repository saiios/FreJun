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
    NSMutableArray *sortedEvents;
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
                @"Priority":@"2",
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
    
    self.navigationItem.title = @"demo1@gmail.com";
    _tableView.dataSource=self;
    _tableView.delegate=self;
    
    sortedEvents = [[NSMutableArray alloc]init];
    for (int i = 0; i < events.count; i++) {
        
        NSDictionary *eventsDict = [events objectAtIndex:i];
        NSString *allday;
        NSString *priority;
        NSString *state;
        
        if ([[eventsDict objectForKey:@"allday"]  isEqual: @"NO"]) {
            allday = @"";
        }
        else{
            allday = @"all-day";
        }
        
        if ([[eventsDict objectForKey:@"Priority"]  isEqual: @"0"]) {
            priority = @"";
        }
        else if ([[eventsDict objectForKey:@"Priority"]  isEqual: @"1"]){
            priority = @"!";
        }
        else if ([[eventsDict objectForKey:@"Priority"]  isEqual: @"2"]){
            priority = @"!!";
        }
        else if ([[eventsDict objectForKey:@"Priority"]  isEqual: @"3"]){
            priority = @"!!!";
        }
        
        if ([[eventsDict objectForKey:@"State"]  isEqual: @"0"]) {
            state = @"NO";
        }
        else if ([[eventsDict objectForKey:@"State"]  isEqual: @"1"]){
            state = @"NO";
        }
        else if ([[eventsDict objectForKey:@"State"]  isEqual: @"2"]){
            state = @"YES";
        }
        else if ([[eventsDict objectForKey:@"State"]  isEqual: @"3"]){
            state = @"YES";
        }
        
        NSMutableDictionary *tempDict = [[NSMutableDictionary alloc]init];
        [tempDict setValue:allday forKey:@"allday"];
        [tempDict setValue:[eventsDict objectForKey:@"Title"] forKey:@"Title"];
        [tempDict setValue:state forKey:@"state"];
        [tempDict setValue:priority forKey:@"Priority"];
        
        [sortedEvents addObject:tempDict];
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

        return sortedEvents.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
/*
    static NSString *cellid=@"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (cell==nil) {
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"cell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    UILabel *allday = (UILabel *)[cell viewWithTag:1];
    allday.textAlignment = NSTextAlignmentRight;
    allday.text = [sortedEvents[indexPath.row] objectForKey:@"allday"];

    UILabel *title = (UILabel *)[cell viewWithTag:5];
    title.text = [sortedEvents[indexPath.row] objectForKey:@"Title"];
//    title.frame = CGRectMake(title.frame.origin.x, 0, [[sortedEvents[indexPath.row] objectForKey:@"Title"] sizeWithFont:cell.textLabel.font constrainedToSize:CGSizeMake(MAXFLOAT, cell.frame.size.height)].width, cell.frame.size.height);
    title.center = cell.contentView.center;

    UILabel *priority = (UILabel *)[cell viewWithTag:6];
    priority.text = [sortedEvents[indexPath.row] objectForKey:@"Priority"];

    cell.accessoryType = [[sortedEvents[indexPath.row] objectForKey:@"state"] boolValue] ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    
    return cell;
 */
    
    static NSString *cellid=@"calenderTableViewCell";
    calenderTableViewCell *cell = (calenderTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellid];
    if (cell==nil) {
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"calenderTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.allDayLabel.text = [sortedEvents[indexPath.row] objectForKey:@"allday"];
    cell.allDayLabel.textAlignment = NSTextAlignmentRight;
    
    cell.title.text = [events[indexPath.row] objectForKey:@"Title"];
    cell.title.frame = CGRectMake(cell.title.frame.origin.x, 0, [[sortedEvents[indexPath.row] objectForKey:@"Title"] sizeWithFont:cell.textLabel.font constrainedToSize:CGSizeMake(MAXFLOAT, cell.frame.size.height)].width, cell.frame.size.height);
    //cell.title.backgroundColor = [UIColor yellowColor];
    
    cell.priorityLabel.text = [sortedEvents[indexPath.row] objectForKey:@"Priority"];
    cell.priorityLabel.frame = CGRectMake(cell.title.frame.origin.x + cell.title.frame.size.width, 0, 35, cell.frame.size.height);
    
    cell.accessoryType = [[sortedEvents[indexPath.row] objectForKey:@"state"] boolValue] ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 44;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
        return 35;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.0001;
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView *sectionView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 280,35)];
    UILabel *date = [[UILabel alloc]initWithFrame:CGRectMake(15, 5, 280,35)];
    date.font = [UIFont systemFontOfSize:10];
    date.textColor = [UIColor lightGrayColor];
    date.text = @"Monday, May 30th, 2016";
    [sectionView addSubview:date];
    return  sectionView;
    
    
}

@end
