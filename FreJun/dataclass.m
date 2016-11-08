//
//  dataclass.m
//  globalvariable
//
//  Created by Simran on 28/03/16.
//  Copyright © 2016 techkaleido. All rights reserved.
//

#import "dataclass.h"

@implementation dataclass
@synthesize NotificationCount;
@synthesize emailTitle;
@synthesize selectedEvent;
@synthesize events;
@synthesize sortedEvents;
@synthesize selectedDate;
@synthesize googleContacts;
@synthesize dates;
@synthesize GCMToken;
@synthesize name;
@synthesize pref;
static dataclass *instance = nil;

+(dataclass *)getInstance
{
    @synchronized(self)
    {
        if(instance==nil)
        {
            instance= [dataclass new];
        }
    }
    return instance;
}

@end
