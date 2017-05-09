//
//  _XXObserverItem.m
//  XXKVOObserver
//
//  Created by Shawn on 2017/4/7.
//  Copyright © 2017年 Shawn. All rights reserved.
//

#import "_XXObserverItem.h"

@interface XXObserver : NSObject

@property (nonatomic, readonly, copy) NSString * keyPath;

@property (nonatomic, readonly, weak) id observer;

@end

@implementation XXObserver

- (instancetype)initWithKeyPath:(NSString *)keyPath observer:(id)observer
{
    self = [super init];
    if (self) {
        _keyPath = [keyPath copy];
        _observer = observer;
    }
    return self;
}

@end

@interface _XXObserverItem ()
{
    NSMutableArray * infos;
    NSMutableDictionary * didObserverKeys;
    NSLock * lock;
}
@end

@implementation _XXObserverItem

- (instancetype)initWithObserver:(id)observer
{
    self = [super init];
    if (self) {
        lock = [[NSLock alloc]init];
        _observer = observer;
        infos = [NSMutableArray array];
        didObserverKeys = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)dealloc
{
    [self unObserverAll];
}

- (XXObserver *)addObserverWithKeyPath:(NSString *)keyPath completion:(_XXObserverItemCompletion)completion
{
    if (!keyPath || !completion) {
        return nil;
    }
    keyPath = [keyPath copy];
    [lock lock];
    _XXObserverInfo * info = [[_XXObserverInfo alloc]initWithKeyPath:keyPath observer:self.observer];
    info.completion = completion;
    [infos addObject:info];
    if ([didObserverKeys.allKeys containsObject:keyPath]) {
        NSInteger observerCount = [[didObserverKeys objectForKey:keyPath] integerValue];
        observerCount ++;
        didObserverKeys[keyPath] = @(observerCount);
    }else
    {
        didObserverKeys[keyPath] = @(1);
        [self.observer addObserver:self forKeyPath:keyPath options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    }
    [lock unlock];
    
    return info.item;
}

- (void)removeObserverByObserver:(XXObserver *)observerItem
{
    if (!observerItem) {
        return;
    }
    [lock lock];
    _XXObserverInfo * removeInfo = nil;
    
    for (_XXObserverInfo * info in infos) {
        if (info.item == observerItem) {
            removeInfo = info;
            break;
        }
    }
    if (removeInfo) {
        NSInteger observerCount = [didObserverKeys[removeInfo.item.keyPath] integerValue];
        if (observerCount == 1) {
            [self.observer removeObserver:self forKeyPath:removeInfo.item.keyPath];
            [didObserverKeys removeObjectForKey:removeInfo.item.keyPath];
        }else
        {
            didObserverKeys[removeInfo.item.keyPath] = @(observerCount - 1);
        }
        [infos removeObject:removeInfo];
    }
    
    [lock unlock];
}

- (void)unObserverAll
{
    [lock lock];
    for (NSString * tempKey in didObserverKeys.allKeys) {
        [self.observer removeObserver:self forKeyPath:tempKey];
    }
    [infos removeAllObjects];
    [didObserverKeys removeAllObjects];
    [lock unlock];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    [lock lock];
    
    for (_XXObserverInfo * info in infos) {
        if (info.item.observer == object && [keyPath isEqualToString:info.item.keyPath]) {
            [info invokeActionWithInfo:change];
        }
    }
    
    [lock unlock];
}

@end



@implementation _XXObserverInfo

- (instancetype)initWithKeyPath:(NSString *)keyPath observer:(id)observer
{
    self = [super init];
    if (self) {
        _item = [[XXObserver alloc]initWithKeyPath:keyPath observer:observer];
    }
    return self;
}

- (void)invokeActionWithInfo:(NSDictionary *)info
{
    if (self.completion) {
        self.completion(self.item.observer, self.item.keyPath, info);
    }
}

@end
