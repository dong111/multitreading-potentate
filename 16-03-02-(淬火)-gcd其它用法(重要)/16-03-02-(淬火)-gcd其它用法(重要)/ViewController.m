//
//  ViewController.m
//  16-03-02-(淬火)-gcd其它用法(重要)
//
//  Created by 陈栋 on 16/3/2.
//  Copyright © 2016年 man. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self delay];
}


#pragma --mark 延时操作
- (void) delay
{
    /**
     参数:
     now 0
     NSEC_PER_SEC: 很大的数字
     
     */
    dispatch_time_t time =dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC));
    
    
    // 参数： when : 表示从现在开始，经过多少纳秒以后
    // queue ：  在哪一个队列里面执行后面的任务
    //    dispatch_after(when, dispatch_get_main_queue(), ^{
    //        NSLog(@"点我了-- %@", [NSThread currentThread]);
    //    });
    //
    dispatch_after(time, dispatch_get_main_queue(), ^{
        NSLog(@"延迟执行--%@",[NSThread currentThread]);
    });
}

@end
