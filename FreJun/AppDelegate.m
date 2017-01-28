//
//  AppDelegate.m
//  FreJun
//
//  Created by GOTESO on 09/08/16.
//  Copyright © 2016 GOTESO. All rights reserved.
//
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

#import "AppDelegate.h"
#import <OneSignal/OneSignal.h>
@import GoogleMaps;
#import <GooglePlaces/GooglePlaces.h>
#import <GoogleMaps/GoogleMaps.h>
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
#import "Hotline.h"
#import "Amplitude.h"
#import "dataclass.h"
#if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
@import UserNotifications;
#endif

@import Firebase;
@import FirebaseInstanceID;
@import FirebaseMessaging;
#import "dataclass.h"

// Implement UNUserNotificationCenterDelegate to receive display notification via APNS for devices
// running iOS 10 and above. Implement FIRMessagingDelegate to receive data message via FCM for
// devices running iOS 10 and above.
#if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
@interface AppDelegate () <UNUserNotificationCenterDelegate, FIRMessagingDelegate>
@end
#endif

// Copied from Apple's header in case it is missing in some cases (e.g. pre-Xcode 8 builds).
#ifndef NSFoundationVersionNumber_iOS_9_x_Max
#define NSFoundationVersionNumber_iOS_9_x_Max 1299
#endif


@interface AppDelegate ()<CLLocationManagerDelegate>
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) NSDate *lastTimestamp;

@property(nonatomic, strong) void (^registrationHandler)
(NSString *registrationToken, NSError *error);
@property(nonatomic, assign) BOOL connectedToGCM;
@property(nonatomic, strong) NSString* registrationToken;
@property(nonatomic, assign) BOOL subscribedToTopic;

@end

NSString *const SubscriptionTopic = @"/topics/global";

@implementation AppDelegate

+ (instancetype)sharedInstance
{
    static id sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
        AppDelegate *instance = sharedInstance;
        instance.locationManager = [CLLocationManager new];
        instance.locationManager.delegate = instance;
        instance.locationManager.desiredAccuracy = kCLLocationAccuracyBest; // you can use kCLLocationAccuracyHundredMeters to get better battery life
        instance.locationManager.pausesLocationUpdatesAutomatically = NO; // this is important
    });
    
    return sharedInstance;
}

