//
//  HYSendOtherCardController.m
//  searHim重制版-01基本框架构建
//
//  Created by 黄远 on 16/8/6.
//  Copyright © 2016年 黄远. All rights reserved.
//

#import "HYSendOtherCardController.h"
#import "HYCurrentMsgItem.h"
#import "HYCurrentClient.h"
#import <AVIMConversation.h>
#import <AVIMConversationQuery.h>
#import "HYConversationTool.h"
#import <AVIMClient.h>
#import <AVUser.h>
#import "HYMsgTool.h"
#import "NSDate+HYRealDate.h"
#import "HYContentItem.h"
#import "HYPicItem.h"
#import "HYVideoItem.h"
#import "HYAudioItem.h"
#import "HYCardItem.h"
#import <AVIMTypedMessage.h>
#import <AVIMImageMessage.h>
#import <AVIMAudioMessage.h>
#import <AVIMVideoMessage.h>
#import <AVIMTextMessage.h>
#import <AVFile.h>
#define HYSendOtherMsg @"转发消息"
#define HYVideoPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"HYMedioFile"]

@interface HYSendOtherCardController ()

@end

@implementation HYSendOtherCardController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"选择联系人";
    [self setupBackBtn];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //通知最近消息更新
    HYCurrentMsgItem* currentItem = [[HYCurrentMsgItem alloc] init];
    HYFriendGroupItem* groupItem = self.groups[indexPath.section];
    HYUserInfo* item = groupItem.items[indexPath.row];
    
    // 首先判断是不是转发到当前聊天
    if ([self.otherObjId isEqualToString:item.objectId]) {  // 是的话，让刚刚的聊天页面发送消息
        [self.delegate sendMsgToCurrentSingleCharRoomWithChatItem:self.baseChatItem];
    }
    
    // 执行转发
    currentItem.otherUserInfo = item;
    [self finConversationWithItem:currentItem WithUserInfo:item];
}

- (void)finConversationWithItem:(HYCurrentMsgItem*)currentItem WithUserInfo:(HYUserInfo*)userInfo{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [HYConversationTool queryConversationWithOtherObjId:userInfo.objectId success:^(HYResponseObject *responseObj) {
        [self initCurrentItem:currentItem WithConversation:responseObj.conversation];
    } failure:^(NSError *error) {
        if (error) {
            //数据库没有，从网络上查询有没有对应(包含otherObjectId, objectId)的conversation, 有的话，返回
            HYCurrentClient* currentClient = [HYCurrentClient shareCurrentClient];
            if (currentClient.imClient.status != AVIMClientStatusOpened) {
                [currentClient openLongCallBackToSever:^(BOOL succeeded) {
                    HYCurrentClient* currentClient = [HYCurrentClient shareCurrentClient];
                    [self queryConversationWithCurrentClient:currentClient WithUserInfo:userInfo WithItem:currentItem];
                } fauil:^(NSError *error) {
                    HYLog(@"%@", error);
                }];
            }else{
                [self queryConversationWithCurrentClient:currentClient WithUserInfo:userInfo WithItem:currentItem];
            }
        }
    }];

}


- (void)queryConversationWithCurrentClient:(HYCurrentClient*)currentClient WithUserInfo:(HYUserInfo*)userInfo WithItem:(HYCurrentMsgItem*)currentItem{
    AVIMConversationQuery *conQuery = [currentClient.imClient conversationQuery];
    NSString* imObjectId = [AVUser currentUser].objectId;
    [conQuery whereKey:@"m" containsAllObjectsInArray:@[imObjectId, userInfo.objectId]];
    [conQuery whereKey:@"m" sizeEqualTo:2];
    conQuery.limit = 1;
    [conQuery findConversationsWithCallback:^(NSArray *objects, NSError *error) {
        if (error) {
            HYLog(@"%@", error);
        }
        if (objects.count != 0) {
            AVIMConversation* conversation = [objects firstObject];
            [self initCurrentItem:currentItem WithConversation:conversation];
        }else{
            //直接创建新的会话
            NSString* imObjectId = [AVUser currentUser].objectId;
            NSString* otherOnjectId = userInfo.objectId;
            [currentClient.imClient createConversationWithName:@"新回话" clientIds:@[imObjectId, otherOnjectId] attributes:nil options:AVIMConversationOptionUnique callback:^(AVIMConversation *conversation, NSError *error) {
                [self initCurrentItem:currentItem WithConversation:conversation];
            }];
        }
    }];
    
}

