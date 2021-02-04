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
#import "NSArray+TTIndexPathValue.h"

@interface TTTableView () <TTMutableArrayObserver, _TTSectionObserver,
                        UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) TTTableTemplateArray *sections;

@end

@implementation TTTableView

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
    TTCellTemplate *template = [self cellTemplateAtIndexPath:indexPath];
    Class<TTCellProvider> provider = [self.sections tt_viewClassAtIndexPath:indexPath] ? : [TTTableViewCell class];
    
    TTTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[provider cellIdentifier] forIndexPath:indexPath];
    cell.data = template.data;
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    TTReusableViewTemplate *template = self.sections[section].header;
    Class<TTReusableViewProvider> provider = template.viewClass ? : [TTTableReusableView class];
    TTTableReusableView *reuseView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:[provider headerIdentifier]];
    reuseView.data = template.data;
    return reuseView;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    TTReusableViewTemplate *template = self.sections[section].footer;
    Class<TTReusableViewProvider> provider = template.viewClass ? : [TTTableReusableView class];
    TTTableReusableView *reuseView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:[provider footerIdentifier]];
    reuseView.data = template.data;
    return reuseView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat fixedHeight = [self.sections tt_heightAtIndexPath:indexPath];
    
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
    TTCellTemplate *template = [self cellTemplateAtIndexPath:indexPath];
    if (template.willDisplay) {
        template.willDisplay(indexPath, template.data, cell);
        return;
    }
    TTSectionTemplate *section = self.sections[indexPath.section];
    if (section.willDisplay) {
        section.willDisplay(indexPath, template.data, cell);
        return;
    }
    if (self.willDisplay) {
        self.willDisplay(indexPath, template.data, cell);
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
    TTCellTemplate *template = [self cellTemplateAtIndexPath:indexPath];
    if (template.didSelect) {
        template.didSelect(indexPath, template.data);
        return;
    }
    TTSectionTemplate *section = self.sections[indexPath.section];
    if (section.didSelect) {
        section.didSelect(indexPath, template.data);
        return;
    }
    if (self.didSelect) {
        self.didSelect(indexPath, template.data);
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

- (void)insertSections:(NSIndexSet *)indexes withTemplates:(NSArray<TTSectionTemplate *> *)tts {
    [self.sections insertObjects:tts atIndexes:indexes];
}
- (void)reloadSections:(NSIndexSet *)indexes withTemplates:(NSArray<TTSectionTemplate *> *)tts {
    [self.sections replaceObjectsAtIndexes:indexes withObjects:tts];
}
- (void)deleteSections:(NSIndexSet *)indexes {
    [self.sections removeObjectsAtIndexes:indexes];
}

- (void)insertSection:(NSInteger)section withTemplate:(TTSectionTemplate *)tt {
    [self.sections insertObject:tt atIndex:section];
}
- (void)reloadSection:(NSInteger)section withTemplate:(TTSectionTemplate *)tt {
    [self.sections replaceObjectAtIndex:section withObject:tt];
}
- (void)deleteSection:(NSInteger)section {
    [self.sections removeObjectAtIndex:section];
}

- (void)insertCells:(NSArray<NSIndexPath *> *)indexPaths withTemplates:(NSArray<TTCellTemplate *> *)cells {
    [self beginUpdates];
    [cells enumerateObjectsUsingBlock:^(TTCellTemplate *cell, NSUInteger idx, BOOL *stop) {
        if (indexPaths.count <= idx) {
            *stop = YES; return; // == break
        }
        NSIndexPath *ip = indexPaths[idx];
        [self.sections[ip.section].cells insertObject:cell atIndex:ip.row];
    }];
    [self endUpdates];
}

- (void)reloadCells:(NSArray<NSIndexPath *> *)indexPaths withTemplates:(NSArray<TTCellTemplate *> *)cells {
    [self beginUpdates];
    [cells enumerateObjectsUsingBlock:^(TTCellTemplate *cell, NSUInteger idx, BOOL *stop) {
        if (indexPaths.count <= idx) {
            *stop = YES; return; // == break
        }
        NSIndexPath *ip = indexPaths[idx];
        [self.sections[ip.section].cells replaceObjectAtIndex:ip.row withObject:cell];
    }];
    [self endUpdates];
}

- (void)reloadCells:(NSArray<NSIndexPath *> *)indexPaths {
    [self reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
}

- (void)deleteCells:(NSArray<NSIndexPath *> *)indexPaths deleteSection:(BOOL)needDelete {
    [self beginUpdates];
    if (indexPaths.count == 1) {
        NSIndexPath *ip = indexPaths.firstObject;
        [self.sections[ip.section].cells removeObjectAtIndex:ip.row];
        
        if (needDelete && self.sections[ip.section].cells.count == 0) {
            [self.sections removeObjectAtIndex:ip.section];
        }
        
    } else {
        NSMutableDictionary<NSNumber *, NSMutableIndexSet *> *section_indexes_pair = [NSMutableDictionary dictionary];
        [indexPaths enumerateObjectsUsingBlock:^(NSIndexPath *obj, NSUInteger idx, BOOL *stop) {
            NSMutableIndexSet *indexSet = section_indexes_pair[@(obj.section)];
            if (!indexSet) {
                indexSet = [NSMutableIndexSet indexSet];
                section_indexes_pair[@(obj.section)] = indexSet;
            }
            [indexSet addIndex:obj.row];
        }];
        
        NSMutableIndexSet *willDeleteSections = needDelete ? [NSMutableIndexSet indexSet] : nil;
        [section_indexes_pair enumerateKeysAndObjectsUsingBlock:^(NSNumber *s, NSMutableIndexSet *indexes, BOOL *stop) {
            NSInteger section = [s integerValue];
            if (self.sections[section].cells.count <= indexes.count) {
                // 这种情况本该奔溃的
                [willDeleteSections addIndex:section];
                [self.sections[section].cells removeAllObjects];
            } else {
                [self.sections[section].cells removeObjectsAtIndexes:indexes];
            }
        }];
        
        if (willDeleteSections.count > 0) {
            [self.sections removeObjectsAtIndexes:willDeleteSections];
        }
    }
    [self endUpdates];
}

- (TTReusableViewTemplate *)headerAtSection:(NSInteger)section {
    return self.sections[section].header;
}
- (TTReusableViewTemplate *)footerAtSection:(NSInteger)section {
    return self.sections[section].footer;
}
- (TTCellTemplate *)cellTemplateAtIndexPath:(NSIndexPath *)indexPath {
    return self.sections[indexPath.section].cells[indexPath.row];
}
- (id)cellDataAtIndexPath:(NSIndexPath *)indexPath {
    return self.sections[indexPath.section].cells[indexPath.row].data;
}

- (NSArray<NSIndexPath *> *)indexPathsForSelectedCells {
    return [self indexPathsForSelectedRows];
}

- (NSArray<NSIndexPath *> *)indexPathsForSelectedCellsInSection:(NSInteger)section {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.section == %ld", section];
    return [[self indexPathsForSelectedRows] filteredArrayUsingPredicate:predicate];
}

- (NSArray *)datasForSelectedCells {
    NSArray *sectionSelected = [self indexPathsForSelectedRows];
    NSMutableArray *datas = [NSMutableArray arrayWithCapacity:sectionSelected.count];
    [sectionSelected enumerateObjectsUsingBlock:^(NSIndexPath *obj, NSUInteger idx, BOOL *stop) {
        [datas addObject:[self cellDataAtIndexPath:obj]];
    }];
    return [datas copy];
}

- (NSArray *)datasForSelectedCellsInSection:(NSInteger)section {
    NSArray *sectionSelected = [self indexPathsForSelectedCellsInSection:section];
    NSMutableArray *datas = [NSMutableArray arrayWithCapacity:sectionSelected.count];
    [sectionSelected enumerateObjectsUsingBlock:^(NSIndexPath *obj, NSUInteger idx, BOOL *stop) {
        [datas addObject:[self cellDataAtIndexPath:obj]];
    }];
    return [datas copy];
}

#pragma mark - TTMutableArrayObserver

- (void)mutableArray:(NSMutableArray *)array
    didInsertObjects:(NSArray<TTSectionTemplate *> *)objects
           atIndexes:(NSIndexSet *)indexes {
    [self _setObserverForSections:objects observer:self];
    [self _registerViewWithSections:objects];
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
    [self _registerViewWithSections:objects];
    [self reloadSections:indexes withRowAnimation:UITableViewRowAnimationNone];
}

- (void)mutableArray:(NSMutableArray *)array
   beReplacedObjects:(NSArray *)objects
           atIndexes:(NSIndexSet *)indexes {
    [self _setObserverForSections:objects observer:nil];
}

- (void)_registerViewWithSections:(NSArray<TTSectionTemplate *> *)sections {
    [sections enumerateObjectsUsingBlock:^(TTSectionTemplate *section, NSUInteger idx, BOOL *stop) {
        [self _registerReusableView:section.header isHeader:YES];
        [self _registerReusableView:section.footer isHeader:NO];
        [self _registerCellWithCells:section.cells];
    }];
    // section 也和 cell 都有 viewClass 属性，同样要注册一下
    [self _registerCellWithCells:(NSArray<TTCellTemplate *> *)sections];
}

- (void)_registerCellWithCells:(NSArray<TTCellTemplate *> *)cells {
    [cells enumerateObjectsUsingBlock:^(TTCellTemplate *obj, NSUInteger idx, BOOL *stop) {
        Class<TTCellProvider> provider = obj.viewClass ? : [TTTableViewCell class];
        [self registerClass:provider forCellReuseIdentifier:[provider cellIdentifier]];
    }];
}

- (void)_registerReusableView:(TTReusableViewTemplate *)template isHeader:(BOOL)isHeader {
    Class<TTReusableViewProvider> provider = template.viewClass ? : [TTTableReusableView class];
    if (isHeader) {
        [self registerClass:provider forHeaderFooterViewReuseIdentifier:[provider headerIdentifier]];
    } else {
        [self registerClass:provider forHeaderFooterViewReuseIdentifier:[provider footerIdentifier]];
    }
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
