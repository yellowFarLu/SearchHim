//
//  HYAddFriendController.m
//  searHim重制版-01基本框架构建
//
//  Created by 黄远 on 16/7/11.
//  Copyright © 2016年 黄远. All rights reserved.
//

#import "HYAddFriendController.h"
#import "HYConfirmationView.h"
#import <AVStatus.h>
#import "HYUserInfo.h"
#import <AVUser.h>
#import "HYBackButton.h"
#import "HYSendButton.h"
#import "HYUserInfoTool.h"

@interface HYAddFriendController () <HYConfirmationViewDelegate>
@property (nonatomic, weak) HYConfirmationView* confiV;
@end

@implementation HYAddFriendController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupNav];
    [self setupConfirmationView];
}

- (void)setupConfirmationView{
    HYConfirmationView* confimationView = [HYConfirmationView confirmationView];
    confimationView.frame = self.view.bounds;
    confimationView.y = 0;
    confimationView.delegate = self;
    [self.view addSubview:confimationView];
    self.confiV = confimationView;
}

- (void)setupNav{
    self.title = @"发送验证信息";
    HYSendButton* sendBtn = [HYSendButton sendButton];
    [sendBtn addTarget:self action:@selector(onClickSendBtn) forControlEvents:UIControlEventTouchUpInside];
    CGFloat sendBtnX, sendBtnY, sendBtnH, sendBtnW;
    sendBtnX = sendBtnY = 0;
    sendBtnH = HYBackBtnH;
    sendBtnW = HYBackBtnW;
    sendBtn.frame = CGRectMake(sendBtnX, sendBtnY, sendBtnW, sendBtnH);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:sendBtn];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    HYBackButton* backBtn = [HYBackButton backButton];
    backBtn.frame = CGRectMake(0, 0, 30, 20);
    [backBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
}

- (void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)onClickSendBtn{
    AppDelegate* appD = (AppDelegate*)[UIApplication sharedApplication].delegate;
    AVUser* imUser = [AVUser currentUser];
    AVStatus *status=[[AVStatus alloc] init];
    HYLog(@"%@    %@    %@    %@", imUser.username, [self.confiV getValue], appD.imUserInfo.iconUrl, imUser.objectId);
    status.data=@{ @"username" : imUser.username,
                   @"type": @"requested",
                   @"decription": [self.confiV getValue],
                   @"iconUrl" : appD.imUserInfo.iconUrl,
                   @"objId"   : imUser.objectId
                   };
    
    NSString *userObjectId=self.userInfo.objectId;
    [MBProgressHUD showMessage:@"正在发送请求..."];
    [AVStatus sendPrivateStatus:status toUserWithID:userObjectId andCallback:^(BOOL succeeded, NSError *error) {
        [MBProgressHUD hideHUD];
        if (succeeded) {
            [MBProgressHUD showSuccess:@"成功发送"];
            [self.navigationController popViewControllerAnimated:YES];
            
            // 从本地数据库的黑名单中删除
            [HYUserInfoTool DeleteUserInBlackTable:self.userInfo];
            
        } else {
            HYLog(@"============ Send %@", error);
        }
        
       HYLog(@"============ Send %@", [status debugDescription]);
    }];
}

#pragma mark - HYConfirmationViewDelegate
- (void)confirmationView:(HYConfirmationView *)confirmationView WithTextViewLenth:(NSInteger)length{
    self.navigationItem.rightBarButtonItem.enabled = length > 0;
}




@end