- (void)initCurrentItem:(HYCurrentMsgItem*)currentMsgItem WithConversation:(AVIMConversation*)conversation{
    //1、发送对应的消息
    [[[NSOperationQueue alloc] init] addOperationWithBlock:^{
        if ([self.baseChatItem isKindOfClass:[HYContentItem class]]) {
            [self sendContentMsgWithCurrentItem:currentMsgItem WithConversation:conversation];
        } else if([self.baseChatItem isKindOfClass:[HYPicItem class]]) {
            [self sendPicMsgWithCurrentItem:currentMsgItem WithConversation:conversation];
        } else if([self.baseChatItem isKindOfClass:[HYVideoItem class]]) {
            [self sendVideoMsgWithCurrentItem:currentMsgItem WithConversation:conversation];
        } else if([self.baseChatItem isKindOfClass:[HYAudioItem class]]) {
            [self sendAudioMsgWithCurrentItem:currentMsgItem WithConversation:conversation];
        } else if([self.baseChatItem isKindOfClass:[HYCardItem class]]) {
            [self sendCardMsgWithCurrentItem:currentMsgItem WithConversation:conversation];
        }
    }];
}

/////////////////////////////转发信息////////////////////////////////////
//转发图片信息
- (void)sendPicMsgWithCurrentItem:(HYCurrentMsgItem*)currentMsgItem WithConversation:(AVIMConversation*)conversation{
    NSMutableDictionary* mulDict = [NSMutableDictionary dictionary];
    NSString* timeStr = [[NSDate date] stringFromDate];
    [mulDict setObject:timeStr forKey:@"timeStr"];

    HYPicItem* picItem = (HYPicItem*)self.baseChatItem;
    NSData* photoData = UIImageJPEGRepresentation(picItem.pic, 1.0);
    AVFile* imaFile = [AVFile fileWithData:photoData];
    AVIMImageMessage* imageMsg = [AVIMImageMessage messageWithText:@"[图片]" file:imaFile attributes:mulDict];
    
    [conversation sendMessage:imageMsg callback:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            HYLog(@"发送图片成功");
            //更新最近消息的界面，同时存数据到数据库（异步)
            [self configureCurrentItem:currentMsgItem WitchConversation:conversation andMsg:imageMsg];
            [self saveIDForMsgTimestamp:imageMsg.sendTimestamp and:YES andOtherObjcId:currentMsgItem.otherUserInfo.objectId];
        } else {
            [MBProgressHUD showError:@"当前没有网络连接.."];
            [MBProgressHUD hideHUDForView:self.view  animated:YES];
        }

    }];
}
//转发文字信息
- (void)sendContentMsgWithCurrentItem:(HYCurrentMsgItem*)currentMsgItem WithConversation:(AVIMConversation*)conversation{
    NSMutableDictionary* mulDict = [NSMutableDictionary dictionary];
    NSString* timeStr = [[NSDate date] stringFromDate];
    [mulDict setObject:timeStr forKey:@"timeStr"];
    HYContentItem* contentItem = (HYContentItem*)self.baseChatItem;
    
    //发送对话
    AVIMTextMessage* textMsg = [AVIMTextMessage messageWithText:contentItem.realString attributes:mulDict];
    [conversation sendMessage:textMsg callback:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            //组装currentItem
            [self configureCurrentItem:currentMsgItem WitchConversation:conversation andMsg:textMsg];
            [self saveIDForMsgTimestamp:textMsg.sendTimestamp and:YES andOtherObjcId:currentMsgItem.otherUserInfo.objectId];
        } else {
            [MBProgressHUD showError:@"当前没有网络连接.."];
            [MBProgressHUD hideHUDForView:self.view  animated:YES];
        }
    }];
}

