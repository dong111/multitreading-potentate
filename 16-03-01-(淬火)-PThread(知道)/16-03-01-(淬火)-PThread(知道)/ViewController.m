//
//  ViewController.m
//  16-03-01-(淬火)-PThread(知道)
//
//  Created by 陈栋 on 16/3/1.
//  Copyright © 2016年 man. All rights reserved.
//

#import "ViewController.h"
#import <pthread.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self test];
}

//c函数
void *run(void *param)
{
    NSString *str = (__bridge NSString *)(param);
    
    NSLog(@"%@",str);
    //声明耗时操作
//    for (int i=0; i<200000; i++) {
//         NSLog(@"%d---%s----%@",i,__func__,[NSThread currentThread]);
//    }
    
    return NULL;
}

//使用PThread创建线程
- (void) test
{
    //声明一个线程变量
    pthread_t threadId;
    
    
    id strParams = @"hello";
    
    /**
     *  参数
     * 要开的线程变量
     *  线程属性
     * 要在这个线程上执行的（函数）
     * 传递参数给第三个参数方法的参数
    */
    pthread_create(&threadId, NULL, run, (__bridge void *)(strParams));
    
    //id需要装换成void *，在ARC里使用_bridge 进行桥联
    //如果在MRC中，这里不要桥联,可以直接设置这个参数
    
    //__bridge void *)(strParams
    
    //ARC自动内存管理,本质是编译器特性,是在程序编译的时候，编译器帮我们在合适的地方添加了 retain release autorelease
}


@end
