//
//  TTCollectionViewCell.h
//  TemplateScrolls
//
//  Created by 张贵广 on 2021/01/03.
//

#import <UIKit/UIKit.h>
#import "TTScrollProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface TTCollectionViewCell : UICollectionViewCell <TTCollectionCellProvider>

- (void)setData:(id _Nullable)data NS_REQUIRES_SUPER;

@property (nonatomic, readonly) UICollectionView *collectionView;

@property (nonatomic, readonly) NSIndexPath *indexPath;

@end

NS_ASSUME_NONNULL_END
