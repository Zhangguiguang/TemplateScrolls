//
//  TTMessageCell.h
//  TemplateScrolls_Example
//
//  Created by 张贵广 on 2021/01/01.
//  Copyright © 2021 GG. All rights reserved.
//

#import <TemplateScrolls/TTTableViewCell.h>

NS_ASSUME_NONNULL_BEGIN

// 为了方便，model直接写在这里了
@interface TTMessageModel : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *msg;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, assign) CGFloat height;

@end

@interface TTMessageCell : TTTableViewCell

@end

NS_ASSUME_NONNULL_END
