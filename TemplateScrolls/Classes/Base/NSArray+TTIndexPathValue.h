//
//  NSArray+TTIndexPathValue.h
//  TemplateScrolls
//
//  Created by 张贵广 on 2021/2/4.
//

#import <Foundation/Foundation.h>
#import <TTScrollProtocol.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSArray (TTIndexPathValue)

- (Class<TTCellProvider>)tt_viewClassAtIndexPath:(NSIndexPath *)indexPath;
- (CGFloat)tt_widthAtIndexPath:(NSIndexPath *)indexPath;
- (CGFloat)tt_heightAtIndexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
