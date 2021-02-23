# TemplateScrolls 入门教程 - 快速开发 UITableView UICollectionView

[TemplateScrolls 进阶教程]

[TemplateScrolls] 提供了两个视图类 [TTTableView] 和 [TTCollectionView]，支持快速搭建 TableView 和 CollectionView.

它的便捷之处有

1. 省去了所有的 dataSource 和 delegate 的代理方法，只需要少量的列表配置。
2. 并且所得即所见，只要配置发生变化，列表会自动进行局部刷新。
3. 不用关心视图重用 (identifier) 的细节
4. Cell、Header、Footer 统一的代码风格

以 [TTTableView] 为例

### 1. 创建自定义 Cell、Header、Footer
继承 [TTTableViewCell]、 [TTTableReusableView]，创建自定义的可复用视图类

```language: Objective-C
@interface TTMessageCell : TTTableViewCell ...
@implementation TTMessageCell

// - init {} // 不需要实现 init 方法

// 在这里搭建你的 UI 视图层级结构
- (void)makeSubview { }

// 在这里为所有子视图创建约束
- (void)makeConstraint { }

// 使用 data 填充到视图上
- (void)refreshView:(TTMessageModel *)data { }

@end
```
```
// 与 Cell 相同，完全一样的代码结构
@interface TTMessageHeader : TTTableReusableView ...
@implementation TTMessageHeader
- (void)makeSubview { }
- (void)makeConstraint { }
- (void)refreshView:(NSString *)data { }
@end
```

### 2. 配置列表
Cell 和 Header/Footer 的配置分别是 [TTCellTemplate]，[TTReusableViewTemplate]，它们都属于 View 的配置，有两个重要的属性 `viewClass` 和 `data`，表示指定视图的类型，以及要展示的数据

Section 的配置是 [TTSectionTemplate]，主要是存储着 cells、header、footer 的配置

```
TTSectionTemplate *section = [TTSectionTemplate new];
section.header.viewClass = [TTMessageHeader class];
section.header.data =  @"2021-02-09";
// section.footer // 没有 footer 不需要配置

[dataArray enumerateObjectsUsingBlock:^(TTMessageModel *data, NSUInteger idx, BOOL *stop) {
	TTCellTemplate *cell = [TTCellTemplate new];
	cell.viewClass = [TTMessageCell class];
	cell.data = data;
	
	// 如果 cell 可以用约束自动撑开，这里可以不指定高度
	// cell.height = custom compute height with data
	[section.cells addObject:cell];
}];
```

### 3. 装入配置到 sections
[TTTableView] 的属性 `sections `，是一个数组，只需要将配置好的 sections 添加到里面即可

```
@property (nonatomic, readonly) TTTableView *tableView;

TTSectionTemplate *section = ......
[self.tableView.sections addObject:section];
```
如此， TableView 就快速的渲染出来了

### 4. CollectionView

类似的，如果你要开发一个CollectionView，也是一样的步骤

1. 继承 [TTCollectionViewCell], [TTCollectionReusableView]
2. 配置 [TTCellTemplate], [TTSectionTemplate]
3. 对 [TTCollectionView].[sections] 进行添加、替换、插入等操作

Demo 见 [这里][TemplateScrolls]

[常量区]:..........
[TemplateScrolls]:
https://github.com/Zhangguiguang/TemplateScrolls

[TemplateScrolls 进阶教程]:
./TemplateScrolls_guide2.md

[TTTableView]:
https://github.com/Zhangguiguang/TemplateScrolls/blob/1.0.2/TemplateScrolls/Classes/TTTableView/TTTableView.h
[TTTableViewCell]:
https://github.com/Zhangguiguang/TemplateScrolls/blob/1.0.2/TemplateScrolls/Classes/TTTableView/TTTableViewCell.h
[TTTableReusableView]:
https://github.com/Zhangguiguang/TemplateScrolls/blob/1.0.2/TemplateScrolls/Classes/TTTableView/TTTableReusableView.h

[TTCollectionView]:
https://github.com/Zhangguiguang/TemplateScrolls/blob/1.0.2/TemplateScrolls/Classes/TTCollectionView/TTCollectionView.h
[TTCollectionViewCell]:
https://github.com/Zhangguiguang/TemplateScrolls/blob/1.0.2/TemplateScrolls/Classes/TTCollectionView/TTCollectionViewCell.h
[TTCollectionReusableView]:
https://github.com/Zhangguiguang/TemplateScrolls/blob/1.0.2/TemplateScrolls/Classes/TTCollectionView/TTCollectionReusableView.h

[TTCellTemplate]:
https://github.com/Zhangguiguang/TemplateScrolls/blob/1.0.2/TemplateScrolls/Classes/Base/TTViewTemplate.h#L38-L67
[TTReusableViewTemplate]:
https://github.com/Zhangguiguang/TemplateScrolls/blob/1.0.2/TemplateScrolls/Classes/Base/TTViewTemplate.h#L72-L92
[TTSectionTemplate]:
https://github.com/Zhangguiguang/TemplateScrolls/blob/1.0.2/TemplateScrolls/Classes/Base/TTViewTemplate.h#L96-L143
[sections]:
https://github.com/Zhangguiguang/TemplateScrolls/blob/1.0.2/TemplateScrolls/Classes/Base/TTViewTemplate.h#L158