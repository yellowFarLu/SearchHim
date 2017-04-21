//
//  HYOtherInfoController.m
//  searHim重制版-01基本框架构建
//
//  Created by 黄远 on 16/7/11.
//  Copyright © 2016年 黄远. All rights reserved.
//

#import "HYOtherInfoController.h"
#import <AVOSCloudIM.h>
#import "HYFooterView.h"
#import "HYSingleChatViewController.h"
#import "HYAddFriendController.h"
#import <AVStatus.h>
#import "HYConversationTool.h"
#import "HYUserInfo.h"
#import "HYResponseObject.h"
#import "HYCurrentClient.h"
#import <AVIMClient.h>
#import "HYMsgTool.h"
#import "NSDate+HYRealDate.h"
#import "HYMoreButton.h"
#import "HYBackButton.h"
#import "HYReportButton.h"
#import "HYReportViewController.h"
#define HYMoreViewBtnCount 1

@interface HYOtherInfoController () <HYFooterViewDelegate>
@property (nonatomic, weak) UIView* moreView;
@end

@implementation HYOtherInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupNav];
    [self setupFooterView];
    [self setupModel];
}

- (void)setupNav{
    HYMoreButton* moreBtn = [HYMoreButton moreButton];
    [moreBtn addTarget:self action:@selector(onClickMoreBtn) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:moreBtn];
    
    HYBackButton* backBtn = [HYBackButton backButton];
    backBtn.frame = CGRectMake(0, 0, 30, 20);
    [backBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
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
        
        // 添加举报按钮
        HYReportButton* reportBtn = [HYReportButton reportButton];
        [reportBtn addTarget:self action:@selector(reportOtherClick) forControlEvents:UIControlEventTouchUpInside];
        reportBtn.frame = CGRectMake(0, 0, width, height);
        [moreView addSubview:reportBtn];
        
    }else{
        [self.moreView removeFromSuperview];
    }
}

/** 举报他人 */
- (void)reportOtherClick{
    HYReportViewController* reportVC = [[HYReportViewController alloc] init];
    [self.navigationController pushViewController:reportVC animated:YES];
}

- (void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setupFooterView{
    HYFooterView* footerView = [HYFooterView footerView];
    footerView.delegate = self;
    self.tableView.tableFooterView = footerView;
}

#pragma mark - HYFooterViewDelegate
- (void)didClickAddFriendWithFooterView:(HYFooterView *)footerView{
    HYAddFriendController* addFVC = [[HYAddFriendController alloc] init];
    addFVC.userInfo = self.imUsrInfo;
    [self.navigationController pushViewController:addFVC animated:YES];
}

-(void)didClickSendMsgWithFooterView:(HYFooterView *)footerView{
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
    [HYMsgTool insertMsgToDBWithOtherObjectId:userInfo.objectId conversation:conversation otherIconUrl:userInfo.iconUrl otherUsername:userInfo.username lastMessageAtStr:[[NSDate date] userStringFromDate] lastContent:@"" unreadCount:0];  //能到这里，说明本地没有该对话，最后一句话设为空字符串
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    return NO;
}






@end
