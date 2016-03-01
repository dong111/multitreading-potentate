//
//  ViewController.m
//  16-03-01-(淬火)-多线程下的数据安全问题
//
//  Created by 陈栋 on 16/3/1.
//  Copyright © 2016年 man. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()


//总票数  模拟售票员 售票
@property (assign,nonatomic) int tickets;

@end

@implementation ViewController

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
