//
//  VWWUtility.h
//  Panoramotion
//
//  Created by Zakk Hoyt on 11/27/13.
//  Copyright (c) 2013 Zakk Hoyt. All rights reserved.
//

#import <Foundation/Foundation.h>
#define VWW_MARK NSLog(@"%s:%d", __FUNCTION__, __LINE__);
#define VWW_MARK_TASK(...) NSLog(@"%s:%d %@", __FUNCTION__, __LINE__, [NSString stringWithFormat:__VA_ARGS__]);
#define VWW_MARK_TODO(...) NSLog(@"%s:%d TODO: %@", __FUNCTION__, __LINE__, [NSString stringWithFormat:__VA_ARGS__]);

@interface VWWUtility : NSObject

+(void)alertViewWithTitle:(NSString*)title message:(NSString*)message;
+(void)alertViewWithMessage:(NSString*)message;

@end
