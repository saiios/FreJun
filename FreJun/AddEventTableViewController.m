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
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import <Contacts/Contacts.h>
#import "ContactList.h"
#import "MPGTextField.h"
#import "ZFTokenField.h"

@interface AddEventTableViewController ()<ZFTokenFieldDataSource, ZFTokenFieldDelegate>{
    UIToolbar *toolBar;
    UIToolbar *toolBar2;
    UIToolbar *toolBar3;
    NSDate *datePicked;
    NSDate *datePicked2;
    NSString *hourPicked;
    NSString *hourPicked2;
    NSString *hourPicked3;
    NSString *minutePicked;
    NSString *minutePicked2;
    NSString *minutePicked3;
    NSString *dayTimePicked;
    NSString *dayTimePicked2;
    NSString *dayTimePicked3;
    
    BOOL locationChanged;
    GMSMarker *marker;
    BOOL checkTableV;
    MKAnnotationView *aView;
    
    NSInteger tabIndex;
    NSInteger tHeight1;
    NSInteger tHeight2;
    NSInteger tHeight3;
    NSInteger tHeight4;
    
    UITableView *table1;
    UITableView *table2;
    UITableView *table3;
    NSArray *table1List;
    NSArray *table2List;
    NSArray *table3List;
    NSArray *remindMinutes;
    
    NSMutableArray *suggestionData;
    
    //Final Data
    NSString *userID;
    NSString *email;
    NSString *eventName;
    NSString *allDay;
    NSString *startTime;
    NSString *endTime;
    NSString *priority;
    NSString *address1;
    NSString *address2;
    NSString *zipCode;
    NSString *country;
    NSString *longitude;
    NSString *lattitude;
    NSString *ETDRemind;
    NSString *eventRemind;
    NSString *repeat;
    NSString *repeatTime;
    NSString *notes;
    NSArray *invitees;
}

@property (weak, nonatomic) IBOutlet ZFTokenField *tokenField;
@property (nonatomic, strong) NSMutableArray *tokens;
@property (nonatomic, strong) NSMutableArray *invitees;

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
@property (strong, nonatomic) UIPickerView *pickerView3;
@end

@implementation AddEventTableViewController

-(id)initWithStyle:(UITableViewStyle)style{
    
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    UITableView *tableView = [[UITableView alloc]initWithFrame:self.tableView.frame style:UITableViewStyleGrouped];
    self.tableView = tableView;
    self.notes.delegate = self;
    _address1.placeSearchDelegate                 = self;
   // _address1.strApiKey                           = @"AIzaSyAHd5Mbt6L9VZSQGZ1wt0XuFh9g7rQcSF8";
   // _address1.superViewOfList                     = self.view;  // View, on which Autocompletion list should be appeared.
   // _address1.autoCompleteShouldHideOnSelection   = YES;
   // _address1.maximumNumberOfAutoCompleteRows     = 5;
    [self initTableViews];
    [self addressBook];
    [self tokenView];
    [self.invitee setDelegate:self];
    tabIndex = 1;
    tHeight1 = 44;
    tHeight2 = 44;
    tHeight3 = 0;
    tHeight4 = 0;
    //Picked Values
    datePicked = [NSDate date];
    datePicked2 = [NSDate date];
    hourPicked = @"10";
    hourPicked2 = @"12";
    hourPicked3 = @"12";
    minutePicked = @"00";
    minutePicked2 = @"00";
    minutePicked3 = @"00";
    dayTimePicked = @"AM";
    dayTimePicked2 = @"AM";
    dayTimePicked3 = @"AM";
    
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
    
    self.pickerView3 = [[UIPickerView alloc] initWithFrame:(CGRect){{0, 44}, self.tableView.frame.size.width, 318}];
    self.pickerView3.delegate = self;
    self.pickerView3.dataSource = self;
    toolBar3 = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 44, self.view.frame.size.width, 44)];
    toolBar3.barStyle = UIBarStyleDefault;
    toolBar3.translucent = true;
    toolBar3.tintColor = [UIColor colorWithRed:76/255 green:217/255 blue:100/255 alpha:1];
    UIBarButtonItem *doneButton3 = [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(done3)];
    UIBarButtonItem *spaceButton3 = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *cancelButton3 = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancel3)];
    [toolBar3 setItems:@[cancelButton3,spaceButton3,doneButton3]];
    toolBar3.userInteractionEnabled = true;
    _pickerView3.hidden = YES;
    toolBar3.hidden = YES;
    
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
    //self.tableView.contentInset = UIEdgeInsetsMake(40, 0, 0, 0);
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
    marker = [[GMSMarker alloc]init];
    marker.map = _mapView;
    marker.groundAnchor = CGPointMake(0.5, 0.5);
    UIImage *markerIcon = [UIImage imageNamed:@"location"];
    marker.icon = markerIcon;

}

