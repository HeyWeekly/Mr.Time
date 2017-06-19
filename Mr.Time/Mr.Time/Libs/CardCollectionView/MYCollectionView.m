//
//  MYCollectionView.m
//  CollectionPrepare
//
//  Created by  tomxiang on 15/11/23.
//  Copyright © 2015年 tomxiang. All rights reserved.
//

#import "MYCollectionView.h"
#import "QQEngine.h"
#import "DSCollectionViewIndex.h"

@interface MYCollectionView()<DSCollectionViewIndexDelegate>
@property(nonatomic,strong) DSCollectionViewIndex   *collectionViewIndex;   //右边索引条
@property(nonatomic,strong) QQLineFlowLayout *flowLayout;
@end

@implementation MYCollectionView

-(instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame]){
        self.flowLayout = [[QQLineFlowLayout alloc] init];
        self.flowLayout.cellCount = [[QQEngine sharedInstance] getCardCount];
        
        self.collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:_flowLayout];
//        self.collectionView.backgroundColor = [UIColor redColor];
        [self addSubview:_collectionView];
        
        _collectionViewIndex = [[DSCollectionViewIndex alloc] initWithFrame:CGRectMake(self.bounds.size.width-20, 0, 20, self.bounds.size.height)];
        [self addSubview:_collectionViewIndex];
        
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(event:)];
        [self addGestureRecognizer:gesture];
    }
    return self;
}


-(void)setDelegate:(id<MYCollectionViewDelegate>)delegate{
    
    _delegate = delegate;
    _collectionView.delegate = delegate;
    _collectionView.dataSource = delegate;
    _collectionViewIndex.titleIndexes = [self.delegate sectionIndexTitlesForDSCollectionView:self];
    
    CGRect rect = _collectionViewIndex.frame;
    rect.size.height = _collectionViewIndex.titleIndexes.count * DSCollectionLetterHeight;
    rect.origin.y = (self.frame.size.height - rect.size.height) / 2 - DSCollectionLetterHeight;
    _collectionViewIndex.frame = rect;
    _collectionViewIndex.backgroundColor = [UIColor clearColor];
    self.collectionViewIndex.collectionDelegate = self;
}

-(void)reloadData{
    
    [_collectionView reloadData];
    
    UIEdgeInsets edgeInsets = _collectionView.contentInset;
    
    _collectionViewIndex.titleIndexes = [self.delegate sectionIndexTitlesForDSCollectionView:self];
    CGRect rect = _collectionViewIndex.frame;
    rect.size.height = _collectionViewIndex.titleIndexes.count * DSCollectionLetterHeight;
    rect.origin.y = (self.bounds.size.height - rect.size.height - edgeInsets.top - edgeInsets.bottom) / 2 + edgeInsets.top - DSCollectionLetterHeight;
    _collectionViewIndex.frame = rect;
    self.collectionViewIndex.collectionDelegate = self;
}


#pragma mark- DSCollectionViewIndexDelegate

-(void)collectionViewIndex:(DSCollectionViewIndex *)collectionViewIndex didselectionAtIndex:(NSInteger)index withTitle:(NSString *)title
{
    return;
//    if ([_collectionView numberOfSections]>index&&index>-1) {
//        [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:index] atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
//    }
}

- (void)collectionViewIndexTouchesBegan:(DSCollectionViewIndex *)collectionViewIndex
{

}

- (void)collectionViewIndexTouchesEnd:(DSCollectionViewIndex *)collectionViewIndex
{

}

- (void)event:(UITapGestureRecognizer *)gesture
{
    CGPoint point = [gesture locationInView:self.collectionView];
    
    NSArray *arrayVisible = self.flowLayout.arrayVisibleAttributes;
    for(NSInteger i = arrayVisible.count-2; i >= 0 ; i-- )
    {
        if(i < 0)
            break;
        
        UICollectionViewLayoutAttributes* attributesCurrent = [arrayVisible objectAtIndex:i];
        UICollectionViewLayoutAttributes* attributesNext = [arrayVisible objectAtIndex:(i+1)];
        
        if(attributesNext != nil){
            CGRect regsionImageView = CGRectMake(attributesCurrent.frame.origin.x, attributesCurrent.frame.origin.y, attributesCurrent.frame.size.width, attributesNext.frame.origin.y - attributesCurrent.frame.origin.y);
            
            if(CGRectContainsPoint(regsionImageView, point)){
                if(attributesCurrent.alpha == 1.f){
                    
                    NSLog(@"%ld",(long)attributesCurrent.indexPath.row);
                }
                break;
            }
        }
    }
}

@end
