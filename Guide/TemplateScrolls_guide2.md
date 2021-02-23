## TemplateScrolls 进阶教程

[TemplateScrolls 入门教程]

为了便于阅读，教程以 [TTTableView] 的用法为例，[TTCollectionView] 的用法基本上类似

### 统一配置、个性化配置

[TTTableView] 最主要的工作就是配置好 `sections` 和 `cells` 数组，就可以快速的渲染出视图了。

其中每一个 Cell 都是独立的，可以为不同的 Cell 设置不同的 **类型、数据、尺寸**

```language: Objective-C
TTCellTemplate *cell1 = [TTCellTemplate new];
cell.viewClass = [TTMessageCell class];	// type 1
cell.data = model1;

// 支持链式语法
TTCellTemplate *cell2 = TTCellTemplate.make
.viewClassSet([TTRadioCell class])		// type 2
.dataSet(model2);

TTSectionTemplate *section = [TTSectionTemplate new];
[section.cells addObject:cell1];
[section.cells addObject:cell2];
```

每一个 Cell 将按照你所配置的类型、数据进行渲染

但是当一个 section 中所有 Cell 的类型一致时，可以通过配置 section 指定一个 **统一的默认类型**

```language: Objective-C
TTSectionTemplate *section = [TTSectionTemplate new];
section.viewClass = [TTMessageCell class]; // 整个 Section 可以统一配置 Cell 类型

[section.cells addObject:model1]; // cells 可以直接存储 data
[section.cells addObject:model2];

```

### 自动刷新

[TTTableView] 的属性 `sections` 数组，在默认情况下，当你对配置数组进行改动操作时，TableView 会自动刷新视图。   
当然你也可以禁用这样的逻辑，自行手动刷新视图。只需要关闭他们的 [autoload] 选项即可 

```
tableView.autoload = NO;
```

### 有自己的BaseCell ?

也许你有自定义的 `BaseTableCell` 或 `BaseTableHeader`，不便于继承 [TTTableViewCell]、[TTTableReusableView] 时  

为了让自定义的基类支持可配置，可以参考 [TTTableViewCell] 等类，遵循 [TTCellProvider]、 [TTReusableViewProvider] 这两个视图协议。  
这样你的基类也就可以被支持用于 [TTTableView] 进行快速配置渲染

### 固定尺寸、自适应尺寸

不管 TableCell 还是 CollectionCell 都支持固定尺寸，支持使用约束自适应尺寸

* 设置固定宽高，只需要显示指定 [TTCellTemplate] 的 `width` 和 `height` 属性即可

	```language: Objective-C
	TTCellTemplate *cell = [TTCellTemplate new];
	cell.width = 100; // 对 tableView 无效
	cell.height = 40;
	```
	
* 动态计算宽高，**不能设置 `width` 和 `height` 属性**
	* 对于 TableCell，需要 Custom TableCell 内部的子控件，在垂直方向上以及与边界充满明确的约束
	* CollectionCell 的使用方式稍微复杂些，大概步骤如下 
		
		```language: Objective-C
		// 1. 设置大于 0 的预估尺寸
		TTCollectionView.layout.estimatedItemSize = CGSizeMake(100, 100);
		
		// 2. 与 Table 类似，Custom CollectionCell, 要在水平、垂直两个方向上，都有明确的约束
		```
		详细步骤 [参考这里][CollectionCellAutoSize]

	> 注意：目前只有 Table 支持高度缓存，Collection 如果使用动态宽高，性能会降低

### Section 单选多选

支持按照 Section 为单位，按组分别指定单选、多选逻辑

> 注意：使用该特性，必须要打开 tableView 的 `allowsMultipleSelection`

```language: Objective-C
self.tableView.allowsMultipleSelection = YES; // 该属性必须为YES

TTSectionTemplate *section = [TTSectionTemplate new];
section.allowsMultipleSelection = YES;	// 该组是否多选
section.forceSelection = NO;			// 该组是否强制选择
```

[常量]:----------------------------------------------
[TemplateScrolls 入门教程]:
./TemplateScrolls_guide1.md

[TemplateScrolls]:
https://github.com/Zhangguiguang/TemplateScrolls

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

[autoload]:
https://github.com/Zhangguiguang/TemplateScrolls/blob/1.0.2/TemplateScrolls/Classes/Base/TTViewTemplate.h#L160-L164

[TTCellProvider]:
https://github.com/Zhangguiguang/TemplateScrolls/blob/1.0.2/TemplateScrolls/Classes/Base/TTScrollProtocol.h#L85-L103
[TTReusableViewProvider]:
https://github.com/Zhangguiguang/TemplateScrolls/blob/1.0.2/TemplateScrolls/Classes/Base/TTScrollProtocol.h#L107-L136
[CollectionCellAutoSize]:
https://www.vadimbulavin.com/collection-view-cells-self-sizing/
