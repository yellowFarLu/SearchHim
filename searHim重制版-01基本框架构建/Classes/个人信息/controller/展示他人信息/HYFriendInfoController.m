//
//  HYFriendInfoController.m
//  searHim重制版-01基本框架构建
//
//  Created by 黄远 on 16/7/12.
//  Copyright © 2016年 黄远. All rights reserved.
//

#import "HYFriendInfoController.h"
//#import <AVIMConversationQuery.h>
#import <AVOSCloudIM.h>
#import "HYFriendFooterView.h"
#import "HYSingleChatViewController.h"
#import "HYConversationTool.h"
#import "HYUserInfo.h"
#import "HYCurrentClient.h"
#import <AVIMClient.h>
#import "HYResponseObject.h"
#import <AVUser.h>
#import "HYMsgTool.h"
#import <AVIMClient.h>
#import "HYUserInfoTool.h"
#import <AVStatus.h>
#import "HYNetTool.h"
#import "HYStatusTool.h"
#import "HYStatusParamters.h"
#import "HYDeleteButton.h"
#import "NSDate+HYRealDate.h"
#import "HYReportButton.h"
#import "HYReportViewController.h"
#import "HYNavgationController.h"
#import "HYMoreButton.h"
#import "HYBaseItemGroup.h"
#import "HYBaseItem.h"
#import "HYBlackTableButton.h"
#define HYReloadFriendFromDele @"删除好友了"
// 更多按钮的子按钮个数
#define HYMoreViewBtnCount 3

@interface HYFriendInfoController () <HYFriendFooterViewDelegate>
//按钮集合
@property (nonatomic, weak) UIView* moreView;
@property (nonatomic, strong) UIAlertController* alertVC;
@end

@implementation HYFriendInfoController


- (void)viewDidLoad{
    [super viewDidLoad];
    [self setupFriendFooterView];
    [self setupNavBtn];
    [self setupModel];
}



- (void)setupNavBtn{
    HYMoreButton* moreBtn = [HYMoreButton moreButton];
    [moreBtn addTarget:self action:@selector(onClickMoreBtn) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:moreBtn];
}

//点击更多按钮
- (void)onClickMoreBtn{
    if (!self.moreView) {
        UIView* moreView = [[UIView alloc] init];
        CGFloat moreViewX, moreViewY, moreViewWid, moreViewHei;
        moreViewWid = 100;
        moreViewX = self.view.width - moreViewWid;
        moreViewY = 0;
        moreViewHei = 30 * HYMoreViewBtnCount;
        moreView.frame = CGRectMake(moreViewX, moreViewY, moreViewWid, moreViewHei);
        [self.view addSubview:moreView];
        self.moreView = moreView;
        moreView.backgroundColor = HYGlobalBg;
        
        
        CGFloat height = moreViewHei / HYMoreViewBtnCount;
        CGFloat width = moreView.width;
        // 添加删除好友按钮
        HYDeleteButton* deleBtn = [HYDeleteButton deleteBtn];
        [deleBtn addTarget:self action:@selector(deleFriendClick) forControlEvents:UIControlEventTouchUpInside];
        deleBtn.frame = CGRectMake(0, 0, width, height);
        [moreView addSubview:deleBtn];
        
        // 添加举报按钮
        HYReportButton* reportBtn = [HYReportButton reportButton];
        [reportBtn addTarget:self action:@selector(reportOtherClick) forControlEvents:UIControlEventTouchUpInside];
        reportBtn.frame = CGRectMake(0, CGRectGetMaxY(deleBtn.frame), width, height);
        [moreView addSubview:reportBtn];
        
        // 添加加入黑名单按钮
        HYBlackTableButton* blackTableBtn = [HYBlackTableButton blackTableButton];
        [blackTableBtn addTarget:self action:@selector(blackTable) forControlEvents:UIControlEventTouchUpInside];
        blackTableBtn.frame = CGRectMake(0, CGRectGetMaxY(reportBtn.frame), width, height);
        [moreView addSubview:blackTableBtn];
        
    }else{
        [self.moreView removeFromSuperview];
    }
}

