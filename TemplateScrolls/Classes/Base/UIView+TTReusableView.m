//
//  UIView+TTReusableView.m
//  TemplateScrolls
//
//  Created by 张贵广 on 2021/2/4.
//

#import "UIView+TTReusableView.h"
#import <objc/runtime.h>

@implementation UIView (TTReusableView)

+ (NSString *)tt_identifierWithKey:(const void *)key name:(NSString *)name {
    NSString *identifier = objc_getAssociatedObject(self, key);
    if (identifier.length == 0) {
        identifier = [NSString stringWithFormat:@"TT-%@-%@", NSStringFromClass(self), name];
        objc_setAssociatedObject(self, key, identifier, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return identifier;
}

@end
