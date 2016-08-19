//
//  ViewController.m
//  FreJun
//
//  Created by GOTESO on 09/08/16.
//  Copyright © 2016 GOTESO. All rights reserved.
//

#import "ViewController.h"
#import <Google/SignIn.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    

    [GIDSignIn sharedInstance].uiDelegate = self;
    [GIDSignIn sharedInstance].delegate = self;
    
    // Uncomment to automatically sign in the user.
    [[GIDSignIn sharedInstance] signInSilently];
}

-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    if ([[NSUserDefaults standardUserDefaults] stringForKey:@"email"]) {
       // [self jumpScreen];
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
    NSString *userId = user.userID;                  // For client-side use only!
    NSString *idToken = user.authentication.idToken; // Safe to send to the server
    NSString *fullName = user.profile.name;
    NSString *givenName = user.profile.givenName;
    NSString *familyName = user.profile.familyName;
    NSString *email = user.profile.email;
    
    
    NSLog(@"{userId : %@},{idToken : %@},{fullName : %@},{givenName : %@},{familyName : %@},{email : %@}",userId,idToken,fullName,givenName,familyName,email);
    NSLog(@"Logged In");
    [[NSUserDefaults standardUserDefaults] setObject:user.profile.email forKey:@"email"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self jumpScreen];
}

- (void)jumpScreen {
    
    NSString * storyboardName = @"Main";
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
    UIViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"main"];
    [self presentViewController:vc animated:NO completion:nil];
    
}


@end
