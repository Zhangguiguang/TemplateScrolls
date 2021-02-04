//
//  TTSelectionViewController.m
//  TemplateScrolls_Example
//
//  Created by 张贵广 on 2021/01/28.
//  Copyright © 2021 GG. All rights reserved.
//

#import "TTSelectionViewController.h"
#import "TTTableCheckBoxCell.h"
#import "TTTableRadioCell.h"

@implementation TTSelectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"选项信息" style:UIBarButtonItemStylePlain target:self action:@selector(currentInfo)];
}

- (void)currentInfo {
    NSMutableString *newData = [NSMutableString stringWithString:@"选项情况：\n"];
    [self.sections enumerateObjectsUsingBlock:^(TTSectionTemplate *obj, NSUInteger idx, BOOL *stop) {
        [newData appendFormat:@"\nSection %ld\n", idx];
        [newData appendFormat:@"是否多选：%d, 是否允许取消：%d\n", obj.allowsMultipleSelection, !obj.forceSelection];
        
//        NSArray *indexPaths = [self.tableView indexPathsForSelectedCellsInSection:idx];
        NSArray *datas = [self.tableView datasForSelectedCellsInSection:idx];
        [newData appendFormat:@"选择了 %ld 个选项\n", datas.count];
        
        if (datas.count == 0) return;
        NSString *options = [datas componentsJoinedByString:@", "];
        [newData appendFormat:@"选择的数据：%@\n", options];
    }];
    [TTToast show:newData delay:5];
}

- (void)makeSkeleton {
    self.tableView.allowsMultipleSelection = YES; // 这一句必须要打开
    {
        TTSectionTemplate *section = [TTSectionTemplate new];
        section.header.height = 50;
        section.header.willDisplay = ^(NSInteger section, id data, UITableViewHeaderFooterView *me) {
            me.textLabel.text = @"多选的，可取消";
        };
        section.allowsMultipleSelection = YES;
        section.forceSelection = NO;
        
        section.viewClass = [TTTableCheckBoxCell class];
        [section.cells addObjectsFromArray:@[@"A", @"B", @"C"]];
        
        [self.sections addObject:section];
    }
    {
        TTSectionTemplate *section = [TTSectionTemplate new];
        section.header.height = 50;
        section.header.willDisplay = ^(NSInteger section, id data, UITableViewHeaderFooterView *me) {
            me.textLabel.text = @"多选的，禁止取消🈲";
        };
        section.allowsMultipleSelection = YES;
        section.forceSelection = YES;
        
        section.viewClassSet([TTTableCheckBoxCell class]);
        [section.cells addObjectsFromArray:@[@"D", @"E", @"F"]];
        
        [self.sections addObject:section];
    }
    {
        TTSectionTemplate *section = [TTSectionTemplate new];
        section.header.height = 50;
        section.header.willDisplay = ^(NSInteger section, id data, UITableViewHeaderFooterView *me) {
            me.textLabel.text = @"单选的，可取消";
        };
        section.allowsMultipleSelection = NO;
        
        section.viewClassSet([TTTableRadioCell class]);
        [section.cells addObjectsFromArray:@[@"X", @"Y", @"Z"]];
        
        [self.sections addObject:section];
    }
    {
        TTSectionTemplate *section = [TTSectionTemplate new];
        section.header.height = 50;
        section.header.willDisplay = ^(NSInteger section, id data, UITableViewHeaderFooterView *me) {
            me.textLabel.text = @"单选的，禁止取消🚫";
        };
        section.allowsMultipleSelection = NO;
        section.forceSelection = YES;
        
        section.viewClassSet([TTTableRadioCell class]);
        [section.cells addObjectsFromArray:@[@"男", @"女", @"隐藏"]];
        
        [self.sections addObject:section];
    }
}


@end
