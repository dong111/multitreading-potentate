//
//  ViewController.m
//  16-03-04-(淬火)-NSCache演练
//
//  Created by 陈栋 on 16/3/4.
//  Copyright © 2016年 man. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<NSCacheDelegate>

//缓存容器
@property (nonatomic,strong)NSCache *myCache;
@end

@implementation ViewController
- (NSCache *)myCache
{
    if (_myCache==nil) {
        _myCache = [[NSCache alloc] init];
        
        //        NSUInteger totalCostLimit;  "成本" 限制, 默认是 0 （没有限制）
        //        图片 像素 ＝＝ 总的像素点
        //        NSUInteger countLimit;  数量的限制  默认是 0
        // 设置缓存的对象，同时指定成本
        //        - (void)setObject:(id)obj forKey:(id)key cost:(NSUInteger)g;
        
        // 设置数量的限制。 一旦超出限额，会自动删除之前添加的内容
        _myCache.countLimit = 10;
        
        // 代理
        _myCache.delegate = self;
    }
    return _myCache;
}
//当存储数据超过了countLimit 限制   可以打印被删除的数据
- (void)cache:(NSCache *)cache willEvictObject:(id)obj
{
    NSLog(@"数据超出了countlimit %@被删除了",obj);
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    //数据存储
    for (int i=0; i<30; i++) {
        [self.myCache setObject:[NSString stringWithFormat:@"hello -%d",i] forKey:[NSNumber numberWithInt:i]];
        //[NSNumber numberWithInt:i]  也可以写成@(i)
        
    }
    //数据读取
    for (int i=0; i<30; i++) {
        NSLog(@"%@",[self.myCache objectForKey:@(i)])
        ;
    }
}


@end
