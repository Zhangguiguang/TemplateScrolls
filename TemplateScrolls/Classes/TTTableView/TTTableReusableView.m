//
//  TTTableReusableView.m
//  TemplateScrolls
//
//  Created by 张贵广 on 2021/01/01.
//

#import "TTTableReusableView.h"
#import <objc/runtime.h>

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

#pragma mark - TTTableViewCellProvider

+ (NSString *)reuseIdentifier {
    NSString *identifier = objc_getAssociatedObject(self, _cmd);
    if (identifier.length == 0) {
        identifier = [NSString stringWithFormat:@"TT-%@Identifier", NSStringFromClass(self)];
        objc_setAssociatedObject(self, _cmd, identifier, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return identifier;
}

@end
