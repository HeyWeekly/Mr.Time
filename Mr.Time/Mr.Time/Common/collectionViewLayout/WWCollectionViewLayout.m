//
//  WWCollectionViewLayout.m
//  Mr.Time
//
//  Created by steaest on 2017/8/10.
//  Copyright © 2017年 Offape. All rights reserved.
//

#import "WWCollectionViewLayout.h"

@interface WWCollectionViewLayout ()
@property (nonatomic, strong) NSArray* cache;
@property (nonatomic, strong) NSArray* oldCache;
@property (nonatomic, assign) CGFloat contentHeight;
@property (nonatomic, assign) CGFloat contentWidth;
@property (nonatomic, assign) CGFloat xOffset;
@property (nonatomic, assign) CGFloat yOffset;
@property (nonatomic, assign) BOOL absoluteItemSize;
@property (nonatomic, assign) BOOL hasColculateInset;
@end

@implementation WWCollectionViewLayout
- (instancetype)init {
    if (self = [super init]) {
        self.InteritemSpacing = 0;
        self.LineSpacing = 0;
        self.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        self.scrollDirection = 0;
        self.bounces = NO;
        self.absoluteItemSize = NO;
        self.lineBreak = NO;
        self.alignCenter = NO;
    }
    return self;
}

-(void)prepareLayout {
    [super prepareLayout];
    self.oldCache = self.cache;
    self.contentWidth  = 0;
    self.contentHeight = 0;
    NSMutableArray<UICollectionViewLayoutAttributes*>* tempArray = [NSMutableArray array];
    NSInteger sectionNum;
    if ([self.delegate respondsToSelector:@selector(layoutNumberOfSection:)]) {
        sectionNum = [self.delegate layoutNumberOfSection:self];
    }else {
        sectionNum = [self.collectionView.dataSource numberOfSectionsInCollectionView:self.collectionView];
    }
    if (sectionNum == 0) {
        return;
    }
    CGFloat itemHeight = 1;
    CGFloat itemWidth = 1;
    if ([self.delegate respondsToSelector:@selector(layout:absoluteSideForSection:)]) {
        if (self.lineBreak) {
            // 让sectionInset  保持原样
        }else {
            CGFloat allItemLength = 0;
            for (int i = 0; i < sectionNum; i++) {
                allItemLength += [self.delegate layout:self absoluteSideForSection:i];
            }
            if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
                CGFloat leftRight;
                leftRight = (self.expectRect.size.width - allItemLength - (self.LineSpacing * (sectionNum - 1)));
                CGFloat leftRate = (self.sectionInset.left ? self.sectionInset.left : 1) /( (self.sectionInset.left == 0 && self.sectionInset.right == 0) ?  (2) : (self.sectionInset.left + self.sectionInset.right ));
                CGFloat rightRate = 1.0 - leftRate;
                if (leftRate == 0 && rightRate == 0) {
                    leftRate = 0.5;
                    rightRate = 0.5;
                }
                self.sectionInset = UIEdgeInsetsMake(self.sectionInset.top, leftRight * leftRate, self.sectionInset.bottom, leftRight * rightRate);
            }else {
                CGFloat topBottom;
                topBottom = (self.expectRect.size.height - allItemLength - (self.LineSpacing * (sectionNum - 1)));
                CGFloat topRate =  (self.sectionInset.top ? self.sectionInset.top : 1) / ( (self.sectionInset.top == 0 && self.sectionInset.bottom == 0) ?  (2) : (self.sectionInset.top + self.sectionInset.bottom ));
                CGFloat bottomRate = 1.0 - topRate;
                if (topRate == 0 && bottomRate == 1) {
                    topRate = 0.5;
                    bottomRate = 0.5;
                }
                self.sectionInset = UIEdgeInsetsMake(topBottom * topRate, self.sectionInset.left, topBottom * bottomRate, self.sectionInset.right);
            }
        }
    }else {
        if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
            itemWidth = (self.expectRect.size.width - self.sectionInset.left - self.sectionInset.right - self.LineSpacing * (sectionNum - 1)) / sectionNum;
        }else {
            itemHeight = (self.expectRect.size.height - self.sectionInset.top - self.sectionInset.bottom - self.LineSpacing * (sectionNum - 1)) / sectionNum;
        }
    }
    NSAssert(!isnan(itemWidth), @"item 为 nan");
    NSAssert(!isnan(itemHeight), @"item 为 nan");
    if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
        self.xOffset = self.sectionInset.right;
    }else {
        self.yOffset = self.sectionInset.top;
    }
    for (NSInteger i = 0; i < sectionNum; i++) {
        if ([self.delegate respondsToSelector:@selector(layout:absoluteSideForSection:)]){
            if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
                itemWidth = [self.delegate layout:self absoluteSideForSection:i];;
            }else {
                itemHeight = [self.delegate layout:self absoluteSideForSection:i];;
            }
        }
        NSInteger rowNum;
        if ([self.delegate respondsToSelector:@selector(layout:numberOfItemsForSection:)]) {
            rowNum = [self.delegate layout:self numberOfItemsForSection:i];
        }else {
            rowNum = [self.collectionView.dataSource collectionView:self.collectionView numberOfItemsInSection:i];
        }
        if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
            self.yOffset = self.sectionInset.top;
        }else {
            self.xOffset = self.sectionInset.left;
        }
        if ([self.delegate respondsToSelector:@selector(layout:sizeForHeaderForSection:)]) {
            CGSize headerSize = [self.delegate layout:self sizeForHeaderForSection:i];
            if (headerSize.width != 0 && headerSize.height != 0) {
                UICollectionViewLayoutAttributes* attrs = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader withIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
                if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
                    itemHeight = itemWidth * (headerSize.height / headerSize.width);
                }else {
                    itemWidth = itemHeight * (headerSize.width / headerSize.height);
                }
                attrs.frame = CGRectMake(self.xOffset, self.yOffset, itemWidth, itemHeight);
                if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
                    self.yOffset += self.InteritemSpacing + itemHeight;
                }else {
                    self.xOffset += self.InteritemSpacing + itemWidth;
                }
                [tempArray addObject:attrs];
            }
        }
        for (NSInteger r = 0; r < rowNum; r ++) {
            UICollectionViewLayoutAttributes* attrs = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:[NSIndexPath indexPathForItem:r inSection:i]];
            if (r == 0) {
                if ([self.delegate respondsToSelector:@selector(layout:firstLinendentation:)]) {
                    if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
                        self.yOffset += [self.delegate layout:self firstLinendentation:i];
                    }else {
                        self.xOffset += [self.delegate layout:self firstLinendentation:i];
                    }
                }
            }
            CGFloat x = self.xOffset;
            CGFloat y = self.yOffset;
            
            CGSize size = [self.delegate layout:self sizeForCellAtIndexPath:[NSIndexPath indexPathForItem:r inSection:i]];
            NSAssert(!isnan(size.width), @"size 为 nan");
            NSAssert(!isnan(size.height), @"size 为 nan");
            NSAssert(itemWidth, @"itemWidth 为0");
            NSAssert(itemHeight, @"itemHeight 为0");
            if (size.width == 0 || size.height == 0) {
                if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
                    size = CGSizeMake(itemWidth, itemWidth);
                }else {
                    size = CGSizeMake(itemHeight, itemHeight);
                }
            }
            NSAssert(size.width, @"size 为 0");
            NSAssert(size.height, @"size 为 0");
            NSAssert(!isnan(size.width), @"size 为 nan");
            NSAssert(!isnan(size.height), @"size 为 nan");
            if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
                itemHeight = itemWidth * (size.height / size.width);
            }else {
                itemWidth = itemHeight * (size.width / size.height);
            }
            NSAssert(!isnan(itemWidth), @"item 为 nan");
            NSAssert(!isnan(itemHeight), @"item 为 nan");
            attrs.frame = CGRectMake(x, y, itemWidth, itemHeight);
            if (self.lineBreak) {
                if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
                    if (y + itemHeight + self.sectionInset.right > self.expectRect.size.height) {
                        self.yOffset = self.sectionInset.top;
                        y = self.yOffset;
                        self.xOffset += itemWidth + self.LineSpacing;
                        x = self.xOffset;
                        attrs.frame = CGRectMake(x, y, itemWidth, itemHeight);
                    }
                }else {
                    if (x + itemWidth + self.sectionInset.right > self.expectRect.size.width) {
                        self.xOffset = self.sectionInset.left;
                        x = self.xOffset;
                        self.yOffset += itemHeight + self.LineSpacing;
                        y = self.yOffset;
                        attrs.frame = CGRectMake(x, y, itemWidth, itemHeight);
                    }
                }
            }
            
            if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
                self.yOffset += self.InteritemSpacing + itemHeight;
            }else {
                self.xOffset += self.InteritemSpacing + itemWidth;
            }
            NSAssert(!isnan(attrs.frame.size.width), @"size 为 nan");
            NSAssert(!isnan(attrs.frame.size.height), @"size 为 nan");
            [tempArray addObject:attrs];
        }
        
        if ([self.delegate respondsToSelector:@selector(layout:sizeForFooterForSection:)]) {
            CGSize footerSize = [self.delegate layout:self sizeForFooterForSection:i];
            if (footerSize.width != 0 && footerSize.height != 0) {
                UICollectionViewLayoutAttributes* attrs = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter withIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
                if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
                    itemHeight = itemWidth * (footerSize.height / footerSize.width);
                }else {
                    itemWidth = itemHeight * (footerSize.width / footerSize.height);
                }
                attrs.frame = CGRectMake(self.xOffset, self.yOffset, itemWidth, itemHeight);
                if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
                    self.yOffset += self.InteritemSpacing + itemHeight;
                }else {
                    self.xOffset += self.InteritemSpacing + itemWidth;
                }
                [tempArray addObject:attrs];
            }
        }
        if (self.lineBreak) {
            if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
                self.contentHeight = self.expectRect.size.height;
                self.xOffset += itemWidth + self.sectionSpacing;
            }else {
                self.contentWidth = self.expectRect.size.width;
                self.yOffset += itemHeight + self.sectionSpacing;
            }
        }else {
            if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
                self.contentHeight = self.contentHeight > (self.yOffset - self.InteritemSpacing + self.sectionInset.bottom) ? self.contentHeight : self.yOffset - self.InteritemSpacing + self.sectionInset.bottom;
                self.xOffset += itemWidth + self.sectionSpacing;
            }else {
                self.contentWidth = self.contentWidth > self.xOffset - self.InteritemSpacing + self.sectionInset.right ? self.contentWidth : self.xOffset - self.InteritemSpacing + self.sectionInset.right;
                self.yOffset += itemHeight + self.sectionSpacing;
            }
        }
    }
    if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
        self.contentWidth = self.xOffset + self.sectionInset.right - self.sectionSpacing;
    }else {
        self.contentHeight = self.yOffset + self.sectionInset.bottom - self.sectionSpacing;
    }
    if (self.alignCenter && self.lineBreak && tempArray.count) {
        if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
            NSUInteger nowIndex = 0;
            while (1) {
                NSMutableArray<UICollectionViewLayoutAttributes*>* mCenterArray = [NSMutableArray array];
                CGFloat nowX = tempArray[nowIndex].frame.origin.x;
                while (1) {
                    if (tempArray[nowIndex].frame.origin.x == nowX) {
                        [mCenterArray addObject:tempArray[nowIndex]];
                    }else {
                        break;
                    }
                    if (nowIndex == tempArray.count - 1) {
                        break;
                    }
                    nowIndex++;
                }
                CGFloat startY= mCenterArray[0].frame.origin.y;
                CGFloat endY = mCenterArray[mCenterArray.count - 1].frame.origin.y + mCenterArray[mCenterArray.count - 1].frame.size.height;
                CGFloat offset = (self.expectRect.size.height - (endY-startY) - self.sectionInset.bottom - self.sectionInset.top)/2;
                for (UICollectionViewLayoutAttributes* attr in mCenterArray) {
                    attr.frame = CGRectMake(attr.frame.origin.x, attr.frame.origin.y + offset, attr.frame.size.width, attr.frame.size.height);
                }
                if (nowIndex == tempArray.count - 1) {
                    break;
                }
            }
        }else {
            NSUInteger nowIndex = 0;
            while (1) {
                NSMutableArray<UICollectionViewLayoutAttributes*>* mCenterArray = [NSMutableArray array];
                CGFloat nowY = tempArray[nowIndex].frame.origin.y;
                while (1) {
                    if (nowIndex == tempArray.count) {
                        break;
                    }
                    if (tempArray[nowIndex].frame.origin.y == nowY) {
                        [mCenterArray addObject:tempArray[nowIndex]];
                    }else {
                        break;
                    }
                    nowIndex++;
                }
                CGFloat startX= mCenterArray[0].frame.origin.x;
                CGFloat endX = mCenterArray[mCenterArray.count - 1].frame.origin.x + mCenterArray[mCenterArray.count - 1].frame.size.width;
                CGFloat offset = (self.expectRect.size.width - (endX-startX) - self.sectionInset.left - self.sectionInset.right)/2;
                for (UICollectionViewLayoutAttributes* attr in mCenterArray) {
                    attr.frame = CGRectMake(attr.frame.origin.x + offset, attr.frame.origin.y, attr.frame.size.width, attr.frame.size.height);
                }
                if (nowIndex == tempArray.count) {
                    break;
                }
            }
        }
    }
    if (self.verticleAlignCenter && self.lineBreak) {
        if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
            if (self.contentWidth < self.expectRect.size.width) {
                UICollectionViewLayoutAttributes* minAttr = tempArray.firstObject;
                UICollectionViewLayoutAttributes* maxAttr = tempArray.lastObject;
                for (UICollectionViewLayoutAttributes* attr in tempArray) {
                    if (CGRectGetMaxX(attr.frame) > CGRectGetMaxX(maxAttr.frame)) {
                        maxAttr = attr;
                    }
                    if (CGRectGetMinX(attr.frame) < CGRectGetMinX(minAttr.frame)) {
                        minAttr = attr;
                    }
                }
                CGFloat offset = (self.expectRect.size.width - (CGRectGetMaxX(maxAttr.frame) - CGRectGetMinX(minAttr.frame))) / 2 - CGRectGetMinX(minAttr.frame);
                for (UICollectionViewLayoutAttributes* attr in tempArray) {
                    attr.frame = CGRectMake(attr.frame.origin.x + offset, attr.frame.origin.y, attr.frame.size.width, attr.frame.size.height);
                }
            }
        }else {
            if (self.contentHeight < self.expectRect.size.height) {
                UICollectionViewLayoutAttributes* minAttr = tempArray.firstObject;
                UICollectionViewLayoutAttributes* maxAttr = tempArray.lastObject;
                for (UICollectionViewLayoutAttributes* attr in tempArray) {
                    if (CGRectGetMaxY(attr.frame) > CGRectGetMaxY(maxAttr.frame)) {
                        maxAttr = attr;
                    }
                    if (CGRectGetMinY(attr.frame) < CGRectGetMinY(minAttr.frame)) {
                        minAttr = attr;
                    }
                }
                CGFloat offset = (self.expectRect.size.height - (CGRectGetMaxY(maxAttr.frame) - CGRectGetMinY(minAttr.frame))) / 2 - CGRectGetMinY(minAttr.frame);
                for (UICollectionViewLayoutAttributes* attr in tempArray) {
                    attr.frame = CGRectMake(attr.frame.origin.x, attr.frame.origin.y + offset, attr.frame.size.width, attr.frame.size.height);
                }
            }
        }
    }
    self.cache = tempArray.copy;
}

