//
//  TTViewController.m
//  TemplateScrolls
//
//  Created by GG on 12/21/2020.
//  Copyright (c) 2020 GG. All rights reserved.
//

#import "TTViewController.h"
#import <TTMutableArray/TTMutableArray.h>
#import <TemplateScrolls/TTTableView.h>
#import "TTMessageCell.h"

UIColor *randomColor() {
    return [UIColor colorWithRed:(arc4random() % 255 / 255.0)
                           green:(arc4random() % 255 / 255.0)
                            blue:(arc4random() % 255 / 255.0)
                           alpha:0.3];
}

@interface TTViewController ()

@property (nonatomic, strong) TTTableView *tableView;

@end

@implementation TTViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self makeTableView];
    
    [self makeTemplateArray];
}

- (void)makeTableView {
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.edges.mas_equalTo(self.view.safeAreaInsets);
        } else {
            make.edges.mas_equalTo(UIEdgeInsetsZero);
        }
    }];
}

- (void)makeTemplateArray {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"log" ofType:@"json"];
    NSData *jsonData = [NSData dataWithContentsOfFile:filePath];
    NSError *error = nil;
    NSArray<NSDictionary *> *dataArray = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
    
    TTTableSectionTemplate *section = [TTSectionTemplate new];
    [dataArray enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
        TTMessageModel *model = [TTMessageModel new];
        [model setValuesForKeysWithDictionary:obj];
        model.title = [NSString stringWithFormat:@"%lu - %@", idx, model.title];
        
        TTTableCellTemplate *cell = [TTCellTemplate new];
        cell.viewClass = [TTMessageCell class];
        cell.data = model;
        cell.height = model.height;
        [section.cellArray addObject:cell];
    }];
    
    [self.tableView.templateArray addObject:section];
    self.tableView.willDisplay = ^(NSIndexPath *i, id data, UITableViewCell *me) {
        me.backgroundColor = randomColor();
    };
}

#pragma mark - Lazy Load

TTLazyLoad(TTTableView, tableView, {
    z = [[TTTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
})

@end
