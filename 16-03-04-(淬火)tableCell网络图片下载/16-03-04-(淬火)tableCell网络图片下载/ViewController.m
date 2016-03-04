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
//plist数据容器
@property (nonatomic,strong) NSArray *apps;
//管理全局下载的队列
@property (nonatomic,strong) NSOperationQueue *oPqueue;
//所有下载操作的缓冲池,防止重复添加下载操作
@property (nonatomic,strong) NSMutableDictionary *imgsDownCache;
//所有下载图片的缓冲池
@property (nonatomic,strong) NSMutableDictionary *images;

@end

@implementation ViewController

- (NSMutableDictionary *)images
{
    if (_images==nil) {
        _images = [NSMutableDictionary dictionary];
    }
    return _images;
}

- (NSMutableDictionary *)imgsDownCache
{
    if (_imgsDownCache==nil) {
        _imgsDownCache = [[NSMutableDictionary alloc] init];
    }
    return _imgsDownCache;
}

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
 
    问题4:用户在图片未下载完成时候快速滚动，导致任务队列多出重复下载操作
    解决办法:建立一个下载缓冲池,通过"缓冲池"检查图片是否下载过，如果下载了就不重复下载了
 
    问题5:将图像保存到模型的优缺点
    优点：不用重复下载图片，将ui与操作分离，和module相互关联，数据交由model管理
    缺点:内存，所有的model对象都是存储都是存在在内存中的，如果大数据交由model管理，在内存警告时候，没有办法清空model
    解决办法;将model中的大数据分离出来，放到资源池中，方便内存管理
 
    问题6：下载操作缓冲池越来越大没有清理   思考问题点：任何缓冲池有加入就一定有销毁，思考销毁的时间点
 
 */

/**
 *  代码重构
    让代码方法单一操作，把其它复杂功能代码分装起来
    代码封装:
    1.建立一个新方法
    2.将代码块移如新方法中，移除代码块的地方调用新创建的方法
    3.根据代码块报错，提取方法参数  需考虑：方法参数相互关联时候，尽量移除可省略参数，只留下必要参数
    4.代码重构后需要测试
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
    UIImage *image = [self.images valueForKey:app.icon];
    if (image!=nil) {
        [cell.imageView setImage:image];
    }else{
        //内存中没有图片，尝试从沙盒中获取
        image = [UIImage imageWithContentsOfFile:[self cachePathWithUrl:app.icon]];
        if (image) {
            //从沙盒中加载到了图片
            NSLog(@"从沙盒中加载到了图片");
            //放入缓存
            [self.images setValue:image forKey:app.icon];
            //刷新表格数据
            [cell.imageView setImage:image];

        }else{
            UIImage *image = [UIImage imageNamed:@"user_default"];
            [cell.imageView setImage:image];
            
            [self downLoadImage:indexPath];
        }
    }
    
//    NSLog(@"下载图片线程数量--%ld",self.oPqueue.operationCount);
//    NSLog(@"%@",self.imgsDownCache);
    return cell;
    
}


//由于app 可以通过类属性和传入参数NSIdexPath获取，所以就不需要传入这个参数了
/**
 *if else 代码块提取  把else的代码移除来
 *
 *  @param indexPath 必要参数对应下载那个app
 */
- (void) downLoadImage:(NSIndexPath *)indexPath
{
    CDApp *app = self.apps[indexPath.row];
    if ([self.imgsDownCache valueForKey:app.icon]) {
        NSLog(@"图片已经在下载了，不需要重复下载");
        return;
    }
    
    //考虑到block中强引用了self 可能最后导致内存泄露 对象没办法销毁 推荐将self 替换成week类型  代码如下 不过我在此处没有形成强循环引用就不改了
//     __weak typeof(self) weakSelf = self;
    
    [self.imgsDownCache setValue:@"yes" forKey:app.icon];
        //下载图片
    NSBlockOperation *op = [NSBlockOperation blockOperationWithBlock:^{
            
            //模拟网络比较卡
            [NSThread sleepForTimeInterval:2.0];
            //下载图片
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:app.icon]];
            
            UIImage *image = [UIImage imageWithData:data];
        // 2. 将下载的数据保存到模型
        // reason: '*** setObjectForKey: object cannot be nil
        //字典的赋值不能为空  nil
//        [NSNull null]; 空对象 可以放到字典或者数组
//        Null : c语言的空指针
    //   nil:oc中指向空对象的指针
//        Nil :空类
//        NSArray *arr = [NSArray arrayWithObjects:@"1", [NSNull null], @"2"];
            if (image) {
                //图片下载了存入实体
                [self.images setValue:image forKey:app.icon];
                //将图片写入沙盒
                [data writeToFile:[self cachePathWithUrl:app.icon] atomically:YES];
                //图片下载完了,该清空下载缓冲池
                [self.imgsDownCache removeObjectForKey:app.icon];
            }

        
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                //局部刷新
                [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
                
                //                [cell.imageView setImage:app.image];
            }];
            
    }];
        
    [self.oPqueue addOperation:op];

}

//根据图片url获取沙盒存储的位置
- (NSString *) cachePathWithUrl:(NSString *) url
{
    //获取沙盒的目录位置
    NSString *cacheDir = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    //获取图片名称，合并目录，生成缓存目录位置
    return [cacheDir stringByAppendingPathComponent:url.lastPathComponent];

}
//测试缓存目录获取
//-(void)viewDidLoad
//{
//    NSLog(@"%@",[self cachePathWithUrl:@""]);
//}

/**
 *  在真实开发中 一定要对这个方法处理
 */
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    //内存警告清空不必要数据
    [self.images removeAllObjects];
    //清空操作缓存
    [self.imgsDownCache removeAllObjects];
    
}



@end
