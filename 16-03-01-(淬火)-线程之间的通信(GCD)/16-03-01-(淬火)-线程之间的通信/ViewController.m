//
//  ViewController.m
//  16-03-01-(淬火)-线程之间的通信
//
//  Created by 陈栋 on 16/3/1.
//  Copyright © 2016年 man. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *iconView;

@end

@implementation ViewController

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{

    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        //异步执行任务
        NSLog(@"%@",[NSThread currentThread]);
        
        //1.定义url
        NSURL *url = [NSURL URLWithString:@"http://h.hiphotos.baidu.com/image/pic/item/5366d0160924ab1828b7c95336fae6cd7b890b34.jpg"];
        
        //2.通过url可以下载网络资源 二进制文件
        NSData *data = [NSData dataWithContentsOfURL:url];
        
        //3.二进制图片
        UIImage *image = [UIImage imageWithData:data];

         // 4. 更新UI，在主线程-》 直接把任务添加到主队列，就会在主队列执行
        dispatch_async(dispatch_get_main_queue(), ^{
            self.iconView.image = image;
             NSLog(@"-----%@", [NSThread currentThread]);
        });
        
    });
    
}

@end
