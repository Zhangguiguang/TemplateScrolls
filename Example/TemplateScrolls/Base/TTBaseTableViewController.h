//
//  TTBaseTableViewController.h
//  TemplateScrolls_Example
//
//  Created by 张贵广 on 2021/01/27.
//  Copyright © 2021 GG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TemplateScrolls/TTTableView.h>
#import "TTToast.h"

NS_ASSUME_NONNULL_BEGIN

@interface TTBaseTableViewController : UIViewController

@property (nonatomic, readonly) TTTableView *tableView;
@property (nonatomic, readonly) TTTableTemplateArray *sections;

- (void)makeSkeleton;

- (UITableViewStyle)tableViewStyle;

@end

NS_ASSUME_NONNULL_END
