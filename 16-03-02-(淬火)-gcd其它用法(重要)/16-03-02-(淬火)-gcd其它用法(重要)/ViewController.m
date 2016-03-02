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
    [self once];
}



#pragma --mark 一次性执行
- (void) once
{
    static dispatch_once_t onceToken;
    NSLog(@"%ld", onceToken);
    dispatch_once(&onceToken, ^{
        NSLog(@"%ld", onceToken);
        //类似于Js防止点击多次
        NSLog(@"真的只执行一次么？");
    });
    
    NSLog(@"执行完成");
}


#pragma --mark(调度组) 分组
- (void) groupQueue
{
    /**
     应用场景：
     开发的时候，有的时候出现多个网络请求都完成以后（每一个网络请求的事件长短不一定），再统一通知用户
     
     比如： 下载小说：三国演义， 红楼梦， 水浒传
     */
    //创建一个调度组
    dispatch_group_t group = dispatch_group_create();
    
    //队列
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    
    //添加到任务组队列
    dispatch_group_async(group, queue, ^{
        NSLog(@"下载小说A---%@", [NSThread currentThread]);
    });
    
    dispatch_group_async(group, queue, ^{
        NSLog(@"下载小说B---%@", [NSThread currentThread]);
    });
    
    dispatch_group_async(group, queue, ^{
        NSLog(@"下载小说C---%@", [NSThread currentThread]);
    });
     // 获得所有调度组里面的异步任务完成的通知
//    dispatch_group_notify(group, queue, ^{
//        NSLog(@"收到通知，小说都下载完了。%@",[NSThread currentThread]);
//    });
    
     //注意点： 在调度组完成通知里，可以跨队列通信
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
         // 更新UI，在主线程
        NSLog(@"收到通知，小说都下载完了。%@",[NSThread currentThread]);
    });
    
    
    
    
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
