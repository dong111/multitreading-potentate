//
//  CDApp.m
//  16-03-04-(淬火)tableCell网络图片下载
//
//  Created by 陈栋 on 16/3/4.
//  Copyright © 2016年 man. All rights reserved.
//

#import "CDApp.h"

@implementation CDApp

- (instancetype) initWithDic:(NSDictionary *)dic{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}

+ (instancetype) appWithDic:(NSDictionary *)dic{
    return [[CDApp alloc] initWithDic:dic];
}


+ (NSArray *) appsList{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"apps" ofType:@"plist"];
    
    NSArray *dicArray = [NSArray arrayWithContentsOfFile:path];
    
    NSMutableArray *tmpArray  = [NSMutableArray array];
    
    for (NSDictionary *dic in dicArray) {
        CDApp *app = [[CDApp alloc] initWithDic:dic];
        [tmpArray addObject:app];
    }
    
    return tmpArray;
}


@end
