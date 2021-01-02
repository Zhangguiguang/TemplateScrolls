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

/**
 Cell 的配置类
 */
@interface TTCellTemplate <CellClass, UICellType> : TTViewTemplate <CellClass>

/**
 可配置该 Cell 将出现时的事件
 */
@property (nonatomic, copy) void (^willDisplay)(NSIndexPath *indexPath, __nullable id data, __kindof UICellType me);

/**
 可配置该 Cell 被点击时的事件
 */
@property (nonatomic, copy) void (^didSelect)(NSIndexPath *indexPath, __nullable id data);

@end

/**
 Header Footer 的配置类
 */
@interface TTReusableViewTemplate <ViewClass, UIViewType> : TTViewTemplate <ViewClass>

/**
 可配置该 View 将出现时的事件
 */
@property (nonatomic, copy) void (^willDisplay)(NSInteger section, __nullable id data, __kindof UIView *me);


@end



@interface TTSectionTemplate <CellTemplate, ResuableViewTemplate> : NSObject

@property (null_resettable, nonatomic, strong) ResuableViewTemplate header;
@property (null_resettable, nonatomic, strong) ResuableViewTemplate footer;

@property (nonatomic, readonly) NSMutableArray<CellTemplate> *cellArray;

@end


@protocol _TTSectionObserver <NSObject>

- (void)section:(TTSectionTemplate *)section didInsertCells:(NSArray<TTCellTemplate *> *)objects atIndexes:(NSIndexSet *)indexes;
- (void)section:(TTSectionTemplate *)section didRemoveCells:(NSArray<TTCellTemplate *> *)objects atIndexes:(NSIndexSet *)indexes;
- (void)section:(TTSectionTemplate *)section didReplaceCells:(NSArray<TTCellTemplate *> *)objects atIndexes:(NSIndexSet *)indexes;

@end


NS_ASSUME_NONNULL_END
