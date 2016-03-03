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

@end

@implementation ViewController

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


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //获取数据
    CDApp *app = self.apps[indexPath.row];
    
    NSString *required= [NSString stringWithFormat:@"app"];
    UITableViewCell *cell =  [self.tableView dequeueReusableCellWithIdentifier:required];
    
    [cell.textLabel setText:app.name];
    [cell.detailTextLabel setText:app.download];
    
    
    
    return cell;
    
}










@end
