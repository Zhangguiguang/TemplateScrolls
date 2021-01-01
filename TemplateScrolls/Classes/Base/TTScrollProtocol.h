//
//  TTScrollProtocol.h
//  TemplateScrolls
//
//  Created by 张贵广 on 2021/01/01.
//

#import <Foundation/Foundation.h>

#if __has_include(<Masonry/Masonry.h>)
#import <Masonry/Masonry.h>
#endif

#define TTLazyLoad(Type, Name, Code...) \
- (Type *)Name { \
    if (!_##Name) { \
        Type *z = nil; \
        Code; \
        _##Name = z; \
    }\
    return _##Name; \
}

#define TTLazyLoadNew(Type, Name, Code...) \
- (Type *)Name { \
    if (!_##Name) { \
        Type *z = [Type new]; \
        _##Name = z; \
        Code; \
    }\
    return _##Name; \
}

NS_ASSUME_NONNULL_BEGIN

/**
 Table、Collection 的 Cell、Header、Footer 通用的属性、方法
 */
@protocol TTTemplateViewProtocol <NSObject>

@required

/**
 view 的数据
 */
@property (nonatomic, strong, nullable) id data;


/**
 使用 data 渲染子视图
 自动在 setData: 之后调用
 */
- (void)refreshView:(id)data;


@optional

/**
 创建子视图
 自动在 init 之后调用
 */
- (void)makeSubview;

/**
 简历视图之间的约束
 自动在 init 之后调用
 */
- (void)makeConstraint;

/**
 绑定响应事件
 自动在 init 之后调用
 */
- (void)makeEvent;

@end


@protocol TTTemplateViewProvider <TTTemplateViewProtocol>

@required
/**
 要提供的 Cell 的重用标识
 */
@property (nonatomic, readonly, class) NSString *reuseIdentifier;

@end

@protocol TTTableCellProvider <TTTemplateViewProvider>
@end

@protocol TTTableReusableViewProvider <TTTemplateViewProvider>
@end

@protocol TTCollectionCellProvider <TTTemplateViewProvider>
@end

@protocol TTCollectionReusableViewProvider <TTTemplateViewProvider>
@end

NS_ASSUME_NONNULL_END
