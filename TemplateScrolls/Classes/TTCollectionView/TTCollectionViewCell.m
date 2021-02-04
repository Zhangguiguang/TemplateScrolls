//
//  TTCollectionViewCell.m
//  TemplateScrolls
//
//  Created by 张贵广 on 2021/01/03.
//

#import "TTCollectionViewCell.h"
#import "TTPrivate.h"

@implementation TTCollectionViewCell

#pragma mark - init

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
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

- (UICollectionView *)collectionView {
    return (UICollectionView *)self.superview;
}

- (NSIndexPath *)indexPath {
    return [(UICollectionView *)self.superview indexPathForItemAtPoint:self.center];
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
    return _DefaultReusableIdentifer(self, _cmd, @"Cell");
}

@end
