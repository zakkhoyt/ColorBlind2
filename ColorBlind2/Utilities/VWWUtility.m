//
//  VWWUtility.m
//  Panoramotion
//
//  Created by Zakk Hoyt on 11/27/13.
//  Copyright (c) 2013 Zakk Hoyt. All rights reserved.
//

#import "VWWUtility.h"

@implementation VWWUtility


#pragma mark Private methods




#pragma mark Public methods
+(void)alertViewWithTitle:(NSString*)title message:(NSString*)message{
    [[[UIAlertView alloc]initWithTitle:title message:message delegate:Nil cancelButtonTitle:@"Got it" otherButtonTitles:nil, nil]show];
}
+(void)alertViewWithMessage:(NSString*)message{
    [VWWUtility alertViewWithTitle:nil message:message];
}
@end
