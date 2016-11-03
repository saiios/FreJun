//
//  AccountsTableViewController.m
//  FreJun
//
//  Created by GOTESO on 19/08/16.
//  Copyright © 2016 GOTESO. All rights reserved.
//

#import "AccountsTableViewController.h"
#import "accountsTableViewCell.h"
#import "Amplitude.h"
#import <Google/SignIn.h>
@interface AccountsTableViewController (){
    
    NSArray *accounts;
    NSArray *colors;
    
    BOOL loading;
    UIView *loadingView;
    NSMutableData *mutableData;
}


@end

@implementation AccountsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[Amplitude instance] logEvent:@"Accounts"];
    self.navigationItem.title = @"Accounts";
    accounts = [[NSArray alloc]init];
    accounts = @[@"demo1@gmail.com",@"demo2@gmail.com",@"demo3@gmail.com"];
    self.view.backgroundColor = [UIColor colorWithRed:243.0/255.0 green:243.0/255.0 blue:243.0/255.0 alpha:1];
    //self.tableView.contentInset = UIEdgeInsetsMake(40, 0, 0, 0);
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    colors = [[NSArray alloc]initWithObjects:@"color1.jpg",@"color2.jpg",@"color3.jpg",@"color4.jpg",@"color5.jpg", nil];
    
    [self loadingView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    else{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"accounts"] count];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    
    if (indexPath.section == 1) {
    
        static NSString *cellid=@"accountsTableViewCell";
        accountsTableViewCell *cell = (accountsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellid];
        if (cell==nil) {
            NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"accountsTableViewCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        dataclass *obj = [dataclass getInstance];
        cell.title.text = [[[NSUserDefaults standardUserDefaults] objectForKey:@"accounts"] objectAtIndex:indexPath.row];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
     }
    else{
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (cell==nil) {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        }
        cell.textLabel.text = @"Add new account";
        cell.textLabel.textColor = [UIColor colorWithRed:28.0/255.0 green:87.0/255.0 blue:255.0/255.0 alpha:1.0];
        
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.0001;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        return 0;
    }
    else{
    return 31;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    

    if (section == 1) {
        UIView *sectionView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,31)];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(50, 0, self.view.frame.size.width, 31)];
        label.text = @"Google Accounts";
        label.textColor = [UIColor colorWithRed:109.0/255.0 green:109.0/255.0 blue:114.0/255.0 alpha:1];
        label.font = [UIFont systemFontOfSize:13];
        [sectionView addSubview:label];
        
        UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(15, 5, 20, 20)];
        image.image = [UIImage imageNamed:@"google-icon"];;
        [sectionView addSubview:image];
        
        return  sectionView;
    }
    
    UIView *emptyview;
    return emptyview;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        [[GIDSignIn sharedInstance] signOut];
        [GIDSignIn sharedInstance].uiDelegate = self;
        [GIDSignIn sharedInstance].delegate = self;
        [GIDSignIn sharedInstance].shouldFetchBasicProfile = YES;
        [GIDSignIn sharedInstance].scopes = [[GIDSignIn sharedInstance].scopes arrayByAddingObject:@"https://www.google.com/m8/feeds/contacts/default/full"];
        [GIDSignIn sharedInstance].scopes = [[GIDSignIn sharedInstance].scopes arrayByAddingObject:@"https://www.googleapis.com/auth/calendar"];
        [GIDSignIn sharedInstance].scopes = [[GIDSignIn sharedInstance].scopes arrayByAddingObject:@"https://www.googleapis.com/auth/userinfo.profile"];
        
        //[GIDSignIn sharedInstance].scopes = [[GIDSignIn sharedInstance].scopes arrayByAddingObject:@"profile"];
        
        [GIDSignIn sharedInstance].clientID = @"303546570344-03b32b71knftdq2fqccj0aq073a7ah24.apps.googleusercontent.com";
        [GIDSignIn sharedInstance].serverClientID = @"303546570344-ttv0ingquts4thesu9ub93l2473f6ras.apps.googleusercontent.com";
        [[GIDSignIn sharedInstance] signIn];

    }
    
}

