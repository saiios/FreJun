//
//  ApxorSDK.h
//  ApxorSDK
//
//  Copyright (c) 2015 Apxor. All rights reserved.
//

#import <UIKit/UIKit.h>

//! Project version number for ApxorSDK.
FOUNDATION_EXPORT double ApxorSDKVersionNumber;

//! Project version string for ApxorSDK.
FOUNDATION_EXPORT const unsigned char ApxorSDKVersionString[];

// SDK interface
@interface ApxorSDK : NSObject

+ (void)notifyApplicationFinishedLaunching;
+ (void)reportCustomError:(NSError * __nonnull)error withContext:(NSString * __nullable) key;
+ (void)setUserIdentifier:(NSString * __nonnull)identifier;
+ (void)setUserCustomInfo:(NSDictionary * __nonnull)userCustomInfo;
+ (void)setCurrentViewName:(NSString * __nonnull)viewName;
+ (void)trackUserEvent:(NSString * __nonnull)eventName forView:(NSString * __nonnull)eventView withContext:(NSDictionary * __nullable)context;
+ (void)logAppEventForEvent:(NSString * __nonnull)eventName withInfo:(NSDictionary * __nullable)info;
+ (void)allowNetworkCalls:(BOOL)allow;

@end


