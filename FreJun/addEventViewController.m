//
//  addEventViewController.m
//  FreJun
//
//  Created by GOTESO on 10/08/16.
//  Copyright © 2016 GOTESO. All rights reserved.
//

#import "addEventViewController.h"

@interface addEventViewController ()

@end

@implementation addEventViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.segmentControl.apportionsSegmentWidthsByContent = YES;
    _mapView.delegate=self;
    _mapView.settings.myLocationButton = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancelAddEvent:(id)sender {
    
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromLeft;
    [self.view.window.layer addAnimation:transition forKey:nil];
    [self dismissModalViewControllerAnimated:NO];
    
}

- (IBAction)openGoogleMaps:(id)sender {
    
    UIApplication *app = [UIApplication sharedApplication];
    [app openURL:[NSURL URLWithString: @"http://maps.google.com/maps?q=London"]];
}

@end
