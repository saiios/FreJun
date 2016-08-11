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
    
    // TODO(developer) Configure the sign-in button look/feel
    
    [GIDSignIn sharedInstance].uiDelegate = self;
    UIImageView *buttonImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"google-login-button.png"]];
   // buttonImage.image = [UIImage imageNamed:@"google-login-button.png"];
    [self.signInButton addSubview:buttonImage];
    self.signInButton.layer.cornerRadius = 6;
    self.signInButton.clipsToBounds = YES;
    

    
    // Uncomment to automatically sign in the user.
    //[[GIDSignIn sharedInstance] signInSilently];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)didTapSignOut:(id)sender {
    [[GIDSignIn sharedInstance] signOut];
}

@end
