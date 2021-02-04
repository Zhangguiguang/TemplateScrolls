//
//  TTCollectionView.m
//  TemplateScrolls
//
//  Created by 张贵广 on 2020/12/29.
//

#import "TTCollectionView.h"
#import "TTCollectionViewCell.h"
#import "TTCollectionReusableView.h"
#import <TTMutableArray/TTMutableArray.h>
#import "NSArray+TTIndexPathValue.h"

@interface TTCollectionView () <TTMutableArrayObserver, _TTSectionObserver,
                    UICollectionViewDataSource, TTCollectionViewDelegateFlowLayout>

@property (nonatomic, strong) TTCollectionTemplateArray *sections;

@property (nonatomic, strong) TTCollectionViewLayout *layout;

@end

@implementation TTCollectionView

#pragma mark - Delegate、DataSource
@synthesize additionalDataSource = _outerDataSource;
@synthesize additionalDelegate = _outerDelegate;

- (instancetype)initWithFrame:(CGRect)frame {
    
    TTCollectionViewLayout *layout = [TTCollectionViewLayout new];
    
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        self.delegate = self;
        self.dataSource = self;
        
        _layout = layout;
        _layout.delegate = self;
        _layout.estimatedItemSize = CGSizeMake(44.0, 44.0);
    }
    return self;
}

#pragma mark - TTCollectionViewDelegateFlowLayout

- (TTCollectionItemAlignment)collectionView:(UICollectionView *)collectionView
                                     layout:(TTCollectionViewLayout *)layout
                    alignmentItemsInSection:(NSInteger)section {
    if ([_outerDelegate respondsToSelector:@selector(collectionView:layout:alignmentItemsInSection:)]) {
        return [_outerDelegate collectionView:collectionView layout:layout alignmentItemsInSection:section];
    }
    return self.sections[section].alignment;
}

- (BOOL)collectionView:(UICollectionView *)collectionView
                layout:(TTCollectionViewLayout *)layout
        isRTLInSection:(NSInteger)section {
    if ([_outerDelegate respondsToSelector:@selector(collectionView:layout:isRTLInSection:)]) {
        return [_outerDelegate collectionView:collectionView layout:layout isRTLInSection:section];
    }
    return NO;
}

#pragma mark - UICollectionViewDataSource, UICollectionViewDelegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.sections.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
    return self.sections[section].cells.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TTCellTemplate *template = [self cellTemplateAtIndexPath:indexPath];
    Class<TTCellProvider> provider = [self.sections tt_viewClassAtIndexPath:indexPath] ? : [TTCollectionViewCell class];
    
    TTCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[provider cellIdentifier] forIndexPath:indexPath];
    cell.data = template.data;
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath {
    TTReusableViewTemplate *template = nil;
    NSString *identifier = nil;
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        template = self.sections[indexPath.section].header;
        Class<TTReusableViewProvider> provider = template.viewClass ? : [TTCollectionReusableView class];
        identifier = [provider headerIdentifier];
    } else if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
        template = self.sections[indexPath.section].footer;
        Class<TTReusableViewProvider> provider = template.viewClass ? : [TTCollectionReusableView class];
        identifier = [provider footerIdentifier];
    }
    
    TTCollectionReusableView *reuseView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:identifier forIndexPath:indexPath];
    reuseView.data = template.data;
    return reuseView;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    TTCellTemplate *template = [self cellTemplateAtIndexPath:indexPath];
    CGFloat fixedWidth = [self.sections tt_widthAtIndexPath:indexPath];
    CGFloat fixedHeight = [self.sections tt_heightAtIndexPath:indexPath];
    
    if (fixedWidth == TTViewAutomaticDimension || fixedHeight == TTViewAutomaticDimension) {
        // 继续往下
    } else if (template.width >= 0 && template.height >= 0) {
        return CGSizeMake(template.width, template.height);
    }
    
    if (@available(iOS 10.0, *)) {
        return UICollectionViewFlowLayoutAutomaticSize;
    } else {
        // 目前的 Cell 只支持固定宽高
        return CGSizeZero;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
referenceSizeForHeaderInSection:(NSInteger)section {
    TTReusableViewTemplate *template = self.sections[section].header;
    return [self _collectionView:collectionView sizeForReusableTemplate:template isHeader:YES];

}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
referenceSizeForFooterInSection:(NSInteger)section {
    TTReusableViewTemplate *template = self.sections[section].footer;
    return [self _collectionView:collectionView sizeForReusableTemplate:template isHeader:NO];
}

- (CGSize)_collectionView:(UICollectionView *)collectionView
  sizeForReusableTemplate:(TTReusableViewTemplate *)template
                 isHeader:(BOOL)isHeader {
    if (template.height > 0) {
        return CGSizeMake(CGRectGetWidth(collectionView.bounds), template.height);
    }
    
    if (!template.viewClass) {
        return CGSizeZero;
    }
    
    if (@available(iOS 10.0, *)) {
        return UICollectionViewFlowLayoutAutomaticSize;
    } else {
        return CGSizeZero;
    }
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                        layout:(UICollectionViewLayout *)collectionViewLayout
        insetForSectionAtIndex:(NSInteger)section {
    TTSectionTemplate *template = self.sections[section];
    return template.insets;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout *)collectionViewLayout
minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    TTSectionTemplate *template = self.sections[section];
    return template.horizontalSpacing;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout *)collectionViewLayout
minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    TTSectionTemplate *template = self.sections[section];
    return template.verticalSpacing;
}

