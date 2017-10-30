//
//  WWCardSlideCell.h
//  Mr.Time
//
//  Created by steaest on 2017/6/13.
//  Copyright © 2017年 Offape. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WWHomeBookModel;

@protocol WWCardSlideCellDelagate <NSObject>
@optional
- (void)moreClickAid:(NSString *)aid withContnet:(NSString *)content;
- (void)bookCellLikeIndex:(NSInteger)index;
@end


@interface WWCardSlideCell : UICollectionViewCell
@property (strong,nonatomic) WWHomeBookModel *model;
@property (nonatomic, weak) id <WWCardSlideCellDelagate> delegate;
@end
