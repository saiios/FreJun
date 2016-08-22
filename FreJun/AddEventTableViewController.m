//
//  AddEventTableViewController.m
//  FreJun
//
//  Created by GOTESO on 21/08/16.
//  Copyright © 2016 GOTESO. All rights reserved.
//

#import "AddEventTableViewController.h"
#import <MapKit/MapKit.h>
@import GoogleMaps;
#import <CoreLocation/CoreLocation.h>
#import <GooglePlaces/GooglePlaces.h>

@interface AddEventTableViewController (){
    UIToolbar *toolBar;
    UIToolbar *toolBar2;
    NSDate *datePicked;
    NSDate *datePicked2;
    NSString *hourPicked;
    NSString *hourPicked2;
    NSString *minutePicked;
    NSString *minutePicked2;
    NSString *dayTimePicked;
    NSString *dayTimePicked2;
    
    BOOL locationChanged;
    GMSMarker *marker;
    BOOL checkTableV;
    MKAnnotationView *aView;
}
@property NSInteger toggle;
@property NSInteger height;
@property NSInteger height2;
@property NSInteger cellIndex;

@property NSArray *hours;
@property NSArray *minutes;
@property NSArray *day;
@property NSMutableArray *dates;
@property (strong, nonatomic) UIPickerView *pickerView;
@property (strong, nonatomic) UIPickerView *pickerView2;
@end

@implementation AddEventTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Picked Values
    datePicked = [NSDate date];
    datePicked2 = [NSDate date];
    hourPicked = @"10";
    hourPicked2 = @"12";
    minutePicked = @"00";
    minutePicked2 = @"00";
    dayTimePicked = @"AM";
    dayTimePicked2 = @"AM";
    
    //Nav Bar
    self.navigationItem.title = @"example@example.com";
    UIBarButtonItem *Add = [[UIBarButtonItem alloc]init];
    [Add setTitle:@"Add"];
    self.navigationItem.rightBarButtonItem = Add;
    
    //Segment Control
    self.prioritySegment.apportionsSegmentWidthsByContent = YES;
    
    //Picker View
    self.height = 44;
    self.height2 = 44;
    self.toggle = 0;
    self.pickerView = [[UIPickerView alloc] initWithFrame:(CGRect){{0, 44}, self.tableView.frame.size.width, 215}];
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 44, self.view.frame.size.width, 44)];
    toolBar.barStyle = UIBarStyleDefault;
    toolBar.translucent = true;
    toolBar.tintColor = [UIColor colorWithRed:76/255 green:217/255 blue:100/255 alpha:1];

    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(done)];
    UIBarButtonItem *spaceButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
    [toolBar setItems:@[cancelButton,spaceButton,doneButton]];
    toolBar.userInteractionEnabled = true;
    
    self.pickerView2 = [[UIPickerView alloc] initWithFrame:(CGRect){{0, 44}, self.tableView.frame.size.width, 215}];

    self.pickerView2.delegate = self;
    self.pickerView2.dataSource = self;
    toolBar2 = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 44, self.view.frame.size.width, 44)];
    toolBar2.barStyle = UIBarStyleDefault;
    toolBar2.translucent = true;
    toolBar2.tintColor = [UIColor colorWithRed:76/255 green:217/255 blue:100/255 alpha:1];
    UIBarButtonItem *doneButton2 = [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(done2)];
    UIBarButtonItem *spaceButton2 = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *cancelButton2 = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
    [toolBar2 setItems:@[cancelButton2,spaceButton2,doneButton2]];
    toolBar2.userInteractionEnabled = true;
    //Picker View Arrays
    self.hours = [[NSArray alloc]initWithObjects:@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12", nil];
    self.minutes = [[NSArray alloc]initWithObjects:@"00",@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23",@"24",@"25",@"26",@"27",@"28",@"29",@"30",@"31",@"32",@"33",@"34",@"35",@"36",@"37",@"38",@"39",@"40",@"41",@"42",@"43",@"44",@"45",@"46",@"47",@"48",@"49",@"50",@"51",@"52",@"53",@"54",@"55",@"56",@"57",@"58",@"59", nil];
    self.day = [[NSArray alloc]initWithObjects:@"AM",@"PM", nil];
    self.dates = [[NSMutableArray alloc]init];
    NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
    for (int i = 0; i<365; i++) {
        
        dayComponent.day = i;
        NSCalendar *theCalendar = [NSCalendar currentCalendar];
        NSDate *nextDate = [theCalendar dateByAddingComponents:dayComponent toDate:[NSDate date] options:0];
        [self.dates addObject:nextDate];
    }
    //Initial Dates
    NSDate *tomorrow = [NSDate dateWithTimeInterval:(24*60*60) sinceDate:[NSDate date]];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    _startDate.text = [dateFormatter stringFromDate:tomorrow];
    _endDate.text = [dateFormatter stringFromDate:tomorrow];
    
    //tableview
    self.tableView.contentInset = UIEdgeInsetsMake(40, 0, 0, 0);
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    self.view.backgroundColor = [UIColor colorWithRed:243.0/255.0 green:243.0/255.0 blue:243.0/255.0 alpha:1];
    
    //MAp
    locationChanged = NO;
    _mapView.settings.myLocationButton = YES;
    _mapView.delegate=self;
    _locationManager.delegate=self;
    [self autoCompleteSetup];
    [self showCurrentLocation];
    checkTableV=NO;
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(15, 0, 146, 43)];
}

