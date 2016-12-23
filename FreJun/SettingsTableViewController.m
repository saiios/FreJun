//
//  SettingsTableViewController.m
//  FreJun
//
//  Created by GOTESO on 19/08/16.
//  Copyright © 2016 GOTESO. All rights reserved.
//

#import "SettingsTableViewController.h"
#import "AccountsTableViewController.h"
#import "PreferencesTableViewController.h"
#import "UserPrefrencesTableViewController.h"
#import "HotlineSDK/Hotline.h"
#import "Amplitude.h"
@interface SettingsTableViewController (){
    
    NSArray *buttons;
}

@end

@implementation SettingsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[Amplitude instance] logEvent:@"Settings"];
    self.navigationItem.title = @"Settings";
    buttons = [[NSArray alloc]init];
    buttons = @[@"Add your new account here",@"Preferences",@"Chat with us for instant support"];
    self.view.backgroundColor = [UIColor colorWithRed:243.0/255.0 green:243.0/255.0 blue:243.0/255.0 alpha:1];
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = backButton;

    [self hotlineUser];
}

-(void)hotlineUser{
    
    /*
     * Following three methods are to identify a user.
     * These user properties will be viewable on the Hotline web dashboard.
     * The externalID (identifier) set will also be used to identify the specific user for any APIs
     * targeting a user or list of users in pro-active messaging or marketing
     */
    dataclass *obj = [dataclass getInstance];
    // Create a user object
    HotlineUser *user = [HotlineUser sharedInstance];
    
    // To set an identifiable name for the user
    user.name = @"John Doe";
    user.name = obj.name;
    
    
    //To set user's email id
    user.email = @"john.doe.1982@mail.com";
    user.email = obj.emailTitle;
    
    //To set user's phone number
   // user.phoneCountryCode=@"91";
   // user.phoneNumber = @"9790987495";
    
    //To set user's identifier (external id to map the user to a user in your system. Setting an external ID is COMPULSARY for many of Hotline’s APIs
    user.externalID=@"john.doe.82";
    user.externalID = [[NSUserDefaults standardUserDefaults] stringForKey:@"userID"];
    
    // FINALLY, REMEMBER TO SEND THE USER INFORMATION SET TO HOTLINE SERVERS
    
    [[Hotline sharedInstance] updateUser:user];
    
    /* Custom properties & Segmentation - You can add any number of custom properties. An example is given below.
     These properties give context for your conversation with the user and also serve as segmentation criteria for your marketing messages */
    
    //You can set custom user properties for a particular user
//    [[Hotline sharedInstance] updateUserPropertyforKey:@"customerType" withValue:@"Premium"];
    //You can set user demographic information
//    [[Hotline sharedInstance] updateUserPropertyforKey:@"city" withValue:@"San Bruno"];
    //You can segment based on where the user is in their journey of using your app
    [[Hotline sharedInstance] updateUserPropertyforKey:@"loggedIn" withValue:@"true"];
    //You can capture a state of the user that includes what the user has done in your app
//    [[Hotline sharedInstance] updateUserPropertyforKey:@"transactionCount" withValue:@"3"];
    
    /* If you want to indicate to the user that he has unread messages in his inbox, you can retrieve the unread count to display. */
    //returns an int indicating the of number of unread messages for the user
    //[[Hotline sharedInstance] getUnreadMessagesCount];
    
    /* Managing Badge number for unread messages - Manual
     If you want to listen to a local notification and take care of updating the badge number yourself, listen for a notification with name "HOTLINE_UNREAD_MESSAGE_COUNT " as below
     */
    
    [[NSNotificationCenter defaultCenter]addObserverForName:HOTLINE_UNREAD_MESSAGE_COUNT object:nil queue:nil usingBlock:^(NSNotification *note) {
        NSLog(@"updated unread messages count %@", note.userInfo[@"count"]);
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = buttons[indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle= UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        
        AccountsTableViewController* infoController = [[AccountsTableViewController alloc]initWithStyle:UITableViewStyleGrouped];
        [self.navigationController pushViewController:infoController animated:YES];
    }
    else if (indexPath.row == 1){
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        UserPrefrencesTableViewController* infoController = [storyboard instantiateViewControllerWithIdentifier:@"pref"];
        [self.navigationController pushViewController:infoController animated:YES];
    }
    else if (indexPath.row == 2){
        [[Hotline sharedInstance] showConversations:self];
        
    }
}

-(void)back{
    
    CATransition* transition = [CATransition animation];
    transition.duration = .3;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionMoveIn;
    transition.subtype= kCATransitionFromRight;
    [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
    [self.navigationController popViewControllerAnimated:NO];
}

@end
