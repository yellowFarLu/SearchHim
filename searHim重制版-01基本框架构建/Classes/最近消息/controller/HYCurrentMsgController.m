//
//  HYCurrentMsgController.m
//  searHim重制版-01基本框架构建
//
//  Created by 黄远 on 16/7/5.
//  Copyright © 2016年 黄远. All rights reserved.
//

#import "HYCurrentMsgController.h"
#import <AVIMConversation.h>
#import <AVUser.h>
#import "HYCurrentMsgItem.h"
#import "HYMsgTool.h"
#import <AVQuery.h>
#import "HYCurrentMsgCell.h"
#import "HYSingleChatViewController.h"
#import "HYUserInfo.h"
#import "HYMsgTool.h"
#import "HYResponseObject.h"
#import "NSDate+HYRealDate.h"
#import "UIImage+Exstension.h"
#import <AVIMVideoMessage.h>
#import <AVFile.h>
#define newMsg @"来新消息啦"
#define HYClientHasGet @"client加载好了"
#define HYReloadCurrentMsgUI @"更新最近消息"
#define HYUnreadCount @"未读消息数"
#define HYSendOtherMsg @"转发消息"

#define HYVideoPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"HYMedioFile"]

//test
//#import "HYCurrentClient.h"
//#import <AVIMClient.h>

@interface HYCurrentMsgController ()

@property (nonatomic, copy) NSString* otherClientId;
//主队列
@property (nonatomic, strong) NSOperationQueue* mQueue;
@property (nonatomic, weak) UIButton* tipsBtn;

@end

@implementation HYCurrentMsgController

- (NSOperationQueue *)mQueue{
    if (!_mQueue) {
        _mQueue = [NSOperationQueue mainQueue];
    }
    return _mQueue;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.contentInset = UIEdgeInsetsMake(-20, 0, 0, 0);
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hasGetClient) name:HYClientHasGet object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadUI) name:HYReloadCurrentMsgUI object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadUIforItem:) name:HYSendOtherMsg object:nil];
}

//更新转发消息
- (void)reloadUIforItem:(NSNotification*)notification{
    //看看最近消息里面有没有对应聊天的信息了，有就把原来的删除
    HYCurrentMsgItem* currentMsgItem = notification.userInfo[@"currentMsgItem"];
    for (HYCurrentMsgItem* curMsg in self.groups) {
        if ([curMsg.otherUserInfo.objectId isEqualToString:currentMsgItem.otherUserInfo.objectId]) {
            [self.groups removeObject:curMsg];
            break;
        }
    }
    
    [self.groups insertObject:currentMsgItem atIndex:0];
    [self.tableView reloadData];
}

- (void)hasGetClient{
    // 从数据库加载所有最近消息
    [HYMsgTool loadAllCurrentMsgFromDBsuccess:^(HYResponseObject *responseObj) {
        if (responseObj.resultInfo.count == 0) {
            [self showTips];
        } else {
            if (self.tipsBtn) {
                self.tipsBtn.hidden = YES;
            }
            self.groups = [NSMutableArray arrayWithArray:responseObj.resultInfo];
            [self.tableView reloadData];
            //发送消息，让tabBar显示未读消息数
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                [self countUnreadCount];
            });
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } failure:^(NSError *error) {
        
    }];
}

- (void)showTips{
    UIButton* nonewsBtn = [[UIButton alloc] init];
    nonewsBtn.backgroundColor = HYGlobalBg;
    [nonewsBtn setTitle:@"朋友，还有没有信息\n到 地图 或 发现 转转吧" forState:UIControlStateNormal];
    nonewsBtn.titleLabel.numberOfLines = 0;
    nonewsBtn.layer.cornerRadius = HYCornerRadius;
    nonewsBtn.clipsToBounds = YES;
    nonewsBtn.titleLabel.font = HYKeyFont;
    [nonewsBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    nonewsBtn.frame = CGRectMake(0, mainScreenHei*0.1, mainScreenWid, 200);
    [self.view addSubview:nonewsBtn];
    self.tipsBtn = nonewsBtn;
}

- (void)countUnreadCount{
    NSUInteger count = 0;
    for (HYCurrentMsgItem* msgItem in self.groups) {
        count += msgItem.unReadCount;
    }
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:@(count) forKey:@"unreadCount"];
    [[NSNotificationCenter defaultCenter] postNotificationName:HYUnreadCount object:nil userInfo:dict];
}

- (void)reloadUI{
    self.groups = nil;
    [self.tipsBtn removeFromSuperview];
    self.tipsBtn.hidden = YES;
    self.tipsBtn = nil;
    [self hasGetClient];
}

