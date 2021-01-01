//
//  TTTableViewCell.m
//  TemplateScrolls
//
//  Created by 张贵广 on 2021/01/01.
//

#import "TTTableViewCell.h"
#import <objc/runtime.h>

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
