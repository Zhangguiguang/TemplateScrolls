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

typedef TTCellTemplate<Class<TTTableCellProvider>, UITableViewCell *> TTTableCellTemplate;
typedef TTReusableViewTemplate<Class<TTTableReusableViewProvider>, UITableViewHeaderFooterView *> TTTableReusableViewTemplate;
typedef TTSectionTemplate<TTTableCellTemplate *, TTTableReusableViewTemplate *> TTTableSectionTemplate;
typedef NSMutableArray<TTTableSectionTemplate *> TTTableTemplateArray;

@interface TTTableView : UITableView

/**
 只需要配置这个模板数组，tableView 就会自动渲染数据
 */
@property (nonatomic, readonly) TTTableTemplateArray *templateArray;

// 这两个代理的部分代理方法，是无效的，被内部强制实现了
@property (nonatomic, weak, nullable) id <UITableViewDataSource> additionalDataSource;
@property (nonatomic, weak, nullable) id <UITableViewDelegate> additionalDelegate;
// 系统的 delegate 和 dataSouce 都是不可用的
- (void)setDelegate:(nullable id<UITableViewDelegate>)delegate NS_UNAVAILABLE;
- (id<UITableViewDelegate>)delegate NS_UNAVAILABLE;
- (void)setDataSource:(nullable id<UITableViewDataSource>)dataSource NS_UNAVAILABLE;
- (id<UITableViewDataSource>)dataSource NS_UNAVAILABLE;

/**
 Cell 出现时的回调，它的优先级比 template.willDisplay 低
 template.willDisplay > self.willDisplay > delegate.willDisplay
 */
@property (nonatomic, copy) void (^willDisplay)(NSIndexPath *indexPath, id data, __kindof UITableViewCell *me);

/**
 Cell 被点击的事件，它的优先级比 template.didSelect 低
 template.didSelect > self.didSelect > delegate.didSelect
 */
@property (nonatomic, copy) void (^didSelect)(NSIndexPath *indexPath, id data);

@end

NS_ASSUME_NONNULL_END
