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

#pragma 单个NSInvocationOperation使用
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
