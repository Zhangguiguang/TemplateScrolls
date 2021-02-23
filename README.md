# TemplateScrolls

[![CI Status](https://img.shields.io/travis/GG/TemplateScrolls.svg?style=flat)](https://travis-ci.org/GG/TemplateScrolls)
[![Version](https://img.shields.io/cocoapods/v/TemplateScrolls.svg?style=flat)](https://cocoapods.org/pods/TemplateScrolls)
[![License](https://img.shields.io/cocoapods/l/TemplateScrolls.svg?style=flat)](https://cocoapods.org/pods/TemplateScrolls)
[![Platform](https://img.shields.io/cocoapods/p/TemplateScrolls.svg?style=flat)](https://cocoapods.org/pods/TemplateScrolls)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Installation

TemplateScrolls is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'TemplateScrolls'
```

## Usage

[TemplateScrolls 入门教程]

[TemplateScrolls 进阶教程]

#### 1. import 

```
#import <TemplateScrolls/TTTableView.h>
#import <TemplateScrolls/TTCollectionView.h>
```

#### 2. Custom Your Cell、 Header、Footer

you need extend `TTTableViewCell`, `TTTableReusableView` or `TTCollectionViewCell`, `TTCollectionReusableView`

```
#import <TemplateScrolls/TTTableViewCell.h>
@interface TTMessageCell : TTTableViewCell
@property (nonatomic, strong) UILabel *titleLabel;
@end

@implementation TTMessageCell

- (void)makeSubview {
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(12);
        make.top.mas_equalTo(12);
    }];
}

- (void)refreshView:(NSString *)data {
    self.titleLabel.text = data.title;
}

TTLazyLoadNew(UILabel, titleLabel, {
    z.font = [UIFont systemFontOfSize:18 weight:UIFontWeightBold];
})

@end
```

#### 3. Config Template Array

```
TTSectionTemplate *section = [TTSectionTemplate new];
section.viewClass = [TTMessageCell class]; // your custom cell

NSArray *dataArray = [@"111", @"222", @"333", ...];
[section.cells addObjectsFromArray:dataArray];

// if you use tableView
TTTableView *tableView = [TTTableView new];
[tableView.sections addObject:section];

// if you use collectionView
TTCollectionView *collectionView = [TTCollectionView new];
[collectionView.sections addObject:section];
```

A TableView or CollectionView can be rendered immediately.


## License

TemplateScrolls is available under the MIT license. See the LICENSE file for more info.


[Constant]:.......
[TemplateScrolls 入门教程]:
./Guide/TemplateScrolls_guide1.md

[TemplateScrolls 进阶教程]:
./Guide/TemplateScrolls_guide2.md