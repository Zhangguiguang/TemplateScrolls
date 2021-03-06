//
//  TTTableViewCell.m
//  TemplateScrolls
//
//  Created by 张贵广 on 2021/01/01.
//

#import "TTTableViewCell.h"
#import "UIView+TTReusableView.h"

@implementation TTTableViewCell

#pragma mark - init
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        
        [self makeSubview];
        [self makeConstraint];
        [self makeEvent];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self makeSubview];
    [self makeConstraint];
    [self makeEvent];
}

#pragma mark - Getter

- (UITableView *)tableView {
    return (UITableView *)self.superview;
}

- (NSIndexPath *)indexPath {
    return [(UITableView *)self.superview indexPathForRowAtPoint:self.center];
}

#pragma mark - TTTemplateViewProtocol
- (void)makeSubview {}
- (void)makeConstraint {}
- (void)makeEvent {}
- (void)refreshView:(id)data {}

@synthesize data = _data;
- (void)setData:(id)data {
    _data = data;
    [self refreshView:data];
}

#pragma mark - TTCellProvider

+ (NSString *)cellIdentifier {
    return [self tt_identifierWithKey:_cmd name:@"Cell"];
}

+ (instancetype)dequeueCellWithListView:(UIScrollView *)listView
                           forIndexPath:(NSIndexPath *)indexPath
                                   data:(id)data {
    UITableView *tableView = (UITableView *)listView;
    [tableView registerClass:self forCellReuseIdentifier:[self cellIdentifier]];
    TTTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[self cellIdentifier] forIndexPath:indexPath];
    cell.data = data;
    return cell;
}

@end