- (CGRect)expectRect {
    if (self.expectSize) {
        return CGRectMake(0, 0, self.expectSize.CGSizeValue.width, self.expectSize.CGSizeValue.height);
    }else {
        return self.collectionView.frame;
    }
}

- (CGSize)collectionViewContentSize {
    if (self.lineBreak) {
        if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
            if (self.bounces) {
                return CGSizeMake(self.contentWidth > self.expectRect.size.width ? self.contentWidth : self.expectRect.size.width + 1, self.contentHeight );
            }else {
                return CGSizeMake(self.contentWidth, self.contentHeight);
            }
        }else {
            if (self.bounces) {
                return CGSizeMake(self.contentWidth, self.contentHeight > self.expectRect.size.height ? self.contentHeight : self.expectRect.size.height + 1);
            }else {
                return CGSizeMake(self.contentWidth, self.contentHeight);
            }
        }
    }
    if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
        if (self.bounces) {
            return CGSizeMake(self.expectRect.size.width, self.contentHeight > self.expectRect.size.height ? self.contentHeight : self.expectRect.size.height + 1);
        }
        return CGSizeMake(self.expectRect.size.width, self.contentHeight);
    }else if (self.scrollDirection == UICollectionViewScrollDirectionHorizontal){
        if (self.bounces) {
            return CGSizeMake(self.contentWidth > self.expectRect.size.width ? self.contentWidth : self.expectRect.size.width + 1, self.expectRect.size.height);
        }
        return CGSizeMake(self.contentWidth, self.expectRect.size.height);
    }
    return CGSizeMake(self.contentWidth, self.contentHeight);
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray* tempArray = [NSMutableArray array];
    
    for (UICollectionViewLayoutAttributes* attr in self.cache) {
        if (CGRectIntersectsRect(attr.frame, rect)) {
            [tempArray addObject:attr];
        }
    }
    return tempArray.copy;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    for (UICollectionViewLayoutAttributes* attr in self.cache) {
        if (attr.representedElementKind == nil && attr.indexPath.row == indexPath.row && attr.indexPath.section == indexPath.section) {
            return attr;
        }
    }
    return nil;
}
- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
    for (UICollectionViewLayoutAttributes* attr in self.cache) {
        if ([attr.representedElementKind isEqualToString:elementKind] && attr.indexPath.row == indexPath.row && attr.indexPath.section == indexPath.section) {
            return attr;
        }
    }
    return nil;
}

