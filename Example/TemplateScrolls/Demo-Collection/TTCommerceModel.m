//
//  TTCommerceModel.m
//  TemplateScrolls_Example
//
//  Created by 张贵广 on 2021/01/31.
//  Copyright © 2021 GG. All rights reserved.
//

#import "TTCommerceModel.h"

@implementation TTCommerceModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

+ (NSArray<TTCommerceModel *> *)demoArray {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"commerce" ofType:@"json"];
    NSData *jsonData = [NSData dataWithContentsOfFile:filePath];
    NSError *error = nil;
    NSArray<NSDictionary *> *dataArray = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
    
    NSMutableArray *temp = [NSMutableArray array];
    [dataArray enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
        TTCommerceModel *model = [TTCommerceModel new];
        [model setValuesForKeysWithDictionary:obj];
        [temp addObject:model];
    }];
    return [temp copy];
}

@end
