//
//  UIView+TTReusableView.h
//  TemplateScrolls
//
//  Created by 张贵广 on 2021/2/4.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (TTReusableView)

+ (NSString *)tt_identifierWithKey:(const void * _Nonnull)key name:(NSString *)name;

@end

NS_ASSUME_NONNULL_END
