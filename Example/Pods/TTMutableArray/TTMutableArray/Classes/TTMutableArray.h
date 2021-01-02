//
//  TTMutableArray.h
//  TTMutableArray
//
//  Created by 张贵广 on 2020/12/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol TTMutableArrayObserver <NSObject>

@optional
- (void)mutableArray:(NSMutableArray *)array didInsertObjects:(NSArray *)objects atIndexes:(NSIndexSet *)indexes;
- (void)mutableArray:(NSMutableArray *)array didRemoveObjects:(NSArray *)objects atIndexes:(NSIndexSet *)indexes;
- (void)mutableArray:(NSMutableArray *)array didReplaceObjects:(NSArray *)objects atIndexes:(NSIndexSet *)indexes;
- (void)mutableArray:(NSMutableArray *)array beReplacedObjects:(NSArray *)objects atIndexes:(NSIndexSet *)indexes;

@end


@interface TTMutableArray <ObjectType> : NSMutableArray

@property (nonatomic, weak) id<TTMutableArrayObserver> observer;

@end

NS_ASSUME_NONNULL_END
