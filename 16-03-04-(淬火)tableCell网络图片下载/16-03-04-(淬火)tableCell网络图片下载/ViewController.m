//
//  ViewController.m
//  16-03-04-(淬火)tableCell网络图片下载
//
//  Created by 陈栋 on 16/3/4.
//  Copyright © 2016年 man. All rights reserved.
//

#import "ViewController.h"
#import "CDApp.h"

@interface ViewController ()

@property (nonatomic,strong) NSArray *apps;

@property (nonatomic,strong) NSOperationQueue *oPqueue;

@end

@implementation ViewController
//初始化op队列
- (NSOperationQueue *)oPqueue
{
    if (_oPqueue==nil) {
        _oPqueue = [[NSOperationQueue alloc] init];
    }
    return _oPqueue;
}

//懒加载数据
- (NSArray *)apps
{
    if (_apps==nil) {
        _apps = [CDApp appsList];
    }
    return _apps;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.apps.count;
}

/**
 *   问题1: 如果网络比较慢，会比较卡
     解决办法：用异步下载
 
     问题2:图片没有frame,图片初始化时候，给的Imageview的frame为0,所以异步加载图片后不点击cell或者滚动cell，图片也不会显示
    解决办法：使用占位图
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //获取数据
    CDApp *app = self.apps[indexPath.row];
    
    NSString *required= [NSString stringWithFormat:@"app"];
    UITableViewCell *cell =  [self.tableView dequeueReusableCellWithIdentifier:required];
    
    [cell.textLabel setText:app.name];
    [cell.detailTextLabel setText:app.download];
    UIImage *image = [UIImage imageNamed:@"user_default"];
    [cell.imageView setImage:image];
    
    
    NSBlockOperation *op = [NSBlockOperation blockOperationWithBlock:^{
        
        //模拟网络比较卡
        [NSThread sleepForTimeInterval:1.0];
        //下载图片
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:app.icon]];
        
        UIImage *image = [UIImage imageWithData:data];
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [cell.imageView setImage:image];
        }];
        
    }];
    
    
    [self.oPqueue addOperation:op];
    
    return cell;
    
}










@end
