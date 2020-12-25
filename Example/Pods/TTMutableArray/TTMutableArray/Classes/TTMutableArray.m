//
//  TTMutableArray.m
//  TTMutableArray
//
//  Created by 张贵广 on 2020/12/23.
//

#import "TTMutableArray.h"

@interface TTMutableArray ()
@property (nonatomic, strong) NSMutableArray *instance;
@end

@implementation TTMutableArray

#pragma mark - NSArray Primitive Method

- (NSUInteger)count {
    return _instance.count;
}

- (id)objectAtIndex:(NSUInteger)index {
    return [_instance objectAtIndex:index];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _instance = [[NSMutableArray alloc] init];
    }
    return self;
}

- (instancetype)initWithObjects:(id  _Nonnull const [])objects count:(NSUInteger)cnt {
    self = [super init];
    if (self) {
        _instance = [[NSMutableArray alloc] initWithObjects:objects count:cnt];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super init];
    if (self) {
        _instance = [[NSMutableArray alloc] initWithCoder:coder];
    }
    return self;
}

#pragma mark - NSMutableArray Primitive Method

//- (instancetype)init NS_DESIGNATED_INITIALIZER;
//- (nullable instancetype)initWithCoder:(NSCoder *)coder NS_DESIGNATED_INITIALIZER;

- (instancetype)initWithCapacity:(NSUInteger)numItems {
    self = [super init];
    if (self) {
        _instance = [[NSMutableArray alloc] initWithCapacity:numItems];
    }
    return self;
}

- (void)addObject:(id)anObject {
    [_instance addObject:anObject];
    [self _notifyObserverInsertArray:@[anObject] indexes:[NSIndexSet indexSetWithIndex:_instance.count - 1]];
}

- (void)insertObject:(id)anObject atIndex:(NSUInteger)index {
    [_instance insertObject:anObject atIndex:index];
    [self _notifyObserverInsertArray:@[anObject] indexes:[NSIndexSet indexSetWithIndex:index]];
}

- (void)removeLastObject {
    NSObject *lastObject = _instance.lastObject;
    [_instance removeLastObject];
    [self _notifyObserverRemoveObjects:@[lastObject] indexes:[NSIndexSet indexSetWithIndex:_instance.count]];
}

- (void)removeObjectAtIndex:(NSUInteger)index {
    NSObject *anObject = [_instance objectAtIndex:index];
    [_instance removeObjectAtIndex:index];
    [self _notifyObserverRemoveObjects:@[anObject] indexes:[NSIndexSet indexSetWithIndex:index]];
}

- (void)replaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject {
    [_instance replaceObjectAtIndex:index withObject:anObject];
    [self _notifyObserverReplaceArray:@[anObject] indexes:[NSIndexSet indexSetWithIndex:index]];
}

#pragma mark - Mutable Convenience Functions
// we need to keep the following methods for perfomance reasons
// the default NSMutableArray implementation will send the insertion event one by one, which is inefficient

- (void)addObjectsFromArray:(NSArray*)array {
    NSUInteger count = _instance.count;
    NSRange range = {count, array.count};
    NSIndexSet* indexSet = [NSIndexSet indexSetWithIndexesInRange:range];
    [self insertObjects:array atIndexes:indexSet];
}

- (void)removeAllObjects {
    NSRange range = {0, _instance.count};
    NSIndexSet* indexSet = [NSIndexSet indexSetWithIndexesInRange:range];
    [self removeObjectsAtIndexes:indexSet];
}

- (void)removeObjectsInArray:(NSArray *)otherArray {
    NSMutableIndexSet *indexSet = [NSMutableIndexSet indexSet];
    [otherArray enumerateObjectsUsingBlock:^(id obj, NSUInteger _, BOOL *stop) {
        NSUInteger idx = [_instance indexOfObject:obj];
        if (idx != NSNotFound) {
            [indexSet addIndex:idx];
        }
    }];
    [self removeObjectsAtIndexes:[indexSet copy]];
}

- (void)insertObjects:(NSArray *)objects atIndexes:(NSIndexSet *)indexes {
    if (indexes.count == 0) return;
    [_instance insertObjects:objects atIndexes:indexes];
    [self _notifyObserverInsertArray:objects indexes:indexes];
}

- (void)removeObjectsAtIndexes:(NSIndexSet *)indexes {
    if (indexes.count == 0) return;
    NSArray *objects = [_instance objectsAtIndexes:indexes];
    [_instance removeObjectsAtIndexes:indexes];
    [self _notifyObserverRemoveObjects:objects indexes:indexes];
}

- (void)replaceObjectsAtIndexes:(NSIndexSet *)indexes withObjects:(NSArray *)objects {
    if (indexes.count == 0) return;
    [_instance replaceObjectsAtIndexes:indexes withObjects:objects];
    [self _notifyObserverReplaceArray:objects indexes:indexes];
}

#pragma mark - NSCopying NSMutableCopying
- (id)copyWithZone:(NSZone *)zone {
    return [_instance copy];
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    TTMutableArray *mutableSelf = [[[self class] allocWithZone:zone] initWithArray:[_instance mutableCopy]];
    return mutableSelf;
}

#pragma mark - KVO _notify

- (void)_notifyObserverInsertArray:(NSArray *)array indexes:(NSIndexSet *)indexes {
    if ([_observer respondsToSelector:@selector(mutableArray:didInsertObjects:atIndexes:)]) {
        [_observer mutableArray:self didInsertObjects:array atIndexes:indexes];
    }
}

- (void)_notifyObserverRemoveObjects:(NSArray *)array indexes:(NSIndexSet *)indexes {
    if ([_observer respondsToSelector:@selector(mutableArray:didRemoveObjects:atIndexes:)]) {
        [_observer mutableArray:self didRemoveObjects:array atIndexes:indexes];
    }
}

- (void)_notifyObserverReplaceArray:(NSArray *)array indexes:(NSIndexSet *)indexes {
    if ([_observer respondsToSelector:@selector(mutableArray:didReplaceObjects:atIndexes:)]) {
        [_observer mutableArray:self didReplaceObjects:array atIndexes:indexes];
    }
}

@end
