//
//  HYLoginView.m
//  searHim重制版-01基本框架构建
//
//  Created by 黄远 on 16/7/5.
//  Copyright © 2016年 黄远. All rights reserved.
//

#import "HYLoginView.h"
#import "HYMainViewController.h"
#import "MBProgressHUD+NJ.h"
#import <AVUser.h>
#import "HYUserInfo.h"
#import "HYCurrentClient.h"
#import "HYNotificationTool.h"
@implementation HYLoginView



- (IBAction)onClickRegister:(UIButton *)sender {
    //通知代理，跳入注册界面
    if ([self.delegate respondsToSelector:@selector(loginViewDidClickRegisterBtn)]) {
        [self.delegate loginViewDidClickRegisterBtn];
    }
}

+ (instancetype)loginView{
    return [[[NSBundle mainBundle] loadNibNamed:@"loginView" owner:nil options:nil] lastObject];
}

- (void)awakeFromNib{
    [super awakeFromNib];
    self.loginBtn.layer.cornerRadius = HYCornerRadius;
    self.loginBtn.backgroundColor = backBtnColor;
    self.loginBtn.clipsToBounds = YES;
    AVUser* imUser = [AVUser currentUser];
    if (imUser) {
        self.accountName.text = imUser.username;
    }
}


- (IBAction)loginClick:(UIButton *)sender {
    if ([self.accountName.text isEqualToString:@""]) {
        [MBProgressHUD showError:@"账号不能为空"];
        return;
    }
    
    if ([self.pwd.text isEqualToString:@""]) {
        [MBProgressHUD showError:@"密码不能为空"];
        return;
    }
    
    [MBProgressHUD showMessage:@"正在登陆中..."];
    
    [AVUser logInWithUsernameInBackground:self.accountName.text password:self.pwd.text block:^(AVUser *user, NSError *error) {
        [MBProgressHUD hideHUD];
        if (!error) {
            UIWindow* keyWindow = [UIApplication sharedApplication].keyWindow;
            HYMainViewController* mainVC = [[HYMainViewController alloc] init];
            keyWindow.rootViewController = mainVC;
            // 监听信息
            [self targetFuncutionWithUser:user];
        } else {
            [MBProgressHUD showError:@"账号或密码错误"];
        }
    }];
 
}

/** 监听操作 */
- (void)targetFuncutionWithUser:(AVUser*)user{
    //根据最新登录的对象，生成最新的对象信息模型userInfo
    HYUserInfo* imUserInfo = [HYUserInfo initOfUser:user];
    AppDelegate* appD = (AppDelegate*)[UIApplication sharedApplication].delegate;
    appD.imUserInfo = imUserInfo;
    if (appD.imUserInfo && appD.allUserInfo && [appD.window.rootViewController isKindOfClass:[HYMainViewController class]]) {
        [appD isGetInfo];
    }
    
    
    // 拿到客户端对象，开始监听信息
    HYCurrentClient* currentClient = [HYCurrentClient shareCurrentClient];
    [currentClient openLongCallBackToSever:^(BOOL succeeded) {
        HYLog(@"----------开始监听信息----------");
        [HYNotificationTool setupRemoteNotification];
    } fauil:^(NSError *error) {
        HYLog(@"登录出错%@", error);
    }];
}


#define HYHasRegister @"注册成功"
#define hasRegisterName @"hasRegisterName"
#define hasRegisterPWD @"hasRegisterPWD"
- (void)didMoveToSuperview{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hasRegister:) name:HYHasRegister object:nil];
}

- (void)hasRegister:(NSNotification*)notification{
    NSString* registerName = notification.userInfo[hasRegisterName];
    self.accountName.text = registerName;
    NSString* registerPWD = notification.userInfo[hasRegisterPWD];
    self.pwd.text = registerPWD;
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
       [MBProgressHUD showMessage:@"正在登陆中..." toView:self.superview];
    }];
    [AVUser logInWithUsernameInBackground:self.accountName.text password:self.pwd.text block:^(AVUser *user, NSError *error) {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
           [MBProgressHUD hideHUDForView:self.superview animated:YES];
        }];
        
        if (!error) {
            [MBProgressHUD showSuccess:@"登录成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                UIWindow* keyWindow = [UIApplication sharedApplication].keyWindow;
                HYMainViewController* mainVC = [[HYMainViewController alloc] init];
                keyWindow.rootViewController = mainVC;
                [self targetFuncutionWithUser:user];
            });
            
        } else {
            [MBProgressHUD showError:@"账号或密码错误"];
            HYLog(@"登录错误信息 --- %@", error);
        }
    }];

}


- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}








@end
