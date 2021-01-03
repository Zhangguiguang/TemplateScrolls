//
//  TTCollectionView.h
//  TemplateScrolls
//
//  Created by 张贵广 on 2020/12/29.
//

#import <UIKit/UIKit.h>
#import "TTViewTemplate.h"
#import "TTScrollProtocol.h"

NS_ASSUME_NONNULL_BEGIN

typedef TTCellTemplate<Class<UICollectionViewDelegate>, UICollectionViewCell *> TTCollectionCellTemplate;
typedef TTReusableViewTemplate<Class<UICollectionViewDataSource>, UICollectionReusableView *> TTCollectionReusableViewTemplate;
typedef TTSectionTemplate<TTCollectionCellTemplate *, TTCollectionReusableViewTemplate *> TTCollectionSectionTemplate;
typedef NSMutableArray<TTCollectionSectionTemplate *> TTCollectionTemplateArray;

@interface TTCollectionView : UICollectionView

@property (nonatomic, readonly) TTCollectionTemplateArray *sectionArray;

@end

NS_ASSUME_NONNULL_END
