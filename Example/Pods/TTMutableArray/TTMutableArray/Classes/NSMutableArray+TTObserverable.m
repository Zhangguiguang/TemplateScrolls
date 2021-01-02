//
//  NSMutableArray+TTObserverable.m
//  TTMutableArray
//
//  Created by 张贵广 on 2020/12/24.
//

#import "NSMutableArray+TTObserverable.h"
#import <objc/runtime.h>

@interface _TTTempObserver : NSObject

@property (nonatomic, weak) id<TTMutableArrayObserver> observer;
@property (nonatomic, weak) NSMutableArray *kvoArray;

@end

@implementation _TTTempObserver

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSKeyValueChangeKey,id> *)change
                       context:(void *)context {
    if ([keyPath isEqualToString:@"kvoArray"]) {
        NSKeyValueChange type = [change[NSKeyValueChangeKindKey] integerValue];
        NSIndexSet *indexes = change[NSKeyValueChangeIndexesKey];
        
        switch (type) {
            case NSKeyValueChangeInsertion:
            {
                NSArray *new = change[NSKeyValueChangeNewKey];
                if (new.count > 0) {
                    if ([_observer respondsToSelector:@selector(mutableArray:didInsertObjects:atIndexes:)]) {
                        [_observer mutableArray:_kvoArray didInsertObjects:new atIndexes:indexes];
                    }
                }
            }
                break;
                
            case NSKeyValueChangeRemoval:
            {
                NSArray *old = change[NSKeyValueChangeOldKey];
                if (old.count > 0) {
                    if ([_observer respondsToSelector:@selector(mutableArray:didRemoveObjects:atIndexes:)]) {
                        [_observer mutableArray:_kvoArray didRemoveObjects:old atIndexes:indexes];
                    }
                }
            }
                break;
                
            case NSKeyValueChangeReplacement:
            {
                NSArray *old = change[NSKeyValueChangeOldKey];
                if (old.count > 0) {
                    if ([_observer respondsToSelector:@selector(mutableArray:beReplacedObjects:atIndexes:)]) {
                        [_observer mutableArray:_kvoArray beReplacedObjects:old atIndexes:indexes];
                    }
                }

                NSArray *new = change[NSKeyValueChangeNewKey];
                if (new.count > 0) {
                    if ([_observer respondsToSelector:@selector(mutableArray:didReplaceObjects:atIndexes:)]) {
                        [_observer mutableArray:_kvoArray didReplaceObjects:new atIndexes:indexes];
                    }
                }
            }
                break;
                
            default:
                break;
        }
    }
}

#pragma mark - MutableArray KVO Method

- (id)objectInKvoArrayAtIndex:(NSUInteger)index {
    return [_kvoArray objectAtIndex:index];
}

- (void)insertObject:(id)object inKvoArrayAtIndex:(NSUInteger)index {
    [_kvoArray insertObject:object atIndex:index];
}

- (void)insertKvoArray:(NSArray *)array atIndexes:(NSIndexSet *)indexes {
    [_kvoArray insertObjects:array atIndexes:indexes];
}

- (void)removeObjectFromKvoArrayAtIndex:(NSUInteger)index {
    [_kvoArray removeObjectAtIndex:index];
}

- (void)removeKvoArrayAtIndexes:(NSIndexSet *)indexes {
    [_kvoArray removeObjectsAtIndexes:indexes];
}

- (void)replaceObjectInKvoArrayAtIndex:(NSUInteger)index withObject:(id)object {
    [_kvoArray replaceObjectAtIndex:index withObject:object];
}

- (void)replaceKvoArrayAtIndexes:(NSIndexSet *)indexes withKvoArray:(NSArray *)array {
    [_kvoArray replaceObjectsAtIndexes:indexes withObjects:array];
}

@end


@interface NSMutableArray ()
@property (nonatomic, strong) _TTTempObserver *tempObserver;
@end

@implementation NSMutableArray (TTObserverable)

- (void)setTempObserver:(_TTTempObserver *)tempObserver {
    objc_setAssociatedObject(self, @selector(tempObserver), tempObserver, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (_TTTempObserver *)tempObserver {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)dealloc {
    if (self.tempObserver) {
        [self.tempObserver removeObserver:self.tempObserver forKeyPath:@"kvoArray"];
        self.tempObserver = nil;
    }
}

- (NSMutableArray *)tt_getObserverableArrayWithObserver:(id<TTMutableArrayObserver>)observer {
    if (!observer) {
        NSAssert(NO, @"id<TTMutableArrayObserver> observer cant be nil");
    }
    if (![observer conformsToProtocol:@protocol(TTMutableArrayObserver)]) {
        NSLog(@"Warning: observer Must be Conform the Prococol <TTMutableArrayObserver>");
        return nil;
    }
    
    _TTTempObserver *tempObserver = [_TTTempObserver new];
    tempObserver.observer = observer;
    tempObserver.kvoArray = self;
    self.tempObserver = tempObserver;
    
    NSString *kvokey = NSStringFromSelector(@selector(kvoArray));
    [tempObserver addObserver:tempObserver forKeyPath:kvokey options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    NSMutableArray *observerableArray = [tempObserver mutableArrayValueForKey:kvokey];
    return observerableArray;
}

#pragma mark - Improve Perfomance

- (void)addObjectsFromArray:(NSArray*)array {
    NSUInteger count = self.count;
    NSRange range = {count, array.count};
    NSIndexSet* indexSet = [NSIndexSet indexSetWithIndexesInRange:range];
    [self insertObjects:array atIndexes:indexSet];
}

- (void)removeAllObjects {
    NSRange range = {0, self.count};
    NSIndexSet* indexSet = [NSIndexSet indexSetWithIndexesInRange:range];
    [self removeObjectsAtIndexes:indexSet];
}

- (void)removeObjectsInArray:(NSArray *)otherArray {
    NSMutableIndexSet *indexSet = [NSMutableIndexSet indexSet];
    [otherArray enumerateObjectsUsingBlock:^(id obj, NSUInteger _, BOOL *stop) {
        NSUInteger idx = [self indexOfObject:obj];
        if (idx != NSNotFound) {
            [indexSet addIndex:idx];
        }
    }];
    [self removeObjectsAtIndexes:[indexSet copy]];
}

@end
