//
//  TTMessageModel.h
//  TemplateScrolls_Example
//
//  Created by 张贵广 on 2021/01/28.
//  Copyright © 2021 GG. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TTMessageModel : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *msg;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, assign) CGFloat height;

@end

NS_ASSUME_NONNULL_END
