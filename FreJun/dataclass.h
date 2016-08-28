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

+(dataclass*)getInstance;

@end
