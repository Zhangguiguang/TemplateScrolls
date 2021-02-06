//
//  UIScrollView+TTTemplateArrayCommon.m
//  TemplateScrolls
//
//  Created by 张贵广 on 2021/2/4.
//

#import "UIScrollView+TTTemplateArrayCommon.h"


#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-property-implementation"
@implementation UIScrollView (TTTemplateArrayCommon)
#pragma clang diagnostic pop

#pragma mark - Public

- (Class<TTCellProvider>)viewClassAtIndexPath:(NSIndexPath *)indexPath {
    TTSectionTemplate *section = self.sections[indexPath.section];
    TTCellTemplate *cell = section.cells[indexPath.item];
    if ([cell isKindOfClass:[TTCellTemplate class]] && cell.viewClass) {
        return cell.viewClass;
    }
    return section.viewClass;
}

- (CGFloat)widthAtIndexPath:(NSIndexPath *)indexPath {
    TTSectionTemplate *section = self.sections[indexPath.section];
    TTCellTemplate *cell = section.cells[indexPath.item];
    if ([cell isKindOfClass:[TTCellTemplate class]] && cell.width > 0) {
        return cell.width;
    }
    return section.width;
}

- (CGFloat)heightAtIndexPath:(NSIndexPath *)indexPath {
    TTSectionTemplate *section = self.sections[indexPath.section];
    TTCellTemplate *cell = section.cells[indexPath.item];
    if ([cell isKindOfClass:[TTCellTemplate class]] && cell.height > 0) {
        return cell.height;
    }
    return section.height;
}

- (TTCellWillDisplay)willDisplayAtIndexPath:(NSIndexPath *)indexPath {
    TTSectionTemplate *section = self.sections[indexPath.section];
    TTCellTemplate *cell = section.cells[indexPath.item];
    if ([cell isKindOfClass:[TTCellTemplate class]] && cell.willDisplay) {
        return cell.willDisplay;
    }
    if (section.willDisplay) {
        return section.willDisplay;
    }
    return self.willDisplay;
}

- (TTCellDidSelect)didSelectAtIndexPath:(NSIndexPath *)indexPath {
    TTSectionTemplate *section = self.sections[indexPath.section];
    TTCellTemplate *cell = section.cells[indexPath.item];
    if ([cell isKindOfClass:[TTCellTemplate class]] && cell.didSelect) {
        return cell.didSelect;
    }
    if (section.didSelect) {
        return section.didSelect;
    }
    return self.didSelect;
}

#pragma mark - TTTemplateArrayOperator

- (void)reloadCell:(NSIndexPath *)indexPath withData:(id)newData {
    TTSectionTemplate *section = self.sections[indexPath.section];
    TTCellTemplate *cell = section.cells[indexPath.item];
    if ([cell isKindOfClass:[TTCellTemplate class]]) {
        cell.data = newData;
        section.cells[indexPath.item] = cell;
    } else {
        section.cells[indexPath.item] = newData;
    }
}

- (void)deleteCells:(NSArray<NSIndexPath *> *)indexPaths deleteSection:(BOOL)needDelete {
    if (indexPaths.count == 1) {
        NSIndexPath *ip = indexPaths.firstObject;
        [self.sections[ip.section].cells removeObjectAtIndex:ip.item];
        
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
            [indexSet addIndex:obj.item];
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
}

- (TTReusableViewTemplate *)headerAtSection:(NSInteger)section {
    return self.sections[section].header;
}
- (TTReusableViewTemplate *)footerAtSection:(NSInteger)section {
    return self.sections[section].footer;
}

- (TTCellTemplate *)cellTemplateAtIndexPath:(NSIndexPath *)indexPath {
    TTCellTemplate *template = self.sections[indexPath.section].cells[[indexPath indexAtPosition:1]];
    if ([template isKindOfClass:[TTCellTemplate class]]) {
        return template;
    }
    return nil;
}

- (id)cellDataAtIndexPath:(NSIndexPath *)indexPath {
    TTCellTemplate *template = self.sections[indexPath.section].cells[[indexPath indexAtPosition:1]];
    if ([template isKindOfClass:[TTCellTemplate class]]) {
        return template.data;
    }
    return template;
}

- (NSArray<NSIndexPath *> *)indexPathsForSelectedCellsInSection:(NSInteger)section {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.section == %ld", section];
    return [[self indexPathsForSelectedCells] filteredArrayUsingPredicate:predicate];
}

- (NSArray *)datasForSelectedCells {
    NSArray *sectionSelected = [self indexPathsForSelectedCells];
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

@end
