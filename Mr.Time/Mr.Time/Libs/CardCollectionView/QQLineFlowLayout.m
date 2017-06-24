//
//  QQLineFlowLayout.m
//  CollectionPrepare
//
//  Created by  tomxiang on 15/11/12.
//  Copyright © 2015年 tomxiang. All rights reserved.
//

#import "QQLineFlowLayout.h"
#import "QQEngine.h"

#define TOP 4
#define CELL_HEIGHT  ((SCREEN_HEIGHT - 64 - 44) / (PAGECOUNT - 1))

@interface QQLineFlowLayout()
@property (nonatomic, strong) NSDictionary *layoutAttributes;
@end

@implementation QQLineFlowLayout
-(id)init {
    self = [super init];
    if (self) {

        self.arrayVisibleAttributes = [NSMutableArray array];
        
        self.itemSize = CGSizeMake(ITEM_SIZE_WIDTH, CELL_HEIGHT);
        self.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        CGFloat marginLeft = (SCREEN_WIDTH - ITEM_SIZE_WIDTH) /2;
        self.sectionInset = UIEdgeInsetsMake(0, marginLeft, ITEM_SIZE_HEIGHT / 2, marginLeft);
        self.minimumLineSpacing = 0;
        self.minimumInteritemSpacing = 0;
    }
    return self;
}

-(NSArray*)layoutAttributesForElementsInRect:(CGRect)rect {
    [self.arrayVisibleAttributes removeAllObjects];
    NSMutableArray* attributes = [NSMutableArray array];
    for (NSInteger i = 0 ; i < self.cellCount; i++) {
        NSIndexPath* indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        [attributes addObject:[self layoutAttributesForItemAtIndexPath:indexPath]];
    }
    return attributes;
}

-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)path {
    CGRect visibleRect;
    visibleRect.origin = self.collectionView.contentOffset;
    visibleRect.size = self.collectionView.bounds.size;
    
    UICollectionViewLayoutAttributes* attributes = [[super layoutAttributesForItemAtIndexPath:path] copy];
    
    //可视区域上面一个也需要，防止突然出现的效果，因为CATransform3DMakeTranslation会产生3d效果，故而应用CGRectIntersectsRect
    CGRect visibleRectAddLast = CGRectMake(0, visibleRect.origin.y - ITEM_SIZE_HEIGHT, self.collectionView.frame.size.width, visibleRect.size.height + ITEM_SIZE_HEIGHT);
    
    if(CGRectIntersectsRect(visibleRectAddLast,attributes.frame)){
        attributes.alpha = 1.f;
        
        // scale
        CGFloat progress = [self getYCoordinate:attributes];
        CGFloat scaleWidth = 1 + (progress) * 0.06;
        CGFloat scaleHeight = 1 + (progress) * 0.06;
        
        // translation
        CGFloat translation = 0;
        if (progress > 0) {
            translation = fabs(progress) * (self.collectionView.frame.size.height * 0.12);//SCREEN_HEIGHT/ 8.f;
        } else {
            translation = fabs(progress) * fabs(progress) * (self.collectionView.frame.size.height * 0.04803);//SCREEN_HEIGHT/ 22.5f;
        }
        
        CATransform3D tranScale = CATransform3DMakeScale(scaleWidth, scaleHeight, 0.0);
        CATransform3D tranTrans = CATransform3DMakeTranslation(0, translation-ITEM_SIZE_HEIGHT/5.8, 0.0);//向上平移
        CATransform3D transResult = CATransform3DConcat(tranScale, tranTrans);
        
        attributes.zIndex = path.row;
        attributes.transform3D = transResult;
        
//        if(path.row == 0 || path.row == 1)
//        {
//            attributes.alpha = 0.f;
//        }
        
        [self.arrayVisibleAttributes addObject:attributes];
    }else{
        attributes.alpha = 0.f;
    }
//    [self setBounce:attributes];
    
    return attributes;

}

//-(void) setBounce:(UICollectionViewLayoutAttributes*) attribute {
//    if(attribute.indexPath.row > PAGECOUNT){
//        self.collectionView.alwaysBounceVertical = NO;
//         [self.collectionView setBounces:NO];
//        return;
//    }
//    [self.collectionView setBounces:YES];
//    self.collectionView.alwaysBounceVertical = YES;
//}

//获取Y坐标百分比 -3 -2 -1 0 1 2 3 :其中0表示中心点
-(CGFloat) getYCoordinate:(UICollectionViewLayoutAttributes*) attribute {
    CGFloat visibleRegionCenterY = [self getShowVisibleRegionCenter].y;

    CGFloat progress = (attribute.center.y - visibleRegionCenterY) / CGRectGetHeight(self.collectionView.bounds) * (PAGECOUNT-1);

    return progress;
}
-(CGPoint) getShowVisibleRegionCenter {
    CGFloat x = self.collectionView.contentOffset.x ;
    CGFloat y = self.collectionView.contentOffset.y + CGRectGetHeight(self.collectionView.bounds) / 2.0f;
    return  CGPointMake(x, y);
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

//  自动对齐到网格
- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity {
    //  proposedContentOffset是没有对齐到网格时停下来的位置
    CGFloat offsetAdjustment = MAXFLOAT;
    CGFloat verticalCenter = proposedContentOffset.y + (ITEM_SIZE_HEIGHT / 2.0);
    
    //  当前显示的区域
    CGRect targetRect = CGRectMake(0.0, proposedContentOffset.y, self.collectionView.bounds.size.width, self.collectionView.bounds.size.height);
    
    //取当前显示的item
    NSArray* array = [super layoutAttributesForElementsInRect:targetRect];
    
    //对当前屏幕中的UICollectionViewLayoutAttributes逐个与屏幕中心进行比较，找出最接近中心的一个
    for (UICollectionViewLayoutAttributes* layoutAttributes in array) {
        CGFloat itemVerticalCenter = layoutAttributes.center.y;
        
        if (ABS(itemVerticalCenter - verticalCenter) < ABS(offsetAdjustment)) {
            offsetAdjustment = itemVerticalCenter - verticalCenter;
        }
        
        NSInteger currentIndex = (NSInteger)(labs((NSInteger)layoutAttributes.indexPath.row - (NSInteger)self.cellCount - (NSInteger)PAGECOUNT + 1));
        
        if(currentIndex <= PAGECOUNT && velocity.y >= 0.f){
            return CGPointMake(proposedContentOffset.x,proposedContentOffset.y);
        }
    }
    
    return CGPointMake(proposedContentOffset.x, proposedContentOffset.y + offsetAdjustment-ITEM_SIZE_HEIGHT/1.8);
}
@end
