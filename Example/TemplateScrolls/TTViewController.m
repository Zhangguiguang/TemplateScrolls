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

@interface TTViewController () <
//TTMutableArrayObserver,
UITableViewDelegate>

@end

@implementation TTViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    TTMutableArray *array = [TTMutableArray array];
//    array.observer = self;
    
    [array addObject:@"jdios"];
    
    TTCellTemplate<Class<UITableViewDelegate>, UITableViewCell *> *template = [TTCellTemplate new];
    
    template.viewClass = UIView.class;
    
    TTTableView *tableView = [TTTableView new];
    tableView.sectionArray;
    
}

- (void)mutableArray:(NSMutableArray *)array didInsertObjects:(NSArray *)objects atIndexes:(NSIndexSet *)indexes {
    NSLog(@"insert %@, ", objects);
}

@end
