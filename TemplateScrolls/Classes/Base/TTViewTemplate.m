//
//  TTViewTemplate.m
//  TemplateScrolls
//
//  Created by 张贵广 on 2020/12/25.
//

#import "TTViewTemplate.h"
#import <TTMutableArray/TTMutableArray.h>

const CGFloat TTViewAutomaticDimension = CGFLOAT_MAX;

@protocol TTCellTemplateDelegate <NSObject>
- (void)templateDidUpdatedData:(TTCellTemplate *)template;
@end

@interface TTCellTemplate ()
@property (nonatomic, weak) id<TTCellTemplateDelegate> delegate;
@end

@implementation TTCellTemplate

TTChainPropertyImplement(TTCellTemplate, Class<TTCellProvider>, viewClass)
TTChainPropertyImplement(TTCellTemplate, id, data)
TTChainPropertyImplement(TTCellTemplate, CGFloat, width)
TTChainPropertyImplement(TTCellTemplate, CGFloat, height)

+ (TTCellTemplate *)make {
    return [self new];
}

- (void)updateView:(void (^)(TTCellTemplate *))block {
    block(self);
    if ([_delegate respondsToSelector:@selector(templateDidUpdatedData:)]) {
        [_delegate templateDidUpdatedData:self];
    }
}

@end


@implementation TTReusableViewTemplate

TTChainPropertyImplement(TTReusableViewTemplate, Class<TTReusableViewProvider>, viewClass)
TTChainPropertyImplement(TTReusableViewTemplate, id, data)
TTChainPropertyImplement(TTReusableViewTemplate, CGFloat, height)

+ (TTReusableViewTemplate *)make {
    return [self new];
}

@end



@interface TTSectionTemplate () <TTMutableArrayObserver, TTCellTemplateDelegate>
@property (nonatomic, weak) id<_TTSectionObserver> observer;
@end

@implementation TTSectionTemplate

TTChainPropertyImplement(TTSectionTemplate, Class<TTCellProvider>, viewClass)
TTChainPropertyImplement(TTSectionTemplate, id, data)
TTChainPropertyImplement(TTSectionTemplate, CGFloat, width)
TTChainPropertyImplement(TTSectionTemplate, CGFloat, height)

TTChainPropertyImplement(TTSectionTemplate, BOOL, allowsMultipleSelection)
TTChainPropertyImplement(TTSectionTemplate, BOOL, forceSelection)

TTChainPropertyImplement(TTSectionTemplate, UIEdgeInsets, insets)
TTChainPropertyImplement(TTSectionTemplate, CGFloat, horizontalSpacing)
TTChainPropertyImplement(TTSectionTemplate, CGFloat, verticalSpacing)
TTChainPropertyImplement(TTSectionTemplate, TTCollectionItemAlignment, alignment)

+ (__kindof TTSectionTemplate *)make {
    return [self new];
}

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

@synthesize cells = _cells;
- (NSMutableArray *)cells {
    if (!_cells) {
        TTMutableArray *cells = [TTMutableArray array];
        cells.observer = self;
        _cells = cells;
    }
    return _cells;
}

#pragma mark - TTViewTemplateDelegate

- (void)templateDidUpdatedData:(TTCellTemplate *)template {
    NSInteger index = [self.cells indexOfObject:template];
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
    [cells enumerateObjectsUsingBlock:^(TTCellTemplate * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[TTCellTemplate class]]) {
            obj.delegate = delegate;
        }
    }];
}

@end
