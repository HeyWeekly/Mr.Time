//
//  NSString+WWExtra.m
//  Mr.Time
//
//  Created by steaest on 2017/6/25.
//  Copyright © 2017年 Offape. All rights reserved.
//

#import "NSString+WWExtra.h"

@implementation NSString (WWExtra)
+ (NSString *)uuid{
    // create a new UUID which you own
    CFUUIDRef uuidref = CFUUIDCreate(kCFAllocatorDefault);
    // create a new CFStringRef (toll-free bridged to NSString)
    // that you own
    CFStringRef uuid = CFUUIDCreateString(kCFAllocatorDefault, uuidref);
    NSString *result = (__bridge NSString *)uuid;
    //release the uuidref
    CFRelease(uuidref);
    // release the UUID
    CFRelease(uuid);
    return result;
}
@end