-(void)addressBook{
    
    [[ContactList sharedContacts] fetchAllContacts]; //fetch all contacts by calling single to method
    
    if ([[ContactList sharedContacts]totalPhoneNumberArray].count !=0) {
        NSLog(@"Fetched Contact Details : %@",[[ContactList sharedContacts]totalPhoneNumberArray]);
    }
    
    suggestionData = [[NSMutableArray alloc]init];
    for (int i = 0; i<[[[ContactList sharedContacts]totalPhoneNumberArray] count]; i++) {
        NSString *subText;
        if (![[[[[ContactList sharedContacts]totalPhoneNumberArray] objectAtIndex:i] objectForKey:@"number"]  isEqual: @""]) {
            subText = [[[[ContactList sharedContacts]totalPhoneNumberArray] objectAtIndex:i] objectForKey:@"number"];
        }
        else{
            subText = [[[[ContactList sharedContacts]totalPhoneNumberArray] objectAtIndex:i] objectForKey:@"email"];
        }
        [suggestionData addObject:[NSDictionary dictionaryWithObjectsAndKeys:[[[[ContactList sharedContacts]totalPhoneNumberArray] objectAtIndex:i] objectForKey:@"name"], @"DisplayText", subText, @"DisplaySubText",            [[[ContactList sharedContacts]totalPhoneNumberArray] objectAtIndex:i],@"CustomObject", nil]];
    }
}

-(void)tokenView{
    
    self.tokens = [NSMutableArray array];
    
    self.tokenField.dataSource = self;
    self.tokenField.delegate = self;
    //self.tokenField.textField.placeholder = @"Enter here";
    //[self.tokenField reloadData];
    
    //[self.tokenField.textField becomeFirstResponder];
}

-(void)initTableViews{
    
    table1 = [[UITableView alloc]initWithFrame:CGRectMake(0, 44, self.view.frame.size.width, 44*5)];
    table1.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    self.list1.delegate = self;
    self.list1.dataSource = self;
    table1List = [[NSArray alloc]initWithObjects:@"On time",@"10 minutes before",@"30 minutes before",@"1 hour before",@"2 hours before", nil];
    table2 = [[UITableView alloc]initWithFrame:CGRectMake(0, 44, self.view.frame.size.width, 44*4)];
    table2.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    self.list2.delegate = self;
    self.list2.dataSource = self;
    table2List = [[NSArray alloc]initWithObjects:@"On time",@"10 minutes before",@"30 minutes before",@"1 hour before", nil];
    table3 = [[UITableView alloc]initWithFrame:CGRectMake(0, 44, self.view.frame.size.width, 44*7)];
    table3.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    self.list3.delegate = self;
    self.list3.dataSource = self;
    table3List = [[NSArray alloc]initWithObjects:@"Never",@"Everyday",@"Weekly",@"Bi-weekly",@"Monthly",@"Quarterly",@"Yearly", nil];
    remindMinutes = [[NSArray alloc]initWithObjects:@"0",@"10",@"30",@"60",@"120", nil];
}


#pragma mark - Place search Textfield Delegates

