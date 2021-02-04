//
//  TTCollectionView.h
//  TemplateScrolls
//
//  Created by 张贵广 on 2020/12/29.
//

#import <UIKit/UIKit.h>
#import "TTViewTemplate.h"
#import "TTScrollProtocol.h"
#import "TTCollectionViewLayout.h"

NS_ASSUME_NONNULL_BEGIN

typedef NSMutableArray<TTSectionTemplate *> TTCollectionTemplateArray;

@interface TTCollectionView : UICollectionView <TTTemplateArrayOperator>

@property (nonatomic, readonly) TTCollectionViewLayout *layout;

/**
 只需要配置这个配置数组，collectionView 就会自动渲染数据
 */
@property (nonatomic, readonly) TTCollectionTemplateArray *sections;

// 这两个代理的部分代理方法，是无效的，被内部强制实现了
@property (nonatomic, weak, nullable) id <UICollectionViewDataSource> additionalDataSource;
@property (nonatomic, weak, nullable) id <TTCollectionViewDelegateFlowLayout> additionalDelegate;

@end


@interface TTCollectionView (TTUnavailable)

/**
 不接受自定义 layout
 */
- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout NS_UNAVAILABLE;

// 系统的 delegate 和 dataSouce 都是不可用的
// 如果有需要，使用 additionalDataSource 和 additionalDelegate
- (void)setDelegate:(nullable id<UICollectionViewDelegate>)delegate NS_UNAVAILABLE;
- (id<UICollectionViewDelegate>)delegate NS_UNAVAILABLE;
- (void)setDataSource:(nullable id<UICollectionViewDataSource>)dataSource NS_UNAVAILABLE;
- (id<UICollectionViewDataSource>)dataSource NS_UNAVAILABLE;

- (UICollectionViewLayout *)collectionViewLayout NS_UNAVAILABLE;
- (void)setCollectionViewLayout:(UICollectionViewLayout *)collectionViewLayout NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
