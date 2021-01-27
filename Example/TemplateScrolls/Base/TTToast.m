//
//  TTToast.m
//  TemplateScrolls_Example
//
//  Created by 张贵广 on 2021/01/28.
//  Copyright © 2021 GG. All rights reserved.
//

#import "TTToast.h"
#import <Masonry/Masonry.h>

@implementation TTToast

+ (void)show:(NSString *)msg {
    [self show:msg delay:2.0];
}

+ (void)show:(NSString *)msg delay:(NSTimeInterval)delay {
    UIView *background = [UIView new];
    background.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.8];
    background.layer.cornerRadius = 6;
    background.userInteractionEnabled = NO;
    
    UILabel *label = [UILabel new];
    label.text = msg;
    label.numberOfLines = 0;
    label.textColor = [UIColor whiteColor];
    
    [UIApplication.sharedApplication.keyWindow addSubview:background];
    [background addSubview:label];
    
    [background mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(UIApplication.sharedApplication.keyWindow);
        make.leading.greaterThanOrEqualTo(@44);
    }];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(12, 18, 12, 18));
    }];
    
    [background performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:delay];
}

@end