-(void)placeSearch:(MVPlaceSearchTextField*)textField ResponseForSelectedPlace:(GMSPlace*)responseDict{
    [self.view endEditing:YES];
    NSLog(@"SELECTED ADDRESS :%@",responseDict);
    lattitude = [NSString stringWithFormat:@"%f",responseDict.coordinate.latitude];
    lattitude = [NSString stringWithFormat:@"%f",responseDict.coordinate.longitude];
    
    for (int i=0;i<[[responseDict addressComponents] count];i++) {
        if ([[[[responseDict addressComponents] objectAtIndex:i] valueForKey:@"type"] isEqualToString:@"country"]) {
                self.country.text = [[[responseDict addressComponents]objectAtIndex:i] valueForKey:@"name"];
        }
        if ([[[[responseDict addressComponents] objectAtIndex:i] valueForKey:@"type"] isEqualToString:@"postal_code"]) {
            self.zipcode.text = [[[responseDict addressComponents]objectAtIndex:i] valueForKey:@"name"];
        }
    }
    
    marker.position = CLLocationCoordinate2DMake(responseDict.coordinate.latitude, responseDict.coordinate.longitude);
    marker.title = responseDict.name;
    marker.snippet = responseDict.formattedAddress;
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:responseDict.coordinate.latitude
                                                            longitude:responseDict.coordinate.longitude
                                                                 zoom:14.0];
    NSLog(@"location chnged");
    
    [_mapView animateToCameraPosition:camera];
}
-(void)placeSearchWillShowResult:(MVPlaceSearchTextField*)textField{
    
}
-(void)placeSearchWillHideResult:(MVPlaceSearchTextField*)textField{
    
}
-(void)placeSearch:(MVPlaceSearchTextField*)textField ResultCell:(UITableViewCell*)cell withPlaceObject:(PlaceObject*)placeObject atIndex:(NSInteger)index{
    if(index%2==0){
        cell.contentView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
    }else{
        cell.contentView.backgroundColor = [UIColor whiteColor];
    }
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section == 0) {
    if (indexPath.row == 2) {
    [cell addSubview:self.pickerView];
    [cell addSubview:toolBar];
    }
    if (indexPath.row == 3) {
        [cell addSubview:self.pickerView2];
        [cell addSubview:toolBar2];
    }
    }
    if (indexPath.section == 2) {
        if (indexPath.row == 2) {
            [cell addSubview:_pickerView3];
            [cell addSubview:toolBar3];
        }
    }
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
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
    }
    if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            tHeight1 = 264;
            tHeight2 = 44;
        }
        if (indexPath.row == 1) {
            tHeight2 = 220;
            tHeight1 = 44;
        }
        if (indexPath.row == 2) {
            //tHeight3 = 352;
        }
        if (indexPath.row == 3) {
            tHeight4 = 176;
        }
        
    }
    [tableView beginUpdates];
    [tableView endUpdates];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section == 0) {
    if(indexPath.row == 2)
    { return self.height;
        }
    else if(indexPath.row == 3)
    { return self.height2;
    }
    }
    
    if (indexPath.section == 2) {
        
            if (indexPath.row == 0) {
                return tHeight1;
            }
            if (indexPath.row == 1) {
                return tHeight2;
            }
            if (indexPath.row == 2) {
                return tHeight3;
            }
            if (indexPath.row == 3) {
                return tHeight4;
    }
    }
    
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
    return 40;
    }
    else if (section == 2){
        
        return 50;
    }
    else{
        return 0.0001;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 1) {
        return 0.0001;
    }
    else{
    return 17;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView *sectionView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,50)];
    if (section == 2) {
    UIButton *button1 = [[UIButton alloc]initWithFrame:CGRectMake(50, 12.5, 25, 25)];
    [button1 setBackgroundImage:[UIImage imageNamed:@"tab1"] forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(tab1) forControlEvents:UIControlEventTouchUpInside];
    [sectionView addSubview:button1];
    
    UIButton *button2 = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2 - 12.5, 12.5, 25, 25)];
    [button2 setBackgroundImage:[UIImage imageNamed:@"tab2"] forState:UIControlStateNormal];
    [button2 addTarget:self action:@selector(tab2) forControlEvents:UIControlEventTouchUpInside];
    [sectionView addSubview:button2];
        
    UIButton *button3 = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 75, 12.5, 25, 25)];
    [button3 setBackgroundImage:[UIImage imageNamed:@"tab3"] forState:UIControlStateNormal];
    [button3 addTarget:self action:@selector(tab3) forControlEvents:UIControlEventTouchUpInside];
    [sectionView addSubview:button3];
        
        UIView *triangle;
        if (tabIndex == 1) {
         triangle = [[UIView alloc]initWithFrame:CGRectMake(60, 45, 10, 5)];
        }
        else if (tabIndex == 2) {
            triangle = [[UIView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2 - 5, 45, 10, 5)];
        }
        else if (tabIndex == 3) {
            triangle = [[UIView alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 65, 45, 10, 5)];
        }
        triangle.backgroundColor = [UIColor grayColor];
