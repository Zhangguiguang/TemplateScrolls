//
//  NSMutableArray+TTObserverable.h
//  TTMutableArray
//
//  Created by 张贵广 on 2020/12/24.
//

#import <Foundation/Foundation.h>
#import "TTMutableArray.h"

NS_ASSUME_NONNULL_BEGIN

@interface NSMutableArray (TTObserverable)

- (NSMutableArray *)tt_getObserverableArrayWithObserver:(id<TTMutableArrayObserver>)observer;

@end

NS_ASSUME_NONNULL_END
