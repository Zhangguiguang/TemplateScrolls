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

#import "NSArray+TTIndexPathValue.h"
#import "TemplateScrolls.h"
#import "TTPrivate.h"
#import "TTScrollProtocol.h"
#import "TTViewTemplate.h"
#import "TTCollectionReusableView.h"
#import "TTCollectionView.h"
#import "TTCollectionViewCell.h"
#import "TTCollectionViewLayout.h"
#import "TTTableReusableView.h"
#import "TTTableView.h"
#import "TTTableViewCell.h"

FOUNDATION_EXPORT double TemplateScrollsVersionNumber;
FOUNDATION_EXPORT const unsigned char TemplateScrollsVersionString[];

