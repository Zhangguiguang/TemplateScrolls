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

@interface TTTableView () <TTMutableArrayObserver, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) TTTableTemplateArray *templateArray;

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
    return self.templateArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.templateArray[section].cellArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TTCellTemplate *template = [self _templateAtIndexPath:indexPath];
    Class<TTTableCellProvider> provider = template.viewClass ? : [TTTableViewCell class];
    
    TTTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[provider reuseIdentifier] forIndexPath:indexPath];
    cell.data = template.data;
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    TTReusableViewTemplate *template = self.templateArray[section].header;
    Class<TTTableReusableViewProvider> provider = template.viewClass ? : [TTTableReusableView class];
    TTTableReusableView *reuseView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:[provider reuseIdentifier]];
    reuseView.data = template.data;
    return reuseView;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    TTReusableViewTemplate *template = self.templateArray[section].footer;
    Class<TTTableReusableViewProvider> provider = template.viewClass ? : [TTTableReusableView class];
    TTTableReusableView *reuseView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:[provider reuseIdentifier2]];
    reuseView.data = template.data;
    return reuseView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    TTTableCellTemplate *template = [self _templateAtIndexPath:indexPath];
    // 固定的高度
    if (template.height > 0) {
        return template.height;
    }
    
    // 缓存的高度
    if ([tableView.fd_indexPathHeightCache existsHeightAtIndexPath:indexPath]) {
        return [tableView.fd_indexPathHeightCache heightForIndexPath:indexPath];
    }
    
    // 动态的高度
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    TTReusableViewTemplate *template = self.templateArray[section].header;
    return [self _tableView:tableView heightForReusableTemplate:template isHeader:YES];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    TTReusableViewTemplate *template = self.templateArray[section].footer;
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
    Class<TTTableReusableViewProvider> provider = template.viewClass ? : TTTableReusableView.class;
    NSString *identifier = isHeader ? [provider reuseIdentifier] : [provider reuseIdentifier2];
    return [tableView fd_heightForHeaderFooterViewWithIdentifier:identifier configuration:^(TTTableReusableView *headerFooterView) {
        headerFooterView.data = template.data;
    }];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath {
    TTCellTemplate *template = [self _templateAtIndexPath:indexPath];
    if (template.willDisplay) {
        template.willDisplay(indexPath, template.data, cell);
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
    TTReusableViewTemplate *template = self.templateArray[section].header;
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
    TTReusableViewTemplate *template = self.templateArray[section].footer;
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
        BOOL isCellKeepExist = self.templateArray.count > indexPath.section
        && self.templateArray[indexPath.section].cellArray.count > indexPath.row;
        
        if (!isCellKeepExist) {
            break;
        }
        
        TTCellTemplate *template = [self _templateAtIndexPath:indexPath];
        
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
    TTCellTemplate *template = [self _templateAtIndexPath:indexPath];
    if (template.didSelect) {
        template.didSelect(indexPath, template.data);
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

#pragma mark - Template Property

- (TTTableTemplateArray *)templateArray {
    if (!_templateArray) {
        TTMutableArray *temp = [TTMutableArray new];
        temp.observer = self;
        _templateArray = temp;
    }
    return _templateArray;
}

- (TTCellTemplate *)_templateAtIndexPath:(NSIndexPath *)indexPath {
    return self.templateArray[indexPath.section].cellArray[indexPath.row];
}

- (id)dataAtIndexPath:(NSIndexPath *)indexPath {
    return self.templateArray[indexPath.section].cellArray[indexPath.row].data;
}

#pragma mark - TTMutableArrayObserver

- (void)mutableArray:(NSMutableArray *)array
    didInsertObjects:(NSArray<TTTableSectionTemplate *> *)objects
           atIndexes:(NSIndexSet *)indexes {
    [self _registerViewWithSections:objects];
    [self insertSections:indexes withRowAnimation:UITableViewRowAnimationNone];
}

- (void)mutableArray:(NSMutableArray *)array
    didRemoveObjects:(NSArray *)objects
           atIndexes:(NSIndexSet *)indexes {
    [self deleteSections:indexes withRowAnimation:UITableViewRowAnimationNone];
}

- (void)mutableArray:(NSMutableArray *)array
   didReplaceObjects:(NSArray<TTTableSectionTemplate *> *)objects
           atIndexes:(NSIndexSet *)indexes {
    [self _registerViewWithSections:objects];
    [self reloadSections:indexes withRowAnimation:UITableViewRowAnimationNone];
}

- (void)_registerViewWithSections:(NSArray<TTTableSectionTemplate *> *)sections {
    [sections enumerateObjectsUsingBlock:^(TTTableSectionTemplate *section, NSUInteger idx, BOOL *stop) {
        [self _registerReusableView:section.header isHeader:YES];
        [self _registerReusableView:section.footer isHeader:NO];
        [self _registerCellWithCells:section.cellArray];
    }];
}

- (void)_registerCellWithCells:(NSArray<TTTableCellTemplate *> *)cells {
    [cells enumerateObjectsUsingBlock:^(TTTableCellTemplate *obj, NSUInteger idx, BOOL *stop) {
        Class<TTTableCellProvider> provider = obj.viewClass ? : [TTTableViewCell class];
        [self registerClass:provider forCellReuseIdentifier:[provider reuseIdentifier]];
    }];
}

- (void)_registerReusableView:(TTTableReusableViewTemplate *)template isHeader:(BOOL)isHeader {
    Class<TTTableReusableViewProvider> provider = template.viewClass ? : [TTTableReusableView class];
    if (isHeader) {
        [self registerClass:provider forHeaderFooterViewReuseIdentifier:[provider reuseIdentifier]];
    } else {
        [self registerClass:provider forHeaderFooterViewReuseIdentifier:[provider reuseIdentifier2]];
    }
}

@end
