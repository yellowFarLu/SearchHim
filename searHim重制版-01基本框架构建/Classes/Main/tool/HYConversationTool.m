//
//  HYConversationTool.m
//  searHim重制版-01基本框架构建
//
//  Created by 黄远 on 16/7/15.
//  Copyright © 2016年 黄远. All rights reserved.
//  

#import "HYConversationTool.h"
#import <AVIMConversation.h>
#import "FMDB.h"
#import "HYResponseObject.h"
#import <AVIMClient.h>
#import <AVUser.h>
#import <AVIMConversationQuery.h>
#import "HYCurrentClient.h"

FMDatabase* _conversationDB;  //值等于全局的数据库,只是用指针指着同一个数据库对象，方便使用


@implementation HYConversationTool

//返回otherObjectId对应的conversation
+ (void)queryConversationWithOtherObjId:(NSString*)otherObjectId success:(void(^)(HYResponseObject* responseObj))succeeded failure:(void(^)(NSError* error))failure{
    AVIMConversation* conversation = [self queryFromDBWithOtherObjId:otherObjectId];
    
    if (!conversation) {
        if (failure) {
            NSError* error = [[NSError alloc] initWithDomain:@"没有该会话" code:1000 userInfo:nil];
            failure(error);
        }
        
    }else{
        if (succeeded) {
            HYResponseObject* responseObject = [[HYResponseObject alloc] init];
            responseObject.conversation = conversation;
            succeeded(responseObject);
        }
    }
}

//create table if not exists currentMsg_table(objectId text, conversationKeyedData blob, otherIconUrl text, otherUsername text, lastMessageAt text,   lastContent text, imObjectId text);

+ (AVIMConversation*)queryFromDBWithOtherObjId:(NSString*)otherObjectId{
    AppDelegate* appD = [UIApplication sharedApplication].delegate;
    _conversationDB = appD._db;
    AVIMConversation* conversation = nil;
    if ([_conversationDB open]) {
       FMResultSet* resultSet = [_conversationDB executeQuery:@"select * from currentMsg_table where objectId like ? and imObjectId like ?", otherObjectId, [AVUser currentUser].objectId];
        HYCurrentClient* currentClient = [HYCurrentClient shareCurrentClient];
        while ([resultSet next]) {
            NSData* conversationKeyedData = [resultSet objectForColumnName:@"conversationKeyedData"];
            AVIMKeyedConversation* keyConversation = [NSKeyedUnarchiver unarchiveObjectWithData:conversationKeyedData];
            conversation = [currentClient.imClient conversationWithKeyedConversation:keyConversation];
        }
    }

    return conversation;
}


@end
