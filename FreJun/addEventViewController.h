//
//  addEventViewController.h
//  FreJun
//
//  Created by GOTESO on 10/08/16.
//  Copyright © 2016 GOTESO. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
@import GoogleMaps;
#import <CoreLocation/CoreLocation.h>

@interface addEventViewController : UIViewController<GMSMapViewDelegate, CLLocationManagerDelegate,MKMapViewDelegate,UISearchDisplayDelegate>

@property (weak, nonatomic) IBOutlet GMSMapView *mapView;

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl;
@end
