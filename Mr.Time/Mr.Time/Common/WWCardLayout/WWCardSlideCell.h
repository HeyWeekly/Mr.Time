//
//  WWCardSlideCell.h
//  Mr.Time
//
//  Created by steaest on 2017/6/13.
//  Copyright © 2017年 Offape. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WWCardSlideCellDelagate <NSObject>
@optional
- (void)bookCellLike;
@end


@interface WWCardSlideCell : UICollectionViewCell
@property (strong,nonatomic) id model;
@property (nonatomic, weak) id <WWCardSlideCellDelagate> delegate;
@end