- (void)startUpdatingLocation
{
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    
    if (status == kCLAuthorizationStatusDenied)
    {
        NSLog(@"Location services are disabled in settings.");
    }
    else
    {
        // for iOS 8
        if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)])
        {
            [self.locationManager requestAlwaysAuthorization];
        }
        // for iOS 9
        if ([self.locationManager respondsToSelector:@selector(setAllowsBackgroundLocationUpdates:)])
        {
            [self.locationManager setAllowsBackgroundLocationUpdates:YES];
        }
        
        [self.locationManager startUpdatingLocation];
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *mostRecentLocation = locations.lastObject;
   // NSLog(@"Current location: %@ %@", @(mostRecentLocation.coordinate.latitude), @(mostRecentLocation.coordinate.longitude));
    dataclass *obj = [dataclass getInstance];
    obj.lat = [NSString stringWithFormat:@"%f",mostRecentLocation.coordinate.latitude];
    obj.lng = [NSString stringWithFormat:@"%f",mostRecentLocation.coordinate.longitude];
    NSDate *now = [NSDate date];
    NSTimeInterval interval = self.lastTimestamp ? [now timeIntervalSinceDate:self.lastTimestamp] : 0;
    
    if (!self.lastTimestamp || interval >= 1 * 60)
    {
        self.lastTimestamp = now;
        NSLog(@"Sending current location to web service.");
        
        NSString *url = [NSString stringWithFormat:@"%@?userID=%@&longitude=%f&latitude=%f",directorylocation,[[NSUserDefaults standardUserDefaults] stringForKey:@"userID"],mostRecentLocation.coordinate.longitude,mostRecentLocation.coordinate.latitude];
        
        url = [url stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        NSLog(@"%@",url);
        NSURL *queryUrl = [NSURL URLWithString:url];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            //Do background work
            NSData *data = [NSData dataWithContentsOfURL: queryUrl];
            NSString* newStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            
            NSError* error;
            if(data){
                NSDictionary* json =[NSJSONSerialization
                                     JSONObjectWithData:data
                                     options:kNilOptions
                                     error:&error];
                NSLog(@"%@",json);

    }
        });
    }
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    [[Hotline sharedInstance] updateDeviceToken:deviceToken];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    dataclass *obj = [dataclass getInstance];
    //One Signal
    [OneSignal initWithLaunchOptions:launchOptions appId:@"2898b157-f468-44ae-8756-fde887ac95ea" handleNotificationReceived:^(OSNotification *notification) {
        NSLog(@"Received Notification - %@", notification.payload.title);
    } handleNotificationAction:^(OSNotificationOpenedResult *result) {
        
        // This block gets called when the user reacts to a notification received
        OSNotificationPayload* payload = result.notification.payload;
        
        NSString* messageTitle = @"OneSignal Example";
        NSString* fullMessage = [payload.body copy];
        
     /*   if (payload.additionalData) {
            
            if(payload.title)
                messageTitle = payload.title;
            
            NSDictionary* additionalData = payload.additionalData;
            
            if (additionalData[@"actionSelected"])
                fullMessage = [fullMessage stringByAppendingString:[NSString stringWithFormat:@"\nPressed ButtonId:%@", additionalData[@"actionSelected"]]];
        }
        
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:messageTitle
                                                            message:fullMessage
                                                           delegate:self
                                                  cancelButtonTitle:@"Close22"
                                                  otherButtonTitles:nil, nil];
        [alertView show]; */
        
    } settings:@{kOSSettingsKeyInFocusDisplayOption : @(OSNotificationDisplayTypeNotification), kOSSettingsKeyAutoPrompt : @YES}];

    [OneSignal IdsAvailable:^(NSString *userId, NSString *pushToken) {
        NSLog(@"user ID : %@",userId);
        obj.gcmToken = userId;
        NSLog(@"Push Token : %@",pushToken);
    }];
    
    [[AppDelegate sharedInstance] startUpdatingLocation];
    
    //Amplitude
    [[Amplitude instance] initializeApiKey:@"78d9e06ace591d133cb55bc87a52721c"];
    
    //Hotline
    /* Initialize Hotline*/
    HotlineConfig *config = [[HotlineConfig alloc]initWithAppID:@"e3f8b80a-b615-4667-a77d-fa32938685cb"  andAppKey:@"20cc3da2-7cf3-4de1-8acc-9da9c93b6acf"];
    [[Hotline sharedInstance] initWithConfig:config];
    /* Enable remote notifications */
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")){
        UIUserNotificationSettings *settings =
        [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        
    }
    else{
        
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    }
    [self.window makeKeyAndVisible]; // or similar code to set a visible view
    /*  Set your view before the following snippet executes */
    /* Handle remote notifications */
    if ([[Hotline sharedInstance]isHotlineNotification:launchOptions]) {
        [[Hotline sharedInstance]handleRemoteNotification:launchOptions
                                              andAppstate:application.applicationState];
    }
    /* Reset badge app count if so desired */
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    //config.displayFAQsAsGrid = YES; // set to NO for List View
    config.voiceMessagingEnabled = YES; // set NO to disable voice messaging
    config.pictureMessagingEnabled = YES; // set NO to disable picture messaging (pictures from gallery/new images from camera)
    config.cameraCaptureEnabled = YES; // set to NO for only pictures from the gallery (turn off the camera capture option)
    config.agentAvatarEnabled = YES; // set to NO to turn of showing an avatar for agents. to customize the avatar shown, use the theme file
    config.showNotificationBanner = NO; // set to NO if you don't want to show the in-app notification banner upon receiving a new message while the app is open
    
    //Fabric
    [Fabric with:@[[Crashlytics class]]];
    [GIDSignIn sharedInstance].delegate = self;
    [GMSServices provideAPIKey:@"AIzaSyBuc0DWd_Ebovu_mO-YJJP6A8DRf-Vl3cg"];
    [GMSPlacesClient provideAPIKey:@"AIzaSyBuc0DWd_Ebovu_mO-YJJP6A8DRf-Vl3cg"];
    
    self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *viewController;
    if ([[NSUserDefaults standardUserDefaults] stringForKey:@"userID"]) {
            viewController = [storyboard instantiateViewControllerWithIdentifier:@"main"];
            obj.emailTitle = [[NSUserDefaults standardUserDefaults] stringForKey:@"email1"];
        [self getGoogleContacts]; }
    else{ viewController = [storyboard instantiateViewControllerWithIdentifier:@"login"]; }
    self.window.rootViewController = viewController;
    [self.window makeKeyAndVisible];
    return YES;
}

