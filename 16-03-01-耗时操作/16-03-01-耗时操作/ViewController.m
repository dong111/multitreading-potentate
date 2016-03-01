//
//  ViewController.m
//  16-03-01-耗时操作
//
//  Created by 陈栋 on 16/3/1.
//  Copyright © 2016年 man. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //获取当前线程
    NSLog(@"%s---%@",__func__,[NSThread currentThread]);
    
    
    [self loginTimeOperation];
    
}


#pragma -mark 耗时操作
- (void) loginTimeOperation
{
    for (int i=0; i<10; i++) {
        NSLog(@"%d--%s--%@",i,__func__,[NSThread currentThread]);
    }
}

@end
