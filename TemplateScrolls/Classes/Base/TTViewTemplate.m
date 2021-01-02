//
//  TTViewTemplate.m
//  TemplateScrolls
//
//  Created by 张贵广 on 2020/12/25.
//

#import "TTViewTemplate.h"
#import <TTMutableArray/TTMutableArray.h>

@implementation TTViewTemplate

@end


@protocol TTCellTemplateDelegate <NSObject>
- (void)templateDidUpdatedData:(TTCellTemplate *)template;
@end

@interface TTCellTemplate ()
@property (nonatomic, weak) id<TTCellTemplateDelegate> delegate;
@end

@implementation TTCellTemplate

- (void)updateView:(void (^)(TTCellTemplate *))block {
    block(self);
    if ([_delegate respondsToSelector:@selector(templateDidUpdatedData:)]) {
        [_delegate templateDidUpdatedData:self];
    }
}

@end


@implementation TTReusableViewTemplate

@end



@interface TTSectionTemplate () <TTMutableArrayObserver, TTCellTemplateDelegate>
@property (nonatomic, weak) id<_TTSectionObserver> observer;
@end

@implementation TTSectionTemplate

- (id)header {
    if (!_header) {
        _header = [TTReusableViewTemplate new];
    }
    return _header;
}

- (id)footer {
    if (!_footer) {
        _footer = [TTReusableViewTemplate new];
    }
    return _footer;
}

@synthesize cellArray = _cellArray;
- (NSMutableArray *)cellArray {
    if (!_cellArray) {
        _cellArray = [TTMutableArray array];
        ((TTMutableArray *)_cellArray).observer = self;
    }
    return _cellArray;
}

#pragma mark - TTViewTemplateDelegate

- (void)templateDidUpdatedData:(TTCellTemplate *)template {
    NSInteger index = [self.cellArray indexOfObject:template];
    if (index == NSNotFound) {
        return;
    }
    if ([_observer respondsToSelector:@selector(section:didReplaceCells:atIndexes:)]) {
        [_observer section:self didReplaceCells:@[template] atIndexes:[NSIndexSet indexSetWithIndex:index]];
    }
}

#pragma mark - TTMutableArrayObserver, 本对象只是个事件中转对象

- (void)mutableArray:(NSMutableArray *)array didInsertObjects:(NSArray *)objects
           atIndexes:(NSIndexSet *)indexes {
    [self _setDelegateForCells:objects delegate:self];
    if ([_observer respondsToSelector:@selector(section:didInsertCells:atIndexes:)]) {
        [_observer section:self didInsertCells:objects atIndexes:indexes];
    }
}

- (void)mutableArray:(NSMutableArray *)array didRemoveObjects:(NSArray *)objects
           atIndexes:(NSIndexSet *)indexes {
    [self _setDelegateForCells:objects delegate:nil];
    if ([_observer respondsToSelector:@selector(section:didRemoveCells:atIndexes:)]) {
        [_observer section:self didRemoveCells:objects atIndexes:indexes];
    }
}

- (void)mutableArray:(NSMutableArray *)array didReplaceObjects:(NSArray *)objects
           atIndexes:(NSIndexSet *)indexes {
    [self _setDelegateForCells:objects delegate:self];
    if ([_observer respondsToSelector:@selector(section:didReplaceCells:atIndexes:)]) {
        [_observer section:self didReplaceCells:objects atIndexes:indexes];
    }
}

- (void)mutableArray:(NSMutableArray *)array beReplacedObjects:(NSArray *)objects
           atIndexes:(NSIndexSet *)indexes {
    [self _setDelegateForCells:objects delegate:nil];
}

- (void)_setDelegateForCells:(NSArray<TTCellTemplate *> *)cells
                    delegate:(nullable id<TTCellTemplateDelegate>)delegate {
    [cells makeObjectsPerformSelector:@selector(setDelegate:) withObject:delegate];
}

@end
