//
//  ViewController.m
//  16-03-01-(淬火)-NSThread
//
//  Created by 陈栋 on 16/3/1.
//  Copyright © 2016年 man. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self test3];
}


//线程执行方法内容
- (void) run:(NSString *) str
{
    NSLog(@"%@",str);
    for (int i=0; i<10; i++) {
        NSLog(@"%s---%@",__func__,[NSThread currentThread]);
    }
}



#pragma 线程创建的方式

/**
 *  创建方式3   
 *  隐式创建  无需启动线程
 */
- (void) test3
{
    [self performSelectorInBackground:@selector(run:) withObject:@"test3"];
}


/**
 *  创建方式2  无需启动线程
 */
- (void) test2
{
    [NSThread detachNewThreadSelector:@selector(run:) toTarget:self withObject:@"haha"];
}


//创建方式1
- (void) test1
{
    //实例化一个线程对象
    NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(run) object:nil];
    
    //启动线程
    [thread start];
    
}

@end
