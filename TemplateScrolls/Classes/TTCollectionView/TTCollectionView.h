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

typedef TTCellTemplate<Class<TTCollectionCellProvider>, UICollectionViewCell *> TTCollectionCellTemplate;
typedef TTReusableViewTemplate<Class<TTCollectionReusableViewProvider>, UICollectionReusableView *> TTCollectionReusableViewTemplate;
typedef TTCollectionSectionTemplate<TTCollectionCellTemplate *, TTCollectionReusableViewTemplate *> TTCollectionSectionTemplate2;
typedef NSMutableArray<TTCollectionSectionTemplate2 *> TTCollectionTemplateArray;

@interface TTCollectionView : UICollectionView <TTTemplateArrayOperator>

@property (nonatomic, readonly) TTCollectionViewLayout *layout;

/**
 只需要配置这个模板数组，collectionView 就会自动渲染数据
 */
@property (nonatomic, readonly) TTCollectionTemplateArray *templateArray;

// 这两个代理的部分代理方法，是无效的，被内部强制实现了
@property (nonatomic, weak, nullable) id <UICollectionViewDataSource> additionalDataSource;
@property (nonatomic, weak, nullable) id <TTCollectionViewDelegateFlowLayout> additionalDelegate;

/**
 Cell 出现时的回调，它的优先级比 template.willDisplay 低
 template.willDisplay > self.willDisplay > delegate.willDisplay
 */
@property (nonatomic, copy) void (^willDisplay)(NSIndexPath *indexPath, id data, __kindof UICollectionViewCell *me);

/**
 Cell 被点击的事件，它的优先级比 template.didSelect 低
 template.didSelect > self.didSelect > delegate.didSelect
 */
@property (nonatomic, copy) void (^didSelect)(NSIndexPath *indexPath, id data);

@end


@interface TTCollectionView (TTUnavailable)

/**
 不接受自定义 layout
 */
- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout NS_UNAVAILABLE;

// 自带的 insert、delete 不可用,
// 直接对 templateArray 及 cellArray 进行操作即可
// reload 方法没有数组操作，不影响使用
- (void)insertSections:(NSIndexSet *)sections NS_UNAVAILABLE;
- (void)moveSection:(NSInteger)section toSection:(NSInteger)newSection NS_UNAVAILABLE;

- (void)insertItemsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths NS_UNAVAILABLE;
- (void)moveItemAtIndexPath:(NSIndexPath *)indexPath toIndexPath:(NSIndexPath *)newIndexPath NS_UNAVAILABLE;

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