//        triangle.layer.borderWidth = 0.7;
//        triangle.layer.borderColor = [UIColor lightGrayColor].CGColor;
        // Build a triangular path
        UIBezierPath *path = [UIBezierPath new];
        [path moveToPoint:(CGPoint){0, 5}];
        [path addLineToPoint:(CGPoint){5, 0}];
        [path addLineToPoint:(CGPoint){10, 5}];
        [path addLineToPoint:(CGPoint){0, 5}];
        
        // Create a CAShapeLayer with this triangular path
        // Same size as the original imageView
        CAShapeLayer *mask = [CAShapeLayer new];
        mask.frame = triangle.bounds;
        mask.path = path.CGPath;
        
        // Mask the imageView's layer with this shape
        triangle.layer.mask = mask;
        [sectionView addSubview:triangle];
        
    }
    return  sectionView;
    
    
}

-(void)tab1{
    tabIndex = 1;
    tHeight1 = 44;
    tHeight2 = 44;
    tHeight3 = 0;
    tHeight4 = 0;
    [self.tableView reloadData];
}
-(void)tab2{
    tabIndex = 2;
    tHeight1 = 0;
    tHeight2 = 0;
    tHeight3 = 44;
    tHeight4 = 0;
    [self.tableView reloadData];
}
-(void)tab3{
    tabIndex = 3;
    tHeight1 = 0;
    tHeight2 = 0;
    tHeight3 = 0;
    tHeight4 = 176;
    [self.tableView reloadData];
}
-(void)cancel{
    
    _height = 44;
    _height2 = 44;
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
}
-(void)cancel3{
    
    tHeight3 = 44;
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
    if ([dayTimePicked  isEqual: @"AM"] & [hourPicked  isEqual: @"12"]) {
        
        hourPicked = @"00";
    }
    _startTime.text = [NSString stringWithFormat:@"%@:%@ %@",hourPicked,minutePicked,timeSuffix];
    _height = 44;
    _height2 = 44;
    
    [dateFormatter setDateFormat:@"YYYY-MM-d"];
    NSLog(@"DATE : %@",[dateFormatter stringFromDate:datePicked]);
    NSString *hour;
    hour = hourPicked;
    if ([dayTimePicked  isEqual: @"PM"]) {
        hour = [NSString stringWithFormat:@"%d",[hourPicked intValue]+12];
        if ([hour  isEqual: @"24"]) {
            hour = @"12";
        }
    }

    NSLog(@"Time : %@",[NSString stringWithFormat:@"%@:%@:00",hour,minutePicked]);
    startTime = [NSString stringWithFormat:@"%@ %@",[dateFormatter stringFromDate:datePicked],[NSString stringWithFormat:@"%@:%@:00",hour,minutePicked]];
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
    if ([dayTimePicked2  isEqual: @"AM"] & [hourPicked2  isEqual: @"12"]) {
        
        hourPicked2 = @"00";
    }
    _endTime.text = [NSString stringWithFormat:@"%@:%@ %@",hourPicked2,minutePicked2,timeSuffix];
    _height = 44;
    _height2 = 44;
    
    [dateFormatter setDateFormat:@"YYYY-MM-d"];
    NSLog(@"DATE : %@",[dateFormatter stringFromDate:datePicked2]);
    NSString *hour;
    hour = hourPicked2;
    if ([dayTimePicked2 isEqual: @"PM"]) {
        hour = [NSString stringWithFormat:@"%d",[hourPicked2 intValue]+12];
        if ([hour  isEqual: @"24"]) {
            hour = @"12";
        }
    }

    NSLog(@"Time : %@",[NSString stringWithFormat:@"%@:%@:00",hour,minutePicked2]);
    endTime = [NSString stringWithFormat:@"%@ %@",[dateFormatter stringFromDate:datePicked2],[NSString stringWithFormat:@"%@:%@:00",hour,minutePicked2]];
    [self.tableView beginUpdates];
    [self.tableView endUpdates];

}