-(void)getGoogleContacts{
    
    NSString *url = [NSString stringWithFormat:@"http://104.131.31.146/api/contacts.php?email=%@",[[NSUserDefaults standardUserDefaults] stringForKey:@"email1"]];
    url = [url stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    NSURL *queryUrl = [NSURL URLWithString:url];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSData *data = [NSData dataWithContentsOfURL: queryUrl];
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
                        [contact setValue:@"needsAction" forKey:@"responseStatus"];
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

// [START receive_apns_token_error]
- (void)application:(UIApplication *)application
didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"Registration for remote notification failed with error: %@", error.localizedDescription);
    // [END receive_apns_token_error]
    NSDictionary *userInfo = @{@"error" :error.localizedDescription};
    [[NSNotificationCenter defaultCenter] postNotificationName:_registrationKey
                                                        object:nil
                                                      userInfo:userInfo];
}


- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))handler {
   // NSLog(@"Notification received: %@", userInfo);
    // This works only if the app started the GCM service
    //[[GCMService sharedInstance] appDidReceiveMessage:userInfo];
    // Handle the received message
    // Invoke the completion handler passing the appropriate UIBackgroundFetchResult value
    // [START_EXCLUDE]
  /*  [[NSNotificationCenter defaultCenter] postNotificationName:_messageKey
                                                        object:nil
                                                      userInfo:userInfo];
    handler(UIBackgroundFetchResultNoData);
    // [END_EXCLUDE]
    if (application.applicationState == UIApplicationStateActive) {
        NSLog(@"app is currently active");
        if ([userInfo[@"message"]  isEqual: @"invite"]) {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"invite"
                                                                object:nil
                                                              userInfo:userInfo];
        }
        else if([userInfo[@"message"]  isEqual: @"etd"]){
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"etd"
                                                                object:nil
                                                              userInfo:userInfo];
        }
        else if([userInfo[@"message"]  isEqual: @"eta"]){
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"eta"
                                                                object:nil
                                                              userInfo:userInfo];
        }
        else if([userInfo[@"message"]  isEqual: @"delay"]){
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"delay"
                                                                object:nil
                                                              userInfo:userInfo];
        }
        else if([userInfo[@"message"]  isEqual: @"eta_response"]){
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"eta_response"
                                                                object:nil
                                                              userInfo:userInfo];
        }
        else if([userInfo[@"message"]  isEqual: @"reminder"]){
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"reminder"
                                                                object:nil
                                                              userInfo:userInfo];
        }
        else if([userInfo[@"message"]  isEqual: @"travel"]){
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"travel"
                                                                object:nil
                                                              userInfo:userInfo];
        }
        else if([userInfo[@"message"]  isEqual: @"travel2"]){
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"travel2"
                                                                object:nil
                                                              userInfo:userInfo];
        }
        else if([userInfo[@"message"]  isEqual: @"travel3"]){
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"travel3"
                                                                object:nil
                                                              userInfo:userInfo];
        }
        else if([userInfo[@"message"]  isEqual: @"travel4"]){
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"travel4"
                                                                object:nil
                                                              userInfo:userInfo];
        }
        else if([userInfo[@"message"]  isEqual: @"notes"]){
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"notes"
                                                                object:nil
                                                              userInfo:userInfo];
        }
    }
    else if (application.applicationState == UIApplicationStateBackground){
        NSLog(@"app is in background");
    }
    else if (application.applicationState == UIApplicationStateInactive){
        NSLog(@"Notification tapped");
        if ([userInfo[@"gcm.notification.message"]  isEqual: @"invite"]) {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"invite"
                                                                object:nil
                                                              userInfo:userInfo];
        }
        else if([userInfo[@"gcm.notification.message"]  isEqual: @"etd"]){
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"etd"
                                                                object:nil
                                                              userInfo:userInfo];
        }
        else if([userInfo[@"gcm.notification.message"]  isEqual: @"eta"]){
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"eta"
                                                                object:nil
                                                              userInfo:userInfo];
        }
        else if([userInfo[@"gcm.notification.message"]  isEqual: @"delay"]){
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"delay"
                                                                object:nil
                                                              userInfo:userInfo];
        }
        else if([userInfo[@"gcm.notification.message"]  isEqual: @"eta_response"]){
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"eta_response"
                                                                object:nil
                                                              userInfo:userInfo];
        }
        else if([userInfo[@"gcm.notification.message"]  isEqual: @"reminder"]){
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"reminder"
                                                                object:nil
                                                              userInfo:userInfo];
        }
        else if([userInfo[@"message"]  isEqual: @"travel"]){
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"travel"
                                                                object:nil
                                                              userInfo:userInfo];
        }
        else if([userInfo[@"message"]  isEqual: @"travel2"]){
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"travel2"
                                                                object:nil
                                                              userInfo:userInfo];
        }
        else if([userInfo[@"message"]  isEqual: @"travel3"]){
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"travel3"
                                                                object:nil
                                                              userInfo:userInfo];
        }
        else if([userInfo[@"message"]  isEqual: @"travel4"]){
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"travel4"
                                                                object:nil
                                                              userInfo:userInfo];
        }
        else if([userInfo[@"message"]  isEqual: @"notes"]){
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"notes"
                                                                object:nil
                                                              userInfo:userInfo];
        }
    }
*/
    
    NSLog(@"Notification received: %@", userInfo);
    if (application.applicationState == UIApplicationStateActive) {
        NSLog(@"app is currently active");
        if ([userInfo[@"custom"][@"a"][@"title"]  isEqual: @"invite"]) {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"invite"
                                                                object:nil
                                                              userInfo:userInfo];
        }
        else if([userInfo[@"custom"][@"a"][@"title"]  isEqual: @"etd"]){
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"etd"
                                                                object:nil
                                                              userInfo:userInfo];
        }
        else if([userInfo[@"custom"][@"a"][@"title"] isEqual: @"eta"]){
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"eta"
                                                                object:nil
                                                              userInfo:userInfo];
        }
        else if([userInfo[@"custom"][@"a"][@"title"]  isEqual: @"delay"]){
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"delay"
                                                                object:nil
                                                              userInfo:userInfo];
        }
        else if([userInfo[@"custom"][@"a"][@"title"]  isEqual: @"eta_response"]){
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"eta_response"
                                                                object:nil
                                                              userInfo:userInfo];
        }
        else if([userInfo[@"custom"][@"a"][@"title"]  isEqual: @"reminder"]){
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"reminderScreen"
                                                                object:nil
                                                              userInfo:userInfo];
        }
        else if([userInfo[@"custom"][@"a"][@"title"]  isEqual: @"travel"]){
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"travel"
                                                                object:nil
                                                              userInfo:userInfo];
        }
        else if([userInfo[@"custom"][@"a"][@"title"]  isEqual: @"travel2"]){
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"travel2"
                                                                object:nil
                                                              userInfo:userInfo];
        }
        else if([userInfo[@"custom"][@"a"][@"title"]  isEqual: @"travel3"]){
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"travel3"
                                                                object:nil
                                                              userInfo:userInfo];
        }
        else if([userInfo[@"custom"][@"a"][@"title"]  isEqual: @"travel4"]){
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"travel4"
                                                                object:nil
                                                              userInfo:userInfo];
        }
        else if([userInfo[@"custom"][@"a"][@"title"]  isEqual: @"travel3_invitees"]){
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"travel3_invitees"
                                                                object:nil
                                                              userInfo:userInfo];
        }
        else if([userInfo[@"custom"][@"a"][@"title"]  isEqual: @"travel4_invitees"]){
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"travel4_invitees"
                                                                object:nil
                                                              userInfo:userInfo];
        }
        else if([userInfo[@"custom"][@"a"][@"title"]  isEqual: @"notes"]){
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"notes"
                                                                object:nil
                                                              userInfo:userInfo];
        }
    }
    else if (application.applicationState == UIApplicationStateInactive) {
        
        NSLog(@"app is currently active");
        if ([userInfo[@"custom"][@"a"][@"title"]  isEqual: @"invite"]) {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"invite"
                                                                object:nil
                                                              userInfo:userInfo];
        }
        else if([userInfo[@"custom"][@"a"][@"title"]  isEqual: @"etd"]){
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"etd"
                                                                object:nil
                                                              userInfo:userInfo];
        }
        else if([userInfo[@"custom"][@"a"][@"title"] isEqual: @"eta"]){
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"eta"
                                                                object:nil
                                                              userInfo:userInfo];
        }
        else if([userInfo[@"custom"][@"a"][@"title"]  isEqual: @"delay"]){
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"delay"
                                                                object:nil
                                                              userInfo:userInfo];
        }
        else if([userInfo[@"custom"][@"a"][@"title"]  isEqual: @"eta_response"]){
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"eta_response"
                                                                object:nil
                                                              userInfo:userInfo];
        }
        else if([userInfo[@"custom"][@"a"][@"title"]  isEqual: @"reminder"]){
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"reminderScreen"
                                                                object:nil
                                                              userInfo:userInfo];
        }
        else if([userInfo[@"custom"][@"a"][@"title"]  isEqual: @"travel"]){
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"travel"
                                                                object:nil
                                                              userInfo:userInfo];
        }
        else if([userInfo[@"custom"][@"a"][@"title"]  isEqual: @"travel2"]){
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"travel2"
                                                                object:nil
                                                              userInfo:userInfo];
        }
        else if([userInfo[@"custom"][@"a"][@"title"]  isEqual: @"travel3"]){
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"travel3"
                                                                object:nil
                                                              userInfo:userInfo];
        }
        else if([userInfo[@"custom"][@"a"][@"title"]  isEqual: @"travel4"]){
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"travel4"
                                                                object:nil
                                                              userInfo:userInfo];
        }
        else if([userInfo[@"custom"][@"a"][@"title"]  isEqual: @"travel3_invitees"]){
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"travel3_invitees"
                                                                object:nil
                                                              userInfo:userInfo];
        }
        else if([userInfo[@"custom"][@"a"][@"title"]  isEqual: @"travel4_invitees"]){
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"travel4_invitees"
                                                                object:nil
                                                              userInfo:userInfo];
        }
        else if([userInfo[@"custom"][@"a"][@"title"]  isEqual: @"notes"]){
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"notes"
                                                                object:nil
                                                              userInfo:userInfo];
        }
    }
    else if (application.applicationState == UIApplicationStateBackground) {
        
        NSLog(@"app is currently active");
        if ([userInfo[@"custom"][@"a"][@"title"]  isEqual: @"invite"]) {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"invite"
                                                                object:nil
                                                              userInfo:userInfo];
        }
        else if([userInfo[@"custom"][@"a"][@"title"]  isEqual: @"etd"]){
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"etd"
                                                                object:nil
                                                              userInfo:userInfo];
        }
        else if([userInfo[@"custom"][@"a"][@"title"] isEqual: @"eta"]){
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"eta"
                                                                object:nil
                                                              userInfo:userInfo];
        }
        else if([userInfo[@"custom"][@"a"][@"title"]  isEqual: @"delay"]){
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"delay"
                                                                object:nil
                                                              userInfo:userInfo];
        }
        else if([userInfo[@"custom"][@"a"][@"title"]  isEqual: @"eta_response"]){
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"eta_response"
                                                                object:nil
                                                              userInfo:userInfo];
        }
        else if([userInfo[@"custom"][@"a"][@"title"]  isEqual: @"reminder"]){
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"reminderScreen"
                                                                object:nil
                                                              userInfo:userInfo];
        }
        else if([userInfo[@"custom"][@"a"][@"title"]  isEqual: @"travel"]){
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"travel"
                                                                object:nil
                                                              userInfo:userInfo];
        }
        else if([userInfo[@"custom"][@"a"][@"title"]  isEqual: @"travel2"]){
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"travel2"
                                                                object:nil
                                                              userInfo:userInfo];
        }
        else if([userInfo[@"custom"][@"a"][@"title"]  isEqual: @"travel3"]){
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"travel3"
                                                                object:nil
                                                              userInfo:userInfo];
        }
        else if([userInfo[@"custom"][@"a"][@"title"]  isEqual: @"travel4"]){
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"travel4"
                                                                object:nil
                                                              userInfo:userInfo];
        }
        else if([userInfo[@"custom"][@"a"][@"title"]  isEqual: @"travel3_invitees"]){
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"travel3_invitees"
                                                                object:nil
                                                              userInfo:userInfo];
        }
        else if([userInfo[@"custom"][@"a"][@"title"]  isEqual: @"travel4_invitees"]){
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"travel4_invitees"
                                                                object:nil
                                                              userInfo:userInfo];
        }
        else if([userInfo[@"custom"][@"a"][@"title"]  isEqual: @"notes"]){
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"notes"
                                                                object:nil
                                                              userInfo:userInfo];
        }
    }


    
}
// [END ack_message_reception]

