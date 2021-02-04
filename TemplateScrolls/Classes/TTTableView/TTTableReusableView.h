//
//  TTTableReusableView.h
//  TemplateScrolls
//
//  Created by 张贵广 on 2021/01/01.
//

#import <UIKit/UIKit.h>
#import "TTScrollProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface TTTableReusableView : UITableViewHeaderFooterView <TTReusableViewProvider>

- (void)setData:(id _Nullable)data NS_REQUIRES_SUPER;

@property (nonatomic, readonly) UITableView *tableView;

@end

NS_ASSUME_NONNULL_END
