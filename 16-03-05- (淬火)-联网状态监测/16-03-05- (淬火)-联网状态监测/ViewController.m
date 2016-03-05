//
//  ViewController.m
//  16-03-05- (淬火)-联网状态监测
//
//  Created by 陈栋 on 16/3/5.
//  Copyright © 2016年 man. All rights reserved.
//

#import "ViewController.h"
#import "Reachability.h"
@interface ViewController ()

//添加一个联网状态监听对象
@property (nonatomic,strong)Reachability *reach;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //判断是否能连接到主机  baidu.com
    self.reach = [Reachability reachabilityWithHostName:@"baidu.com"];
    
    //添加网络通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChange) name:kReachabilityChangedNotification object:self.reach];
    [self.reach startNotifier];
    
}


- (void)dealloc
{
    NSLog(@"移除通知！！");
    //移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:self.reach];
}

- (void) reachabilityChange
{
    switch (self.reach.currentReachabilityStatus) {
        case NotReachable:
            NSLog(@"没有连接！");
            break;
        case ReachableViaWiFi:
            NSLog(@"连接Wifi！");
            break;
        case ReachableViaWWAN:
            NSLog(@"需要流量！");
            break;
            
        default:
            break;
    }
}


@end
