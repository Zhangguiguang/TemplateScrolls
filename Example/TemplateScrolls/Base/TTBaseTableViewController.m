//
//  TTBaseTableViewController.m
//  TemplateScrolls_Example
//
//  Created by 张贵广 on 2021/01/27.
//  Copyright © 2021 GG. All rights reserved.
//

#import "TTBaseTableViewController.h"

@implementation TTBaseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self makeSkeleton];
    [self _makeTableView];
}

- (void)_makeTableView {
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.edges.mas_equalTo(self.view.safeAreaInsets);
        } else {
            make.edges.mas_equalTo(UIEdgeInsetsZero);
        }
    }];
}

- (void)makeSkeleton {
}

- (UITableViewStyle)tableViewStyle {
    return UITableViewStyleGrouped;
}

@synthesize tableView = _tableView;
- (TTTableView *)tableView {
    if (!_tableView) {
        _tableView = [[TTTableView alloc] initWithFrame:CGRectZero style:[self tableViewStyle]];
    }
    return _tableView;
}

- (TTTableTemplateArray *)templateArray {
    return self.tableView.templateArray;
}

@end
