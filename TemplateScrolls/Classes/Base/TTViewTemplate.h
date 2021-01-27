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

/**
 如果要修改数据，并刷新视图，可以使用这个方法，将所有的修改放入到 block 中
 */
- (void)updateView:(void (^)(TTCellTemplate *tt))block;

@end

/**
 Header Footer 的配置类
 */
@interface TTReusableViewTemplate <ViewClass, UIViewType> : TTViewTemplate <ViewClass>

/**
 可配置该 View 将出现时的事件
 */
@property (nonatomic, copy) void (^willDisplay)(NSInteger section, __nullable id data, __kindof UIView *me);

// 不支持
//- (void)updateView:(void (^)(TTReusableViewTemplate *tt))block;

@end



@interface TTSectionTemplate <CellTemplate, ReusableViewTemplate> : NSObject

@property (null_resettable, nonatomic, strong) ReusableViewTemplate header;
@property (null_resettable, nonatomic, strong) ReusableViewTemplate footer;

@property (nonatomic, readonly) NSMutableArray<CellTemplate> *cellArray;

/**
 可以设置该 Section 的元素单选\多选
 Default NO
 @discussion 与 [table|collection]View.allowsMultipleSelection 功能类似，
 不同的是，该属性只对该 section 有效，不影响其他 section
 
 但是 view.allowsMultipleSelection 会作为一个总开关的存在，它为 NO 时，
 所有 section.allowsMultipleSelection 都会失效，
 整个 [table|collection]View 都只能选择一个 item
 */
@property (nonatomic, assign) BOOL allowsMultipleSelection;

/**
 强制选中（至少要选中一个）
 */
@property (nonatomic, assign) BOOL forceSelection;

@end


@interface TTCollectionSectionTemplate <CellTemplate, ReusableViewTemplate> : TTSectionTemplate <CellTemplate, ReusableViewTemplate>

@property (nonatomic, assign) UIEdgeInsets insets;

@property (nonatomic, assign) CGFloat horizontalSpacing;

@property (nonatomic, assign) CGFloat veritcalSpacing;

@end


@protocol _TTSectionObserver <NSObject>

- (void)section:(TTSectionTemplate *)section didInsertCells:(NSArray<TTCellTemplate *> *)objects atIndexes:(NSIndexSet *)indexes;
- (void)section:(TTSectionTemplate *)section didRemoveCells:(NSArray<TTCellTemplate *> *)objects atIndexes:(NSIndexSet *)indexes;
- (void)section:(TTSectionTemplate *)section didReplaceCells:(NSArray<TTCellTemplate *> *)objects atIndexes:(NSIndexSet *)indexes;

@end


@protocol TTTemplateArrayOperator <NSObject>

@required
@property (nonatomic, readonly) NSMutableArray *templateArray;

@optional

- (void)insertSections:(NSIndexSet *)indexes withTemplates:(NSArray<TTSectionTemplate *> *)tts;
- (void)reloadSections:(NSIndexSet *)indexes withTemplates:(NSArray<TTSectionTemplate *> *)tts;
- (void)deleteSections:(NSIndexSet *)indexes;

- (void)insertSection:(NSInteger)section withTemplate:(TTSectionTemplate *)tt;
- (void)reloadSection:(NSInteger)section withTemplate:(TTSectionTemplate *)tt;
- (void)deleteSection:(NSInteger)section;

- (void)insertCells:(NSArray<NSIndexPath *> *)indexPaths withTemplates:(NSArray<TTCellTemplate *> *)cells;
- (void)reloadCells:(NSArray<NSIndexPath *> *)indexPaths withTemplates:(NSArray<TTCellTemplate *> *)cells;

/**
 刷新 Cell, 但是并不需要修改数据
 */
- (void)reloadCells:(NSArray<NSIndexPath *> *)indexPaths;

/**
 删除指定位置的 Cell
 @params needDelete 如果删除的 cell 所在 section 中所有元素被删光了，是否要将整个 section 移除
 */
- (void)deleteCells:(NSArray<NSIndexPath *> *)indexPaths deleteSection:(BOOL)needDelete;

- (TTReusableViewTemplate *)headerAtSection:(NSInteger)section;
- (TTReusableViewTemplate *)footerAtSection:(NSInteger)section;
- (TTCellTemplate *)cellTemplateAtIndexPath:(NSIndexPath *)indexPath;
- (id)cellDataAtIndexPath:(NSIndexPath *)indexPath;

#pragma mark - Selection

/**
 获取所有被选中的 Cell 的下标
 */
- (NSArray<NSIndexPath *> *)indexPathsForSelectedCells;

/**
 获取指定 section 中被选中的 Cell 的下标
 */
- (NSArray<NSIndexPath *> *)indexPathsForSelectedCellsInSection:(NSInteger)section;

/**
 获取所有被选中的 Cell 的数据
 */
- (NSArray *)datasForSelectedCells;

/**
 获取指定 section 中被选中的 Cell 的数据
 */
- (NSArray *)datasForSelectedCellsInSection:(NSInteger)section;

@end


NS_ASSUME_NONNULL_END
