//
//  HYMsgTool.m
//  searHim重制版-01基本框架构建
//
//  Created by 黄远 on 16/7/14.
//  Copyright © 2016年 黄远. All rights reserved.
//

#import "HYMsgTool.h"
#import "FMDB.h"
#import <AVIMConversation.h>
#import "HYCurrentMsgItem.h"
#import "HYUserInfo.h"
#import "HYCurrentClient.h"
#import <AVIMClient.h>
#import "HYResponseObject.h"
#import <AVUser.h>
#import "NSDate+HYRealDate.h"
#import "NSDate+HYDate.h"

FMDatabase* _msgDB;  //值等于全局的数据库

@implementation HYMsgTool


/*
 * 从数据库中加载所有的最近消息
 */
+ (void)loadAllCurrentMsgFromDBsuccess:(void(^)(HYResponseObject* responseObj))succeeded failure:(void(^)(NSError* error))failure{
    AppDelegate* appD = (AppDelegate*)[UIApplication sharedApplication].delegate;
    _msgDB = appD._db;
    NSMutableArray* allCurrentMsg = [NSMutableArray array];
    HYCurrentClient* currentClient = [HYCurrentClient shareCurrentClient];
    NSString* imObjId = [AVUser currentUser].objectId;
    if ([_msgDB open]) {
        FMResultSet* resultSet = [_msgDB executeQuery:@"SELECT * from currentMsg_table where imObjectId like ?", imObjId];
        while ([resultSet next]) {
            HYCurrentMsgItem* currentMsgItem = [[HYCurrentMsgItem alloc] init];
            HYUserInfo* otherUserInfo = [[HYUserInfo alloc] init];
            otherUserInfo.objectId = [resultSet objectForColumnName:@"objectId"];
            otherUserInfo.iconUrl = [resultSet objectForColumnName:@"otherIconUrl"];
            otherUserInfo.username = [resultSet objectForColumnName:@"otherUsername"];
            
            currentMsgItem.otherUserInfo = otherUserInfo;
            NSData* conversationKeyedData = [resultSet objectForColumnName:@"conversationKeyedData"];
            AVIMKeyedConversation* keyConversation = [NSKeyedUnarchiver unarchiveObjectWithData:conversationKeyedData];
            currentMsgItem.conversation = [currentClient.imClient conversationWithKeyedConversation:keyConversation];
            //这是存储的，要转化成用户可见的
            currentMsgItem.preLastMessageAtString = [resultSet objectForColumnName:@"lastMessageAtStr"];
            currentMsgItem.lastMessageAtString = [NSDate currentStringFromPreString:currentMsgItem.preLastMessageAtString];
            currentMsgItem.lastContent = [resultSet objectForColumnName:@"lastContent"];
            if ([currentMsgItem.lastContent isKindOfClass:[NSNull class]]) {
                currentMsgItem.lastContent = @"";
            }
            NSString* unreadCountStr = [resultSet objectForColumnName:@"unreadCount"];
            if (unreadCountStr && ![unreadCountStr isKindOfClass:[NSNull class]] && ![unreadCountStr isEqualToString:@"0"]) {
                currentMsgItem.unReadCount = unreadCountStr.integerValue;
            }else{
                currentMsgItem.unReadCount = 0;
            }
            
            [allCurrentMsg addObject:currentMsgItem];
        }
        
        // 根据时间，把消息模型进行排序
        // 1、把字符串转化为date
        // 2、根据date比较大小
        NSArray* allCurrentMsgArr = [NSArray arrayWithArray:allCurrentMsg];
        allCurrentMsgArr = [allCurrentMsgArr sortedArrayUsingComparator:^NSComparisonResult(HYCurrentMsgItem* obj1, HYCurrentMsgItem* obj2) {
            NSDate* date1 = [NSDate dateFromString:obj1.preLastMessageAtString];
            NSDate* date2 = [NSDate dateFromString:obj2.preLastMessageAtString];
            NSComparisonResult reslut = [NSDate compareWithDateOne:date1 dateTwo:date2];
            return reslut;
        }];
        
        if (succeeded) {
            HYResponseObject* responseObject = [[HYResponseObject alloc] init];
            responseObject.resultInfo = allCurrentMsgArr;
            succeeded(responseObject);
        }
        
    }
}


