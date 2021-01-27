//
//  TTToast.h
//  TemplateScrolls_Example
//
//  Created by 张贵广 on 2021/01/28.
//  Copyright © 2021 GG. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TTToast : NSObject

+ (void)show:(NSString *)msg;

+ (void)show:(NSString *)msg delay:(NSTimeInterval)delay;

@end

NS_ASSUME_NONNULL_END