- (void)prepareForCollectionViewUpdates:(NSArray<UICollectionViewUpdateItem *> *)updateItems {
    [super prepareForCollectionViewUpdates:updateItems];
}

- (UICollectionViewLayoutAttributes *)initialLayoutAttributesForAppearingItemAtIndexPath:(NSIndexPath *)itemIndexPath {
    UICollectionViewLayoutAttributes* attr = [super initialLayoutAttributesForAppearingItemAtIndexPath:itemIndexPath].copy;
    attr.frame = ((UICollectionViewLayoutAttributes*)[self collectionViewLayoutAttributesForIndexPath:itemIndexPath onOld:NO]).frame;
    attr.alpha = 1;
    return attr;
}
- (UICollectionViewLayoutAttributes *)finalLayoutAttributesForDisappearingItemAtIndexPath:(NSIndexPath *)itemIndexPath {
    UICollectionViewLayoutAttributes* attr = [super finalLayoutAttributesForDisappearingItemAtIndexPath:itemIndexPath].copy;
    attr.alpha = 0;
    return attr;
}

- (UICollectionViewLayoutAttributes*)collectionViewLayoutAttributesForIndexPath:(NSIndexPath*)indexPath onOld:(BOOL)onOld {
    if (onOld) {
        for (UICollectionViewLayoutAttributes* attr in self.oldCache) {
            if (attr.indexPath.item == indexPath.item) {
                if (attr.indexPath.section == indexPath.section) {
                    return attr;
                }
            }
        }
    }else {
        for (UICollectionViewLayoutAttributes* attr in self.cache) {
            if (attr.indexPath.item == indexPath.item) {
                if (attr.indexPath.section == indexPath.section) {
                    return attr;
                }
            }
        }
    }
    return nil;
}
@end
