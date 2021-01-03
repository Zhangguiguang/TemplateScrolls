//
//  TTCollectionViewLayout.h
//  TemplateScrolls
//
//  Created by 张贵广 on 2021/01/03.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 Collection Section 里面的 Item 的对齐方式
 */
typedef NS_ENUM(NSInteger, TTCollectionItemAlignment) {
    TTCollectionItemAlignmentDefault,       // ...FlowLayout 默认行为，我也不清楚
    TTCollectionItemAlignmentLeft,          // 左对齐
    TTCollectionItemAlignmentRight,         // 右对齐
    TTCollectionItemAlignmentCenter,        // 往中间靠拢居中
    TTCollectionItemAlignmentJustified,     // 左右两端对齐
};


@class TTCollectionViewLayout;
@protocol TTCollectionViewDelegateFlowLayout <UICollectionViewDelegateFlowLayout>

@optional
/**
 设置每一组 Section 内的 Item 在行内的对齐方式
 Default TTCollectionItemAlignmentDefault
 */
- (TTCollectionItemAlignment)collectionView:(UICollectionView *)collectionView
                                     layout:(TTCollectionViewLayout *)layout
                    alignmentItemsInSection:(NSInteger)section;

/**
 获取 Section 的 Item 的排列顺序
 Default NO 从左往右排 →
 */
- (BOOL)collectionView:(UICollectionView *)collectionView
                layout:(TTCollectionViewLayout *)layout
        isRTLInSection:(NSInteger)section;

@end



@interface TTCollectionViewLayout : UICollectionViewFlowLayout

@property (nonatomic, weak) id<TTCollectionViewDelegateFlowLayout> delegate;

@end

NS_ASSUME_NONNULL_END
