//
//  NSObject+XXObserver.h
//  XXKVOObserver
//
//  Created by Shawn on 2017/4/7.
//  Copyright © 2017年 Shawn. All rights reserved.
//

#import <Foundation/Foundation.h>

@class XXObserver;

typedef void (^XXObserverCompletion)(id observer, NSString * keyPath, NSDictionary * change);

@interface NSObject (XXObserver)

- (XXObserver *)xx_observerKeyPath:(NSString *)keyPath completion:(XXObserverCompletion)completion;

- (void)xx_removeObserverByItem:(XXObserver *)item;

- (void)xx_removeAllObserver;

@end

@interface XXObserver : NSObject

@property (nonatomic, readonly, copy) NSString * keyPath;

@property (nonatomic, readonly, weak) id observer;

@end
