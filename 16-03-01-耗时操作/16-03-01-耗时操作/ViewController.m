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
    //number ==1 主线程
    NSLog(@"%s---%@",__func__,[NSThread currentThread]);
    //将耗时操作放到子线程中去
    [self performSelectorInBackground:@selector(loginTimeOperation) withObject:nil];
//    [self loginTimeOperation];
    
}


#pragma -mark 耗时操作
- (void) loginTimeOperation
{
    for (int i=0; i<200000; i++) {
        NSLog(@"%d--%s--%@",i,__func__,[NSThread currentThread]);
    }
}

@end
