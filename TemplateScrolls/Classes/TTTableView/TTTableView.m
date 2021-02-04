//
//  TTTableView.m
//  TemplateScrolls
//
//  Created by 张贵广 on 2020/12/29.
//

#import "TTTableView.h"
#import "TTTableViewCell.h"
#import "TTTableReusableView.h"
#import <TTMutableArray/TTMutableArray.h>
#import <UITableView_FDTemplateLayoutCell/UITableView+FDTemplateLayoutCell.h>
#import "UIScrollView+TTTemplateArrayCommon.h"

@interface TTTableView () <TTMutableArrayObserver, _TTSectionObserver,
                        UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) TTTableTemplateArray *sections;

@end

@implementation TTTableView

@synthesize willDisplay = _willDisplay;
@synthesize didSelect   = _didSelect;

#pragma mark - Delegate、DataSource
@synthesize additionalDataSource = _outerDataSource;
@synthesize additionalDelegate = _outerDelegate;

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.delegate = self;
        self.dataSource = self;
        
        self.estimatedRowHeight = 44.0;
        self.estimatedSectionHeaderHeight = 44.0;
        self.estimatedSectionFooterHeight = 44.0;
    }
    return self;
}

#pragma mark - UITableViewDelegate, UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.sections[section].cells.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Class<TTCellProvider> provider = [self viewClassAtIndexPath:indexPath] ? : [TTTableViewCell class];
    id data = [self cellDataAtIndexPath:indexPath];
    return [provider dequeueCellWithListView:tableView forIndexPath:indexPath data:data];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    TTReusableViewTemplate *template = self.sections[section].header;
    Class<TTReusableViewProvider> provider = template.viewClass ? : [TTTableReusableView class];
    return [provider dequeueHeaderWithListView:tableView forSection:section data:template.data];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    TTReusableViewTemplate *template = self.sections[section].footer;
    Class<TTReusableViewProvider> provider = template.viewClass ? : [TTTableReusableView class];
    return [provider dequeueFooterWithListView:tableView forSection:section data:template.data];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat fixedHeight = [self heightAtIndexPath:indexPath];
    
    if (fixedHeight == TTViewAutomaticDimension) {
        // 继续向下执行
    } else if (fixedHeight > 0) {
        // 固定的高度
        return fixedHeight;
    }
    
    // 缓存的高度
    if ([tableView.fd_indexPathHeightCache existsHeightAtIndexPath:indexPath]) {
        return [tableView.fd_indexPathHeightCache heightForIndexPath:indexPath];
    }
    
    // 动态的高度
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    TTReusableViewTemplate *template = self.sections[section].header;
    return [self _tableView:tableView heightForReusableTemplate:template isHeader:YES];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    TTReusableViewTemplate *template = self.sections[section].footer;
    return [self _tableView:tableView heightForReusableTemplate:template isHeader:NO];
}
- (CGFloat)_tableView:(UITableView *)tableView
heightForReusableTemplate:(TTReusableViewTemplate *)template
             isHeader:(BOOL)isHeader {
    // 固定的高度
    if (template.height > 0) {
        return template.height;
    }
    
    if (template.viewClass == nil) {
        // 明确的不需要显示
        // 不能 return 0, 否则在 UITableViewStyleGroup 样式下，顶部有一段间距
        // https://blog.csdn.net/LXL_815520/article/details/51799370
        return CGFLOAT_MIN;
    }
    
    // 动态高度
    Class<TTReusableViewProvider> provider = template.viewClass ? : TTTableReusableView.class;
    NSString *identifier = isHeader ? [provider headerIdentifier] : [provider footerIdentifier];
    return [tableView fd_heightForHeaderFooterViewWithIdentifier:identifier configuration:^(TTTableReusableView *headerFooterView) {
        headerFooterView.data = template.data;
    }];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath {
    TTCellWillDisplay willDisplay = [self willDisplayAtIndexPath:indexPath];
    if (willDisplay) {
        id data = [self cellDataAtIndexPath:indexPath];
        willDisplay(indexPath, data, cell);
        return;
    }
    if ([_outerDelegate respondsToSelector:@selector(tableView:willDisplayCell:forRowAtIndexPath:)]) {
        [_outerDelegate tableView:tableView willDisplayCell:cell forRowAtIndexPath:indexPath];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view
       forSection:(NSInteger)section {
    TTReusableViewTemplate *template = self.sections[section].header;
    if (template.willDisplay) {
        template.willDisplay(section, template.data, view);
        return;
    }
    if ([_outerDelegate respondsToSelector:@selector(tableView:willDisplayHeaderView:forSection:)]) {
        [_outerDelegate tableView:tableView willDisplayHeaderView:view forSection:section];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view
       forSection:(NSInteger)section {
    TTReusableViewTemplate *template = self.sections[section].footer;
    if (template.willDisplay) {
        template.willDisplay(section, template.data, view);
        return;
    }
    if ([_outerDelegate respondsToSelector:@selector(tableView:willDisplayFooterView:forSection:)]) {
        [_outerDelegate tableView:tableView willDisplayFooterView:view forSection:section];
    }
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath {
    // 处理高度存储的逻辑
    do {
        // Cell 是否还继续存在于列表中
        BOOL isCellKeepExist = self.sections.count > indexPath.section
        && self.sections[indexPath.section].cells.count > indexPath.row;
        
        if (!isCellKeepExist) {
            break;
        }
        
        TTCellTemplate *template = [self cellTemplateAtIndexPath:indexPath];
        
        if (template.height > 0) {
            break;
        }
        
        if ([tableView.fd_indexPathHeightCache existsHeightAtIndexPath:indexPath]) {
            // 如果之前存储过有效的高度，那就不要再更新高度了
            // 实际运行时出现过前面已经计算了正确的高度，结果后来又进入这个方法，存储了一个错误的高度
            break;
        }
        
        // 保存系统适配的动态高度
        [tableView.fd_indexPathHeightCache cacheHeight:CGRectGetHeight(cell.bounds)
                                           byIndexPath:indexPath];
        
    } while (0);
    
    if ([_outerDelegate respondsToSelector:@selector(tableView:didEndDisplayingCell:forRowAtIndexPath:)]) {
        [_outerDelegate tableView:tableView didEndDisplayingCell:cell forRowAtIndexPath:indexPath];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TTCellDidSelect didSelect = [self didSelectAtIndexPath:indexPath];
    if (didSelect) {
        id data = [self cellDataAtIndexPath:indexPath];
        didSelect(indexPath, data);
        return;
    }
    if ([_outerDelegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)]) {
        [_outerDelegate tableView:tableView didSelectRowAtIndexPath:indexPath];
    }
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.allowsMultipleSelection == NO) {
        // 如果不允许多选，直接按系统默认行为处理
        return indexPath;
    }
    
    TTSectionTemplate *template = self.sections[indexPath.section];
    if (template.allowsMultipleSelection) {
        // 允许多选，也不需要其他处理
        return indexPath;
    }
    
    // section 不允许多选，需要把已选中的取消掉
    NSArray *sectionSelected = [self indexPathsForSelectedCellsInSection:indexPath.section];
    [sectionSelected enumerateObjectsUsingBlock:^(NSIndexPath *obj, NSUInteger idx, BOOL *stop) {
        [tableView deselectRowAtIndexPath:obj animated:NO];
    }];
    
    // 选中当前行
    return indexPath;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    TTSectionTemplate *template = self.sections[indexPath.section];
    if (template.forceSelection == NO) {
        // 不强制选中，可以取消
        return indexPath;
    }
    
    NSArray *sectionSelected = [self indexPathsForSelectedCellsInSection:indexPath.section];
    if (sectionSelected.count <= 1) {
        // 只有一条选中，不允许取消
        [tableView selectRowAtIndexPath:indexPath animated:NO
                         scrollPosition:UITableViewScrollPositionNone];
        return nil;
    }
    
    return indexPath;
}

#pragma mark - TTTemplateArrayOperator

- (TTTableTemplateArray *)sections {
    if (!_sections) {
        TTMutableArray *temp = [TTMutableArray new];
        temp.observer = self;
        _sections = temp;
    }
    return _sections;
}

- (NSArray<NSIndexPath *> *)indexPathsForSelectedCells {
    return [self indexPathsForSelectedRows];
}

#pragma mark - TTMutableArrayObserver

- (void)mutableArray:(NSMutableArray *)array
    didInsertObjects:(NSArray<TTSectionTemplate *> *)objects
           atIndexes:(NSIndexSet *)indexes {
    [self _setObserverForSections:objects observer:self];
    [self insertSections:indexes withRowAnimation:UITableViewRowAnimationNone];
}

- (void)mutableArray:(NSMutableArray *)array
    didRemoveObjects:(NSArray *)objects
           atIndexes:(NSIndexSet *)indexes {
    [self _setObserverForSections:objects observer:nil];
    [self deleteSections:indexes withRowAnimation:UITableViewRowAnimationNone];
}

- (void)mutableArray:(NSMutableArray *)array
   didReplaceObjects:(NSArray<TTSectionTemplate *> *)objects
           atIndexes:(NSIndexSet *)indexes {
    [self _setObserverForSections:objects observer:self];
    [self reloadSections:indexes withRowAnimation:UITableViewRowAnimationNone];
}

- (void)mutableArray:(NSMutableArray *)array
   beReplacedObjects:(NSArray *)objects
           atIndexes:(NSIndexSet *)indexes {
    [self _setObserverForSections:objects observer:nil];
}

- (void)_setObserverForSections:(NSArray<TTSectionTemplate *> *)sections
                       observer:(id<_TTSectionObserver>)observer {
    [sections makeObjectsPerformSelector:@selector(setObserver:) withObject:observer];
}

#pragma mark - _TTSectionObserver

- (void)section:(TTSectionTemplate *)section
 didInsertCells:(NSArray<TTCellTemplate *> *)objects
      atIndexes:(NSIndexSet *)indexes {
    NSArray *indexPaths = [self _indexPathsFromSection:section indexes:indexes];
    if (indexPaths.count > 0) {
        [self insertRowsAtIndexPaths:indexPaths
                    withRowAnimation:UITableViewRowAnimationNone];
    }
}

- (void)section:(TTSectionTemplate *)section
 didRemoveCells:(NSArray<TTCellTemplate *> *)objects
      atIndexes:(NSIndexSet *)indexes {
    NSArray *indexPaths = [self _indexPathsFromSection:section indexes:indexes];
    if (indexPaths.count > 0) {
        [self deleteRowsAtIndexPaths:indexPaths
                    withRowAnimation:UITableViewRowAnimationNone];
    }
}

- (void)section:(TTSectionTemplate *)section
didReplaceCells:(NSArray<TTCellTemplate *> *)objects
      atIndexes:(NSIndexSet *)indexes {
    NSArray *indexPaths = [self _indexPathsFromSection:section indexes:indexes];
    if (indexPaths.count > 0) {
        [self reloadRowsAtIndexPaths:indexPaths
                    withRowAnimation:UITableViewRowAnimationNone];
    }
}

- (nullable NSArray<NSIndexPath *> *)_indexPathsFromSection:(TTSectionTemplate *)section
                                           indexes:(NSIndexSet *)indexes {
    __block NSInteger s = [self.sections indexOfObject:section];
    if (s == NSNotFound) {
        return nil;
    }
    NSMutableArray<NSIndexPath *> *indexPaths = [NSMutableArray arrayWithCapacity:indexes.count];
    [indexes enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL * _Nonnull stop) {
        [indexPaths addObject:[NSIndexPath indexPathForRow:idx inSection:s]];
    }];
    return [indexPaths copy];
}

@end
