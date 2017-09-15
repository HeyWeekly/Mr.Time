//
//  WWNoContentView.h
//  Mr.Time
//
//  Created by 王伟伟 on 2017/9/15.
//  Copyright © 2017年 Offape. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, NoContentType) {
    NoContentTypeNetwork = 0,
    NoContentTypeData
};


@interface WWNoContentView : UIView

/** 无数据占位图的类型 */
@property (nonatomic,assign) NSInteger type;

@end
