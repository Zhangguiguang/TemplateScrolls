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
 只需要配置这个配置数组，tableView 就会自动渲染数据
 */
@property (nonatomic, readonly) TTTableTemplateArray *sections;

// 这两个代理的部分代理方法，是无效的，被内部强制实现了
@property (nonatomic, weak, nullable) id <UITableViewDataSource> additionalDataSource;
@property (nonatomic, weak, nullable) id <UITableViewDelegate> additionalDelegate;

@end


@interface TTTableView (TTUnavailable)

// 系统的 delegate 和 dataSouce 都是不可用的
// 如果有需要，使用 additionalDataSource 和 additionalDelegate
- (void)setDelegate:(nullable id<UITableViewDelegate>)delegate NS_UNAVAILABLE;
- (id<UITableViewDelegate>)delegate NS_UNAVAILABLE;
- (void)setDataSource:(nullable id<UITableViewDataSource>)dataSource NS_UNAVAILABLE;
- (id<UITableViewDataSource>)dataSource NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