- (void) viewDidAppear:(BOOL)animated {
    [self.pickerView reloadAllComponents];
    [self.pickerView selectRow:9 inComponent:1 animated:YES];
    [self.pickerView2 reloadAllComponents];
    [self.pickerView2 selectRow:9 inComponent:1 animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Incomplete implementation, return the number of sections
//    return 0;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows
//    return 0;
//}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row == 2) {
    [cell addSubview:self.pickerView];
    [cell addSubview:toolBar];
    }
    if (indexPath.row == 3) {
        [cell addSubview:self.pickerView2];
        [cell addSubview:toolBar2];
    }
    if (indexPath.section == 1) {
        [cell.contentView addSubview:_searchBar];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 2){
    if(self.height == 259) {
        self.height = 44;
        self.height2 = 44;
    }
    else {
        self.height = 259;
        self.height2 = 44;
    }}
    if (indexPath.row == 3){
        if(self.height2 == 259) {
            self.height = 44;
            self.height2 = 44;
        }
        else {
            self.height2 = 259;
            self.height = 44;
        }}
    
    [tableView beginUpdates];
    [tableView endUpdates];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.row == 2)
    { return self.height;
        }
    else if(indexPath.row == 3)
    { return self.height2;
    }
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)cancel{
    
    _height = 44;
    _height2 = 44;
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
}

-(void)done{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    _startDate.text = [dateFormatter stringFromDate:datePicked];
    NSString *timeSuffix;
    if ([dayTimePicked  isEqual: @"AM"]) {
        timeSuffix = @"a.m.";
    }
    else if ([dayTimePicked  isEqual: @"PM"]){
        timeSuffix = @"p.m.";
    }
    _startTime.text = [NSString stringWithFormat:@"%@:%@ %@",hourPicked,minutePicked,timeSuffix];
    _height = 44;
    _height2 = 44;
    [self.tableView beginUpdates];
    [self.tableView endUpdates];

}
-(void)done2{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    _endDate.text = [dateFormatter stringFromDate:datePicked2];
    NSString *timeSuffix;
    if ([dayTimePicked2 isEqual: @"AM"]) {
        timeSuffix = @"a.m.";
    }
    else if ([dayTimePicked2  isEqual: @"PM"]){
        timeSuffix = @"p.m.";
    }
    _endTime.text = [NSString stringWithFormat:@"%@:%@ %@",hourPicked2,minutePicked2,timeSuffix];
    _height = 44;
    _height2 = 44;
    [self.tableView beginUpdates];
    [self.tableView endUpdates];

}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (pickerView == _pickerView) {
        if (component == 0) {
            datePicked = _dates[row];
        }
        if (component == 1) {
            hourPicked = _hours[row];
        }
        if (component == 2) {
            minutePicked = _minutes[row];
        }
        if (component == 3) {
            dayTimePicked = _day[row];
        }
    }
    if (pickerView == _pickerView2) {
        if (component == 0) {
            datePicked2 = _dates[row];
        }
        if (component == 1) {
            hourPicked2 = _hours[row];
        }
        if (component == 2) {
            minutePicked2 = _minutes[row];
        }
        if (component == 3) {
            dayTimePicked2 = _day[row];
        }
    }
}

