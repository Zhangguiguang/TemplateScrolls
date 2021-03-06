//
//  TTViewController.m
//  TemplateScrolls
//
//  Created by GG on 12/21/2020.
//  Copyright (c) 2020 GG. All rights reserved.
//

#import "TTViewController.h"
#import <TemplateScrolls/TemplateScrolls.h>

@implementation TTViewController

- (void)makeSkeleton {
    {
        TTSectionTemplate *section = [TTSectionTemplate new];
        section.header.height = 60;
        section.header.willDisplay = ^(NSInteger section, id data, TTTableReusableView *me) {
            me.textLabel.font = [UIFont systemFontOfSize:20 weight:UIFontWeightSemibold];
            me.textLabel.text = @"Demo For Table View";
        };
        section.viewClass = [TTTableViewCell class];
        [section.cells addObjectsFromArray:[self tableTemplates]];
        
        [self.sections addObject:section];
    }
    {
        TTSectionTemplate *section = [TTSectionTemplate new];
        section.header.height = 60;
        section.header.willDisplay = ^(NSInteger section, id data, TTTableReusableView *me) {
            me.textLabel.font = [UIFont systemFontOfSize:20 weight:UIFontWeightSemibold];
            me.textLabel.text = @"Demo For Table View";
        };
        section.viewClass = [TTTableViewCell class];
        [section.cells addObjectsFromArray:[self collectionTemplates]];
        
        [self.sections addObject:section];
    }
    
    self.tableView.willDisplay = ^(NSIndexPath *indexPath, NSDictionary *data, UITableViewCell *me) {
        me.textLabel.font = [UIFont systemFontOfSize:18];
        me.textLabel.text = data[@"title"];
    };
    self.tableView.didSelect = ^(NSIndexPath *indexPath, NSDictionary *data) {
        Class vcClass = NSClassFromString(data[@"vcName"]);
        if (vcClass) {
            UIViewController *vc = [vcClass new];
            vc.title = data[@"title"];
            [self.navigationController pushViewController:vc animated:YES];
        }
    };
}

- (NSArray *)tableTemplates {
    return @[
        [self dataWithTitle:@"Sample Log"
                   targetVC:@"TTLogViewController"],
        
        [self dataWithTitle:@"Cell 插入、删除、更新"
                   targetVC:@"TTCellUpdateViewController"],
        
        [self dataWithTitle:@"单选、多选"
                   targetVC:@"TTSelectionViewController"],
        
        [self dataWithTitle:@"自动刷新"
                   targetVC:@"TTViewAutoLoadViewController"],
        
    ];
}

- (NSArray *)collectionTemplates {
    return @[
        [self dataWithTitle:@"Sample Collection"
                   targetVC:@"TTCommerceViewController"],
    ];
}

- (NSDictionary *)dataWithTitle:(NSString *)title targetVC:(NSString *)vcName {
    return @{
        @"title": title,
        @"vcName": vcName,
    };
}

@end
