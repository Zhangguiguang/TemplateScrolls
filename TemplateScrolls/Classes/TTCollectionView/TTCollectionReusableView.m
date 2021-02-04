//
//  TTCollectionReusableView.m
//  TemplateScrolls
//
//  Created by 张贵广 on 2021/01/03.
//

#import "TTCollectionReusableView.h"
#import "UIView+TTReusableView.h"

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
    UICollectionView *collectionView = (UICollectionView *)listView;
    [collectionView registerClass:self forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:[self headerIdentifier]];
    TTCollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:[self headerIdentifier] forIndexPath:[NSIndexPath indexPathForItem:0 inSection:section]];
    view.data = data;
    return view;
}

+ (instancetype)dequeueFooterWithListView:(UIScrollView *)listView
                               forSection:(NSInteger)section
                                     data:(id)data {
    UICollectionView *collectionView = (UICollectionView *)listView;
    [collectionView registerClass:self forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:[self footerIdentifier]];
    TTCollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:[self footerIdentifier] forIndexPath:[NSIndexPath indexPathForItem:0 inSection:section]];
    view.data = data;
    return view;
}

@end
