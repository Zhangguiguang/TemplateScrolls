//
//  TTCommerceModel.h
//  TemplateScrolls_Example
//
//  Created by 张贵广 on 2021/01/31.
//  Copyright © 2021 GG. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TTCommerceModel : NSObject

@property (nonatomic, copy) NSString *imageUrl;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *router;

+ (NSArray<TTCommerceModel *> *)demoArray;

@end

NS_ASSUME_NONNULL_END