//更新模型（拿出对应的模型，修改最后一条聊天信息，时间。每次修改的模型要放到第一位，然后刷新表格）
- (void)updateItem:(HYCurrentMsgItem*)currrentMsgItem WithReceiveMsg:(AVIMTypedMessage *)msg andConversation:(AVIMConversation *)conversation{
    currrentMsgItem.lastContent = msg.text;
    NSString* temStr = msg.attributes[@"timeStr"];
    currrentMsgItem.timeStr = temStr;
    currrentMsgItem.lastMessageAtString = [NSDate currentStringFromPreString:temStr];
    NSUInteger UnReadCount = currrentMsgItem.unReadCount;
    UnReadCount = UnReadCount + 1;
    currrentMsgItem.unReadCount = UnReadCount;
    currrentMsgItem.showRing = YES;
    
    [self.groups removeObject:currrentMsgItem];
    [self.groups insertObject:currrentMsgItem atIndex:0];
    [self.tableView reloadData];
    
    //通知singleChat
    [self notificationSingleChatWithItem:currrentMsgItem WithReceiveMsg:msg andConversation:conversation];
    
    //更新到本地数据库
    [HYMsgTool reloadMsgToDBWithOtherObjectId:self.otherClientId conversation:conversation otherIconUrl:currrentMsgItem.otherUserInfo.iconUrl otherUsername:currrentMsgItem.otherUserInfo.username lastMessageAtStr:temStr lastContent:currrentMsgItem.lastContent unreadCount:currrentMsgItem.unReadCount];
}

//没有的话，创建新的模型，加入到最近消息的界面中;  同时插入数据库。
- (void)newItemWithReceiveMsg:(AVIMTypedMessage *)msg andConversation:(AVIMConversation *)conversation{
    HYCurrentMsgItem* currrentMsgItem = [[HYCurrentMsgItem alloc] init];
    HYUserInfo* userInfo = [[HYUserInfo alloc] init];
    userInfo.objectId = self.otherClientId;
    currrentMsgItem.lastContent = msg.text;
    NSString* temStr = msg.attributes[@"timeStr"];
    currrentMsgItem.timeStr = temStr;
    currrentMsgItem.lastMessageAtString = [NSDate currentStringFromPreString:temStr];
    currrentMsgItem.unReadCount = 1;
    currrentMsgItem.showRing = YES;
    currrentMsgItem.row = 0;
    currrentMsgItem.conversation = conversation;
    currrentMsgItem.otherUserInfo = userInfo;
    [self.groups insertObject:currrentMsgItem atIndex:0];
    [self.tableView reloadData];
    
    AVQuery *userQuery = [AVQuery queryWithClassName:@"_User"];
    [userQuery whereKey:@"objectId" equalTo:self.otherClientId];
    [userQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        AVUser* otherUser = [objects firstObject];
        HYCurrentMsgItem* currrentMsgItem = self.groups[0];
        currrentMsgItem.otherUserInfo = [HYUserInfo initOfUser:otherUser];
        NSIndexPath* indP = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.tableView reloadRowsAtIndexPaths:@[indP] withRowAnimation:UITableViewRowAnimationNone];
        
        //通知singleChat
        [self notificationSingleChatWithItem:currrentMsgItem WithReceiveMsg:msg andConversation:conversation];
        
        //插入数据库
        [HYMsgTool insertMsgToDBWithOtherObjectId:self.otherClientId conversation:conversation otherIconUrl:currrentMsgItem.otherUserInfo.iconUrl otherUsername:currrentMsgItem.otherUserInfo.username lastMessageAtStr:currrentMsgItem.timeStr lastContent:currrentMsgItem.lastContent unreadCount:currrentMsgItem.unReadCount];
    }];
}