//转发视频信息
- (void)sendVideoMsgWithCurrentItem:(HYCurrentMsgItem*)currentMsgItem WithConversation:(AVIMConversation*)conversation{
    HYVideoItem* videoItem = (HYVideoItem*)self.baseChatItem;
    NSMutableDictionary* mulDict = [NSMutableDictionary dictionary];
    NSString* timeStr = [[NSDate date] stringFromDate];
    [mulDict setObject:timeStr forKey:@"timeStr"];
    [mulDict setObject:videoItem.videoUrl forKey:@"videoUrl"];
    
    NSData* data = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:videoItem.videoUrl]];
    AVFile* file = [AVFile fileWithData:data];
    
    AVIMVideoMessage* videoMsg = [AVIMVideoMessage messageWithText:@"[视频]" file:file attributes:mulDict];
    [conversation sendMessage:videoMsg callback:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSString* documentPath = HYVideoPath;
            [[NSFileManager defaultManager] createDirectoryAtPath:documentPath withIntermediateDirectories:YES attributes:nil error:nil];
            NSString* realStr = [file.url stringByReplacingOccurrencesOfString:@"/" withString:@"h"];
            NSString* videoName = [NSString stringWithFormat:@"%@.mov", realStr];
            NSString* videoPath = [documentPath stringByAppendingPathComponent:videoName];
            [data writeToFile:videoPath atomically:YES];

            
            [self configureCurrentItem:currentMsgItem WitchConversation:conversation andMsg:videoMsg];
            [self saveIDForMsgTimestamp:videoMsg.sendTimestamp and:YES andOtherObjcId:currentMsgItem.otherUserInfo.objectId];
        } else {
            [MBProgressHUD showError:@"当前没有网络连接.."];
            [MBProgressHUD hideHUDForView:self.view  animated:YES];
        }
    }];

}

//发送音频消息
- (void)sendAudioMsgWithCurrentItem:(HYCurrentMsgItem*)currentMsgItem WithConversation:(AVIMConversation*)conversation{
    HYAudioItem* audioItem = (HYAudioItem*)self.baseChatItem;
    NSMutableDictionary* mulDict = [NSMutableDictionary dictionary];
    NSString* timeStr = [[NSDate date] stringFromDate];
    [mulDict setObject:timeStr forKey:@"timeStr"];
    [mulDict setValue:@(audioItem.audioTime) forKey:@"recorderTime"];
    
    AVFile* file = [AVFile fileWithData:audioItem.audio];
    AVIMAudioMessage* audioMsg = [AVIMAudioMessage messageWithText:@"音频" file:file attributes:mulDict];
    [conversation sendMessage:audioMsg callback:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            [self configureCurrentItem:currentMsgItem WitchConversation:conversation andMsg:audioMsg];
            [self saveIDForMsgTimestamp:audioMsg.sendTimestamp and:YES andOtherObjcId:currentMsgItem.otherUserInfo.objectId];

        } else{
            [MBProgressHUD showError:@"当前没有网络连接.."];
            [MBProgressHUD hideHUDForView:self.view  animated:YES];
        }
    }];
}

//发送名片
- (void)sendCardMsgWithCurrentItem:(HYCurrentMsgItem*)currentMsgItem WithConversation:(AVIMConversation*)conversation{
    HYCardItem* cardItem = (HYCardItem*)self.baseChatItem;
    NSData* infoData = [NSKeyedArchiver archivedDataWithRootObject:cardItem.userInfo];
    AVFile* file = [AVFile fileWithData:infoData];
    NSMutableDictionary* mulDict = [NSMutableDictionary dictionary];
    NSString* timeStr = [[NSDate date] stringFromDate];
    cardItem.timeStr = timeStr;
    [mulDict setObject:timeStr forKey:@"timeStr"];
    AVIMTextMessage* infoMsg = [AVIMTextMessage messageWithText:@"名片" file:file attributes:mulDict];
    infoMsg.mediaType = kAVIMMessageMediaTypeFile;
    [conversation sendMessage:infoMsg callback:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            [self configureCurrentItem:currentMsgItem WitchConversation:conversation andMsg:infoMsg];
            [self saveIDForMsgTimestamp:infoMsg.sendTimestamp and:YES andOtherObjcId:currentMsgItem.otherUserInfo.objectId];
        }else{
            [MBProgressHUD showError:@"当前没有网络连接.."];
            [MBProgressHUD hideHUDForView:self.view  animated:YES];
        }
    }];

}


