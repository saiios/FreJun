//
//  ViewController.m
//  FreJun
//
//  Created by GOTESO on 09/08/16.
//  Copyright © 2016 GOTESO. All rights reserved.
//

#import "ViewController.h"
#import <Google/SignIn.h>
#import "AppDelegate.h"
#import "Amplitude.h"

@interface ViewController ()<NSURLConnectionDelegate>{
    
    BOOL loading;
    UIView *loadingView;
    NSMutableData *mutableData;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[Amplitude instance] logEvent:@"Login"];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateRegistrationStatus:)
                                                 name:appDelegate.registrationKey
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showReceivedMessage:)
                                                 name:appDelegate.messageKey
                                               object:nil];
    
    [self loadingView];
    [GIDSignIn sharedInstance].uiDelegate = self;
    [GIDSignIn sharedInstance].delegate = self;
    [GIDSignIn sharedInstance].shouldFetchBasicProfile = YES;
    [GIDSignIn sharedInstance].scopes = [[GIDSignIn sharedInstance].scopes arrayByAddingObject:@"https://www.google.com/m8/feeds/contacts/default/full"];
    //[GIDSignIn sharedInstance].scopes = [[GIDSignIn sharedInstance].scopes arrayByAddingObject:@"profile"];
    // Uncomment to automatically sign in the user.
    if ([GIDSignIn sharedInstance].hasAuthInKeychain) {
    [[GIDSignIn sharedInstance] signInSilently];
    }
}

-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    if ([[NSUserDefaults standardUserDefaults] stringForKey:@"userID"]) {
        dataclass *obj = [dataclass getInstance];
        obj.emailTitle = [[NSUserDefaults standardUserDefaults] stringForKey:@"email1"];
        obj.name = [[NSUserDefaults standardUserDefaults] stringForKey:@"name"];
        obj.NotificationCount = [[NSUserDefaults standardUserDefaults] stringForKey:@"notificationCount"];
        NSString * storyboardName = @"Main";
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
        UIViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"main"];
        //[self presentViewController:vc animated:NO completion:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)didTapSignOut:(id)sender {
    [[GIDSignIn sharedInstance] signOut];
}

# pragma mark Helper Methods

