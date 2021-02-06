//
//  TTCommerceViewController.m
//  TemplateScrolls_Example
//
//  Created by 张贵广 on 2021/01/31.
//  Copyright © 2021 GG. All rights reserved.
//

#import "TTCommerceViewController.h"
#import "TTCommerceModel.h"
#import "TTCommerceImageCell.h"
#import "TTCommerceItemCell.h"
#import <SafariServices/SFSafariViewController.h>

@interface TTCommerceViewController ()

@end

@implementation TTCommerceViewController

- (void)makeSkeleton {
    self.collectionView.contentInset = UIEdgeInsetsMake(10, 0, 10, 0);
    tt_weakify(self);
    self.collectionView.didSelect = ^(NSIndexPath *indexPath, TTCommerceModel *data) {
        if ([data isKindOfClass:[TTCommerceModel class]]) {
            tt_strongify(self);
            NSURL *url = [NSURL URLWithString:data.router];
            SFSafariViewController *vc = [[SFSafariViewController alloc] initWithURL:url];
            [self presentViewController:vc animated:YES completion:nil];
        }
    };
    
    {
        TTSectionTemplate *imageSection = [TTSectionTemplate new];
        imageSection.viewClass = [TTCommerceImageCell class];
        imageSection.width = TTScreenWidth();
        imageSection.height = 80;
        
        NSArray *dataArray = [TTCommerceModel demoArray];
        [imageSection.cells addObjectsFromArray:dataArray];
        [self.sections addObject:imageSection];
    }
    {
        // 左右边距 12， 中间 10
        CGFloat width = (TTScreenWidth() - 12*2 - 10*3) / 4.0;
        
        TTSectionTemplate *categorySection = TTSectionTemplate.make
        .viewClassSet([TTCommerceItemCell class])
        .alignmentSet(TTCollectionItemAlignmentLeft)
        .verticalSpacingSet(10)
        .horizontalSpacingSet(10)
        .insetsSet(UIEdgeInsetsMake(10, 12, 0, 0))
        .widthSet(width)
        .heightSet(width + 20);
        
        NSArray *dataArray = [TTCommerceModel demoArray];
        [categorySection.cells addObjectsFromArray:dataArray];
        [categorySection.cells addObjectsFromArray:dataArray];
        [self.sections addObject:categorySection];
    }
    {
        CGFloat width = (TTScreenWidth() - 12*2 - 10) / 2.0;
        
        TTSectionTemplate *section = TTSectionTemplate.make
        .viewClassSet([TTCommerceImageCell class])
        .alignmentSet(TTCollectionItemAlignmentCenter)
        .verticalSpacingSet(10)
        .horizontalSpacingSet(10)
        .insetsSet(UIEdgeInsetsMake(10, 0, 0, 0))
        .widthSet(width)
        .heightSet(width * 0.618);
        
        NSArray *dataArray = [TTCommerceModel demoArray];
        [section.cells addObjectsFromArray:dataArray];
        [self.sections addObject:section];
    }
    
}

@end
