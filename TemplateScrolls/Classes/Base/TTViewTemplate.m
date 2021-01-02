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


@implementation TTCellTemplate

@end


@implementation TTReusableViewTemplate

@end



@interface TTSectionTemplate () <TTMutableArrayObserver>
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
    }
    return _cellArray;
}

- (void)setObserver:(id<_TTSectionObserver>)observer {
    _observer = observer;
    TTMutableArray *cellArray = (TTMutableArray *)self.cellArray;
    if (observer) {
        cellArray.observer = self;
    } else {
        cellArray.observer = nil;
    }
}

#pragma mark - TTMutableArrayObserver, 本对象只是个事件中转对象

- (void)mutableArray:(NSMutableArray *)array didInsertObjects:(NSArray *)objects
           atIndexes:(NSIndexSet *)indexes {
    if ([_observer respondsToSelector:@selector(section:didInsertCells:atIndexes:)]) {
        [_observer section:self didInsertCells:objects atIndexes:indexes];
    }
}

- (void)mutableArray:(NSMutableArray *)array didRemoveObjects:(NSArray *)objects
           atIndexes:(NSIndexSet *)indexes {
    if ([_observer respondsToSelector:@selector(section:didRemoveCells:atIndexes:)]) {
        [_observer section:self didRemoveCells:objects atIndexes:indexes];
    }
}

- (void)mutableArray:(NSMutableArray *)array didReplaceObjects:(NSArray *)objects
           atIndexes:(NSIndexSet *)indexes {
    if ([_observer respondsToSelector:@selector(section:didReplaceCells:atIndexes:)]) {
        [_observer section:self didReplaceCells:objects atIndexes:indexes];
    }
}

@end
