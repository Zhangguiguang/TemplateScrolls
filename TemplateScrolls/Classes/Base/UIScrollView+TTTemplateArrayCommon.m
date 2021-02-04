//
//  UIScrollView+TTTemplateArrayCommon.m
//  TemplateScrolls
//
//  Created by 张贵广 on 2021/2/4.
//

#import "UIScrollView+TTTemplateArrayCommon.h"


@implementation UIScrollView (TTTemplateArrayCommon)

#pragma mark - Public

- (Class<TTCellProvider>)viewClassAtIndexPath:(NSIndexPath *)indexPath {
    TTSectionTemplate *section = self.sections[indexPath.section];
    TTCellTemplate *cell = section.cells[[indexPath indexAtPosition:1]];
    if ([cell isKindOfClass:[TTCellTemplate class]] && cell.viewClass) {
        return cell.viewClass;
    }
    return section.viewClass;
}

- (CGFloat)widthAtIndexPath:(NSIndexPath *)indexPath {
    TTSectionTemplate *section = self.sections[indexPath.section];
    TTCellTemplate *cell = section.cells[[indexPath indexAtPosition:1]];
    if (cell.width > 0) {
        return cell.width;
    }
    return section.width;
}

- (CGFloat)heightAtIndexPath:(NSIndexPath *)indexPath {
    TTSectionTemplate *section = self.sections[indexPath.section];
    TTCellTemplate *cell = section.cells[[indexPath indexAtPosition:1]];
    if (cell.height > 0) {
        return cell.height;
    }
    return section.height;
}

- (TTCellWillDisplay)willDisplayAtIndexPath:(NSIndexPath *)indexPath {
    TTSectionTemplate *section = self.sections[indexPath.section];
    TTCellTemplate *cell = section.cells[[indexPath indexAtPosition:1]];
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
    TTCellTemplate *cell = section.cells[[indexPath indexAtPosition:1]];
    if ([cell isKindOfClass:[TTCellTemplate class]] && cell.didSelect) {
        return cell.didSelect;
    }
    if (section.didSelect) {
        return section.didSelect;
    }
    return self.didSelect;
}

#pragma mark - TTTemplateArrayOperator

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

@end
