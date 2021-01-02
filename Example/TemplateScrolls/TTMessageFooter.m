//
//  TTMessageFooter.m
//  TemplateScrolls_Example
//
//  Created by 张贵广 on 2021/01/02.
//  Copyright © 2021 GG. All rights reserved.
//

#import "TTMessageFooter.h"

@interface TTMessageFooter ()
@property (nonatomic, strong) UILabel *fakeImageView;
@property (nonatomic, strong) UILabel *messageLabel;
@end

@implementation TTMessageFooter

- (void)makeSubview {
    self.contentView.backgroundColor = [UIColor lightGrayColor];
    [self.contentView addSubview:self.fakeImageView];
    [self.contentView addSubview:self.messageLabel];
}

- (void)makeConstraint {
    [self.fakeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(12);
        make.top.mas_equalTo(12);
        make.trailing.mas_lessThanOrEqualTo(-12);
        make.bottom.mas_lessThanOrEqualTo(-12);
    }];
    [self.messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.fakeImageView);
        make.top.equalTo(self.fakeImageView.mas_bottom).offset(8);
        make.trailing.mas_lessThanOrEqualTo(-12);
        make.bottom.mas_lessThanOrEqualTo(-12);
    }];
}

- (void)refreshView:(id)data {
    self.messageLabel.text = data;
}


TTLazyLoadNew(UILabel, fakeImageView, {
    z.text = @">>>>>>>>>> custom footer <<<<<<<<<";
})

TTLazyLoadNew(UILabel, messageLabel, {
    z.numberOfLines = 0;
})

@end