- (NSString*) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == 0) {
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"EEE MMM d"];
        if (row == 0) {
            return @"Today";
        }
        return [dateFormatter stringFromDate:self.dates[row]];
    }
    else if (component == 1) {
        return self.hours[row];
    }
    else if (component == 2) {
        return self.minutes[row];
    }
    else {
        return self.day[row];
    }

}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* tView = (UILabel*)view;
    if (!tView){
        tView = [[UILabel alloc] init];
        tView.font = [UIFont systemFontOfSize:19];
        tView.textAlignment = NSTextAlignmentRight;
    }
    
    if (component == 0) {
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"EEE MMM d"];
        if (row == 0) {
            tView.text =  @"Today";
        }
        tView.text = [dateFormatter stringFromDate:self.dates[row]];
    }
    else if (component == 1) {
        tView.text = self.hours[row];
    }
    else if (component == 2) {
        tView.text = self.minutes[row];
    }
    else {
        tView.text = self.day[row];
    }

    
    return tView;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 4;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0) {
        return self.dates.count;
    }
    else if (component == 1) {
        return self.hours.count;
    }
    else if (component == 2) {
        return self.minutes.count;
    }
    else {
        return self.day.count;
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    if (component == 0) {
        return 130;
    }
    else if (component == 1) {
        return 40;
    }
    else if (component == 2) {
        return 40;
    }
    else {
        return 35;
    }
}

//GMS Setup
- (void)showCurrentLocation {
  
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:-33.86
                                                            longitude:151.20
                                                                 zoom:14.0];
    
    _mapView.myLocationEnabled = YES;
    _mapView.settings.myLocationButton = YES;
    // Creates a marker in the center of the map.
    marker = [[GMSMarker alloc]init];
    marker.map = _mapView;
    marker.groundAnchor = CGPointMake(0.5, 0.5);
    UIImage *markerIcon = [UIImage imageNamed:@"location"];
    marker.icon = markerIcon;

//    self.locationManager = [[CLLocationManager alloc] init];
//    // Set a delegate to receive location callbacks
//    self.locationManager.delegate = self;
//    // Start the location manager
//    [self.locationManager startUpdatingLocation];
//    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied ||
        [CLLocationManager authorizationStatus] == kCLAuthorizationStatusRestricted) {
            } else {
           
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    [self.locationManager startUpdatingLocation];
}
}

// Wait for location callbacks
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    
    if (locationChanged==NO) {
        locationChanged=YES;
        
        GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:newLocation.coordinate.latitude
                                                                longitude:newLocation.coordinate.longitude
                                                                     zoom:14.0];
        NSLog(@"location chnged");
        
        [_mapView animateToCameraPosition:camera];
    }
    else if (locationChanged==YES){
        
        
    }
    
    
}

