//
//  HYMainViewController.m
//  searHim重制版-01基本框架构建
//
//  Created by 黄远 on 16/7/4.
//  Copyright © 2016年 黄远. All rights reserved.
//

#import "HYMainViewController.h"
#import "HYTabBarController.h"
#import "HYNavgationController.h"
#import "HYRightMenu.h"
#import "HYImInfoController.h"
#import "HYCurrentClient.h"
#import <AVIMClient.h>
#import "HYLoginViewController.h"
#import "SDImageCache.h"
#import "HYCurrentClient.h"
#import "HYWebViewController.h"
#import "HYNotificationTool.h"
#import <AVUser.h>
#define HYMoveTabBar @"移动tabBar"
#define HYOtherLoginMyAccount @"其他人登录了账号"
#define coverTag 100
#define animaDuration 0.25

@interface HYMainViewController () <HYRightMenuDelegate>
@property (nonatomic, weak) HYRightMenu* rightMenu;
@property (nonatomic, strong) HYTabBarController* tabBarVC;
@property (nonatomic, strong) HYNavgationController* naV;
@property (nonatomic, strong) UIAlertController* alertVC;
@property (nonatomic, strong) HYWebViewController* webVC;
@end

@implementation HYMainViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    //设置背景图片
    [self backImage];
    
    //设置tabBarVC
    [self setUpAllChildVC];
    
    //设置设置菜单控制器
    [self setupRightMenu];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onClick) name:HYMoveTabBar object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(otherLogin) name:HYOtherLoginMyAccount object:nil];
}


- (void)otherLogin{
    UIAlertController* alertVC = [UIAlertController alertControllerWithTitle:@"信息提示" message:@"当前其他地方登录了您的账号" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"重新登录" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        //回到登录界面
        AppDelegate* appD = [UIApplication sharedApplication].delegate;
        HYLoginViewController* loginVC = [[HYLoginViewController alloc] init];
        HYNavgationController* naVC = [[HYNavgationController alloc] initWithRootViewController:loginVC];
        appD.window.rootViewController = naVC;
    }];

    UIAlertAction *queAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:^(UIAlertAction* _Nonnull action){

    }];

    [alertVC addAction:cancelAction];
    [alertVC addAction:queAction];
    [self presentViewController:alertVC animated:YES completion:^{
        
    }];

}

- (void)onClick{
    [UIView animateWithDuration:animaDuration animations:^{
        CGFloat heightAfterScale = self.view.frame.size.height - 60.0 * 2;
        CGFloat scale = heightAfterScale / self.view.frame.size.height;
        CGFloat transX = self.rightMenu.frame.size.width - ((1.0 - scale)*0.5*self.view.frame.size.width);
        CGAffineTransform scaleTransform = CGAffineTransformMakeScale(scale, scale);
        self.naV.view.transform = CGAffineTransformTranslate(scaleTransform, -transX/scale, 0);
        
        UIButton* cover = [[UIButton alloc] init];
        cover.backgroundColor = [UIColor clearColor];
        cover.frame = self.view.bounds;
        cover.tag = coverTag;
        [self.naV.view addSubview:cover];
        [cover addTarget:self action:@selector(huiFu:) forControlEvents:UIControlEventTouchUpInside];
        
        //        NSLog(@"%@ -----  %@", NSStringFromCGRect(self.HMleftMenu.frame), NSStringFromCGRect(self.showingNavigationController.view.frame));
    }];
}

- (void)huiFu:(UIButton*)btn{
    [UIView animateWithDuration:animaDuration animations:^{
        self.naV.view.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        [btn removeFromSuperview];
    }];
    
}


- (void)setUpAllChildVC{
    HYTabBarController* tabBarController = [[HYTabBarController alloc] init];
    HYNavgationController* naV = [[HYNavgationController alloc] initWithRootViewController:tabBarController];
    [self addChildViewController:naV];
    self.tabBarVC = tabBarController;
    [self.view addSubview:naV.view];
    self.naV = naV;
    self.naV.navigationBar.barStyle = UIBarStyleBlackOpaque;
}


- (void)setupRightMenu{
    HYRightMenu* rightMenu = [[HYRightMenu alloc] init];
    CGFloat wid,hei,x,y;
    CGFloat screenWid = [UIScreen mainScreen].bounds.size.width;
    wid = screenWid* 0.6;
    hei = [UIScreen mainScreen].bounds.size.height * 0.7;
    x = screenWid - wid;
    y = (self.view.frame.size.height - hei)*0.5;
    rightMenu.frame = CGRectMake(x, y, wid, hei);
    [self.view insertSubview:rightMenu atIndex:1];
    rightMenu.delegate = self;
    self.rightMenu = rightMenu;
}

