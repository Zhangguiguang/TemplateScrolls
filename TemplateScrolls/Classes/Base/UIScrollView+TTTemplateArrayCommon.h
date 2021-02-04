//
//  UIScrollView+TTTemplateArrayCommon.h
//  TemplateScrolls
//
//  Created by 张贵广 on 2021/2/4.
//

#import <UIKit/UIKit.h>
#import <TTScrollProtocol.h>
#import <TTViewTemplate.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIScrollView (TTTemplateArrayCommon) <TTTemplateArrayOperator>

- (Class<TTCellProvider>)viewClassAtIndexPath:(NSIndexPath *)indexPath;
- (CGFloat)widthAtIndexPath:(NSIndexPath *)indexPath;
- (CGFloat)heightAtIndexPath:(NSIndexPath *)indexPath;

- (TTCellWillDisplay)willDisplayAtIndexPath:(NSIndexPath *)indexPath;
- (TTCellDidSelect)didSelectAtIndexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