- (IBAction)signInButtonPressed:(id)sender {
    [[GIDSignIn sharedInstance] signIn];
    [loadingView setHidden:NO];
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
    [self getGoogleContacts:user.authentication.accessToken];
  //  NSLog(@"{userId : %@},{idToken : %@},{fullName : %@},{givenName : %@},{familyName : %@},{email : %@}",userId,idToken,fullName,givenName,familyName,email);
    NSLog(@"auth code = %@",user.serverAuthCode);
    dataclass *obj = [dataclass getInstance];
   // NSLog(@"Logged In");
    [[NSUserDefaults standardUserDefaults] setObject:email forKey:@"email1"];
    [[NSUserDefaults standardUserDefaults] setObject:user.profile.name forKey:@"name"];
    obj.name = user.profile.name;
    [[NSUserDefaults standardUserDefaults] synchronize];
//    [[NSUserDefaults standardUserDefaults] setObject:user.profile.email forKey:@"email"];
//    [[NSUserDefaults standardUserDefaults] synchronize];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:directory]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    
    [request setHTTPMethod:@"POST"];
    NSString *postString = [NSString stringWithFormat:@"idToken=%@&deviceId=%@&email=%@&fullName=%@&givenName=%@&familyName=%@&timeZone=%@&gcmToken=%@&authCode=%@",user.authentication.idToken,obj.GCMToken,user.profile.email,user.profile.name,user.profile.givenName,user.profile.familyName,[NSString stringWithFormat:@"timeZone=%ld",(long)[[NSTimeZone localTimeZone] secondsFromGMT]],obj.GCMToken,user.authentication.accessToken];
    NSLog(@"%@",postString);
    NSData *parameterData = [postString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    [request setHTTPBody:parameterData];
    [request setHTTPMethod:@"POST"];
    [request addValue: @"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if( connection )
    {
        mutableData = [NSMutableData new];
        [loadingView setHidden:YES];
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

- (void)jumpScreen {
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:directory]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    
    [request setHTTPMethod:@"POST"];
    NSString *postString = @"idToken=Locassa&deviceId=AWESOME!&email=242212&fullName=ffrfe&givenName=erwtt&familyName=bbnbmn&userID=EC90D519";
    NSData *parameterData = [postString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    [request setHTTPBody:parameterData];
    [request setHTTPMethod:@"POST"];
    [request addValue: @"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if( connection )
    {
        mutableData = [NSMutableData new];
    }

    
//    NSString * storyboardName = @"Main";
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
//    UIViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"main"];
//    [self presentViewController:vc animated:NO completion:nil];
//    
}

-(IBAction)save:(id)sender{

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:directory]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    
    [request setHTTPMethod:@"POST"];
    NSString *postString = @"idToken=Locassa&deviceId=AWESOME!&email=242212&fullName=ffrfe&givenName=erwtt&familyName=bbnbmn&userID=EC90D519";
    NSData *parameterData = [postString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    [request setHTTPBody:parameterData];
    [request setHTTPMethod:@"POST"];
    [request addValue: @"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if( connection )
    {
    //    mutableData = [NSMutableData new];
    }


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
-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [[self navigationController] setNavigationBarHidden:YES];
}

#pragma mark NSURLConnection delegates

-(void) connection:(NSURLConnection *) connection didReceiveResponse:(NSURLResponse *)response
{
    [mutableData setLength:0];
  //  NSLog(@"response %@",response);
}

-(void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [mutableData appendData:data];
   // NSLog(@"dara got");
}

-(void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    //serverResponse.text = NO_CONNECTION;
   // NSLog(@"45455 %@",error);
    return;
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [loadingView setHidden:YES];
    });
    NSString *responseStringWithEncoded = [[NSString alloc] initWithData: mutableData encoding:NSUTF8StringEncoding];
    NSError* error;
    NSArray *json = [NSJSONSerialization
                     JSONObjectWithData:mutableData
                     options:kNilOptions
                     error:&error];
    
    NSLog(@"Response from Server : %@", responseStringWithEncoded);
    // NSAttributedString * attrStr = [[NSAttributedString alloc] initWithData:[responseStringWithEncoded dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    //serverResponse.attributedText = attrStr;
    if ([[json objectAtIndex:0] objectForKey:@"userID"]) {

    [[NSUserDefaults standardUserDefaults] setObject:[[json objectAtIndex:0] objectForKey:@"userID"] forKey:@"userID"];
     dataclass *obj = [dataclass getInstance];
    obj.emailTitle = [[NSUserDefaults standardUserDefaults] stringForKey:@"email1"];
    obj.NotificationCount = [NSString stringWithFormat:@"%@",[[json objectAtIndex:0] objectForKey:@"notificationCount"]];
    [[NSUserDefaults standardUserDefaults] setObject:[[json objectAtIndex:0] objectForKey:@"notificationCount"] forKey:@"notificationCount"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSMutableArray *dates = [[NSMutableArray alloc]init];
    NSArray *dates2 = [[NSMutableArray alloc]init];
    for (int i = 1; i < json.count ; i++) {
        NSString *date = [[[json objectAtIndex:i] objectForKey:@"startTime"] substringToIndex:10];
        [dates addObject:date]; }
    dates2 = [dates valueForKeyPath:@"@distinctUnionOfObjects.self"];
    obj.dates = dates2;

        NSString * storyboardName = @"Main";
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
        UIViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"main"];
        [self presentViewController:vc animated:NO completion:nil];
    }
    else{
        
        loadingView.hidden = YES;
        loading = NO;
        [[GIDSignIn sharedInstance] signOut];
        
    }
}


//alert
- (void) updateRegistrationStatus:(NSNotification *) notification {
    //[_registrationProgressing stopAnimating];
    if ([notification.userInfo objectForKey:@"error"]) {
       // _registeringLabel.text = @"Error registering!";
       // [self showAlert:@"Error registering with GCM" withMessage:notification.userInfo[@"error"]];
    } else {
        //_registeringLabel.text = @"Registered!";
        NSString *message = @"Check the xcode debug console for the registration token that you can"
        " use with the demo server to send notifications to your device";
       // [self showAlert:@"Registration Successful" withMessage:message];
    };
}

- (void) showReceivedMessage:(NSNotification *) notification {
    NSString *message = notification.userInfo[@"aps"][@"alert"];
    [self showAlert:@"Message received" withMessage:message];
}

- (void)showAlert:(NSString *)title withMessage:(NSString *) message{
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_7_1) {
        // iOS 7.1 or earlier
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:@"Dismiss"
                                              otherButtonTitles:nil];
        [alert show];
    } else {
        //iOS 8 or later
        UIAlertController *alert =
        [UIAlertController alertControllerWithTitle:title
                                            message:message
                                     preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *dismissAction = [UIAlertAction actionWithTitle:@"Dismiss"
                                                                style:UIAlertActionStyleDestructive
                                                              handler:nil];
        
        [alert addAction:dismissAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
