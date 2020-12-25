#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "NSMutableArray+TTObserverable.h"
#import "TTMutableArray.h"

FOUNDATION_EXPORT double TTMutableArrayVersionNumber;
FOUNDATION_EXPORT const unsigned char TTMutableArrayVersionString[];

