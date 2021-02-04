//
//  TTViewTemplate.h
//  TemplateScrolls
//
//  Created by 张贵广 on 2020/12/25.
//

#import <Foundation/Foundation.h>
#import <TTCollectionViewLayout.h>
#import <TTScrollProtocol.h>

#define TTChainPropertyStatement(ClassName, modifier, propType, propName)   \
@property (nonatomic, modifier) propType propName;                          \
- (__kindof ClassName * (^)(propType))propName##Set;

#define TTChainPropertyImplement(ClassName, propType, propName)     \
- (__kindof ClassName *(^)(propType))propName##Set {                \
    return ^ClassName *(propType propName) {                        \
        self.propName = propName;                                   \
        return self;                                                \
    };                                                              \
}

NS_ASSUME_NONNULL_BEGIN

/**
 cell 的默认尺寸是 0
 cell 如果是 0, 它不能覆盖 section 所设置的统一尺寸
 但是 TTViewAutomaticDimension 可以覆盖
 */
UIKIT_EXTERN const CGFloat TTViewAutomaticDimension;

typedef void (^TTCellWillDisplay)(NSIndexPath *indexPath, __nullable id data, __kindof UIView *me);
typedef void (^TTCellDidSelect)(NSIndexPath *indexPath, __nullable id data);
typedef void (^TTReusableViewWillDisplay)(NSInteger section, __nullable id data, __kindof UIView *me);


/**
 Cell 的配置类
 */
@interface TTCellTemplate : NSObject

@property (nonatomic, readonly, class) TTCellTemplate *make;

// Cell 可配置的属性，支持链式语法
TTChainPropertyStatement(TTCellTemplate, strong, Class<TTCellProvider>, viewClass);
TTChainPropertyStatement(TTCellTemplate, strong, id, data);
TTChainPropertyStatement(TTCellTemplate, assign, CGFloat, width);
TTChainPropertyStatement(TTCellTemplate, assign, CGFloat, height);

/**
 可配置该 Cell 将出现时的事件
 */
@property (nonatomic, copy) TTCellWillDisplay willDisplay;

/**
 可配置该 Cell 被点击时的事件
 */
@property (nonatomic, copy) TTCellDidSelect didSelect;

/**
 如果要修改数据，并刷新视图，可以使用这个方法，将所有的修改放入到 block 中
 */
- (void)updateView:(void (^)(TTCellTemplate *tt))block;

@end




/**
 Header Footer 的配置类
 */
@interface TTReusableViewTemplate : NSObject

@property (nonatomic, readonly, class) TTReusableViewTemplate *make;

// Header Footer 可配置的属性，支持链式语法
TTChainPropertyStatement(TTReusableViewTemplate, strong, Class<TTReusableViewProvider>, viewClass);
TTChainPropertyStatement(TTReusableViewTemplate, strong, id, data);
TTChainPropertyStatement(TTReusableViewTemplate, assign, CGFloat, height);

/**
 可配置该 View 将出现时的事件
 */
@property (nonatomic, copy) TTReusableViewWillDisplay willDisplay;

// 不支持
//- (void)updateView:(void (^)(TTReusableViewTemplate *tt))block;

@end



@interface TTSectionTemplate : NSObject

@property (nonatomic, readonly, class) TTSectionTemplate *make;

// Section 支持一套默认的 Cell 配置
TTChainPropertyStatement(TTSectionTemplate, strong, Class<TTCellProvider>, viewClass);
TTChainPropertyStatement(TTSectionTemplate, strong, id, data);
TTChainPropertyStatement(TTSectionTemplate, assign, CGFloat, width);
TTChainPropertyStatement(TTSectionTemplate, assign, CGFloat, height);
@property (nonatomic, copy) TTCellWillDisplay willDisplay;
@property (nonatomic, copy) TTCellDidSelect didSelect;


@property (null_resettable, nonatomic, strong) TTReusableViewTemplate *header;
@property (null_resettable, nonatomic, strong) TTReusableViewTemplate *footer;

@property (nonatomic, readonly) NSMutableArray<TTCellTemplate *> *cells;

/**
 可以设置该 Section 的元素单选\多选
 Default NO
 @discussion 与 [table|collection]View.allowsMultipleSelection 功能类似，
 不同的是，该属性只对该 section 有效，不影响其他 section
 
 但是 view.allowsMultipleSelection 会作为一个总开关的存在，它为 NO 时，
 所有 section.allowsMultipleSelection 都会失效，
 整个 [table|collection]View 都只能选择一个 item
 */
TTChainPropertyStatement(TTSectionTemplate, assign, BOOL, allowsMultipleSelection);

/**
 强制选中（至少要选中一个）
 */
TTChainPropertyStatement(TTSectionTemplate, assign, BOOL, forceSelection);


#pragma mark - CollectionView Usable
TTChainPropertyStatement(TTSectionTemplate, assign, UIEdgeInsets, insets);
TTChainPropertyStatement(TTSectionTemplate, assign, CGFloat, horizontalSpacing);
TTChainPropertyStatement(TTSectionTemplate, assign, CGFloat, verticalSpacing);
TTChainPropertyStatement(TTSectionTemplate, assign, TTCollectionItemAlignment, alignment);

@end


@protocol _TTSectionObserver <NSObject>

- (void)section:(TTSectionTemplate *)section didInsertCells:(NSArray<TTCellTemplate *> *)objects atIndexes:(NSIndexSet *)indexes;
- (void)section:(TTSectionTemplate *)section didRemoveCells:(NSArray<TTCellTemplate *> *)objects atIndexes:(NSIndexSet *)indexes;
- (void)section:(TTSectionTemplate *)section didReplaceCells:(NSArray<TTCellTemplate *> *)objects atIndexes:(NSIndexSet *)indexes;

@end


@protocol TTTemplateArrayOperator <NSObject>

@required
@property (nonatomic, readonly) NSMutableArray<TTSectionTemplate *> *sections;

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
