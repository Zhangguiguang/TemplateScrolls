//
//  NSArray+TTIndexPathValue.m
//  TemplateScrolls
//
//  Created by 张贵广 on 2021/2/4.
//

#import "NSArray+TTIndexPathValue.h"
#import "TTViewTemplate.h"

@implementation NSArray (TTIndexPathValue)

- (Class<TTCellProvider>)tt_viewClassAtIndexPath:(NSIndexPath *)indexPath {
    TTSectionTemplate *section = self[indexPath.section];
    TTCellTemplate *cell = section.cellArray[[indexPath indexAtPosition:1]];
    return cell.viewClass ? : section.viewClass;
}

- (CGFloat)tt_widthAtIndexPath:(NSIndexPath *)indexPath {
    TTSectionTemplate *section = self[indexPath.section];
    TTCellTemplate *cell = section.cellArray[[indexPath indexAtPosition:1]];
    if (cell.width >= 0) {
        return cell.width;
    }
    return section.width;
}

- (CGFloat)tt_heightAtIndexPath:(NSIndexPath *)indexPath {
    TTSectionTemplate *section = self[indexPath.section];
    TTCellTemplate *cell = section.cellArray[[indexPath indexAtPosition:1]];
    if (cell.height >= 0) {
        return cell.height;
    }
    return section.height;
}

@end
