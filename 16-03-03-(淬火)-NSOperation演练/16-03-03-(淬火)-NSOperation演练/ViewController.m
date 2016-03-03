//
//  ViewController.m
//  16-03-03-(淬火)-NSOperation演练
//
//  Created by 陈栋 on 16/3/3.
//  Copyright © 2016年 man. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

//创建任务队列，负责调度所有操作
@property (nonatomic,strong) NSOperationQueue *opQueue;

@end

@implementation ViewController

//懒加载的方式初始化opQueue
- (NSOperationQueue *)opQueue
{
    if (_opQueue==nil) {
        _opQueue = [[NSOperationQueue alloc] init];
    }
    return _opQueue;
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self opDemo1];
}

#pragma --mark NSBlockOperation使用
- (void) opDemo3
{
    NSOperationQueue *q = [[NSOperationQueue alloc] init];
    
    //把多个操作翻入队里并发异步执行
    for (int i=0; i<10; i++) {
        
//        [q addOperation:op];
    }
}


#pragma --mark多个NSInvocation的使用
- (void) opDemo2
{
    //队列 GCD里面并发 （全局）队列使用最多，所以NSOpration 技术直接把GCD里面的并发队列封装了起来
    //NSOprationQueue 的本质就是GCD里面的并发队里
    //操作就是GCD里面的异步执行操作
    NSOperationQueue *q = [[NSOperationQueue alloc] init];

    //把多个操作翻入队里并发异步执行
    for (int i=0; i<10; i++) {
        NSInvocationOperation *op =[[NSInvocationOperation alloc] initWithTarget:self selector:@selector(downLoadImages:) object:@"哈哈哈"];
        [q addOperation:op];
    }
    
}

#pragma  --mark单个NSInvocationOperation使用
- (void) opDemo1
{
   NSInvocationOperation *op =  [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(downLoadImages:) object:@"hahahehe"];
    //start 方法不会开辟新的线程  直接在当前线程使用  所以该方法的调用时没有意义的
//    [op start];
    //放入队列  才会开辟新的线程
    [self.opQueue addOperation:op];
}

- (void) downLoadImages:(NSString *) params
{
    NSLog(@"%@----%@",[NSThread currentThread],params);
}


@end
