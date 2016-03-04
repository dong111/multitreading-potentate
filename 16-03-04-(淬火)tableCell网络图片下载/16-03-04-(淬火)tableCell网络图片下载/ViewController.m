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
    问题3:如果图片下载速度不一致，同时用户快速滚动，因为cell重用导致图片混乱
        说明比如第一个cell可能对于下载图片1.2.3 滚动导致cell对于不同图片
    解决办法：mvc 让cell关联模型  模型绑定对于图片  让图片和cell解绑
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //获取数据
    CDApp *app = self.apps[indexPath.row];
    
    NSString *required= [NSString stringWithFormat:@"app"];
    UITableViewCell *cell =  [self.tableView dequeueReusableCellWithIdentifier:required];
    
    [cell.textLabel setText:app.name];
    [cell.detailTextLabel setText:app.download];

    //对图片存在是否做出判断
    //如果图片存在不需要去下载了
    if (app.image!=nil) {
        [cell.imageView setImage:app.image];
    }else{
        UIImage *image = [UIImage imageNamed:@"user_default"];
        [cell.imageView setImage:image];
    
        //下载图片
        NSBlockOperation *op = [NSBlockOperation blockOperationWithBlock:^{
            
            //模拟网络比较卡
            [NSThread sleepForTimeInterval:1.0];
            //下载图片
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:app.icon]];
            
            UIImage *image = [UIImage imageWithData:data];
            //图片下载了存入实体
            app.image = image;
            
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                //局部刷新
                [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
                
//                [cell.imageView setImage:app.image];
            }];
            
        }];
        
        [self.oPqueue addOperation:op];
        
        
    }
    

    
    return cell;
    
}










@end