/** 拉黑系统 */
- (void)blackTable{
    UIAlertController* alertVC = [UIAlertController alertControllerWithTitle:@"信息提示tip" message:@"将会删除该好友同时不会接收到其消息"  preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        self.alertVC = nil;
    }];
    
    UIAlertAction *queAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDestructive handler:^(UIAlertAction* _Nonnull action){
        // 删除该好友
        [self deleteFriend];
        
        // 加入数据库中该好友的黑名单表
        Boolean result = [HYUserInfoTool putUser:self.imUsrInfo ToBlackTableWithParamters:nil];
        if (result) {
            [MBProgressHUD showSuccess:@"拉黑成功"];
        } else {
            [MBProgressHUD showError:@"未知错误，请稍后再试"];
        }
    }];
    
    [alertVC addAction:queAction];
    [alertVC addAction:cancelAction];
    [self presentViewController:alertVC animated:YES completion:^{
        
    }];
    self.alertVC = alertVC;
}

/** 举报他人 */
- (void)reportOtherClick{
    HYReportViewController* reportVC = [[HYReportViewController alloc] init];
    [self.navigationController pushViewController:reportVC animated:YES];
}

// 删除朋友
- (void)deleFriendClick{
    [self.moreView removeFromSuperview];
    [self showInfoVCWithTitle:nil message:@"删除该好友？" cancelTitle:@"取消" cancelHandler:^(UIAlertAction * _Nonnull action) {
        
    } andQueTitle:@"删除" cancelHandler:^(UIAlertAction * _Nonnull action) {
        [self deleteFriend];
    }];
}

/** 删除好友具体实现 */
- (void)deleteFriend{
    int isConnect = [HYNetTool isInConnectNet];
    if (isConnect) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        //从服务器里面删除
        [[AVUser currentUser] unfollow:self.imUsrInfo.objectId andCallback:^(BOOL succeeded, NSError *error) {
            //从数据库里面删除
            [HYUserInfoTool deleteFriendFromDB:self.imUsrInfo WithParamter:nil];
            HYLog(@"取消关注 ---- %@", self.imUsrInfo.username);
            
            //从邮箱里面删除该好友的请求，防止再次添加
            HYStatusParamters* statusPram = [[HYStatusParamters alloc] init];
            statusPram.userInfo = self.imUsrInfo;
            [HYStatusTool deleteStatusWithParamters:statusPram success:^(HYStatusResultParamters *resultParamters) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            } failure:^(NSError *err) {
                
            }];
            
            //更新UI
            [[NSNotificationCenter defaultCenter] postNotificationName:HYReloadFriendFromDele object:nil];
            [MBProgressHUD showSuccess:@"已删除"];
            [self.navigationController popViewControllerAnimated:YES];
        }];
        
    } else {
        [MBProgressHUD showError:@"无网络连接，请稍后再试.."];
    }

}

- (void)showInfoVCWithTitle:(NSString*)title message:(NSString*)msg cancelTitle:(NSString*)cancelTitle cancelHandler:(void(^)(UIAlertAction * _Nonnull action))cancel andQueTitle:(NSString*)queTitle cancelHandler:(void(^)(UIAlertAction * _Nonnull action))que{
    UIAlertController* alertVC = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (cancel) {
            cancel(action);
        }
    }];
    UIColor* btnColor = [UIColor grayColor];
    [cancelAction setValue:btnColor forKey:@"titleTextColor"];
    UIAlertAction *queAction = [UIAlertAction actionWithTitle:queTitle style:UIAlertActionStyleDestructive handler:^(UIAlertAction* _Nonnull action){
        if (que) {
            que(action);
        }
    }];
