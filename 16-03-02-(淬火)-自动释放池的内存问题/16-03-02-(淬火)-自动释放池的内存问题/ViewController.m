//
//  ViewController.m
//  16-03-02-(淬火)-自动释放池的内存问题
//
//  Created by 陈栋 on 16/3/2.
//  Copyright © 2016年 man. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
#pragma 为什么没出问题呢？？  ios9新特效？？？
    int maxLength = 1024*1024*10;
    for (int i=0; i<maxLength; i++) {
        NSLog(@"%d",i);
//       NSString *str =  [NSString stringWithFormat:@"hello"];
        NSString *str = [[NSString alloc] initWithFormat:@"hello"];
        
        NSLog(@"%p",str);
        
        str=  [str uppercaseString];
         NSLog(@"%p",str);
       str = [str stringByAppendingString:@"--world!"];
        
         NSLog(@"%p",str);
        
        //                (alloc new retain copy) release
        //                如果没有alloc new retain copy而产生了新对象，里面都是autorelease
    }
}

@end
