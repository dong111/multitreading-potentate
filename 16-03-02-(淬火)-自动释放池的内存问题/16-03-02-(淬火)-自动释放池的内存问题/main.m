//
//  main.m
//  16-03-02-(淬火)-自动释放池的内存问题
//
//  Created by 陈栋 on 16/3/2.
//  Copyright © 2016年 man. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

int main(int argc, char * argv[]) {
    @autoreleasepool {
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
