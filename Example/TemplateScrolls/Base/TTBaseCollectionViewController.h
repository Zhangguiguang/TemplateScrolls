//
//  TTBaseCollectionViewController.h
//  TemplateScrolls_Example
//
//  Created by 张贵广 on 2021/01/31.
//  Copyright © 2021 GG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TemplateScrolls/TemplateScrolls.h>

NS_ASSUME_NONNULL_BEGIN

@interface TTBaseCollectionViewController : UIViewController

@property (nonatomic, readonly) TTCollectionView *collectionView;
@property (nonatomic, readonly) TTCollectionTemplateArray *sections;

- (void)makeSkeleton;

@end

NS_ASSUME_NONNULL_END