//    [queAction setValue:btnColor forKey:@"titleTextColor"];
    
    [alertVC addAction:cancelAction];
    [alertVC addAction:queAction];
    [self presentViewController:alertVC animated:YES completion:^{
        
    }];
    
}


- (void)setupFriendFooterView{
    HYFriendFooterView* friendFooterView = [HYFriendFooterView friendFooterView];
    friendFooterView.delegate = self;
    self.tableView.tableFooterView = friendFooterView;
}

#pragma mark - HYFriendFooterViewDelegate

- (void)didClickSendMsgWithFooterView:(HYFriendInfoController *)friendFooterView{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [HYConversationTool queryConversationWithOtherObjId:self.imUsrInfo.objectId success:^(HYResponseObject *responseObj) {
        HYSingleChatViewController* singleChatVC = [[HYSingleChatViewController alloc] init];
        singleChatVC.sourceVC = self;
        singleChatVC.otherUserInfo = self.imUsrInfo;
        singleChatVC.conversation = responseObj.conversation;
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self.navigationController pushViewController:singleChatVC animated:YES];
    } failure:^(NSError *error) {
        if (error) {
            //数据库没有，从网络上查询有没有对应(包含otherObjectId, objectId)的conversation, 有的话，返回
            HYCurrentClient* currentClient = [HYCurrentClient shareCurrentClient];
            [self queryConversationWithCurrentClient:currentClient];
        }
    }];
}

- (void)queryConversationWithCurrentClient:(HYCurrentClient*)currentClient{
    AVIMConversationQuery *conQuery = [currentClient.imClient conversationQuery];
    NSString* imObjectId = [AVUser currentUser].objectId;
    [conQuery whereKey:@"m" containsAllObjectsInArray:@[imObjectId, self.imUsrInfo.objectId]];
    [conQuery whereKey:@"m" sizeEqualTo:2];
    conQuery.limit = 1;
    [conQuery findConversationsWithCallback:^(NSArray *objects, NSError *error) {
        if (error) {
            HYLog(@"%@", error);
        }
        if (objects.count != 0) {
            AVIMConversation* conversation = [objects firstObject];
            HYSingleChatViewController* singleChatVC = [[HYSingleChatViewController alloc] init];
            singleChatVC.sourceVC = self;
            singleChatVC.otherUserInfo = self.imUsrInfo;
            singleChatVC.conversation = conversation;
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self.navigationController pushViewController:singleChatVC animated:YES];
            [self saveInDBWithUserInfo:self.imUsrInfo andConversation:conversation];
        }else{
            //直接创建新的会话
            NSString* imObjectId = [AVUser currentUser].objectId;
            NSString* otherOnjectId = self.imUsrInfo.objectId;
            [currentClient.imClient createConversationWithName:@"新回话" clientIds:@[imObjectId, otherOnjectId] attributes:nil options:AVIMConversationOptionUnique callback:^(AVIMConversation *conversation, NSError *error) {
                HYSingleChatViewController* singleChatVC = [[HYSingleChatViewController alloc] init];
                singleChatVC.sourceVC = self;
                singleChatVC.otherUserInfo = self.imUsrInfo;
                singleChatVC.conversation = conversation;
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [self.navigationController pushViewController:singleChatVC animated:YES];
                [self saveInDBWithUserInfo:self.imUsrInfo andConversation:conversation];
            }];
        }
    }];

}

- (void)saveInDBWithUserInfo:(HYUserInfo*)userInfo andConversation:(AVIMConversation*)conversation{
    //能到这里，说明本地没有该对话，最后一句话设为空字符串
    [HYMsgTool insertMsgToDBWithOtherObjectId:userInfo.objectId conversation:conversation otherIconUrl:userInfo.iconUrl otherUsername:userInfo.username lastMessageAtStr:[[NSDate date] userStringFromDate] lastContent:@"" unreadCount:0];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    [MBProgressHUD showError:@"亲，别人的信息不能修改哦~"];
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    return NO;
}










@end