-(void)done3{
    
    NSString *timeSuffix;
    if ([dayTimePicked3 isEqual: @"AM"]) {
        timeSuffix = @"a.m.";
    }
    else if ([dayTimePicked3  isEqual: @"PM"]){
        timeSuffix = @"p.m.";
    }
    if ([dayTimePicked3  isEqual: @"AM"] & [hourPicked3  isEqual: @"12"]) {
        
        hourPicked3 = @"00";
    }
    [self.timeButton setTitle:[NSString stringWithFormat:@"at %@:%@ %@",hourPicked3,minutePicked3,timeSuffix] forState:UIControlStateNormal] ;
    tHeight3 = 44;
    
    NSString *hour;
    hour = hourPicked3;
    if ([dayTimePicked3 isEqual: @"PM"]) {
        hour = [NSString stringWithFormat:@"%d",[hourPicked3 intValue]+12];
        if ([hour  isEqual: @"24"]) {
            hour = @"12";
        }
    }
    
    repeatTime = [NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%@:%@:00",hour,minutePicked3]];
    
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
    if (pickerView == _pickerView3) {
        if (component == 0) {
            hourPicked3 = _hours[row];

        }
        if (component == 1) {
            minutePicked3 = _minutes[row];
        }
        if (component == 2) {
             dayTimePicked3 = _day[row];
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
    
    if (pickerView == _pickerView | pickerView == _pickerView2) {
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
    else{
        
        UILabel* tView = (UILabel*)view;
        if (!tView){
            tView = [[UILabel alloc] init];
            tView.font = [UIFont systemFontOfSize:19];
            tView.textAlignment = NSTextAlignmentRight;
        }
        
        if (component == 0) {
            tView.text = self.hours[row];
        }
        else if (component == 1) {
            tView.text = self.minutes[row];
        }
        else {
            tView.text = self.day[row];
        }
        return tView;

    }
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if (pickerView == _pickerView | pickerView == _pickerView2) {
        return 4;
    }
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (pickerView == _pickerView | pickerView == _pickerView2) {
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
    else{
        
        if (component == 0) {
            return self.hours.count;
        }
        else if (component == 1) {
            return self.minutes.count;
        }
        else{
            return self.day.count;
        }
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    
    if (pickerView == _pickerView | pickerView == _pickerView2) {
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
    else{
        
        if (component == 0) {
            return 40;
        }
        else if (component == 1) {
            return 40;
        }
        else {
            return 35;
        }

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

-(void)textViewDidChange:(UITextView *)textView
{
    NSLog(@"fef");
    if (textView == self.notes) {
        self.notesLAbel.hidden = YES;
    }
    if (self.notes.text.length == 0) {
        self.notesLAbel.hidden = NO;
    }
}

//Collection View
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    if (collectionView == self.list1) {
        return table1List.count;
    }
    else if (collectionView == self.list2) {
        return table2List.count;
    }
    else if (collectionView == self.list3) {
        return table3List.count;
    }
    return 1;
    
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (collectionView == self.list1) {
    static NSString *cellIdentifier = @"list1";
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
        cell.backgroundColor = [UIColor whiteColor];
        UILabel *title = (UILabel *)[cell viewWithTag:11];
        title.textColor=[UIColor colorWithRed:28.0/255.0 green:87.0/255.0 blue:255.0/255.0 alpha:1.0];
        title.text = table1List[indexPath.row];
        return cell;
    }
    else if (collectionView == self.list2) {
        static NSString *cellIdentifier = @"list2";
        
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
        cell.backgroundColor = [UIColor whiteColor];
        UILabel *title = (UILabel *)[cell viewWithTag:13];
        title.textColor=[UIColor colorWithRed:28.0/255.0 green:87.0/255.0 blue:255.0/255.0 alpha:1.0];
        title.text = table2List[indexPath.row];
        return cell;
    }

    else if (collectionView == self.list3) {
        static NSString *cellIdentifier = @"list3";
        
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
        cell.backgroundColor = [UIColor whiteColor];
        UILabel *title = (UILabel *)[cell viewWithTag:15];
        title.textColor=[UIColor colorWithRed:28.0/255.0 green:87.0/255.0 blue:255.0/255.0 alpha:1.0];
        title.text = table3List[indexPath.row];
        return cell;
    }

    static NSString *cellIdentifier = @"cvCell";
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    return cell;
}

#pragma mark collection view cell layout / size

-(CGSize)collectionView:(UICollectionView *)collectionView
                 layout:(UICollectionViewLayout *)collectionViewLayout
 sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    return CGSizeMake(self.view.frame.size.width,44);
}


#pragma mark collection view cell paddings
- (UIEdgeInsets)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0); // top, left, bottom, right
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    return 0;
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    
    return 0;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView == _list1) {
        tHeight1 = 44;
        tHeight2 = 44;
    }
    else if (collectionView == _list2) {
        tHeight1 = 44;
        tHeight2 = 44;
    }
    else if (collectionView == _list3) {
        tHeight3 = 44;
    }

    [self.tableView beginUpdates];
    [self.tableView endUpdates];
}

- (IBAction)everyday:(id)sender {
    
    tHeight3 = 352;
    _pickerView3.hidden = YES;
    toolBar3.hidden = YES;
    _list3.hidden = NO;
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
}

- (IBAction)atTime:(id)sender {
    
    tHeight3 = 352;
    _pickerView3.hidden = NO;
    toolBar3.hidden = NO;
    _list3.hidden = YES;
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
}

- (NSArray *)dataForPopoverInTextField:(MPGTextField *)textField
{
    return suggestionData;
}
- (void)textField:(MPGTextField *)textField didEndEditingWithSelection:(NSDictionary *)result
{

    NSLog(@"rsult : %@",result);
    [self.invitees addObject:result[@"CustomObject"]];
    [self.tokens addObject:result[@"DisplayText"]];
    [self.tokenField reloadData];
    self.invitee.text = @"";
}
- (BOOL)textFieldShouldSelect:(MPGTextField *)textField
{
    return YES;
}

- (void)tokenDeleteButtonPressed:(UIButton *)tokenButton
{
    NSUInteger index = [self.tokenField indexOfTokenView:tokenButton.superview];
    if (index != NSNotFound) {
        [self.tokens removeObjectAtIndex:index];
        [self.invitees removeObjectAtIndex:index];
        [self.tokenField reloadData];
    }
}

#pragma mark - ZFTokenField DataSource

- (CGFloat)lineHeightForTokenInField:(ZFTokenField *)tokenField
{
    return 40;
}

- (NSUInteger)numberOfTokenInField:(ZFTokenField *)tokenField
{
    return self.tokens.count;
}

- (UIView *)tokenField:(ZFTokenField *)tokenField viewForTokenAtIndex:(NSUInteger)index
{
    NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:@"TokenView" owner:nil options:nil];
    UIView *view = nibContents[0];
    UILabel *label = (UILabel *)[view viewWithTag:2];
    UIButton *button = (UIButton *)[view viewWithTag:3];
    
    [button addTarget:self action:@selector(tokenDeleteButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    label.text = self.tokens[index];
    CGSize size = [label sizeThatFits:CGSizeMake(1000, 40)];
    view.frame = CGRectMake(0, 0, size.width + 50, 40);
    return view;
}

#pragma mark - ZFTokenField Delegate

- (CGFloat)tokenMarginInTokenInField:(ZFTokenField *)tokenField
{
    return 5;
}

- (void)tokenField:(ZFTokenField *)tokenField didReturnWithText:(NSString *)text
{
    //[self.tokens addObject:text];
    [tokenField reloadData];
}

- (void)tokenField:(ZFTokenField *)tokenField didRemoveTokenAtIndex:(NSUInteger)index
{
    [self.tokens removeObjectAtIndex:index];
    [self.invitees removeObjectAtIndex:index];
}

- (BOOL)tokenFieldShouldEndEditing:(ZFTokenField *)textField
{
    return YES;
}

- (void) switchChanged:(id)sender {
    UISwitch* switchControl = sender;
    NSLog( @"The switch is %@", switchControl.on ? @"ON" : @"OFF" );
}
-(void)createEvent{
    
    userID = [[NSUserDefaults standardUserDefaults] stringForKey:@"userId"];
    email = [[NSUserDefaults standardUserDefaults] stringForKey:@"email"];
    eventName = self.eventName.text;
    allDay = self.eventSwitch.on ? @"1" : @"0";
    priority = [self.prioritySegment titleForSegmentAtIndex:self.prioritySegment.selectedSegmentIndex];
    address1 = self.address1.text;
    address2 = self.address2.text;
    zipCode = self.zipcode.text;
    country = self.country.text;
    notes = self.notes.text;
}

@end
