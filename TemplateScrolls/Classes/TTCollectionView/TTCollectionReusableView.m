//
//  TTCollectionReusableView.m
//  TemplateScrolls
//
//  Created by 张贵广 on 2021/01/03.
//

#import "TTCollectionReusableView.h"
#import "TTPrivate.h"

@implementation TTCollectionReusableView

#pragma mark - init

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
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

- (UICollectionView *)collectionView {
    return (UICollectionView *)self.superview;
}

- (UIView *)contentView {
    return self;
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

#pragma mark - TTTableReusableViewProvider

+ (NSString *)reuseIdentifier {
    return _DefaultReusableIdentifer(self, _cmd, @"Header");
}

+ (NSString *)reuseIdentifier2 {
    return _DefaultReusableIdentifer(self, _cmd, @"Footer");
}

@end
