//
//  TTCommerceImageCell.m
//  TemplateScrolls_Example
//
//  Created by 张贵广 on 2021/01/31.
//  Copyright © 2021 GG. All rights reserved.
//

#import "TTCommerceImageCell.h"
#import "TTCommerceModel.h"

@interface TTCommerceImageCell ()
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *label;
@end

@implementation TTCommerceImageCell

- (void)makeSubview {
    [self.contentView addSubview:self.imageView];
    [self.contentView addSubview:self.label];
}

- (void)makeConstraint {
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(@8);
        make.trailing.lessThanOrEqualTo(@-8);
        make.bottom.equalTo(@-6);
    }];
}

- (void)refreshView:(TTCommerceModel *)data {
    self.label.text = [@"❗️ " stringByAppendingString:data.title];
}

#pragma mark - Lazy Load

TTLazyLoadNew(UIImageView, imageView, {
    z.contentMode = UIViewContentModeScaleAspectFit;
    z.backgroundColor = RandomColor;
})

TTLazyLoadNew(UILabel, label)

@end