- (void)collectionView:(UICollectionView *)collectionView
       willDisplayCell:(UICollectionViewCell *)cell
    forItemAtIndexPath:(NSIndexPath *)indexPath {
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
    if ([_outerDelegate respondsToSelector:@selector(collectionView:willDisplayCell:forItemAtIndexPath:)]) {
        [_outerDelegate collectionView:collectionView willDisplayCell:cell forItemAtIndexPath:indexPath];
    }
}

- (void)collectionView:(UICollectionView *)collectionView
willDisplaySupplementaryView:(UICollectionReusableView *)view
        forElementKind:(NSString *)kind
           atIndexPath:(NSIndexPath *)indexPath {
    TTReusableViewTemplate *template = nil;
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        template = self.sections[indexPath.section].header;
    } else if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
        template = self.sections[indexPath.section].footer;
    }
    
    if (template.willDisplay) {
        template.willDisplay(indexPath.section, template.data, view);
        return;
    }
    if ([_outerDelegate respondsToSelector:@selector(collectionView:willDisplaySupplementaryView:forElementKind:atIndexPath:)]) {
        [_outerDelegate collectionView:collectionView willDisplaySupplementaryView:view forElementKind:kind atIndexPath:indexPath];
    }
}

- (void)collectionView:(UICollectionView *)collectionView
didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
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
    if ([_outerDelegate respondsToSelector:@selector(collectionView:didSelectItemAtIndexPath:)]) {
        [_outerDelegate collectionView:collectionView didSelectItemAtIndexPath:indexPath];
    }
}

- (BOOL)collectionView:(UICollectionView *)collectionView
shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView.allowsMultipleSelection == NO) {
        // 如果不允许多选，直接按系统默认行为处理
        return YES;
    }
    
    TTSectionTemplate *template = self.sections[indexPath.section];
    if (template.allowsMultipleSelection) {
        // 允许多选，也不需要其他处理
        return YES;
    }
    
    // section 不允许多选，需要把已选中的取消掉
    NSArray *sectionSelected = [self indexPathsForSelectedCellsInSection:indexPath.section];
    [sectionSelected enumerateObjectsUsingBlock:^(NSIndexPath *obj, NSUInteger idx, BOOL *stop) {
        [collectionView deselectItemAtIndexPath:obj animated:NO];
    }];
    
    // 选中
    return YES;
}

- (BOOL)collectionView:(UICollectionView *)collectionView
shouldDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    TTSectionTemplate *template = self.sections[indexPath.section];
    if (template.forceSelection == NO) {
        // 不强制选中，可以取消
        return YES;
    }
    
    NSArray *sectionSelected = [self indexPathsForSelectedCellsInSection:indexPath.section];
    if (sectionSelected.count <= 1) {
        // 只有一条选中，不允许取消
        [collectionView selectItemAtIndexPath:indexPath animated:NO
                               scrollPosition:UICollectionViewScrollPositionNone];
        return NO;
    }
    
    return YES;
}

#pragma mark - TTTemplateArrayOperator

- (TTCollectionTemplateArray *)sections {
    if (!_sections) {
        TTMutableArray *temp = [TTMutableArray new];
        temp.observer = self;
        _sections = temp;
    }
    return _sections;
}

