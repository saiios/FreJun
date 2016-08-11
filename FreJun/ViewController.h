//
//  ViewController.h
//  FreJun
//
//  Created by GOTESO on 09/08/16.
//  Copyright © 2016 GOTESO. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Google/SignIn.h>

@interface ViewController : UIViewController<GIDSignInUIDelegate,GIDSignInDelegate>

- (IBAction)signInButtonPressed:(id)sender;

@end

