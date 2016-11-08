//
//  calenderViewController.m
//  FreJun
//
//  Created by GOTESO on 16/08/16.
//  Copyright © 2016 GOTESO. All rights reserved.
//

#import "calenderViewController.h"
#import "calenderTableViewCell.h"
#import "eventDetailsViewController.h"

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
    dataclass *obj = [dataclass getInstance];
    self.navigationItem.title = @"demo1@gmail.com";
    self.navigationItem.title = obj.emailTitle;
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
        dataclass *obj = [dataclass getInstance];
        return obj.events.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    dataclass *obj = [dataclass getInstance];
    static NSString *cellid=@"calenderTableViewCell";
    calenderTableViewCell *cell = (calenderTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellid];
    if (cell==nil) {
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"calenderTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    int all = [[obj.events[indexPath.row] objectForKey:@"allDay"] intValue];
    if (all == 1) {
        cell.allDayLabel.text = @"all-Day";
    }
    else{
        cell.allDayLabel.text = @"";
    }
    
    cell.allDayLabel.textAlignment = NSTextAlignmentRight;
    
    cell.time1.text = [[obj.events[indexPath.row] objectForKey:@"startTime"] substringFromIndex:[[obj.events[indexPath.row] objectForKey:@"startTime"] length] - 8];
    if (all != 1) {
        cell.time2.text = [[obj.events[indexPath.row] objectForKey:@"endTime"] substringFromIndex:[[obj.events[indexPath.row] objectForKey:@"endTime"] length] - 8];
    }

    if (all == 1) {
        cell.time1.text = @"";
        cell.time2.text = @"";
    }
    cell.title.text = [obj.events[indexPath.row] objectForKey:@"eventName"];
    cell.title.frame = CGRectMake(cell.title.frame.origin.x, 0, [[obj.events[indexPath.row] objectForKey:@"eventName"] sizeWithFont:cell.textLabel.font constrainedToSize:CGSizeMake(MAXFLOAT, cell.frame.size.height)].width, cell.frame.size.height);
    //cell.title.backgroundColor = [UIColor yellowColor];
    
    NSArray * temp = [[NSUserDefaults standardUserDefaults] objectForKey:@"accounts"];
    int index = 0;
    for (int i = 0; i < temp.count; i++) {
        if ([[obj.events[indexPath.row] objectForKey:@"email"] isEqualToString:temp[i]]) {
            index = i;
        }
    }
    NSArray *colors = [[NSArray alloc]init];
    colors = @[color1,color2,color3,color4,color5];
    cell.colorView.backgroundColor = colors[index];
    
    int priorityLevel = [[obj.events[indexPath.row] objectForKey:@"priority"] intValue];
    switch(priorityLevel)
    {
        case 0 :
            cell.priorityLabel.text = @"";
            break;
        case 1 :
            cell.priorityLabel.text = @"!";
            break;
        case 2 :
            cell.priorityLabel.text = @"!!";
            break;
        case 3 :
            cell.priorityLabel.text = @"!!!";
            break;
        default :
            cell.priorityLabel.text = @"";
    }

    cell.priorityLabel.frame = CGRectMake(cell.title.frame.origin.x + cell.title.frame.size.width, 0, 35, cell.frame.size.height);
    
    //cell.accessoryType = [[obj.events[indexPath.row] objectForKey:@"allDay"] boolValue] ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
    dataclass *obj = [dataclass getInstance];
    obj.selectedEvent = obj.events[indexPath.row];
    eventDetailsViewController* infoController = [self.storyboard instantiateViewControllerWithIdentifier:@"eventDetails"];
    [self.navigationController pushViewController:infoController animated:YES];
    
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
    dataclass *obj = [dataclass getInstance];
    date.text = obj.selectedDate;
    [sectionView addSubview:date];
    return  sectionView;
    
    
}

@end