//设置背景图片
- (void)backImage{
    UIImageView* imaV = [[UIImageView alloc] init];
    imaV.frame = self.view.bounds;
    imaV.image = [UIImage imageNamed:@"sidebar_bg.jpg"];
    [self.view addSubview:imaV];
}


#pragma mark - HYRightMenuDelegate
- (void)leftMenu:(HYRightMenu *)menu didSelectedButtonWithType:(HYMenuButtonType)type{
    switch (type) {
        case HYMenuButtonTypeMyInfo:
            [self addShowInfoController];
            [self huiFu:[self.naV.view viewWithTag:coverTag]];
            break;
        case HYMenuButtonTypeQuitAccount:
            [self showQuitAccountInfo]; break;
        case HYMenuButtonTypeClearCache:
            [self showClearVC];
            break;
        case HYMenuButtonTypeReceiveNews:
            [self showIsReceveVC]; break;
        case HYMenuButtonTypeQuitApp:
            [self showQuitAppVC]; break;
        case HYMenuButtonTypeAboutSearchHim:
            [self showAboutHim];
            [self huiFu:[self.naV.view viewWithTag:coverTag]]; break;
        default:
            break;
    }
    
    //这里进行动作
//    [self huiFu:[self.naV.view viewWithTag:coverTag]];
}

- (void)showAboutHim{
    HYWebViewController* webVC = [[HYWebViewController alloc] init];
    [self.naV pushViewController:webVC animated:YES];
    self.webVC = webVC;
}

- (void)showInfoVCWithTitle:(NSString*)title message:(NSString*)msg cancelTitle:(NSString*)cancelTitle cancelHandler:(void(^)(UIAlertAction * _Nonnull action))cancel andQueTitle:(NSString*)queTitle cancelHandler:(void(^)(UIAlertAction * _Nonnull action))que andNotQue:(NSString*)notQueTitle cancelHandler:(void(^)(UIAlertAction * _Nonnull action))notQue{
    UIAlertController* alertVC = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        if (cancel) {
            cancel(action);
        }
    }];
    
    UIAlertAction *notQueAction = [UIAlertAction actionWithTitle:notQueTitle style:UIAlertActionStyleDestructive handler:^(UIAlertAction* _Nonnull action){
        if (notQue) {
            notQue(action);
        }
    }];
    
    UIAlertAction *queAction = [UIAlertAction actionWithTitle:queTitle style:UIAlertActionStyleDestructive handler:^(UIAlertAction* _Nonnull action){
        if (que) {
            que(action);
        }
    }];
    
    
    [alertVC addAction:queAction];
    [alertVC addAction:notQueAction];
    [alertVC addAction:cancelAction];
    [self presentViewController:alertVC animated:YES completion:^{
        
    }];

}

- (void)showQuitAppVC{
    [self showInfoVCWithTitle:@"确定离开searchHim？" message:nil cancelTitle:@"取消" cancelHandler:^(UIAlertAction * _Nonnull action) {
        
    } andQueTitle:@"确定" cancelHandler:^(UIAlertAction * _Nonnull action) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        //断开连接
        HYCurrentClient* currentC = [HYCurrentClient shareCurrentClient];
        [currentC.imClient closeWithCallback:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                HYLog(@"中断了服务器连接");
            }
            //退出程序
            AppDelegate *app = (AppDelegate*)[UIApplication sharedApplication].delegate;
            UIWindow *window = app.window;
            [UIView animateWithDuration:1.0f animations:^{
                window.alpha = 0.0;
                window.frame = CGRectMake(0, window.bounds.size.width, 0, 0);
            } completion:^(BOOL finished) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                exit(0);
            }];

        }];
    } andNotQue:@"返回" cancelHandler:^(UIAlertAction * _Nonnull action) {
        
    }];
}

- (void)showIsReceveVC{
    [self showInfoVCWithTitle:@"信息tip" message:@"相关推送能帮助您获取Ta的最新消息" cancelTitle:@"返回" cancelHandler:^(UIAlertAction * _Nonnull action) {
       
    } andQueTitle:@"接收推送" cancelHandler:^(UIAlertAction * _Nonnull action) {
        //添加通知
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isNo"];
        [HYNotificationTool setupUserPermission];
        [HYNotificationTool cancelLocalNotification];
        [HYNotificationTool setupLocationNotificaiton];
        [MBProgressHUD showSuccess:@"接收最新消息"];
    } andNotQue:@"取消推送" cancelHandler:^(UIAlertAction * _Nonnull action) {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isNo"];
        [MBProgressHUD showSuccess:@"成功取消"];
    }];
}

