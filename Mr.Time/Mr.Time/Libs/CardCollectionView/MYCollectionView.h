//
//  MYCollectionView.h
//  CollectionPrepare
//
//  Created by  tomxiang on 15/11/23.
//  Copyright © 2015年 tomxiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QQLineFlowLayout.h"

@class MYCollectionView;
@protocol MYCollectionViewDelegate <UICollectionViewDataSource,UICollectionViewDelegate>
- (NSArray *)sectionIndexTitlesForDSCollectionView:(MYCollectionView *)tableView;
@end

@interface MYCollectionView : UIView
@property(nonatomic,strong) UICollectionView *collectionView;
@property(nonatomic, weak)  id<MYCollectionViewDelegate> delegate;


-(void)reloadData;

@end
