//
//  _XXObserverItem.h
//  XXKVOObserver
//
//  Created by Shawn on 2017/4/7.
//  Copyright © 2017年 Shawn. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^_XXObserverItemCompletion)(id observer, NSString * keyPath, NSDictionary * change);

@class XXObserver;

@interface _XXObserverItem : NSObject

- (instancetype)initWithObserver:(id)observer;

@property (nonatomic, readonly, unsafe_unretained) id observer;//千万别改 assign 的内存引用类型,因为作为 observer 的属性,在调用 dealloc 的时候会先将 observer set 为 nil 所以 不能用 weak 只能用 assign 这样在 dealloc 的时候才能 remove 所有kvo

- (XXObserver *)addObserverWithKeyPath:(NSString *)keyPath completion:(_XXObserverItemCompletion)completion;

- (void)removeObserverByObserver:(XXObserver *)observerItem;

- (void)unObserverAll;

@end

@interface _XXObserverInfo : NSObject

- (instancetype)initWithKeyPath:(NSString *)keyPath observer:(id)observer;

@property (nonatomic, strong, readonly) XXObserver * item;
@property (nonatomic, weak) id target;//暂未实现,如果谁有空可以实现一下
@property (nonatomic) SEL action;//暂未实现,如果谁有空可以实现一下
@property (nonatomic, copy) _XXObserverItemCompletion completion;

- (void)invokeActionWithInfo:(NSDictionary *)info;

@end
