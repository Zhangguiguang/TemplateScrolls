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

@interface TTCollectionView () <TTMutableArrayObserver, _TTSectionObserver,
                    UICollectionViewDataSource, TTCollectionViewDelegateFlowLayout>

@property (nonatomic, strong) TTCollectionTemplateArray *templateArray;

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
    return TTCollectionItemAlignmentDefault;
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
    return self.templateArray.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
    return self.templateArray[section].cellArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TTCellTemplate *template = [self cellTemplateAtIndexPath:indexPath];
    Class<TTTableCellProvider> provider = template.viewClass ? : [TTCollectionViewCell class];
    
    TTCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[provider reuseIdentifier] forIndexPath:indexPath];
    cell.data = template.data;
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath {
    TTReusableViewTemplate *template = nil;
    NSString *identifier = nil;
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        template = self.templateArray[indexPath.section].header;
        Class<TTCollectionReusableViewProvider> provider = template.viewClass ? : [TTCollectionReusableView class];
        identifier = [provider reuseIdentifier];
    } else if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
        template = self.templateArray[indexPath.section].footer;
        Class<TTCollectionReusableViewProvider> provider = template.viewClass ? : [TTCollectionReusableView class];
        identifier = [provider reuseIdentifier2];
    }
    
    TTCollectionReusableView *reuseView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:identifier forIndexPath:indexPath];
    reuseView.data = template.data;
    return reuseView;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    TTCellTemplate *template = [self cellTemplateAtIndexPath:indexPath];
    
    if (template.width > 0 && template.height > 0) {
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
    TTReusableViewTemplate *template = self.templateArray[section].header;
    return [self _collectionView:collectionView sizeForReusableTemplate:template isHeader:YES];

}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
referenceSizeForFooterInSection:(NSInteger)section {
    TTReusableViewTemplate *template = self.templateArray[section].footer;
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
    TTCollectionSectionTemplate *template = self.templateArray[section];
    return template.insets;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout *)collectionViewLayout
minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    TTCollectionSectionTemplate *template = self.templateArray[section];
    return template.horizontalSpacing;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout *)collectionViewLayout
minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    TTCollectionSectionTemplate *template = self.templateArray[section];
    return template.veritcalSpacing;
}

