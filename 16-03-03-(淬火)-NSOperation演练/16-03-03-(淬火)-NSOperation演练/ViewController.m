//
//  ViewController.m
//  16-03-03-(淬火)-NSOperation演练
//
//  Created by 陈栋 on 16/3/3.
//  Copyright © 2016年 man. All rights reserved.
//

#import "ViewController.h"


/**
 GCD --> iOS 4.0
 - 将任务（block）添加到队列（串行/并发(全局)），指定 执行任务的方法(同步(阻塞)/异步)
 - 拿到 dispatch_get_main_queue()。 线程间通信
 - NSOperation无法做到，一次性执行，延迟执行，调度组(op相对复杂)
 
 
 NSOperation ----> iOS 2.0 （后来苹果改造了NSOperation的底层）
 - 将操作(异步执行)添加到队列(并发/全局)
 - [NSOperationQueue mainQueue] 主队列。 任务添加到主队列， 就会在主线程执行
 - 提供了一些GCD不好实现的，”最大并发数“
 - 暂停/继续 --- 挂起
 - 取消所有的任务
 - 依赖关系
 */

/**
 小结一下:
 只要是NSOperation的子类 就能添加到操作队列
 - 一旦操作添加到队列， 就会自动异步执行
 - 如果没有添加到队列, 而是使用start方法，会在当前线程执行操作
 - 如果要做线程间通信，可以使用[NSOperationQueue mainQueue]拿到主队列，往主队列添加操作(更新UI)
 */

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
    [self dependecy];
}
#pragma -mark 线程之间的依赖关系
- (void) dependecy
{
    /**
     例子：
     1. 下载一个小说的压缩包
     2. 解压缩，删除压缩包
     3. 更新UI
     
     */
    
   NSBlockOperation *blockOp1 = [NSBlockOperation blockOperationWithBlock:^{
       NSLog(@"1. 下载一个小说的压缩包");
    }];
    NSBlockOperation *blockOp2 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"2. 解压缩，删除压缩包");
    }];
    NSBlockOperation *blockOp3 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"3. 更新UI");
    }];
    
    //指定任务之间的依赖关系  --依赖关系可以跨队列，（子线程下载完成，主线程更新）
    [blockOp2 addDependency:blockOp1];
    [blockOp3 addDependency:blockOp2];
    
    // 注意点：一定不要出现循环依赖关系 否则就是死锁
    //    [op1 addDependency:op3];
    
    // waitUntilFinished 类似GCD的调度组的通知
    // NO 不等待，会直接执行  NSLog(@"come here");
    // YES 等待上面的操作执行结束，再 执行  NSLog(@"come here")
    [self.opQueue addOperations:@[blockOp1,blockOp2] waitUntilFinished:YES];
    //在主线程更新UI
    [[NSOperationQueue mainQueue] addOperation:blockOp3];
    NSLog(@"任务完成！");
}

#pragma -mark 取消队列里面所有操作
- (IBAction)cancelAll {
    //取消队列所有操作
    [self.opQueue cancelAllOperations];
    
    NSLog(@"取消队列所有操作！");
    //取消队列的挂起挂起状态
    //(只要是取消队列操作，我们就把队列设置为开启状态，帆=方便队列再次启动)
    self.opQueue.suspended = NO;
}

#pragma -mark 暂停/继续 (对队列的暂停和继续)

- (IBAction)pause {
    //判断操作的数量，当前队列是否有操作，没有操作不需要暂停和继续
    if (self.opQueue.operationCount==0) {
        NSLog(@"没有操作！");
        return;
    }
    
    //暂停/继续功能
    self.opQueue.suspended = !self.opQueue.suspended;
    if (self.opQueue.isSuspended) {
        NSLog(@"暂停");
    }else{
        NSLog(@"继续");
    }
}

#pragma -mark 最大并发数设置
- (void) opDemo6
{
    
    //设置最大并发数为2(最大并发数 不是线程总数量  而是同时执行操作的线程数量)
    self.opQueue.maxConcurrentOperationCount = 2;
    
    for (int i=0; i<10; i++) {
        // 不创建操作对象，使用addOperationWithBlock:直接添加操作到队列
        [self.opQueue addOperationWithBlock:^{
            [NSThread sleepForTimeInterval:2.0];
            NSLog(@"%@----%d",[NSThread currentThread],i);
            
        }];
    }
}

#pragma --mark 线程间通信(最重要的代码)
- (void) opDemo5
{
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperationWithBlock:^{
         NSLog(@"耗时任务---%@",[NSThread currentThread]);
        
        //在主队列更新UI
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
             NSLog(@"主任务更新UI---%@",[NSThread currentThread]);
        }];
    }];
}

#pragma NSBlockOperation更简单的使用
- (void) opDemo4
{
    //队列
    NSOperationQueue *queue =[[NSOperationQueue alloc] init];
    
    for (int i=0; i<10; i++) {
        // 不创建操作对象，使用addOperationWithBlock:直接添加操作到队列
        [queue addOperationWithBlock:^{
            NSLog(@"%@----%d",[NSThread currentThread],i);

        }];
    }
    
    //队列里面还可以继续添加block对象
   NSBlockOperation *opb =  [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"opBlock---%@",[NSThread currentThread]);
    }];
    [queue addOperation:opb];
    
    NSInvocationOperation *opinv = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(downLoadImages:) object:@"invocation 下载图片"];
    [queue addOperation:opinv];
    
}

#pragma --mark NSBlockOperation使用
- (void) opDemo3
{
    NSOperationQueue *q = [[NSOperationQueue alloc] init];
    
    //把多个操作翻入队里并发异步执行
    for (int i=0; i<10; i++) {
       NSBlockOperation *op = [NSBlockOperation blockOperationWithBlock:^{
            NSLog(@"%@----%d",[NSThread currentThread],i);

        }];
        [q addOperation:op];
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
