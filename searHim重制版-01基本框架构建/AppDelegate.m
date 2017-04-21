//
//  AppDelegate.m
//  searHim重制版-01基本框架构建
//
//  Created by 黄远 on 16/7/4.
//  Copyright © 2016年 黄远. All rights reserved.
//

#import "AppDelegate.h"
#import "HYNavgationController.h"
#import "HYLoginViewController.h"
#import <AVOSCloud/AVOSCloud.h>
#import "HYMainViewController.h"
#import "HYUserInfo.h"
#import "FMDB.h"
#import "HYUserInfoTool.h"
#import "HYCurrentClient.h"
#import <AVIMClient.h>
#import <AVIMClient.h>
#import "HYNetTool.h"
#import "HYNotificationTool.h"
#import <AVStatus.h>
#import <UserNotifications/UserNotifications.h>
#define HYClientHasGet @"client加载好了"
@interface AppDelegate () 

@property (nonatomic, strong) NSTimer* timer;

@end


//这里一定要设置全局的对象，不然，其他控制器也调用数据库相关方法，生成新的数据库
static FMDatabase*_db;

#define DBPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"searchHimBD.sqlite"]

@implementation AppDelegate

- (FMDatabase*)_db{
    _db = [FMDatabase databaseWithPath:DBPath];
    return _db;
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [AVOSCloud setApplicationId:@"YMFgjHdLQJ8JPP4QiK67SQi2-gzGzoHsz"
                      clientKey:@"e4nYSaSS4cFajWRxol2WJr8X"];
    /** 注册远程推送 */
    [application registerForRemoteNotifications];
    [[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionCarPlay completionHandler:^(BOOL granted, NSError * _Nullable error) {
        
    }];
    
    // 把badge取消掉
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    UIWindow* keyWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window = keyWindow;
    
    AVUser *currentUser = [AVUser currentUser];
    if (currentUser != nil) {
        self.imUserInfo = [HYUserInfo initOfUser:currentUser];
        // 跳转到首页
        HYMainViewController* mainVC = [[HYMainViewController alloc] init];
        keyWindow.rootViewController = mainVC;
        HYCurrentClient* currClient = [HYCurrentClient shareCurrentClient];
        [currClient openLongCallBackToSever:^(BOOL succeeded) {
            [HYNotificationTool setupRemoteNotification];
        } fauil:^(NSError *error) {
            
        }];
        
        //等待控制器生成
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:HYClientHasGet object:nil];
        });
        
    } else {
        //缓存用户对象为空时，可打开用户登录界面…
        HYLoginViewController* loginVC = [[HYLoginViewController alloc] init];
        HYNavgationController* naVC = [[HYNavgationController alloc] initWithRootViewController:loginVC];
        keyWindow.rootViewController = naVC;
    }

    [keyWindow makeKeyAndVisible];
    [self loadUserInfo];
    
    BOOL result = [HYNetTool isInConnectNet];
    if (!result) {
        [MBProgressHUD showError:@"当前没有网络连接.."];
        [[NSNotificationCenter defaultCenter] postNotificationName:HYClientHasGet object:nil];
    }
    
    //添加通知
    [self setupNotification];
    
    return YES;
}

/** 添加通知 */
- (void)setupNotification{
    dispatch_queue_t queue = dispatch_queue_create("1", DISPATCH_QUEUE_PRIORITY_DEFAULT);
    dispatch_async(queue, ^{
        NSUserDefaults *userD = [NSUserDefaults standardUserDefaults];
        NSObject* isOne = [userD objectForKey:@"isOne"];
        
        if (isOne == nil) { // 第一次使用
            [HYNotificationTool setupUserPermission];
            // 取消原来的
            [HYNotificationTool cancelLocalNotification];
            // 添加新的推送
            [HYNotificationTool setupLocationNotificaiton];
            [userD setObject:@"isOne" forKey:@"isOne"];
            // 第一次使用，默认设置推送
            [userD setBool:YES forKey:@"isNo"];
            
        } else { // 不是第一次使用
            // 从本地读取数据， 查看用户有没有需要进行推送
            Boolean isNo;
            isNo = [userD boolForKey:@"isNo"];
            if (isNo) {
                [HYNotificationTool setupUserPermission];
                // 取消原来的
                [HYNotificationTool cancelLocalNotification];
                // 添加新的推送
                [HYNotificationTool setupLocationNotificaiton];
            }

        }
        
    });

}

#define userInfoHasGet @"使用者信息已经加载好了"
- (void)isGetInfo{
    //发布通知，让mapkit和各种需要userInfo的控制器加载
    if ([self.window.rootViewController isKindOfClass:[HYMainViewController class]]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:userInfoHasGet object:nil];
        [self.timer invalidate];
    }
}


- (void)loadUserInfo{
    [HYUserInfoTool loadAllPersonInfoWithParamters:nil success:^(HYResponseObject *responseObject) {
        for (HYUserInfo*userInfo in responseObject.resultInfo) {
            if ([userInfo.objectId isEqualToString:[AVUser currentUser].objectId]) {
                self.imUserInfo = userInfo;
                break;
            }
        }
        self.allUserInfo = responseObject.resultInfo;
        
        NSTimer* timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(isGetInfo) userInfo:nil repeats:YES];
        NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
        [runLoop addTimer:timer forMode:NSDefaultRunLoopMode];
        self.timer = timer;
    } failure:^(NSError *error) {
        HYLog(@"%@", error);
    }];

}

//程序中断后点开与服务器的链接
- (void)applicationWillTerminate:(UIApplication *)application{
    HYCurrentClient* currentC = [HYCurrentClient shareCurrentClient];
    [currentC.imClient closeWithCallback:^(BOOL succeeded, NSError *error) {
        HYLog(@"程序退出，断后点开与服务器的链接");
    }];
}

- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    AVInstallation *currentInstallation = [AVInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    [currentInstallation saveInBackground];
}

/** 注册远程推送失败 */
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"注册失败，无法获取设备 ID, 具体错误: %@", error);
}


- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application{
    HYLog(@"接收到内存警告");
}

/** 接收远程推送信息 */
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))handler {
    HYLog(@"接收到远程推送 ---- %@", userInfo);
}

- (void)applicationWillEnterForeground:(UIApplication *)application{
    // 把badge取消掉
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}



@end