- (void)configureCurrentItem:(HYCurrentMsgItem*)currentMsgItem WitchConversation:(AVIMConversation*)conversation andMsg:(AVIMTypedMessage*)msg{
    currentMsgItem.conversation = conversation;
    if (msg.mediaType == kAVIMMessageMediaTypeText) {
        currentMsgItem.lastContent = msg.text;
    } else if(msg.mediaType == kAVIMMessageMediaTypeImage){
        currentMsgItem.lastContent = @"[图片]";
    } else if(msg.mediaType == kAVIMMessageMediaTypeAudio){
        currentMsgItem.lastContent = @"[语音]";
    } else if(msg.mediaType == kAVIMMessageMediaTypeVideo){
        currentMsgItem.lastContent = @"[视频]";
    } else if(msg.mediaType == kAVIMMessageMediaTypeFile){
        currentMsgItem.lastContent = @"[名片]";
    }
    NSString* temStr = msg.attributes[@"timeStr"];
    currentMsgItem.timeStr = temStr;
    currentMsgItem.lastMessageAtString = [NSDate currentStringFromPreString:temStr];
    currentMsgItem.unReadCount = 0;
    currentMsgItem.showRing = NO;
    
    //2、更新最近消息(插入到第一位)
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    [dict setValue:currentMsgItem forKey:@"currentMsgItem"];
    [[NSNotificationCenter defaultCenter] postNotificationName:HYSendOtherMsg object:nil userInfo:dict];
    
    //3、存储到数据库
    [self saveInDBWithUserInfo:currentMsgItem.otherUserInfo andConversation:conversation WithContent:currentMsgItem.lastContent];
    
    [MBProgressHUD hideHUDForView:self.view  animated:YES];
    //回退到原本的聊天室
    [self.navigationController popViewControllerAnimated:YES];
    [MBProgressHUD showSuccess:@"发送成功"];
}

//存储消息要不要被展示的标志
- (void)saveIDForMsgTimestamp:(int64_t)timestamp and:(BOOL)show andOtherObjcId:(NSString*)otherObjId{
    dispatch_queue_t queue = dispatch_queue_create("存储标志", DISPATCH_QUEUE_PRIORITY_DEFAULT);
    dispatch_async(queue, ^{
        //标志该消息需被展示了(异步)
        NSString* key = [NSString stringWithFormat:@"%@%@%lld", otherObjId, [AVUser currentUser].objectId, timestamp];
        NSUserDefaults* def = [NSUserDefaults standardUserDefaults];
        [def setBool:show forKey:key];
        [def synchronize];
    });
}

- (void)saveInDBWithUserInfo:(HYUserInfo*)userInfo andConversation:(AVIMConversation*)conversation WithContent:(NSString*)title{
    [HYMsgTool insertMsgToDBWithOtherObjectId:userInfo.objectId conversation:conversation otherIconUrl:userInfo.iconUrl otherUsername:userInfo.username lastMessageAtStr:[[NSDate date] userStringFromDate] lastContent:title unreadCount:0];
}

- (void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setupBackBtn{
    UIButton* backBtn = [[UIButton alloc] init];
    [backBtn setTitle:@"返回" forState:UIControlStateNormal];
    [backBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backBtn setTitleColor:backBtnColor forState:UIControlStateHighlighted];
    backBtn.frame = CGRectMake(0, 0, 30, 20);
    backBtn.titleLabel.font = HYValueFont;
    [backBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
}

- (void)addItemWithArr:(NSArray*)resultInfo{
    for (HYUserInfo*userInfo in resultInfo) {
        NSString* tem = [userInfo.username lowercaseString];
        unichar temC = [tem characterAtIndex:0];
        int index = [HYPinyinOC pinyinFirstLetter:temC];
        if (index >= 97) {
            index = index - 97;
        }
        HYFriendGroupItem* groupItem = nil;
        if(index >=0 && index < 26){
            groupItem = self.groups[index];
        }else{
            //如果账号名字首字母是数字或其他  //27固定存放其他不能识别首字母的对象
            groupItem = self.groups[27];
        }
        [groupItem.items addObject:userInfo];
    }
}

@end
