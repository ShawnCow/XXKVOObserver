//
//  NSObject+XXObserver.m
//  XXKVOObserver
//
//  Created by Shawn on 2017/4/7.
//  Copyright © 2017年 Shawn. All rights reserved.
//

#import "NSObject+XXObserver.h"
#import <objc/runtime.h>
#import "_XXObserverItem.h"

@implementation NSObject (XXObserver)

static void *XXObserverItemPropertyKey = &XXObserverItemPropertyKey;

- (_XXObserverItem *)_xx_observerItem
{
    id item = objc_getAssociatedObject(self, XXObserverItemPropertyKey);
    if (!item) {
        @synchronized (self) {
            item = [[_XXObserverItem alloc]initWithObserver:self];
            objc_setAssociatedObject(self, XXObserverItemPropertyKey, item, OBJC_ASSOCIATION_RETAIN);
        }
    }
    return item;
}

- (XXObserver *)xx_observerKeyPath:(NSString *)keyPath completion:(XXObserverCompletion)completion
{
    return [[self _xx_observerItem]addObserverWithKeyPath:keyPath completion:completion];
}

- (void)xx_removeObserverByItem:(XXObserver *)item
{
    [[self _xx_observerItem]xx_removeObserverByItem:item];
}

- (void)xx_removeAllObserver
{
    [[self _xx_observerItem]unObserverAll];
}

@end
