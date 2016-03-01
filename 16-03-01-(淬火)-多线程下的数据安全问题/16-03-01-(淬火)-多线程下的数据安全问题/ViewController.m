//
//  ViewController.m
//  16-03-01-(淬火)-多线程下的数据安全问题
//
//  Created by 陈栋 on 16/3/1.
//  Copyright © 2016年 man. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

// nonatomic 非原子属性
// atomic 原子属性--默认属性
// 原子属性就是针对多线程设计的。 原子属性实现 单(线程)写 多(线程)读
// 因为写的安全级别要求更高。 读的要求低一些，可以多读几次来保证数据的正确性
//总票数  模拟售票员 售票
@property (assign,nonatomic) int tickets;
@property (atomic,strong)NSObject *obj;
// nonatomic 非原子属性
// atomic 原子属性--默认属性
// 原子属性就是针对多线程设计的。 原子属性实现 单(线程)写 多(线程)读
// 因为写的安全级别要求更高。 读的要求低一些，可以多读几次来保证数据的正确性
@end

@implementation ViewController
// 如果同时重写了setter和getter方法，"_成员变量" 就不会提供
// 可以使用 @synthesize 合成指令，告诉编译器属性的成员变量的名称
@synthesize obj = _obj;

- (void)setObj:(NSObject *)obj
{
    // 原子属性内部使用的 自旋锁
    // 自旋锁和互斥锁
    // 共同点: 都可以锁定一段代码。 同一时间， 只有线程能够执行这段锁定的代码
    // 区别：互斥锁，在锁定的时候，其他线程会睡眠，等待条件满足，再唤醒
    // 自旋锁，在锁定的时候， 其他的线程会做死循环，一直等待这条件满足，一旦条件满足，立马去执行，少了一个唤醒过程
    
    @synchronized(self){ // 模拟锁。 真实情况下，使用的不是互斥锁。
        _obj = obj;
    }
}

- (NSObject *)obj
{
    return _obj;
}



- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{

    //剩余票数
    self.tickets = 20;
    
    NSThread *threadA = [[NSThread alloc] initWithTarget:self selector:@selector(saleTicktes) object:nil];
    
    threadA.name = @"售票员A";
    [threadA start];
    
    NSThread *threadB = [[NSThread alloc] initWithTarget:self selector:@selector(saleTicktes) object:nil];
    
    threadB.name = @"售票员B";
    [threadB start];
    
}


#pragma --mark 提供售票方法
/**
 *  加锁，互斥锁
    加锁，锁定代码尽量少
    加锁范围内的代码，统一时间是允许一个线程执行
    要保证这个锁，所有线程多能访问,而且所有线程访问的是同一个对象
 */
- (void) saleTicktes
{
    while (YES) {
        //模拟下一张票，卖一张票休息一秒
//        [NSThread sleepForTimeInterval:1.0];
        
        @synchronized(self) {
            //判断是否有票
            if (self.tickets>0) {
                self.tickets --;
                NSLog(@"剩余票数:--%d---%@",self.tickets,[ NSThread currentThread]);
                
            }else{
                NSLog(@"票卖完了！！");
                break;
            }
        }


        
    }
}


@end
