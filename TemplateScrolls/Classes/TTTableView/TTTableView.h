//
//  TTTableView.h
//  TemplateScrolls
//
//  Created by 张贵广 on 2020/12/29.
//

#import <UIKit/UIKit.h>
#import "TTViewTemplate.h"

NS_ASSUME_NONNULL_BEGIN


typedef TTCellTemplate<Class<UITableViewDelegate>, UITableViewCell *> TTTableCellTemplate;
typedef TTReusableViewTemplate<Class<UITableViewDataSource>, UITableViewHeaderFooterView *> TTTableReusableViewTemplate;
typedef TTSectionTemplate<TTTableCellTemplate *, TTTableReusableViewTemplate *> TTTableSectionTemplate;
typedef NSMutableArray<TTTableSectionTemplate *> TTTableViewSectionArray;

@interface TTTableView : UITableView

@property (nonatomic, readonly) TTTableViewSectionArray *sectionArray;

@end

NS_ASSUME_NONNULL_END
