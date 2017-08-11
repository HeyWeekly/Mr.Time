//
//  WWGeneric.h
//  Mr.Time
//
//  Created by steaest on 2017/8/11.
//  Copyright © 2017年 Offape. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

inline static long long adjustTimestampFromServer(long long timestamp) {
    if (timestamp > 140000000000) {
        timestamp /= 1000;
    }
    return timestamp;
}

@interface WWGeneric : NSObject
+ (instancetype)sharedUtils;

//服务器返回的时间戳单位可能是毫秒
+ (NSTimeInterval)adjustTimestampFromServer:(long long)timestamp;
@end

static inline UIViewAnimationOptions animationOptionsWithCurve(UIViewAnimationCurve curve) {
    switch (curve) {
        case UIViewAnimationCurveEaseInOut:
            return UIViewAnimationOptionCurveEaseInOut;
        case UIViewAnimationCurveEaseIn:
            return UIViewAnimationOptionCurveEaseIn;
        case UIViewAnimationCurveEaseOut:
            return UIViewAnimationOptionCurveEaseOut;
        case UIViewAnimationCurveLinear:
            return UIViewAnimationOptionCurveLinear;
    }
    
    return curve << 16;
}

NS_ASSUME_NONNULL_END
