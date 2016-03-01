//
//  ViewController.m
//  16-03-01-(淬火)-NSThrea线程状态(知道)
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
    [self test];
}


- (void) test
{
    // 1. 新建一个线程
    NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(run) object:nil];
    
    // 2. 放到可调度线程池，等待被调度。 这时候是就绪状态
    [thread start];
}


- (void)run
{
    NSLog(@"%s",__func__);
    //刚进来就睡眠2秒
//    [NSThread sleepForTimeInterval:3.0];
    //睡到指定时间点
//    [NSThread sleepUntilDate:[NSDate dateWithTimeIntervalSinceNow:5.0]];
    
    
    for (int i = 0; i < 20; i++) {
    
        //满足一定条件后，让线程休息一会儿
        if (i==10) {
             [NSThread sleepForTimeInterval:3.0];
        }
        
        //满足一定条件  结束线程
        if (i==15) {
            NSLog(@"线程要结束了哦！！");
            [NSThread exit];
        }
        
        NSLog(@"%@--- %d", [NSThread currentThread], i);
    }
    
     NSLog(@"线程结束");

}



@end
