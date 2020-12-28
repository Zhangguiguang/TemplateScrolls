//
//  TTViewTemplate.h
//  TemplateScrolls
//
//  Created by 张贵广 on 2020/12/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TTViewTemplate <ViewClass> : NSObject

/**
 视图的类型
 */
@property (nonatomic, strong) ViewClass viewClass;

/**
 视图的数据
 */
@property (nonatomic, strong) id data;

/**
 视图的固定宽度
 */
@property (nonatomic, assign) CGFloat width;

/**
 视图的固定高度
 */
@property (nonatomic, assign) CGFloat height;

@end

@interface TTCellTemplate <ViewClass, CellType> : TTViewTemplate <ViewClass>

/**
 可配置该 Cell 的UI渲染
 @discussion 该 block 会在 ConfigTableViewCell.refreshUI 之后执行
 */
@property (nonatomic, copy) void (^refreshUI)(NSIndexPath *indexPath, id data, CellType me);

/**
 可配置该 Cell 将出现时的事件
 */
@property (nonatomic, copy) void (^willDisplay)(NSIndexPath *indexPath, id data, CellType me);

/**
 可配置该 Cell 被点击时的事件
 */
@property (nonatomic, copy) void (^didSelect)(NSIndexPath *indexPath, id data);

@end




NS_ASSUME_NONNULL_END
