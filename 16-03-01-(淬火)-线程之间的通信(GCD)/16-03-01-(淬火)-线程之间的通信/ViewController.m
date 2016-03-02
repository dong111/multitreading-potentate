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
    [self performSelectorInBackground:@selector(downloadImage) withObject:nil];
}

- (void) downloadImage
{
    // 子线程里面的runloop默认不开启， 也就意味不会自动创建自动释放池, 子线程里面autorelease的对象 就会没有池子可放。 也就意味后面没办法进行释放。 造成内存泄露
    // 所以需要手动创建
    
#warning 不过我测试了，加上autoreleasepooll 没多大用  可能和新特性有关系
    @autoreleasepool {
        int size = 1024*1024;
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:size];
        
        for (int i=0; i<size; i++) {
            NSString *str = [NSString stringWithFormat:@"dadsafffffffffffffffffffdafdsafdsa"];
            [array addObject:str];
        }
        
        NSLog(@"%@",[NSThread currentThread]);
        
        //1.定义url
        NSURL *url = [NSURL URLWithString:@"http://h.hiphotos.baidu.com/image/pic/item/5366d0160924ab1828b7c95336fae6cd7b890b34.jpg"];
        
        //2.通过url可以下载网络资源 二进制文件
        NSData *data = [NSData dataWithContentsOfURL:url];
        
        //3.二进制图片
        UIImage *image = [UIImage imageWithData:data];
        
        //    self.iconView.image = image;
#warning  在这里需要把数据传到主线程，在主线程更新UI
        
        //    [self performSelectorOnMainThread:@selector(showImage:) withObject:image waitUntilDone:YES];
        // waitUntilDone：表示是否等待@selector(setImage:) 方法执行完成
        // 如果是YES，就等待setImage在其他线程执行结束，再往下执行
        //    NSLog(@"看看是 waitUntilDone生效了么？");
        //指定线程通信
        //    [self performSelector:@selector(showImage:) onThread:[NSThread mainThread] withObject:image waitUntilDone:NO];
        //使用UI自定义的方法
        [self.iconView performSelectorOnMainThread:@selector(setImage:) withObject:image waitUntilDone:NO];
        
        
        
    }
    
}


- (void) showImage:(UIImage *)image
{
    NSLog(@"%s----%@",__func__,[NSThread currentThread]);
    self.iconView.image = image;
    
}


@end
