//
//  TTViewTemplate.m
//  TemplateScrolls
//
//  Created by 张贵广 on 2020/12/25.
//

#import "TTViewTemplate.h"

@implementation TTViewTemplate

@end


@implementation TTCellTemplate

@end


@implementation TTReusableViewTemplate

@end


@implementation TTSectionTemplate

- (id)header {
    if (!_header) {
        // TODO: header
    }
    return _header;
}

@synthesize cellArray = _cellArray;
- (NSMutableArray *)cellArray {
    if (!_cellArray) {
        _cellArray = [NSMutableArray array];
    }
    return _cellArray;
}

@end
