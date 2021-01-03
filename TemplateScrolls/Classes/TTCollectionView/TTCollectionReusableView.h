//
//  TTCollectionReusableView.h
//  TemplateScrolls
//
//  Created by 张贵广 on 2021/01/03.
//

#import <UIKit/UIKit.h>
#import "TTScrollProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface TTCollectionReusableView : UICollectionReusableView <TTCollectionReusableViewProvider>

- (void)setData:(id _Nullable)data NS_REQUIRES_SUPER;

@property (nonatomic, readonly) UICollectionView *collectionView;

/**
 实际上这是自定义的属性
 添加这个属性是为了与 CollectionCell 、TableCell/HeaderFooter 在代码样式上【可以】保持一致性
 @discussion 该属性是直接 return self;
 */
@property (nonatomic, readonly) UIView *contentView;

@end

NS_ASSUME_NONNULL_END
