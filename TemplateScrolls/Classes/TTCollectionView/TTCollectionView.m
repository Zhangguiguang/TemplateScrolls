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
#import "UIScrollView+TTTemplateArrayCommon.h"

@interface TTCollectionView () <TTMutableArrayObserver, _TTSectionObserver,
                    UICollectionViewDataSource, TTCollectionViewDelegateFlowLayout>

@property (nonatomic, strong) TTCollectionTemplateArray *sections;

@property (nonatomic, strong) TTCollectionViewLayout *layout;

@end

@implementation TTCollectionView

@synthesize willDisplay = _willDisplay;
@synthesize didSelect   = _didSelect;

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
    Class<TTCellProvider> provider = [self viewClassAtIndexPath:indexPath] ? : [TTCollectionViewCell class];
    id data = [self cellDataAtIndexPath:indexPath];
    return [provider dequeueCellWithListView:collectionView forIndexPath:indexPath data:data];
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        TTReusableViewTemplate *template = self.sections[indexPath.section].header;
        Class<TTReusableViewProvider> provider = template.viewClass ? : [TTCollectionReusableView class];
        return [provider dequeueHeaderWithListView:collectionView forSection:indexPath.section data:template.data];
        
    } else if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
        TTReusableViewTemplate *template = self.sections[indexPath.section].footer;
        Class<TTReusableViewProvider> provider = template.viewClass ? : [TTCollectionReusableView class];
        return [provider dequeueFooterWithListView:collectionView forSection:indexPath.section data:template.data];
    }
    
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    TTCellTemplate *template = [self cellTemplateAtIndexPath:indexPath];
    CGFloat fixedWidth = [self widthAtIndexPath:indexPath];
    CGFloat fixedHeight = [self heightAtIndexPath:indexPath];
    
    if (fixedWidth == TTViewAutomaticDimension || fixedHeight == TTViewAutomaticDimension) {
        // 继续往下
    } else if (template.width > 0 && template.height > 0) {
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
    TTCellWillDisplay willDisplay = [self willDisplayAtIndexPath:indexPath];
    if (willDisplay) {
        id data = [self cellDataAtIndexPath:indexPath];
        willDisplay(indexPath, data, cell);
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
    TTCellDidSelect didSelect = [self didSelectAtIndexPath:indexPath];
    if (didSelect) {
        id data = [self cellDataAtIndexPath:indexPath];
        didSelect(indexPath, data);
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

- (NSArray<NSIndexPath *> *)indexPathsForSelectedCells {
    return [self indexPathsForSelectedItems];
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
