//
//  TTBaseCollectionViewController.m
//  TemplateScrolls_Example
//
//  Created by 张贵广 on 2021/01/31.
//  Copyright © 2021 GG. All rights reserved.
//

#import "TTBaseCollectionViewController.h"

@interface TTBaseCollectionViewController ()

@end

@implementation TTBaseCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _makeCollectionView];
    [self makeSkeleton];
}

- (void)_makeCollectionView {
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.edges.mas_equalTo(self.view.safeAreaInsets);
        } else {
            make.edges.mas_equalTo(UIEdgeInsetsZero);
        }
    }];
}

- (void)makeSkeleton {}


@synthesize collectionView = _collectionView;
- (TTCollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [TTCollectionView new];
    }
    return _collectionView;
}

- (TTCollectionTemplateArray *)sections {
    return self.collectionView.sections;
}

@end
