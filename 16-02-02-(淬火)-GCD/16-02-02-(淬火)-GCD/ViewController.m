//
//  ViewController.m
//  16-02-02-(淬火)-GCD
//
//  Created by 陈栋 on 16/3/2.
//  Copyright © 2016年 man. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

//GCD核心概念
//任务：block
//队列:把任务放到队列里面，队列是先进先出的的原则
//串行队列:顺序,一个个执行(必须一个任务执行完，才能从队列里面取出下一个任务)
//并行队列:同时，同时执行多个任务（可以同时取出多个任务，只要线程执行）

//同步sync:不会开新线程
//异步async:会开新线程：多线程的代名词


//串行队列同步执行：不开新线程，在原来线程里面一个个执行
//串行队列异步执行：开一条新线程：在这个新线程里面一个个执行
//并行队列同步执行：不开线程，在原来线程里面一个个执行
//并行队列异步执行:开多个线程，并发执行（不是一个个的）执行


//阶段性总结:
//1.开不开线程  由执行任务方法决定，同步不开线程，异步肯定开=线程
//2.开多少线程由队列决定：串行最多开一个线程  并行可以开多个线程，具体开多少个由GCD底层决定，程序员不能控制


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self gcdtest6];
}

/**
 *  主队列：专门负责在主线程上调度任务，不会在子线程调度任务，在主队列不允许开新线程.
    同步执行：要马上执行
    结果：死锁
 */
- (void) gcdtest6
{
    //获取主队列-->程序启动——->至少有一个主线程-->开始就会创建主队列
    dispatch_queue_t queue = dispatch_get_main_queue();
    
    NSLog(@"1----");
    //异步执行任务
    for (int i=0; i<30; i++) {
        NSLog(@"添加异步执行任务！");
        // 异步：把任务放到主队列里，但是不需要马上执行
        //主线程要继续往主队列里面添加任务，同步任务要马上执行，结果只能死锁主线程
        //添加同步任务就死锁
        dispatch_sync(queue, ^{
            NSLog(@"%@--%d",[NSThread currentThread],i);
        });
    }
    NSLog(@"完成----");
}


/**
 *  主队列：负责在主线程上调度任务，不会在子线程调度任务，在主队列不允许开新线程
    异步执行：会开新线程，在新线程执行
    结果不线程，只能在主线程上顺序执行
 */
- (void) gcdtest5
{
    //获取主队列-->程序启动——->至少有一个主线程-->开始就会创建主队列
    dispatch_queue_t queue = dispatch_get_main_queue();
    
    NSLog(@"1----");
    
    //异步执行任务
    for (int i=0; i<30; i++) {
        NSLog(@"添加异步执行任务！");
         // 异步：把任务放到主队列里，但是不需要马上执行
        //主线程继续往主队列里面添加任务
        dispatch_async(queue, ^{
            NSLog(@"%@--%d",[NSThread currentThread],i);
        });
    }
    NSLog(@"完成----");

}




/**
 *  并行队里: 可以同时执行多个任务
    异步执行: 肯定会开辟新线程，在新线程执行
    结果：在很多个线程并发执行任务
 */
- (void) gcdtest4
{
    dispatch_queue_t queue = dispatch_queue_create("queue4", DISPATCH_QUEUE_CONCURRENT);
    
    for (int i=0; i<30; i++) {
        dispatch_async(queue, ^{
            NSLog(@"%@--%d",[NSThread currentThread],i);
        });
    }
}


/**
 *  并行队里: 可以同时执行多个任务
    同步执行: 不会开辟新线程：在当前线程执行
    结果：不会开辟新线程  顺序一个个执行
 */
- (void) gcdtest3
{
    dispatch_queue_t queue = dispatch_queue_create("queue3", DISPATCH_QUEUE_CONCURRENT);
    
    for (int i=0; i<30; i++) {
        dispatch_sync(queue, ^{
        NSLog(@"%@--%d",[NSThread currentThread],i);
        });
    }
    
}



/**
 *  串行异步
    串行队列：一个个执行
    异步执行：肯定会开辟新线程，在新线程里面一个个执行
     结果：只会开一个新线程，所有任务在新线程里面一个个执行
 */
- (void) gcdtest2
{
    //串行队列，以下两种写法一样
//    dispatch_queue_t queue =  dispatch_queue_create("queue2", DISPATCH_QUEUE_SERIAL);
    dispatch_queue_t queue =  dispatch_queue_create("queue2", NULL);
    
    //异步执行队列
    for (int i=0; i<30; i++) {
        dispatch_async(queue, ^{
            NSLog(@"%@--%d",[NSThread currentThread],i);
        });
    }
    
}






/**
 *  串行队列同步执行
    串行队列：顺序一个个执行
    同步任务：不会开辟新线程，在当前线程执行
    结果： 不开新线程 在当前线程顺序执行
    dispatch:调度 GCD里面调度函数 都是以dispatch开头
 */
- (void) gcdtest1
{
    //创建一个串行队列
    //1.队列名称 2.队列类型
     dispatch_queue_t queue = dispatch_queue_create("queue1", DISPATCH_QUEUE_SERIAL);
    //同步执行任务
    NSLog(@"开始!");
    dispatch_sync(queue, ^{
        NSLog(@"%@",[NSThread currentThread]);
    });
    
    NSLog(@"完成!");
    
}

























@end
