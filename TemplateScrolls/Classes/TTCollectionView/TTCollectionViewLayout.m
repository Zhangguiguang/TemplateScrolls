//
//  TTCollectionViewLayout.m
//  TemplateScrolls
//
//  Created by 张贵广 on 2021/01/03.
//

#import "TTCollectionViewLayout.h"

@implementation TTCollectionViewLayout

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    // 获取系统计算好的布局，再自己做些微调
    NSArray<UICollectionViewLayoutAttributes *> *answer = [super layoutAttributesForElementsInRect:rect];
    
    NSMutableArray *sameRowAttributes = [NSMutableArray arrayWithCapacity:3];
    __block CGFloat sameRowTotalWidth = 0.0;
    [answer enumerateObjectsUsingBlock:^(UICollectionViewLayoutAttributes *currentAttributes,
                                         NSUInteger idx, BOOL *stop) {
        if (currentAttributes.representedElementCategory != UICollectionElementCategoryCell) {
            // 只布局 Cell，其它视图忽略掉
            return ;
        }

        CGRect previousFrame = idx > 0 ? answer[idx-1].frame : CGRectZero;
        CGRect currentFrame  = currentAttributes.frame;
        
        CGFloat previousY = CGRectGetMidY(previousFrame);
        CGFloat currentY  = CGRectGetMidY(currentFrame);
        
        if (previousY != currentY) {
            // 当前 item 和前面 item 不在同一行, 因此当前 item 是在新一行的第一个元素
            
            // 先把上一行的布局处理完
            [self relayoutTheSameRowAttributes:[sameRowAttributes copy]
                                itemTotalWidth:sameRowTotalWidth];
            
            // 处理之后清空
            [sameRowAttributes removeAllObjects];
            sameRowTotalWidth = 0;
        }
        
        // 记录处于同一行的 item
        [sameRowAttributes addObject:currentAttributes];
        sameRowTotalWidth += CGRectGetWidth(currentFrame);
    }];
    
    // 上面的遍历结束，会遗漏最后一行没处理
    [self relayoutTheSameRowAttributes:[sameRowAttributes copy]
                        itemTotalWidth:sameRowTotalWidth];
    
    return answer;
}


- (void)relayoutTheSameRowAttributes:(NSArray<UICollectionViewLayoutAttributes *> *)attributes
                      itemTotalWidth:(CGFloat)itemTotalWidth {
    if (attributes.count == 0) {
        return;
    }
    
    NSInteger section = attributes.firstObject.indexPath.section;
    
    // item 对齐方式
    TTCollectionItemAlignment alignment = TTCollectionItemAlignmentDefault;
    if ([self.delegate respondsToSelector:@selector(collectionView:layout:alignmentItemsInSection:)]) {
        alignment = [self.delegate collectionView:self.collectionView layout:self alignmentItemsInSection:section];
    }
    if (alignment == TTCollectionItemAlignmentDefault) {
        // 什么也不用做
        return;
    }
    
    id<UICollectionViewDelegateFlowLayout> collectionDelegate =
    (id<UICollectionViewDelegateFlowLayout>)self.collectionView.delegate;
    
    // collection 整体的左右边距
    UIEdgeInsets collectionViewInset = self.collectionView.contentInset;
    
    // 该行左右边距
    UIEdgeInsets sectionInset = self.sectionInset;
    if ([collectionDelegate respondsToSelector:@selector(collectionView:layout:insetForSectionAtIndex:)]) {
        sectionInset = [collectionDelegate collectionView:self.collectionView
                                                   layout:self
                                   insetForSectionAtIndex:section];
    }
    
    CGFloat rowWidth = self.collectionView.bounds.size.width
                        - collectionViewInset.left - collectionViewInset.right
                        - sectionInset.left - sectionInset.right;
    CGFloat leftStart = sectionInset.left;
    
    // 该行 item 间距
    NSInteger itemSpacing = self.minimumInteritemSpacing;
    if ([collectionDelegate respondsToSelector:@selector(collectionView:layout:minimumInteritemSpacingForSectionAtIndex:)]) {
        itemSpacing = [collectionDelegate collectionView:self.collectionView
                                                  layout:self
                minimumInteritemSpacingForSectionAtIndex:section];
    }
    
    // 语言方向
    BOOL isRTL = NO;
    if ([self.delegate respondsToSelector:@selector(collectionView:layout:isRTLInSection:)]) {
        isRTL = [self.delegate collectionView:self.collectionView layout:self isRTLInSection:section];
    }
    
    // 根据 item 对齐方式，重新调整布局参数（1）
    if (alignment == TTCollectionItemAlignmentJustified) {
        if (attributes.count > 1) {
            // 两边对齐，需要重新计算 item 间距
            itemSpacing = (rowWidth - itemTotalWidth) / (attributes.count - 1.0);
        } else {
            // 只有一个 item 时，根据语言方向，让这单个 item 左对齐或右对齐
            if (isRTL) {
                alignment = TTCollectionItemAlignmentRight;
            } else {
                alignment = TTCollectionItemAlignmentLeft;
            }
        }
        
    } else if (alignment == TTCollectionItemAlignmentCenter) {
        // 居中，需要调整起点
        leftStart = leftStart + (rowWidth - itemTotalWidth - ((attributes.count - 1.0) * itemSpacing)) / 2.0;
        
    }
    
    // 根据 item 对齐方式，重新调整布局参数（2）
    if (alignment == TTCollectionItemAlignmentLeft) {
        // 什么也不用改
        
    } else if (alignment == TTCollectionItemAlignmentRight) {
        // 右对齐，需要调整起点
        leftStart = leftStart + (rowWidth - itemTotalWidth - ((attributes.count - 1.0) * itemSpacing));
        
    }
    
    // 重算布局
    __block CGFloat startX = leftStart;
    // 如果语言方向相反，需要反向遍历
    NSEnumerationOptions option = isRTL ? NSEnumerationReverse : 0;
    [attributes enumerateObjectsWithOptions:option usingBlock:^(UICollectionViewLayoutAttributes *att, NSUInteger idx, BOOL *stop) {
        CGRect frame = att.frame;
        frame.origin.x = startX;
        att.frame = frame;
        startX = startX + frame.size.width + itemSpacing;
    }];
}

@end