- (void)insertSections:(NSIndexSet *)indexes withTemplates:(NSArray *)tts {
    [self.sections insertObjects:tts atIndexes:indexes];
}
- (void)reloadSections:(NSIndexSet *)indexes withTemplates:(NSArray *)tts {
    [self.sections replaceObjectsAtIndexes:indexes withObjects:tts];
}
- (void)deleteSections:(NSIndexSet *)indexes {
    // 系统本身也是这个方法，这里相当于重写
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
    [self performBatchUpdates:^{
        [cells enumerateObjectsUsingBlock:^(TTCellTemplate *cell, NSUInteger idx, BOOL *stop) {
            if (indexPaths.count <= idx) {
                *stop = YES; return; // == break
            }
            NSIndexPath *ip = indexPaths[idx];
            [self.sections[ip.section].cells insertObject:cell atIndex:ip.row];
        }];
    } completion:nil];
}

- (void)reloadCells:(NSArray<NSIndexPath *> *)indexPaths withTemplates:(NSArray<TTCellTemplate *> *)cells {
    [self performBatchUpdates:^{
        [cells enumerateObjectsUsingBlock:^(TTCellTemplate *cell, NSUInteger idx, BOOL *stop) {
            if (indexPaths.count <= idx) {
                *stop = YES; return; // == break
            }
            NSIndexPath *ip = indexPaths[idx];
            [self.sections[ip.section].cells replaceObjectAtIndex:ip.row withObject:cell];
        }];
    } completion:nil];
}

- (void)reloadCells:(NSArray<NSIndexPath *> *)indexPaths {
    [self reloadItemsAtIndexPaths:indexPaths];
}

- (void)deleteCells:(NSArray<NSIndexPath *> *)indexPaths deleteSection:(BOOL)needDelete {
    [self performBatchUpdates:^{
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
    } completion:nil];
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
    return [self indexPathsForSelectedItems];
}

- (NSArray<NSIndexPath *> *)indexPathsForSelectedCellsInSection:(NSInteger)section {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.section == %ld", section];
    return [[self indexPathsForSelectedItems] filteredArrayUsingPredicate:predicate];
}

- (NSArray *)datasForSelectedCells {
    NSArray *sectionSelected = [self indexPathsForSelectedItems];
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
    didInsertObjects:(NSArray *)objects
           atIndexes:(NSIndexSet *)indexes {
    [self _setObserverForSections:objects observer:self];
    [self _registerViewWithSections:objects];
    [super insertSections:indexes];
}

- (void)mutableArray:(NSMutableArray *)array
    didRemoveObjects:(NSArray *)objects
           atIndexes:(NSIndexSet *)indexes {
    [self _setObserverForSections:objects observer:nil];
    [super deleteSections:indexes];
}

- (void)mutableArray:(NSMutableArray *)array
   didReplaceObjects:(NSArray *)objects
           atIndexes:(NSIndexSet *)indexes {
    [self _setObserverForSections:objects observer:self];
    [self _registerViewWithSections:objects];
    [super reloadSections:indexes];
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
    [self _registerCellWithCells:(NSArray<TTCellTemplate *> *)sections];
}

- (void)_registerCellWithCells:(NSArray<TTCellTemplate *> *)cells {
    [cells enumerateObjectsUsingBlock:^(TTCellTemplate *obj, NSUInteger idx, BOOL *stop) {
        Class<TTCellProvider> provider = obj.viewClass ? : [TTCollectionViewCell class];
        [self registerClass:provider forCellWithReuseIdentifier:[provider cellIdentifier]];
    }];
}

- (void)_registerReusableView:(TTReusableViewTemplate *)template isHeader:(BOOL)isHeader {
    Class<TTReusableViewProvider> provider = template.viewClass ? : [TTCollectionReusableView class];
    if (isHeader) {
        [self registerClass:provider forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
        withReuseIdentifier:[provider headerIdentifier]];
    } else {
        [self registerClass:provider forSupplementaryViewOfKind:UICollectionElementKindSectionFooter
        withReuseIdentifier:[provider footerIdentifier]];
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
        [super insertItemsAtIndexPaths:indexPaths];
    }
}

- (void)section:(TTSectionTemplate *)section
 didRemoveCells:(NSArray<TTCellTemplate *> *)objects
      atIndexes:(NSIndexSet *)indexes {
    NSArray *indexPaths = [self _indexPathsFromSection:section indexes:indexes];
    if (indexPaths.count > 0) {
        [super deleteItemsAtIndexPaths:indexPaths];
    }
}

- (void)section:(TTSectionTemplate *)section
didReplaceCells:(NSArray<TTCellTemplate *> *)objects
      atIndexes:(NSIndexSet *)indexes {
    NSArray *indexPaths = [self _indexPathsFromSection:section indexes:indexes];
    if (indexPaths.count > 0) {
        [super reloadItemsAtIndexPaths:indexPaths];
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
