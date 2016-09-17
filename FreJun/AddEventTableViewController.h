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
#import "MVPlaceSearchTextField/MVPlaceSearchTextField.h"
#import "MPGTextField.h"

@interface AddEventTableViewController : UITableViewController <UIPickerViewDataSource, UIPickerViewDelegate,GMSMapViewDelegate, CLLocationManagerDelegate,GMSAutocompleteTableDataSourceDelegate,MKMapViewDelegate,UISearchDisplayDelegate,UITextViewDelegate,PlaceSearchTextFieldDelegate,UICollectionViewDelegate,UICollectionViewDataSource,MPGTextFieldDelegate,UITextFieldDelegate>

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

@property (weak, nonatomic) IBOutlet UITextView *notes;
@property (weak, nonatomic) IBOutlet UILabel *notesLAbel;

@property (weak, nonatomic) IBOutlet MVPlaceSearchTextField *address1;
@property (weak, nonatomic) IBOutlet UICollectionView *list1;
@property (weak, nonatomic) IBOutlet UICollectionView *list2;
@property (weak, nonatomic) IBOutlet UICollectionView *list3;


@property (weak, nonatomic) IBOutlet MPGTextField *invitee;
@property (weak, nonatomic) IBOutlet UITextField *eventName;
@property (weak, nonatomic) IBOutlet UISwitch *eventSwitch;
@property (weak, nonatomic) IBOutlet UITextField *address2;
@property (weak, nonatomic) IBOutlet UITextField *zipcode;
@property (weak, nonatomic) IBOutlet UITextField *country;
@property (weak, nonatomic) IBOutlet UITextField *etd;
@property (weak, nonatomic) IBOutlet UITextField *eta;

@property (weak, nonatomic) IBOutlet UILabel *ETDRemindLabel;
@property (weak, nonatomic) IBOutlet UILabel *EventRemindLabel;
@property (weak, nonatomic) IBOutlet UIButton *timeButton;
@property (weak, nonatomic) IBOutlet UIButton *RemindDayLabel;

@end