#pragma mark - HYCurrentClientDelegate
- (void)currentClient:(HYCurrentClient *)currentClient ReceiveMsg:(AVIMTypedMessage *)msg andConversation:(AVIMConversation *)conversation{
    [self.tipsBtn removeFromSuperview];
    // 找出发送消息的人的Id
    NSString* temId = nil;
    for (int i=0; i < conversation.members.count; i++) {
        temId = conversation.members[i];
        if (![temId isEqualToString:[AVUser currentUser].objectId]) {
            self.otherClientId = temId;
            break;
        }
    }
    
    HYCurrentMsgItem* currrentMsgItem = nil;
    for (currrentMsgItem in self.groups) {
        if ([self.otherClientId isEqualToString:currrentMsgItem.otherUserInfo.objectId]) {
            break;
        }
    }
    
    if (currrentMsgItem) {  //最近消息控制器中有发来用户的Id对应的模型
        [self updateItem:currrentMsgItem WithReceiveMsg:msg andConversation:conversation];
        
    } else {     //最近消息控制器中没有发来用户的Id对应的模型
        [self newItemWithReceiveMsg:msg andConversation:conversation];
    }
    // 发送消息，让tabBar显示未读消息数
    [self countUnreadCount];
    
    // 如果是视频，首先把视频写入本地
    if (msg.mediaType == kAVIMMessageMediaTypeVideo) {
        AVIMVideoMessage* videoMsg = (AVIMVideoMessage*)msg;
        NSString* documentPath = HYVideoPath;
        [[NSFileManager defaultManager] createDirectoryAtPath:documentPath withIntermediateDirectories:YES attributes:nil error:nil];
        NSString* realStr = [msg.file.url stringByReplacingOccurrencesOfString:@"/" withString:@"h"];
        NSString* videoName = [NSString stringWithFormat:@"%@.mov", realStr];
        NSString* videoPath = [documentPath stringByAppendingPathComponent:videoName];
        NSData* videoData = [videoMsg.file getData];
        [videoData writeToFile:videoPath atomically:YES];
    }

    [self saveIDForMsgTimestamp:msg.sendTimestamp and:YES andObjectID:self.otherClientId];
}

//存储消息要不要被展示的标志
- (void)saveIDForMsgTimestamp:(int64_t)timestamp and:(BOOL)show andObjectID:(NSString*)objId{
    dispatch_queue_t queue = dispatch_queue_create("存储标志", DISPATCH_QUEUE_PRIORITY_DEFAULT);
    dispatch_async(queue, ^{
        //标志该消息需被展示了(异步)
        NSString* key = [NSString stringWithFormat:@"%@%@%lld", objId, [AVUser currentUser].objectId, timestamp];
        NSUserDefaults* def = [NSUserDefaults standardUserDefaults];
        [def setBool:show forKey:key];
        [def synchronize];
    });
}

- (void)notificationSingleChatWithItem:(HYCurrentMsgItem*)currrentMsgItem WithReceiveMsg:(AVIMTypedMessage *)msg andConversation:(AVIMConversation *)conversation{
    //同时发出通知 #define newMsg @“来新消息啦”，发来用户的Id和聊天界面中的他人聊天id对比一下，如果一样，就增加一个模型，显示到聊天界面中。
    NSMutableDictionary* msgDict = [NSMutableDictionary dictionary];
    [msgDict setValue:self.otherClientId forKey:@"objectId"];
    [msgDict setValue:msg forKey:@"AVIMTypedMessage"];
    [msgDict setValue:conversation forKey:@"AVIMConversation"];
    [msgDict setValue:currrentMsgItem.lastMessageAtString forKey:@"lastMessageAtString"];
    //这个通知是在聊天界面生成以后才能接收到
    [[NSNotificationCenter defaultCenter] postNotificationName:newMsg object:self userInfo:msgDict];
}


#pragma mark - tableDelegate
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* ID = @"HYCurrentMsgCell";
    HYCurrentMsgCell* cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [HYCurrentMsgCell currentMsgCell];
    }
    HYCurrentMsgItem* currentMsgItem = self.groups[indexPath.row];
    cell.currentMsgItem = currentMsgItem;
    cell.showsReorderControl = YES;
    return cell;
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewRowAction *deletaAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        //删除数据库中对应的聊天
        HYCurrentMsgItem* currentItem = self.groups[indexPath.row];
        [HYMsgTool deleteMsgWithOtherObjectId:currentItem.otherUserInfo.objectId imObjectId:[AVUser currentUser].objectId];
        
        //删除cell之前，要保证对应的模型也删除了，这样子模型的数量才对应cell的数量
        [self.groups removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }];
    
    return @[deletaAction];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    HYSingleChatViewController* singleCharVC = [[HYSingleChatViewController alloc] init];
    HYCurrentMsgItem* currentMsgItem = self.groups[indexPath.row];
    singleCharVC.sourceVC = self;
    singleCharVC.otherUserInfo = currentMsgItem.otherUserInfo;
    singleCharVC.conversation = currentMsgItem.conversation;
    [self.navigationController pushViewController:singleCharVC animated:YES];
    currentMsgItem.showRing = NO;
    currentMsgItem.unReadCount = 0;
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    //发送消息，让tabBar显示未读消息数
    [self countUnreadCount];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55;
}


- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
