# TTMutableArray
--
如果你想监听可变数组的元素变动，可以使用可被观察的 TTMutableArray, 也可以使用分类方法，为任意的 NSMutableArray 添加监听

If you want to KVO the changes in the elements of the mutable array, you can use the observable TTMutableArray. 
Or you can use the category method to add observer to any NSMutableArray.

[![CI Status](https://img.shields.io/travis/GG/TTMutableArray.svg?style=flat)](https://travis-ci.org/GG/TTMutableArray)
[![Version](https://img.shields.io/cocoapods/v/TTMutableArray.svg?style=flat)](https://cocoapods.org/pods/TTMutableArray)
[![License](https://img.shields.io/cocoapods/l/TTMutableArray.svg?style=flat)](https://cocoapods.org/pods/TTMutableArray)
[![Platform](https://img.shields.io/cocoapods/p/TTMutableArray.svg?style=flat)](https://cocoapods.org/pods/TTMutableArray)


## Installation

TTMutableArray is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'TTMutableArray'
```

## Usage

#### TTMutableArray 

You can use it like a `NSMutableArray`

```Objective-C
TTMutableArray *array = [TTMutableArray arrayWithArray:@[@11, @22]];
[array addObject:@44];
[array removeLastObject];
[array replaceObjectAtIndex:1 withObject:@55];
......
```

If you want KVO the array, set the `observer` property

```Objective-C
array.observer = observerObject;
```

And the `observerObject` need conform the protocol `<TTMutableArrayObserver>`

```Objective-C
#pragma mark - TTMutableArrayObserver
- (void)mutableArray:(NSMutableArray *)array didInsertObjects:(NSArray *)objects atIndexes:(NSIndexSet *)indexes {
    NSLog(@"========> did insert %@, %@ \n result %@", objects, indexes, array);
}
- (void)mutableArray:(NSMutableArray *)array didRemoveObjects:(NSArray *)objects atIndexes:(NSIndexSet *)indexes {
    NSLog(@"========> did remove %@, %@ \n result %@", objects, indexes, array);
}
- (void)mutableArray:(NSMutableArray *)array didReplaceObjects:(NSArray *)objects atIndexes:(NSIndexSet *)indexes {
    NSLog(@"========> did replace %@, %@ \n result %@", objects, indexes, array);
}
```

#### NSMutableArray

If you use NSMutableArray, and want KVO array, you should use the category method.

```Objective-C
NSMutableArray *array = [NSMutableArray arrayWithArray:@[@11, @22]];
NSMutableArray *observerableArray = [array tt_getObserverableArrayWithObserver: observerObject];
```
> Note: you must use the new object `observerableArray` that get from the category method to change(insert, remove, replace) the array items.   
> The original array can't trigger the kvo callback.

Similarly, the `observerObject` need conform protocol `<TTMutableArrayObserver>` too.


## License

TTMutableArray is available under the MIT license. See the LICENSE file for more info.