- (void)collectionView:(UICollectionView *)collectionView
       willDisplayCell:(UICollectionViewCell *)cell
    forItemAtIndexPath:(NSIndexPath *)indexPath {
    TTCellTemplate *template = [self cellTemplateAtIndexPath:indexPath];
    if (template.willDisplay) {
        template.willDisplay(indexPath, template.data, cell);
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
        template = self.templateArray[indexPath.section].header;
    } else if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
        template = self.templateArray[indexPath.section].footer;
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
    
    TTSectionTemplate *template = self.templateArray[indexPath.section];
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
    TTSectionTemplate *template = self.templateArray[indexPath.section];
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

- (TTCollectionTemplateArray *)templateArray {
    if (!_templateArray) {
        TTMutableArray *temp = [TTMutableArray new];
        temp.observer = self;
        _templateArray = temp;
    }
    return _templateArray;
}

- (void)insertSections:(NSIndexSet *)indexes withTemplates:(NSArray *)tts {
    [self.templateArray insertObjects:tts atIndexes:indexes];
}
- (void)reloadSections:(NSIndexSet *)indexes withTemplates:(NSArray *)tts {
    [self.templateArray replaceObjectsAtIndexes:indexes withObjects:tts];
}
- (void)deleteSections:(NSIndexSet *)indexes {
    // 系统本身也是这个方法，这里相当于重写
    [self.templateArray removeObjectsAtIndexes:indexes];
}

- (void)insertSection:(NSInteger)section withTemplate:(TTCollectionSectionTemplate *)tt {
    [self.templateArray insertObject:tt atIndex:section];
}
- (void)reloadSection:(NSInteger)section withTemplate:(TTCollectionSectionTemplate *)tt {
    [self.templateArray replaceObjectAtIndex:section withObject:tt];
}
- (void)deleteSection:(NSInteger)section {
    [self.templateArray removeObjectAtIndex:section];
}

- (void)insertCells:(NSArray<NSIndexPath *> *)indexPaths withTemplates:(NSArray<TTCellTemplate *> *)cells {
    [self performBatchUpdates:^{
        [cells enumerateObjectsUsingBlock:^(TTCellTemplate *cell, NSUInteger idx, BOOL *stop) {
            if (indexPaths.count <= idx) {
                *stop = YES; return; // == break
            }
            NSIndexPath *ip = indexPaths[idx];
            [self.templateArray[ip.section].cellArray insertObject:cell atIndex:ip.row];
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
            [self.templateArray[ip.section].cellArray replaceObjectAtIndex:ip.row withObject:cell];
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
            [self.templateArray[ip.section].cellArray removeObjectAtIndex:ip.row];
            
            if (needDelete && self.templateArray[ip.section].cellArray.count == 0) {
                [self.templateArray removeObjectAtIndex:ip.section];
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
                if (self.templateArray[section].cellArray.count <= indexes.count) {
                    // 这种情况本该奔溃的
                    [willDeleteSections addIndex:section];
                    [self.templateArray[section].cellArray removeAllObjects];
                } else {
                    [self.templateArray[section].cellArray removeObjectsAtIndexes:indexes];
                }
            }];
            
            if (willDeleteSections.count > 0) {
                [self.templateArray removeObjectsAtIndexes:willDeleteSections];
            }
        }
    } completion:nil];
}

- (TTReusableViewTemplate *)headerAtSection:(NSInteger)section {
    return self.templateArray[section].header;
}
- (TTReusableViewTemplate *)footerAtSection:(NSInteger)section {
    return self.templateArray[section].footer;
}
- (TTCellTemplate *)cellTemplateAtIndexPath:(NSIndexPath *)indexPath {
    return self.templateArray[indexPath.section].cellArray[indexPath.row];
}
- (id)cellDataAtIndexPath:(NSIndexPath *)indexPath {
    return self.templateArray[indexPath.section].cellArray[indexPath.row].data;
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

- (void)_registerViewWithSections:(NSArray<TTCollectionSectionTemplate *> *)sections {
    [sections enumerateObjectsUsingBlock:^(TTCollectionSectionTemplate *section, NSUInteger idx, BOOL *stop) {
        [self _registerReusableView:section.header isHeader:YES];
        [self _registerReusableView:section.footer isHeader:NO];
        [self _registerCellWithCells:section.cellArray];
    }];
}

- (void)_registerCellWithCells:(NSArray<TTCellTemplate *> *)cells {
    [cells enumerateObjectsUsingBlock:^(TTCellTemplate *obj, NSUInteger idx, BOOL *stop) {
        Class<TTTableCellProvider> provider = obj.viewClass ? : [TTCollectionViewCell class];
        [self registerClass:provider forCellWithReuseIdentifier:[provider reuseIdentifier]];
    }];
}

- (void)_registerReusableView:(TTCollectionReusableViewTemplate *)template isHeader:(BOOL)isHeader {
    Class<TTTableReusableViewProvider> provider = template.viewClass ? : [TTCollectionReusableView class];
    if (isHeader) {
        [self registerClass:provider forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
        withReuseIdentifier:[provider reuseIdentifier]];
    } else {
        [self registerClass:provider forSupplementaryViewOfKind:UICollectionElementKindSectionFooter
        withReuseIdentifier:[provider reuseIdentifier2]];
    }
}

- (void)_setObserverForSections:(NSArray<TTCollectionSectionTemplate *> *)sections
                       observer:(id<_TTSectionObserver>)observer {
    [sections makeObjectsPerformSelector:@selector(setObserver:) withObject:observer];
}

#pragma mark - _TTSectionObserver

- (void)section:(TTCollectionSectionTemplate *)section
 didInsertCells:(NSArray<TTCellTemplate *> *)objects
      atIndexes:(NSIndexSet *)indexes {
    NSArray *indexPaths = [self _indexPathsFromSection:section indexes:indexes];
    if (indexPaths.count > 0) {
        [super insertItemsAtIndexPaths:indexPaths];
    }
}

- (void)section:(TTCollectionSectionTemplate *)section
 didRemoveCells:(NSArray<TTCellTemplate *> *)objects
      atIndexes:(NSIndexSet *)indexes {
    NSArray *indexPaths = [self _indexPathsFromSection:section indexes:indexes];
    if (indexPaths.count > 0) {
        [super deleteItemsAtIndexPaths:indexPaths];
    }
}

- (void)section:(TTCollectionSectionTemplate *)section
didReplaceCells:(NSArray<TTCellTemplate *> *)objects
      atIndexes:(NSIndexSet *)indexes {
    NSArray *indexPaths = [self _indexPathsFromSection:section indexes:indexes];
    if (indexPaths.count > 0) {
        [super reloadItemsAtIndexPaths:indexPaths];
    }
}

- (nullable NSArray<NSIndexPath *> *)_indexPathsFromSection:(TTCollectionSectionTemplate *)section
                                                    indexes:(NSIndexSet *)indexes {
    __block NSInteger s = [self.templateArray indexOfObject:section];
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
