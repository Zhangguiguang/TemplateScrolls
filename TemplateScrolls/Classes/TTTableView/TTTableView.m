//
//  TTTableView.m
//  TemplateScrolls
//
//  Created by 张贵广 on 2020/12/29.
//

#import "TTTableView.h"
#import <TTMutableArray/TTMutableArray.h>

@interface TTTableView ()
@property (nonatomic, strong) TTTableViewSectionArray *sectionArray;
@end

@implementation TTTableView

- (TTTableViewSectionArray *)sectionArray {
    if (!_sectionArray) {
        _sectionArray = [TTMutableArray array];
        
        TTTableSectionTemplate *section = [TTTableSectionTemplate new];
        
        [_sectionArray addObject:section];
        [_sectionArray enumerateObjectsUsingBlock:^(TTTableSectionTemplate * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj.cellArray enumerateObjectsUsingBlock:^(TTTableCellTemplate * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                obj.viewClass = self.class;
                
            }];
        }];
        
    }
    return _sectionArray;
}

@end