# pragma mark - Google SignIn Delegate
- (void)signInWillDispatch:(GIDSignIn *)signIn error:(NSError *)error {
    
}

- (void)signIn:(GIDSignIn *)signIn presentViewController:(UIViewController *)viewController {
    
    [self presentViewController:viewController animated:YES completion:nil];
    
}

- (void)signIn:(GIDSignIn *)signIn dismissViewController:(UIViewController *)viewController {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)signIn:(GIDSignIn *)signIn didSignInForUser:(GIDGoogleUser *)user
     withError:(NSError *)error {
    
    if (error) {
    NSLog(@"Error is : %@",error);
    }
    else{
    //user signed in
    dispatch_async(dispatch_get_main_queue(), ^{
        [loadingView setHidden:NO];
    });
    NSString *userId = user.userID;                  // For client-side use only!
    NSString *idToken = user.authentication.idToken; // Safe to send to the server
    NSString *fullName = user.profile.name;
    NSString *givenName = user.profile.givenName;
    NSString *familyName = user.profile.familyName;
    NSString *email = user.profile.email;
    NSLog(@"ppp %@",user.authentication.accessToken);
    NSLog(@"ggg %@",user.authentication.refreshToken);
    [self getGoogleContacts:user.authentication.accessToken];
    //  NSLog(@"{userId : %@},{idToken : %@},{fullName : %@},{givenName : %@},{familyName : %@},{email : %@}",userId,idToken,fullName,givenName,familyName,email);
    NSLog(@"auth code = %@",user.serverAuthCode);
    dataclass *obj = [dataclass getInstance];
    // NSLog(@"Logged In");
    [[NSUserDefaults standardUserDefaults] setObject:email forKey:@"email1"];
    [[NSUserDefaults standardUserDefaults] setObject:user.profile.name forKey:@"name"];
    obj.name = user.profile.name;
    [[NSUserDefaults standardUserDefaults] synchronize];

    NSString *url = [NSString stringWithFormat:@"%@?userID=%@&idToken=%@&deviceId=%@&email=%@&fullName=%@&givenName=%@&familyName=%@&timeZone=%@&gcmToken=%@&authCode=%@&refresh_token=%@&server_authcode=%@",directoryAccount,[[NSUserDefaults standardUserDefaults] stringForKey:@"userID"],user.authentication.idToken,obj.GCMToken,user.profile.email,user.profile.name,user.profile.givenName,user.profile.familyName,[NSString stringWithFormat:@"timeZone=%ld",(long)[[NSTimeZone localTimeZone] secondsFromGMT]],obj.GCMToken,user.authentication.accessToken,user.authentication.refreshToken,user.serverAuthCode];
    
    
    NSLog(@"%@",url);
    
    url = [url stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    
    NSURL *queryUrl = [NSURL URLWithString:url];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *data = [NSData dataWithContentsOfURL: queryUrl];
        NSError* error;
        NSLog(@"bholi %@",data);
        NSString* newStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"string is : %@",newStr);
        if(data){
            NSArray *json = [NSJSONSerialization
                             JSONObjectWithData:data
                             options:kNilOptions
                             error:&error];
            NSLog(@"%@",json);
            dispatch_async(dispatch_get_main_queue(), ^{
                if (1) {
                    
                    [[NSUserDefaults standardUserDefaults] setObject:[json objectAtIndex:0] forKey:@"userID"];
                    dataclass *obj = [dataclass getInstance];
                    obj.emailTitle = [[NSUserDefaults standardUserDefaults] stringForKey:@"email1"];
                    obj.NotificationCount = [NSString stringWithFormat:@"%@",[json objectAtIndex:2]];
                    [[NSUserDefaults standardUserDefaults] setObject:[json objectAtIndex:2] forKey:@"notificationCount"];
                    
                    NSMutableArray *dates = [[NSMutableArray alloc]init];
                    NSArray *dates2 = [[NSMutableArray alloc]init];
                    for (int i = 0; i < [json[1] count] ; i++) {
                        NSString *date = [[[[json objectAtIndex:1] objectAtIndex:i] objectForKey:@"startTime"] substringToIndex:10];
                        [dates addObject:date]; }
                    dates2 = [dates valueForKeyPath:@"@distinctUnionOfObjects.self"];
                    obj.dates = dates2;
                    
                    NSMutableArray *emails = [[NSMutableArray alloc]initWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"accounts"]];
                    BOOL repeat;
                    repeat = NO;
                    for (int i = 0; i < [[[NSUserDefaults standardUserDefaults] objectForKey:@"accounts"] count] ; i++) {
                        if ([[[[NSUserDefaults standardUserDefaults] objectForKey:@"accounts"] objectAtIndex:i] isEqualToString:user.profile.email]) {
                            repeat = YES;
                        }
                    }
                    if (repeat == NO) {
                        [emails addObject:user.profile.email];
                    }
                    [[NSUserDefaults standardUserDefaults] setObject:emails forKey:@"accounts"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    
                    loadingView.hidden = YES;
                    loading = NO;
                    [self.tableView reloadData];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshTitle" object:self];
                    
//                    NSString * storyboardName = @"Main";
//                    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
//                    UIViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"main"];
//                    [self presentViewController:vc animated:NO completion:nil];
                }
                else{
                    
                    loadingView.hidden = YES;
                    loading = NO;
                    [[GIDSignIn sharedInstance] signOut];
                    
                }
            });
            
        }
        else{
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [loadingView setHidden:YES];
                // loading = NO;
                // [self alertStatus:@"Please try again after some time." :@"Connection Failed!"];
                
            });}
    });
    }
}


