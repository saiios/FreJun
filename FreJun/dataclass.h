//
//  dataclass.h
//  globalvariable
//
//  Created by Simran on 28/03/16.
//  Copyright © 2016 techkaleido. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface dataclass : NSObject

@property(nonatomic,retain)NSString *NotificationCount;
@property(nonatomic,retain)NSString *emailTitle;
@property(nonatomic,retain)NSString *name;
@property(nonatomic,retain)NSDictionary *selectedEvent;
@property(nonatomic,retain)NSString *selectedDate;
@property(nonatomic,retain)NSArray *events;
@property(nonatomic,retain)NSArray *sortedEvents;
@property(nonatomic,retain)NSArray *dates;
@property(nonatomic,retain)NSArray *googleContacts;

@property(nonatomic,retain)NSDictionary *pref;

@property(nonatomic,retain)NSString *GCMToken;
+(dataclass*)getInstance;

@end