// [START ios_10_message_handling]
// Receive displayed notifications for iOS 10 devices.
#if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
- (void)userNotificationCenter:(UNUserNotificationCenter *)center
       willPresentNotification:(UNNotification *)notification
         withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    // Print message ID.
    NSDictionary *userInfo = notification.request.content.userInfo;
    // Pring full message.
    NSLog(@"%@", userInfo);
}

// Receive data message on iOS 10 devices.
- (void)applicationReceivedRemoteMessage:(FIRMessagingRemoteMessage *)remoteMessage {
    // Print full message
    NSLog(@"%@", [remoteMessage appData]);
}
#endif
// [END ios_10_message_handling]

- (void)applicationDidBecomeActive:(UIApplication *)application {
}
- (void)applicationDidEnterBackground:(UIApplication *)application {
}
- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)app
            openURL:(NSURL *)url
            options:(NSDictionary *)options {
    return [[GIDSignIn sharedInstance] handleURL:url
                               sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]
                                      annotation:options[UIApplicationOpenURLOptionsAnnotationKey]];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    return [[GIDSignIn sharedInstance] handleURL:url
                               sourceApplication:sourceApplication
                                      annotation:annotation];
}

- (void)signIn:(GIDSignIn *)signIn
didSignInForUser:(GIDGoogleUser *)user
     withError:(NSError *)error {
    // Perform any operations on signed in user here.
    NSString *userId = user.userID;                  // For client-side use only!
    NSString *idToken = user.authentication.idToken; // Safe to send to the server
    NSString *fullName = user.profile.name;
    NSString *givenName = user.profile.givenName;
    NSString *familyName = user.profile.familyName;
    NSString *email = user.profile.email;
    // ...
    NSLog(@"here");
}

- (void)signIn:(GIDSignIn *)signIn
didDisconnectWithUser:(GIDGoogleUser *)user
     withError:(NSError *)error {
    // Perform any operations when the user disconnects from app here.
    // ...
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "goteso.FreJun" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"FreJun" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"FreJun.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end
