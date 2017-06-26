//
//  MYCollectionView.m
//  CollectionPrepare
//
//  Created by  tomxiang on 15/11/23.
//  Copyright © 2015年 tomxiang. All rights reserved.
//

#import "MYCollectionView.h"
#import "QQEngine.h"

@interface MYCollectionView()
@property(nonatomic,strong) QQLineFlowLayout *flowLayout;
@end

@implementation MYCollectionView

-(instancetype)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]){
        self.flowLayout = [[QQLineFlowLayout alloc] init];
        self.flowLayout.cellCount = [[QQEngine sharedInstance] getCardCount];
        
        self.collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:_flowLayout];
        self.collectionView.backgroundColor = viewBackGround_Color;
        [self addSubview:_collectionView];
        
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(event:)];
        [self addGestureRecognizer:gesture];
    }
    return self;
}

-(void)setDelegate:(id<MYCollectionViewDelegate>)delegate {
    _delegate = delegate;
    _collectionView.delegate = delegate;
    _collectionView.dataSource = delegate;
}

-(void)reloadData {
    [_collectionView reloadData];
}

#pragma mark- DSCollectionViewIndexDelegate
- (void)event:(UITapGestureRecognizer *)gesture {
    CGPoint point = [gesture locationInView:self.collectionView];
    
    NSArray *arrayVisible = self.flowLayout.arrayVisibleAttributes;
    for(NSInteger i = arrayVisible.count-2; i >= 0 ; i-- ) {
        if(i < 0)
            break;
        
        UICollectionViewLayoutAttributes* attributesCurrent = [arrayVisible objectAtIndex:i];
        UICollectionViewLayoutAttributes* attributesNext = [arrayVisible objectAtIndex:(i+1)];
        
        if(attributesNext != nil){
            CGRect regsionImageView = CGRectMake(attributesCurrent.frame.origin.x, attributesCurrent.frame.origin.y, attributesCurrent.frame.size.width, attributesNext.frame.origin.y - attributesCurrent.frame.origin.y);
            
            if(CGRectContainsPoint(regsionImageView, point)){
                if(attributesCurrent.alpha == 1.f){
                    
                    if ([self.delegate respondsToSelector:@selector(myCollectionViewdidSelectItemAtIndexPath:)]) {
                        [self.delegate myCollectionViewdidSelectItemAtIndexPath:attributesCurrent.indexPath];
                    }
//                    NSLog(@"%ld",(long)attributesCurrent.indexPath.row);
                }
                break;
            }
        }
    }
}

@end
