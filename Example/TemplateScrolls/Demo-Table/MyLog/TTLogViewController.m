//
//  TTLogViewController.m
//  TemplateScrolls_Example
//
//  Created by 张贵广 on 2021/01/28.
//  Copyright © 2021 GG. All rights reserved.
//

#import "TTLogViewController.h"
#import "TTMessageModel.h"
#import "TTMessageCell.h"

@implementation TTLogViewController

- (void)makeSkeleton {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"log" ofType:@"json"];
    NSData *jsonData = [NSData dataWithContentsOfFile:filePath];
    NSError *error = nil;
    NSArray<NSDictionary *> *dataArray = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
    
    TTSectionTemplate *section = [TTSectionTemplate new];
    section.allowsMultipleSelection = NO;
    section.forceSelection = NO;
    [dataArray enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
        TTMessageModel *model = [TTMessageModel new];
        [model setValuesForKeysWithDictionary:obj];
        model.title = [NSString stringWithFormat:@"%lu - %@", idx, model.title];
        
        TTCellTemplate *cell = [TTCellTemplate new];
        cell.viewClass = [TTMessageCell class];
        cell.data = model;
        cell.height = model.height;
        [section.cells addObject:cell];
    }];
    [self.sections addObject:section];
}

@end
