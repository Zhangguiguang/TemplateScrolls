//
//  TTTableReusableView.m
//  TemplateScrolls
//
//  Created by 张贵广 on 2021/01/01.
//

#import "TTTableReusableView.h"
#import "UIView+TTReusableView.h"

@implementation TTTableReusableView

#pragma mark - init

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundView = [UIView new];
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

#pragma mark - TTReusableViewProvider

+ (NSString *)headerIdentifier {
    return [self tt_identifierWithKey:_cmd name:@"Header"];
}

+ (NSString *)footerIdentifier {
    return [self tt_identifierWithKey:_cmd name:@"Footer"];
}

+ (instancetype)dequeueHeaderWithListView:(UIScrollView *)listView
                               forSection:(NSInteger)section
                                     data:(id)data {
    return [self _dequeueViewWithListView:listView identifier:[self headerIdentifier] data:data];
}

+ (instancetype)dequeueFooterWithListView:(UIScrollView *)listView
                               forSection:(NSInteger)section
                                     data:(id)data {
    return [self _dequeueViewWithListView:listView identifier:[self footerIdentifier] data:data];
}

+ (instancetype)_dequeueViewWithListView:(UIScrollView *)listView
                              identifier:(NSString *)identifer
                                    data:(id)data {
    UITableView *tableView = (UITableView *)listView;
    [tableView registerClass:self forHeaderFooterViewReuseIdentifier:identifer];
    TTTableReusableView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:identifer];
    if (!view) {
        view = [[TTTableReusableView alloc] initWithReuseIdentifier:identifer];
    }
    view.data = data;
    return view;
}


@end