//最近消息数据库设计：	他人Id（主键）	他人聊天头像，名称，最后更新时间，最后一句话 本机用户的Id
//（这里不用用户名来区别不同的登录用户，是因为用户名可能变化）
//currentMsg_table(objectId text , conversationKeyedData blob, otherIconUrl text,  otherUsername text,  lastMessageAt text,   lastContent  text, imObjectId text);
+ (void)insertMsgToDBWithOtherObjectId:(NSString *)otherObjectId conversation:(AVIMConversation *)conversation otherIconUrl:(NSString *)otherIcon otherUsername:(NSString *)otherUsername lastMessageAtStr:(NSString*)temStr lastContent:(NSString *)lastContent unreadCount:(NSUInteger)unreadCount{
    HYLog(@"%@", _msgDB.databasePath);
    AppDelegate* appD = [UIApplication sharedApplication].delegate;
    _msgDB = appD._db;

    if ([_msgDB open]) {
        int result = [_msgDB executeUpdate:@"create table if not exists currentMsg_table(objectId text, conversationKeyedData blob, otherIconUrl text, otherUsername text, lastMessageAtStr text,   lastContent text, imObjectId text, unreadCount text, primary key(objectId,imObjectId));"];
        if (result) {
            HYLog(@"成功创表currentMsg_table");
        } else {
            HYLog(@"创表失败");
        }
        
        //检查是否已经有该用户的聊天记录了
        BOOL isIn = [self isMsgInDBWithOtherId:otherObjectId andImId:[AVUser currentUser].objectId];
        if (!isIn) {
            NSString* unreadCountStr = [NSString stringWithFormat:@"%d", (int)unreadCount];
            AVIMKeyedConversation* keyConversation = [conversation keyedConversation];
            NSData* keyConversationData = [NSKeyedArchiver archivedDataWithRootObject:keyConversation];
            [_msgDB executeUpdate:@"insert into currentMsg_table values(?, ?, ?, ?, ?, ?, ?, ?)", otherObjectId, keyConversationData, otherIcon, otherUsername, temStr, lastContent, [AVUser currentUser].objectId, unreadCountStr];
        }
    }

}

+ (BOOL)isMsgInDBWithOtherId:(NSString*)otherObjectId andImId:(NSString*)imObjectId{
    AppDelegate* appD = [UIApplication sharedApplication].delegate;
    _msgDB = appD._db;
    BOOL isIn = NO;
    if ([_msgDB open]) {
        FMResultSet* resultSet = [_msgDB executeQuery:@"select * from currentMsg_table where objectId like ? and imObjectId like ?", otherObjectId, imObjectId];
        while ([resultSet next]) {
            NSString* objID = [resultSet objectForColumnName:@"objectId"];
            if (objID) {
                isIn = YES;
                return isIn;
            }
        }
    }
    
    return isIn;
}


+ (void)reloadMsgToDBWithOtherObjectId:(NSString *)otherObjectId conversation:(AVIMConversation *)conversation otherIconUrl:(NSString *)otherIcon otherUsername:(NSString *)otherUsername lastMessageAtStr:(NSString*)temStr lastContent:(NSString *)lastContent unreadCount:(NSUInteger)unreadCount{
    AppDelegate* appD = (AppDelegate*)[UIApplication sharedApplication].delegate;
    _msgDB = appD._db;
    
    if ([_msgDB open]) {
        AVIMKeyedConversation* keyConversation = [conversation keyedConversation];
        NSData* keyConversationData = [NSKeyedArchiver archivedDataWithRootObject:keyConversation];
        NSString* imObjectId = [AVUser currentUser].objectId;
        [_msgDB executeUpdate:@"update currentMsg_table set conversationKeyedData = ? where objectId like ? and imObjectId like ?", keyConversationData, otherObjectId, imObjectId];
        [_msgDB executeUpdate:@"update currentMsg_table set otherIconUrl = ? where objectId like ? and imObjectId like ?", otherIcon, otherObjectId, imObjectId];
        [_msgDB executeUpdate:@"update currentMsg_table set otherUsername = ? where objectId like ? and imObjectId like ?", otherUsername, otherObjectId, imObjectId];
        [_msgDB executeUpdate:@"update currentMsg_table set lastMessageAtStr = ? where objectId like ? and imObjectId like ?", temStr, otherObjectId, imObjectId];
        [_msgDB executeUpdate:@"update currentMsg_table set lastContent = ? where objectId like ? and imObjectId like ?", lastContent, otherObjectId, imObjectId];
        
        NSString* unreadCountStr = [NSString stringWithFormat:@"%d",(int)unreadCount];
        [_msgDB executeUpdate:@"update currentMsg_table set unreadCount = ? where objectId like ? and imObjectId like ?", unreadCountStr, otherObjectId, imObjectId];
    }

}

+ (void)deleteMsgWithOtherObjectId:(NSString*)otherObjectId imObjectId:(NSString*)imObjectId{
    AppDelegate* appD = [UIApplication sharedApplication].delegate;
    _msgDB = appD._db;
    if ([_msgDB open]) {
        BOOL result = [_msgDB executeUpdate:@"delete from currentMsg_table where objectId like ? and imObjectId like ?", otherObjectId, imObjectId];
        if (result) {
            HYLog(@"删除成功");
        }else{
            HYLog(@"删除失败");
        }
    }
}






@end