- (void)showClearVC{
    //图片缓存
    NSString *SDImaCachesFilePath = [SDImageCache sharedImageCache].diskCachePath;
    long long SDImaCaches = [self totalCachesWithPath:SDImaCachesFilePath];
    //视频、音频缓存
    NSString* medioCachesFilePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"HYMedioFile"];
    long long medioCaches = [self totalCachesWithPath:medioCachesFilePath];
    
    long long totalCaches = SDImaCaches + medioCaches;
    NSString* cachesTitle = [NSString stringWithFormat:@"清除缓存 %0.1fM", totalCaches/1000.0/1000.0];
    [self showInfoVCWithTitle:cachesTitle message:@"清理缓存可能导致视频、音频无法播放" cancelTitle:@"取消" cancelHandler:^(UIAlertAction * _Nonnull action) {
        
    } andQueTitle:@"确认" cancelHandler:^(UIAlertAction * _Nonnull action) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        //清除缓存
        NSFileManager* mgr = [NSFileManager defaultManager];
        [mgr removeItemAtPath:SDImaCachesFilePath error:nil];
        [mgr removeItemAtPath:medioCachesFilePath error:nil];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self huiFu:[self.naV.view viewWithTag:coverTag]];
    } andNotQue:@"返回" cancelHandler:^(UIAlertAction * _Nonnull action) {
        
    }];
}

- (long long)totalCachesWithPath:(NSString*)filePath{
    long long totalCaches = 0;
    NSFileManager* mgr = [NSFileManager defaultManager];
    BOOL isDirectory;
    BOOL  fileExistsAtPath = [mgr fileExistsAtPath:filePath isDirectory:&isDirectory];
    if (!fileExistsAtPath) {
        return 0;
    }
    
    if (isDirectory) {
        NSArray* subFilePath = [mgr contentsOfDirectoryAtPath:filePath error:nil];
        for (int i=0; i<subFilePath.count; i++) {
            NSString* subPath = subFilePath[i];
            subPath = [filePath stringByAppendingPathComponent:subPath];
            totalCaches += [self totalCachesWithPath:subPath];
        }
    } else {
        NSDictionary* dict = [mgr attributesOfItemAtPath:filePath error:nil];
        totalCaches = [dict[@"NSFileSize"] longLongValue];
    }
    
    
    return totalCaches;
}

- (void)showQuitAccountInfo{
    UIAlertController* alertVC = [UIAlertController alertControllerWithTitle:@"点击确认退出?" message:@"退出账号将不会清除您的聊天信息" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        HYLog(@"点击取消了");
    }];
    
    UIAlertAction *queAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDestructive handler:^(UIAlertAction* _Nonnull action){
        HYLog(@"点击确认");
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        HYCurrentClient* curentClient = [HYCurrentClient shareCurrentClient];
        //让请求状态的循环停止
        [curentClient.queryStatusTimer invalidate];
        //断开客户端和服务器连接
        [curentClient.imClient closeWithCallback:^(BOOL succeeded, NSError *error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self.alertVC dismissViewControllerAnimated:YES completion:^{
                
            }];
            //回到登录界面
            if (succeeded) {
                [AVUser logOut];
                AppDelegate* appD = (AppDelegate*)[UIApplication sharedApplication].delegate;
                HYLoginViewController* loginVC = [[HYLoginViewController alloc] init];
                HYNavgationController* naVC = [[HYNavgationController alloc] initWithRootViewController:loginVC];
                appD.window.rootViewController = naVC;
            } else {
                HYLog(@"%@", error);
                [MBProgressHUD showError:@"网络繁忙，请直接退出程序并重启"];
            }
        }];
    }];
    
    [alertVC addAction:cancelAction];
    [alertVC addAction:queAction];
    [self presentViewController:alertVC animated:YES completion:^{
        
    }];
    self.alertVC = alertVC;
}

- (void)addShowInfoController{
    HYImInfoController* imInfoVC = [[HYImInfoController alloc] init];
    AppDelegate* appD = (AppDelegate*)[UIApplication sharedApplication].delegate;
    imInfoVC.imUsrInfo = appD.imUserInfo;
    [self.naV pushViewController:imInfoVC animated:YES];
}
















@end