-(void)getGoogleContacts:(NSString *)token{
    
    NSString *url = [NSString stringWithFormat:@"https://www.google.com/m8/feeds/contacts/default/full?max-results=1000&alt=json&access_token=%@",token];
    url = [url stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    NSURL *queryUrl = [NSURL URLWithString:url];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:queryUrl];
    [request addValue:@"3.0" forHTTPHeaderField:@"GData-Version"];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        NSError* error;
        if(data){
            
            NSDictionary *json=[[NSDictionary alloc]init];
            json = [NSJSONSerialization
                    JSONObjectWithData:data
                    options:kNilOptions
                    error:&error];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                NSMutableArray *gmailContacts = [[NSMutableArray alloc]init];
                
                for (int i=0; i<[json[@"feed"][@"entry"] count]; i++) {
                    NSDictionary *tempDict = json[@"feed"][@"entry"][i];
                    NSMutableDictionary *contact = [[NSMutableDictionary alloc]init];
                    if ([tempDict objectForKey:@"gd$email"] != nil) {
                        [contact setValue:[[[tempDict objectForKey:@"gd$name"] objectForKey:@"gd$fullName"] objectForKey:@"$t"] forKey:@"name"];
                        [contact setValue:[[[tempDict objectForKey:@"gd$email"] objectAtIndex:0] objectForKey:@"address"] forKey:@"email"];
                        [gmailContacts addObject:contact];
                    }
                    
                }
                NSLog(@"Gmail Contacts are : %@",gmailContacts);
                dataclass *obj = [dataclass getInstance];
                obj.googleContacts = gmailContacts;
                [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshContacts" object:self];
            });
            
        }});
}

-(void)loadingView{
    
    loadingView = [[UIView alloc]initWithFrame:CGRectMake(100, 400, 80, 80)];
    loadingView.center = self.view.center;
    loadingView.backgroundColor = [UIColor colorWithWhite:0. alpha:0.85];
    loadingView.layer.cornerRadius = 5;
    
    UIActivityIndicatorView *activityView=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activityView.center = CGPointMake(loadingView.frame.size.width / 2.0, 35);
    [activityView startAnimating];
    activityView.tag = 100;
    [loadingView addSubview:activityView];
    
    UILabel* lblLoading = [[UILabel alloc]initWithFrame:CGRectMake(0, 48, 80, 30)];
    lblLoading.text = @"Loading...";
    lblLoading.textColor = [UIColor whiteColor];
    lblLoading.font = [UIFont fontWithName:lblLoading.font.fontName size:15];
    lblLoading.textAlignment = NSTextAlignmentCenter;
    [loadingView addSubview:lblLoading];
    
    [self.view addSubview:loadingView];
    [loadingView setHidden:YES];
    
}


@end
