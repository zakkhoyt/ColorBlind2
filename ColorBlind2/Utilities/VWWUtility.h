//
//  VWWUtility.h
//  Panoramotion
//
//  Created by Zakk Hoyt on 11/27/13.
//  Copyright (c) 2013 Zakk Hoyt. All rights reserved.
//

#import <Foundation/Foundation.h>

// Some macros for logging
#define VWW_MARK            NSLog(@"%s:%d", __FUNCTION__, __LINE__);
#define VWW_LOG(...)        NSLog(@"%s:%d %@", __FUNCTION__, __LINE__, [NSString stringWithFormat:__VA_ARGS__]);
#define VWW_LOG_TODO(...)   NSLog(@"%s:%d TODO: %@", __FUNCTION__, __LINE__, [NSString stringWithFormat:__VA_ARGS__]);
#define VWW_LOG_ERROR(...)  NSLog(@"%s:%d *****ERROR: %@", __FUNCTION__, __LINE__, [NSString stringWithFormat:__VA_ARGS__]);
#define VWW_LOG_WARN(...)   NSLog(@"%s:%d ***** WARNING: %@", __FUNCTION__, __LINE__, [NSString stringWithFormat:__VA_ARGS__]);


@interface VWWUtility : NSObject

+(void)alertViewWithTitle:(NSString*)title message:(NSString*)message;
+(void)alertViewWithMessage:(NSString*)message;

@end
