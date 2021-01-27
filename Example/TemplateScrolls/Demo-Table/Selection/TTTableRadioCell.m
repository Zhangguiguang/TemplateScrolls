//
//  TTTableRadioCell.m
//  TemplateScrolls_Example
//
//  Created by 张贵广 on 2021/01/28.
//  Copyright © 2021 GG. All rights reserved.
//

#import "TTTableRadioCell.h"

@interface TTTableRadioCell ()
@property (nonatomic, strong) UILabel *iconView;
@property (nonatomic, strong) UILabel *titleLabel;
@end

@implementation TTTableRadioCell

- (void)makeSubview {
    [self.contentView addSubview:self.iconView];
    [self.contentView addSubview:self.titleLabel];
}

- (void)makeConstraint {
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@10);
        make.bottom.lessThanOrEqualTo(@-10);
        make.leading.equalTo(@14);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.iconView);
        make.leading.equalTo(self.iconView.mas_trailing).offset(8);
    }];
}

- (void)refreshView:(id)data {
    self.titleLabel.text = data;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (selected) {
        self.iconView.text = @"🔴";
    } else {
        self.iconView.text = @"🔘";
    }
}

TTLazyLoadNew(UILabel, iconView, {
    z.text = @"🔘";
})

TTLazyLoadNew(UILabel, titleLabel)

@end
