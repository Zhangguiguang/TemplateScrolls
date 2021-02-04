//
//  TTCellUpdateViewController.m
//  TemplateScrolls_Example
//
//  Created by 张贵广 on 2021/01/28.
//  Copyright © 2021 GG. All rights reserved.
//

#import "TTCellUpdateViewController.h"
#import "TTMessageModel.h"
#import "TTMessageCell.h"

@implementation TTCellUpdateViewController

- (void)makeSkeleton {
    TTSectionTemplate *section = [TTSectionTemplate new];
    section.viewClass = [TTMessageCell class]; // 整个 Section 可以统一配置 Cell 类型
    section.didSelect = ^(NSIndexPath *indexPath, TTMessageModel *data) {
        NSLog(@"... section 配置的点击，如果 Cell 没有定义特别的事件，就会被该事件响应 %@ %@", data.title, indexPath);
    };
    section.allowsMultipleSelection = YES;
    
    {
        TTMessageModel *model = [TTMessageModel new];
        model.title = @"1 - 动态添加 Cell";
        model.msg = @"点击这行，可以在它下面动态的添加一行 Cell";
        model.time = @"2020/01/02";

        TTCellTemplate *cell = TTCellTemplate.make.dataSet(model);
        tt_weakify(self);
        cell.didSelect = ^(NSIndexPath *indexPath, id data) {
            tt_strongify(self);
            [self _appendCellAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row+2 inSection:indexPath.section]];
        };
        [section.cellArray addObject:cell];
    }
    {
        // 添加两个间距 Cell
        [section.cellArray addObject:TTCellTemplate.make.heightSet(10)];
        [section.cellArray addObject:TTCellTemplate.make.heightSet(10)];
    }
    {
        TTMessageModel *model = [TTMessageModel new];
        model.title = @"2 - 动态删除 Cell";
        model.msg = @"点击这行，可以删除在它上面的一行 Cell";
        model.time = @"2020/01/02";

        TTCellTemplate *cell = TTCellTemplate.make.dataSet(model);
        tt_weakify(self);
        cell.didSelect = ^(NSIndexPath *indexPath, id data) {
            tt_strongify(self);
            [self _removeCellAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row-2 inSection:indexPath.section]];
        };
        [section.cellArray addObject:cell];
    }
    {
        TTMessageModel *model = [TTMessageModel new];
        model.title = @"3 - 动态更新 Cell";
        model.msg = @"点击这行，可以更改这行的数据";
        model.time = @"2020/01/02";

        TTCellTemplate *cell = TTCellTemplate.make.dataSet(model);
        tt_weakify(self);
        cell.didSelect = ^(NSIndexPath *indexPath, id data) {
            tt_strongify(self);
            [self _updateCellAtIndexPath:indexPath];
        };
        [section.cellArray addObject:cell];
    }

    [self.tableView.templateArray addObject:section];
}

- (void)_appendCellAtIndexPath:(NSIndexPath *)indexPath {
    static NSInteger index = 0;
    index ++;

    TTMessageModel *model = [TTMessageModel new];
    model.title = @"- - 我是动态添加的 Cell";
    model.msg = [NSString stringWithFormat:@"第 %ld 个新增的 Cell", index];
    NSDateFormatter *formater = [NSDateFormatter new];
    formater.dateFormat = @"yyyy/MM/dd";
    model.time = [formater stringFromDate:[NSDate date]];

    TTCellTemplate *cell = TTCellTemplate.make.dataSet(model);

    [self.tableView insertCells:@[indexPath] withTemplates:@[cell]];
}

- (void)_removeCellAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row <= 1) {
        NSLog(@"⚠️ 没有 Cell 可以被删除了！");
        return;
    }
    [self.tableView deleteCells:@[indexPath] deleteSection:NO];
}

- (void)_updateCellAtIndexPath:(NSIndexPath *)indexPath {
    static NSInteger index = 0;
    index ++;

    [[self.tableView cellTemplateAtIndexPath:indexPath] updateView:^(TTCellTemplate *tt) {
        TTMessageModel *data = tt.data;
        data.msg = [NSString stringWithFormat:@"%@ 第 %ld 次改变数据", data.msg, index];
    }];
}

@end
