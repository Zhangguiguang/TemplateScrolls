//
//  TTTableView.h
//  TemplateScrolls
//
//  Created by 张贵广 on 2020/12/29.
//

#import <UIKit/UIKit.h>
#import "TTViewTemplate.h"
#import "TTScrollProtocol.h"

NS_ASSUME_NONNULL_BEGIN

typedef NSMutableArray<TTSectionTemplate *> TTTableTemplateArray;

@interface TTTableView : UITableView <TTTemplateArrayOperator>

/**
 只需要配置这个模板数组，tableView 就会自动渲染数据
 */
@property (nonatomic, readonly) TTTableTemplateArray *sections;

// 这两个代理的部分代理方法，是无效的，被内部强制实现了
@property (nonatomic, weak, nullable) id <UITableViewDataSource> additionalDataSource;
@property (nonatomic, weak, nullable) id <UITableViewDelegate> additionalDelegate;

/**
 Cell 出现时的回调，它的优先级比 template.willDisplay 低
 template.willDisplay > section.willDisplay > self.willDisplay > delegate.willDisplay
 */
@property (nonatomic, copy) TTCellWillDisplay willDisplay;

/**
 Cell 被点击的事件，它的优先级比 template.didSelect 低
 template.didSelect > section.didSelect > self.didSelect > delegate.didSelect
 */
@property (nonatomic, copy) TTCellDidSelect didSelect;


@end


@interface TTTableView (TTUnavailable)

// 自带的 insert、delete 不可用,
// 直接对 sections 及 cells 进行操作即可
// reload 方法没有数组操作，不影响使用
- (void)insertSections:(NSIndexSet *)sections
      withRowAnimation:(UITableViewRowAnimation)animation NS_UNAVAILABLE;
- (void)deleteSections:(NSIndexSet *)sections
      withRowAnimation:(UITableViewRowAnimation)animation NS_UNAVAILABLE;
- (void)moveSection:(NSInteger)section
          toSection:(NSInteger)newSection NS_UNAVAILABLE;

- (void)insertRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths
              withRowAnimation:(UITableViewRowAnimation)animation NS_UNAVAILABLE;
- (void)deleteRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths
              withRowAnimation:(UITableViewRowAnimation)animation NS_UNAVAILABLE;
- (void)moveRowAtIndexPath:(NSIndexPath *)indexPath
               toIndexPath:(NSIndexPath *)newIndexPath NS_UNAVAILABLE;

// 系统的 delegate 和 dataSouce 都是不可用的
// 如果有需要，使用 additionalDataSource 和 additionalDelegate
- (void)setDelegate:(nullable id<UITableViewDelegate>)delegate NS_UNAVAILABLE;
- (id<UITableViewDelegate>)delegate NS_UNAVAILABLE;
- (void)setDataSource:(nullable id<UITableViewDataSource>)dataSource NS_UNAVAILABLE;
- (id<UITableViewDataSource>)dataSource NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
