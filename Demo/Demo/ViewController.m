//
//  ViewController.m
//  Demo
//
//  Created by Shawn on 2017/5/8.
//  Copyright © 2017年 Shawn. All rights reserved.
//

#import "ViewController.h"
#import "NSObject+XXObserver.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self xx_observerKeyPath:@"title" completion:^(id observer, NSString *keyPath, NSDictionary *change) {
        NSLog(@"change %@",change);
    }];
    [self performSelector:@selector(test) withObject:nil afterDelay:2];
}


- (void)test
{
    self.title = @"hello world";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
