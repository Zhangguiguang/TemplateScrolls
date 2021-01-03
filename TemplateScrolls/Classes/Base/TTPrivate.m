//
//  TTPrivate.m
//  TemplateScrolls
//
//  Created by 张贵广 on 2021/01/03.
//

#import "TTPrivate.h"
#import <objc/runtime.h>

inline NSString *_DefaultReusableIdentifer(Class Type, SEL sel, NSString *name) {
    NSString *identifier = objc_getAssociatedObject(Type, sel);
    if (identifier.length == 0) {
        identifier = [NSString stringWithFormat:@"TT-%@-%@", NSStringFromClass(Type), name];
        objc_setAssociatedObject(Type, sel, identifier, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return identifier;
}
