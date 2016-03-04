//
//  CDApp.h
//  16-03-04-(淬火)tableCell网络图片下载
//
//  Created by 陈栋 on 16/3/4.
//  Copyright © 2016年 man. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import <UIKit/UIKit.h>

@interface CDApp : NSObject
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *icon;
@property (nonatomic,copy) NSString *download;
//@property (nonatomic,strong) UIImage *image;

- (instancetype) initWithDic:(NSDictionary *)dic;

+ (instancetype) appWithDic:(NSDictionary *)dic;


+ (NSArray *) appsList;

@end
