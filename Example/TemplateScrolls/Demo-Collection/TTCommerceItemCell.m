//
//  TTCommerceItemCell.m
//  TemplateScrolls_Example
//
//  Created by 张贵广 on 2021/01/31.
//  Copyright © 2021 GG. All rights reserved.
//

#import "TTCommerceItemCell.h"
#import "TTCommerceModel.h"

@interface TTCommerceItemCell ()
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *label;
@end

@implementation TTCommerceItemCell

- (void)makeSubview {
    [self.contentView addSubview:self.imageView];
    [self.contentView addSubview:self.label];
}

- (void)makeConstraint {
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(self.contentView);
        make.height.equalTo(self.imageView.mas_width);
    }];
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.contentView);
        make.trailing.equalTo(self.contentView);
        make.top.equalTo(self.imageView.mas_bottom).offset(4);
        make.bottom.lessThanOrEqualTo(self.contentView);
    }];
}

- (void)refreshView:(TTCommerceModel *)data {
    self.label.text = data.title;
}

#pragma mark - Lazy Load
TTLazyLoadNew(UIImageView, imageView, {
    z.contentMode = UIViewContentModeScaleAspectFit;
    z.backgroundColor = RandomColor;
})

TTLazyLoadNew(UILabel, label, {
    z.textColor = [UIColor colorWithWhite:0.2 alpha:1];
    z.font = [UIFont systemFontOfSize:14];
    z.textAlignment = NSTextAlignmentCenter;
})

@end