-(void)autoCompleteSetup{
    
//    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 85, self.view.frame.size.width, 50)];
    
    // Configure your images
    UIImage *backgroundImage = [UIImage imageNamed:@"white.png"];
    UIImage *searchFieldImage = [[UIImage imageNamed:@"white.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5)];
    // Set it to your UISearchBar appearance
    [[UISearchBar appearance] setBackgroundImage:backgroundImage];
    [[UISearchBar appearance] setSearchFieldBackgroundImage:searchFieldImage forState:UIControlStateNormal];
    
   // _searchBar.layer.borderColor = [UIColor lightGrayColor].CGColor;
   // _searchBar.layer.borderWidth = 1.0;
    _tableDataSource = [[GMSAutocompleteTableDataSource alloc] init];
    _tableDataSource.delegate = self;
//    _searchDisplayController = [[UISearchController alloc] initWithSearchBar:_searchBar contentsController:self];
//    _searchDisplayController.searchResultsDataSource = _tableDataSource;
//    _searchDisplayController.searchResultsDelegate = _tableDataSource;
//    _searchDisplayController.delegate = self;
//    _searchBar.placeholder=@"Type Address Here...";
    //[self.view addSubview:_searchBar];
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller
shouldReloadTableForSearchString:(NSString *)searchString
{
    [_tableDataSource sourceTextHasChanged:searchString];
    return NO;
}

// Handle the user's selection.
- (void)tableDataSource:(GMSAutocompleteTableDataSource *)tableDataSource
didAutocompleteWithPlace:(GMSPlace *)place {
    //[_searchDisplayController setActive:NO animated:YES];
    // Do something with the selected place.
    NSLog(@"Place name %@", place.name);
    NSLog(@"Place address %@", place.formattedAddress);
    NSLog(@"Place attributions %@", place.attributions.string);
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:place.coordinate.latitude
                                                            longitude:place.coordinate.longitude
                                                                 zoom:15.0];
    _searchBar.placeholder=place.name;
    [_mapView animateToCameraPosition:camera];
    
    marker.position = CLLocationCoordinate2DMake(place.coordinate.latitude, place.coordinate.longitude);
    marker.title = place.name;
    marker.snippet = place.formattedAddress;
    
    [self.locationManager startUpdatingLocation];
    
    
}

- (void)tableDataSource:(GMSAutocompleteTableDataSource *)tableDataSource
didFailAutocompleteWithError:(NSError *)error {
    //[_searchDisplayController setActive:NO animated:YES];
    // TODO: handle the error.
    NSLog(@"Error: %@", [error description]);
}

- (void)didUpdateAutocompletePredictionsForTableDataSource:
(GMSAutocompleteTableDataSource *)tableDataSource {
    // Turn the network activity indicator off.
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    // Reload table data.
    //[_searchDisplayController.searchResultsTableView reloadData];
}

- (void)didRequestAutocompletePredictionsForTableDataSource:
(GMSAutocompleteTableDataSource *)tableDataSource {
    // Turn the network activity indicator on.
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    // Reload table data.
    //[_searchDisplayController.searchResultsTableView reloadData];
}

-(void)mapView:(GMSMapView *)mapViewW didChangeCameraPosition:(GMSCameraPosition *)position{
    NSLog(@"Did scroll");
    
    
    //    [UIView animateWithDuration:0.5
    //                          delay:0.0
    //                        options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionTransitionNone
    //                     animations:^{
    //                         [_navView setFrame:CGRectMake(0, 0, self.view.frame.size.width, 0)];
    //                         [_searchBar setFrame:CGRectMake(0, 15, self.view.frame.size.width, 50)];
    //                         [ _mapView setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) ];
    //                         [self.cancelBookingButton setFrame:CGRectMake(15, self.view.frame.size.height,  self.view.frame.size.width-30, 50)];
    //                         [self.processingView setFrame:CGRectMake(15, self.view.frame.size.height,  self.view.frame.size.width-30, 50)];
    //                         [_bookCarButton setFrame:CGRectMake(15, self.view.frame.size.height,  self.view.frame.size.width-30, 50)];
    //
    //                     }
    //                     completion:nil];
    
}
- (void)mapView:(GMSMapView *)mapView idleAtCameraPosition:(GMSCameraPosition *)position;
{
    NSLog(@"Did ");
    
    
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionTransitionNone
                     animations:^{
                         
                         
                         // [_searchBar setFrame:CGRectMake(0, 90, self.view.frame.size.width, 50)];
                         //  [_navView setFrame:CGRectMake(0, 0, self.view.frame.size.width, 71)];
                         //  [ _mapView setFrame:CGRectMake(0, 71, self.view.frame.size.width, self.view.frame.size.height) ];
                         // [self.bookCarButton setFrame:CGRectMake(15, self.view.frame.size.height-100, self.view.frame.size.width-30, 50)];
                         // [self.cancelBookingButton setFrame:CGRectMake(15, self.view.frame.size.height-100, self.view.frame.size.width-30, 50)];
                         // [self.processingView setFrame:CGRectMake(15, self.view.frame.size.height-100, self.view.frame.size.width-30, 50)];
                     }
                     completion:nil];
}


- (MKAnnotationView *)mapView:(MKMapView *)sender viewForAnnotation:(id < MKAnnotation >)annotation
{
    static NSString *reuseId = @"StandardPin";
    
    aView = (MKAnnotationView *)[sender dequeueReusableAnnotationViewWithIdentifier:reuseId];
    NSLog(@"mkanno");
    if (aView == nil)
    {
        
        aView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseId];
        aView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        aView.canShowCallout = YES;
    }
    aView.image = [UIImage imageNamed : @"location"];
    aView.annotation = annotation;
    aView.calloutOffset = CGPointMake(0, -5);
    aView.draggable = YES;
    aView.enabled = YES;
    return aView;
}

- (IBAction)openGoogleMaps:(id)sender {
    
    UIApplication *app = [UIApplication sharedApplication];
    [app openURL:[NSURL URLWithString: @"http://maps.google.com/maps?q=London"]];
}

@end
