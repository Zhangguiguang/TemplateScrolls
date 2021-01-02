//
//  TTMessageCell.m
//  TemplateScrolls_Example
//
//  Created by 张贵广 on 2021/01/01.
//  Copyright © 2021 GG. All rights reserved.
//

#import "TTMessageCell.h"

@implementation TTMessageModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {}
@end

@interface TTMessageCell ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *msgLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@end

@implementation TTMessageCell

- (void)makeSubview {
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.msgLabel];
    [self.contentView addSubview:self.timeLabel];
}

- (void)makeConstraint {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(12);
        make.top.mas_equalTo(12);
    }];
    [self.msgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.titleLabel);
        make.trailing.mas_lessThanOrEqualTo(-12);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
        make.bottom.mas_lessThanOrEqualTo(-12);
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.greaterThanOrEqualTo(self.titleLabel.mas_trailing).offset(8);
        make.trailing.mas_equalTo(-12);
        make.centerY.equalTo(self.titleLabel);
    }];
}

- (void)refreshView:(TTMessageModel *)data {
    self.titleLabel.text = data.title;
    self.msgLabel.text = data.msg;
    self.timeLabel.text = data.time;
}

#pragma mark - Getter

TTLazyLoadNew(UILabel, titleLabel, {
    z.font = [UIFont systemFontOfSize:18 weight:UIFontWeightBold];
})

TTLazyLoadNew(UILabel, msgLabel, {
    z.font = [UIFont systemFontOfSize:15 weight:UIFontWeightMedium];
    z.textColor = [UIColor darkGrayColor];
    z.numberOfLines = 0;
})

TTLazyLoadNew(UILabel, timeLabel, {
    z.font = [UIFont systemFontOfSize:15 weight:UIFontWeightBold];
    z.textColor = [UIColor orangeColor];
})

@end
