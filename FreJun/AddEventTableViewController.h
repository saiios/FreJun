//
//  AddEventTableViewController.h
//  FreJun
//
//  Created by GOTESO on 21/08/16.
//  Copyright © 2016 GOTESO. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
@import GoogleMaps;
#import <CoreLocation/CoreLocation.h>
#import <GooglePlaces/GooglePlaces.h>

@interface AddEventTableViewController : UITableViewController <UIPickerViewDataSource, UIPickerViewDelegate,GMSMapViewDelegate, CLLocationManagerDelegate,GMSAutocompleteTableDataSourceDelegate,MKMapViewDelegate,UISearchDisplayDelegate>

@property (weak, nonatomic) IBOutlet UISegmentedControl *prioritySegment;

@property (weak, nonatomic) IBOutlet UILabel *startDate;
@property (weak, nonatomic) IBOutlet UILabel *startTime;
@property (weak, nonatomic) IBOutlet UILabel *endDate;
@property (weak, nonatomic) IBOutlet UILabel *endTime;
//GMS
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLLocation* currentLocation;
@property (nonatomic, strong)UISearchBar *searchBar;
@property (nonatomic, strong) UISearchController *searchController;

@property (weak, nonatomic) IBOutlet GMSMapView *mapView;
@property (nonatomic, retain)GMSAutocompleteResultsViewController *resultsViewController;
@property (nonatomic, strong)GMSAutocompleteTableDataSource *tableDataSource;
@property (nonatomic, strong)UISearchController  *searchDisplayController;
@property (nonatomic, strong)GMSPlacesClient *placesClient;

@end
