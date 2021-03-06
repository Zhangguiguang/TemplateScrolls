//
//  TTTableViewCell.h
//  TemplateScrolls
//
//  Created by 张贵广 on 2021/01/01.
//

#import <UIKit/UIKit.h>
#import "TTScrollProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface TTTableViewCell : UITableViewCell <TTCellProvider>

- (void)setData:(id _Nullable)data NS_REQUIRES_SUPER;

@property (nonatomic, readonly) UITableView *tableView;

@property (nonatomic, readonly) NSIndexPath *indexPath;

@end

NS_ASSUME_NONNULL_END
