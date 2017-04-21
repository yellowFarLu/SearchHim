//
//  HYCurrentClient.m
//  searHim重制版-01基本框架构建
//
//  Created by 黄远 on 16/7/14.
//  Copyright © 2016年 黄远. All rights reserved.
// 

#import "HYCurrentClient.h"
#import <AVUser.h>
#import <AVIMClient.h>
#import <AVIMConversation.h>
#import "HYStatusTool.h"
#import "HYUserInfoTool.h"
#import "HYUserInfo.h"
#define HYClientHasGet @"client加载好了"
#define HYOtherLoginMyAccount @"其他人登录了账号"
#define HYEndQueryStatus @"停止请求账号"
#define HYNewStatus @"来新的请求了"

//全局变量
static HYCurrentClient* _currentClient = nil;

@interface HYCurrentClient () <AVIMClientDelegate>

/*!
 * AVIMClient 实例
 */
@property (nonatomic, strong) AVIMClient *imClient;
/*
 * 请求状态的timer
 */
@property (nonatomic, strong) NSTimer* queryStatusTimer;
@end

@implementation HYCurrentClient


//ARC下确保唯一性的3个方法
+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _currentClient = [super allocWithZone:zone];
    });
    return _currentClient;
}

+ (id)copyWithZone:(struct _NSZone *)zone
{
    return _currentClient;
}

//- (instancetype)init{
//    if (self = [super init]) {
//        NSTimer* timer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(isGetOpen) userInfo:nil repeats:YES];
//        NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
//        [runLoop addTimer:timer forMode:NSDefaultRunLoopMode];
//    }
//    return self;
//}

+ (instancetype)shareCurrentClient{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _currentClient = [[HYCurrentClient alloc] init];
    });
    
    return _currentClient;
}


- (void)setupAVStatusQuery{
    NSTimer* timer = [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(queryStatus) userInfo:nil repeats:YES];
    NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
    [runLoop addTimer:timer forMode:NSDefaultRunLoopMode];
    self.queryStatusTimer = timer;
}

- (void)queryStatus{
    [HYStatusTool loadStatusWithParamters:nil success:^(HYStatusResultParamters *resultParamters) {
        NSMutableDictionary* newStatus = [NSMutableDictionary dictionary];
        [newStatus setObject:resultParamters.allStatus forKey:@"newStatus"];
        [[NSNotificationCenter defaultCenter] postNotificationName:HYNewStatus object:nil userInfo:newStatus];
    } failure:^(NSError *err) {
        
    }];
}

- (AVIMClient*)imClient{
    if (!_imClient) {
        NSString* imId = [AVUser currentUser].objectId;
        self.imClient = [[AVIMClient alloc] initWithClientId:imId];
        self.imClient.delegate = self;
    }
    return _imClient;
}



//与服务器建立长链接，开启聊天
- (void)openLongCallBackToSever:(void(^)(BOOL succeeded))success fauil:(void(^)(NSError* error))fauil{
    _imClient = nil;
    _imClient = self.imClient;
    [[NSNotificationCenter defaultCenter] postNotificationName:HYClientHasGet object:nil];
    [self.imClient openWithCallback:^(BOOL succeeded, NSError *error) {
        if (success) {
            HYLog(@"%@  ------  登录成功", self.imClient.clientId);
            success(succeeded);
            //监听邮箱，每隔10秒查看
            [self setupAVStatusQuery];
        }
        
        if (error) {
            fauil(error);
        }
    }];
}

#pragma mark - AVIMClientDelegate
- (void)conversation:(AVIMConversation *)conversation didReceiveTypedMessage:(AVIMTypedMessage *)message{
    // 转发信息前，先看该用户是否是黑名单
    NSString * otherClientId;
    for (int i=0; i < conversation.members.count; i++) {
        otherClientId = conversation.members[i];
        if (![otherClientId isEqualToString:[AVUser currentUser].objectId]) {
            break;
        }
    }
    HYUserInfo * userInfo = [[HYUserInfo alloc] init];
    userInfo.objectId = otherClientId;
    Boolean result = [HYUserInfoTool UserisInBlackTable:userInfo];
    if (result) {
        return;
    }
    [self.delegate currentClient:self ReceiveMsg:message andConversation:conversation];
}

- (void)client:(AVIMClient *)client didOfflineWithError:(NSError *)error{
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        //发送通知，让main控制器显示提示
//        [[NSNotificationCenter defaultCenter] postNotificationName:HYOtherLoginMyAccount object:nil];
//    });
}


- (void)conversation:(AVIMConversation *)conversation didReceiveCommonMessage:(AVIMMessage *)message{
    
}



@end
