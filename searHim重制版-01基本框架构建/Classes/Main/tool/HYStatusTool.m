//
//  HYStatusTool.m
//  searHim重制版-01基本框架构建
//
//  Created by 黄远 on 16/7/12.
//  Copyright © 2016年 黄远. All rights reserved.
//

#import "HYStatusTool.h"
#import <AVStatus.h>
#import "FMDB.h"
#import "HYNewFriendItem.h"
#import <AVUser.h>
#import "HYUserInfo.h"

FMDatabase* _db;

@implementation HYStatusTool


+ (void)loadStatusWithParamters:(HYStatusParamters *)paramters success:(void (^)(HYStatusResultParamters *))success failure:(void (^)(NSError *))failure{
    AVStatusQuery* stattusQuery = [AVStatus inboxQuery:kAVStatusTypePrivateMessage];
    [stattusQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (success) {
            HYStatusResultParamters* resultPa = [[HYStatusResultParamters alloc] init];
            resultPa.allStatus = [NSMutableArray array];
            
            for (AVStatus* status in objects) {
                NSMutableDictionary* mulDict= [NSMutableDictionary dictionaryWithDictionary:status.data];
                [mulDict setObject:status.objectId forKey:@"statusObjectId"];
                [mulDict setObject:@(status.messageId) forKey:@"messageId"];
                status.data = mulDict;
             // 有可能对一个人发很多次（添加好友请求）或（同意回复），应该删除出重复的(看发送者的id是否在数据库里面了)
                if ([self canSaveInDB:status]) {
                    [resultPa.allStatus addObject:status];
                }
            }
            
            //有新添加的请求，才刷新界面
            if (resultPa.allStatus.count > 0) {
                success(resultPa);
            }
        }
        
        if (error) {
            if (failure) {
                failure(error);
            }
        }
    }];
}

+ (void)deleteStatusWithParamters:(HYStatusParamters*)paramters success:(void(^)(HYStatusResultParamters* resultParamters))success failure:(void(^)(NSError* err))failure{
    NSArray* stastusArr = [self statusFromDB];
    for (AVStatus*status in stastusArr) {
        NSString* objId = status.data[@"objId"];
        if ([objId isEqualToString:paramters.userInfo.objectId]) {
            NSError* error = nil;
            NSNumber* msgId = status.data[@"messageId"];
            BOOL result = [AVStatus deleteInboxStatusForMessageId:msgId.integerValue inboxType:kAVStatusTypePrivateMessage receiver:[AVUser currentUser].objectId error:&error];
            if (result) {
                HYLog(@"服务器删除成功");
            } else {
                HYLog(@"服务器删除失败");
            }
            break;
        }
    }
    
    //删除数据库中的
    [self deleStatusFromDB:paramters];
}

+ (void)deleStatusFromDB:(HYStatusParamters*)paramters{
    AppDelegate* appD = (AppDelegate*)[UIApplication sharedApplication].delegate;
    _db = appD._db;
    if ([_db open]) {
        BOOL result = [_db executeUpdate:@"delete from status_table where imObjId like ? and otherObjId like ?", [AVUser currentUser].objectId, paramters.userInfo.objectId];
        if (result) {
            HYLog(@"数据库删除成功");
        } else {
            HYLog(@"数据库删除失败");
        }
    }
}

+ (BOOL)canSaveInDB:(AVStatus*) status{
    AppDelegate* appD = (AppDelegate*)[UIApplication sharedApplication].delegate;
    _db = appD._db;
    BOOL result = NO;
    if ([_db open]) {
        [_db executeUpdate:@"create table if not exists status_table(statusObjectId integer, statusData blob, isAgree text, isSend text, imObjId text, otherObjId text, primary key(imObjId, otherObjId));"];
        
        //存储陌生人信息到数据库，首先看这个陌生人是否存在数据库里面了
        NSDictionary* statusDict = status.data;
        NSInteger statusObjectId = (NSInteger)status.objectId;
        NSData* statusData = [NSKeyedArchiver archivedDataWithRootObject:statusDict];
        NSString* otherObjId = status.data[@"objId"];
        return result =  [_db executeUpdate:@"insert into status_table(statusObjectId, statusData, isAgree, isSend, imObjId, otherObjId) values(?, ?, ?, ?, ?, ?);", statusObjectId, statusData, @"unagree", @"unsend", [AVUser currentUser].objectId, otherObjId];
    }
    
    return result;
}

+ (NSUInteger)sinceIdFromDB{
    AppDelegate* appD = [UIApplication sharedApplication].delegate;
    _db = appD._db;
    NSUInteger sinceId = 0;
    if ([_db open]) {
        FMResultSet* resultSet = nil;
        resultSet = [_db executeQuery:@"SELECT max(statusObjectId) FROM status_table where username like ?;",[AVUser currentUser].username];
        while (resultSet.next) {
            //            sinceId = (NSUInteger)[resultSet objectForColumnName:@"statusObjectId"];
            sinceId = [resultSet unsignedLongLongIntForColumnIndex:0];
        }
        
    }
    
    return sinceId;
}

+ (NSArray*)statusFromDB{
    //根据数据库中isAgree, isSend字段判断用户是否已同意，已发送，并将值写入dict中，方便cell判断
    AppDelegate* appD = [UIApplication sharedApplication].delegate;
    _db = appD._db;
    
    NSMutableArray *statusArr = [NSMutableArray array];
    FMResultSet* resultSet = nil;
    if ([_db open]) {
        resultSet = [_db executeQuery:@"SELECT * FROM status_table where imObjId like ? ORDER BY statusObjectId DESC;", [AVUser currentUser].objectId];
        
        while (resultSet.next) {
            NSData* statusData = [resultSet objectForColumnName:@"statusData"];
            NSDictionary* preStatusDict = [NSKeyedUnarchiver unarchiveObjectWithData:statusData];
            NSMutableDictionary* statusDict = [NSMutableDictionary dictionaryWithDictionary:preStatusDict];
            NSString* isAgree = [resultSet objectForColumnName:@"isAgree"];
            if ([isAgree isEqualToString:@"unagree"]) {
                [statusDict setValue:@"unagree" forKey:@"isAgree"];
            }else{
                [statusDict setValue:@"agree" forKey:@"isAgree"];
            }
            
            NSString* isSend = [resultSet objectForColumnName:@"isSend"];
            if ([isSend isEqualToString:@"unsend"]) {
                [statusDict setValue:@"unsend" forKey:@"isSend"];
            }else{
                [statusDict setValue:@"send" forKey:@"isSend"];
            }
            
            //包装成AVStatus
            AVStatus* status = [[AVStatus alloc] init];
            status.data = statusDict;
            [statusArr addObject:status];
        }
    }
    
    
    return statusArr;
}

+ (void)saveInDB:(NSArray*)allStatus{
    //看数据库里面有没有这个用户发过的，如果有了，就不再插入
    AppDelegate* appD = [UIApplication sharedApplication].delegate;
    _db = appD._db;
    //    HYLog(@"%@", DBPath);
    if ([_db open]) {
        //  default 'unagree'  default 'unsend'
        int result = [_db executeUpdate:@"create table if not exists status_table(statusObjectId integer, statusData blob, isAgree text, isSend text, imObjId text, otherObjId text primary key(imObjId, otherObjId));"];
        if (result) {
            HYLog(@"成功创表status_table");
        } else {
            HYLog(@"创表失败");
        }
    
        //插入数据到数据库
        for (int i=0; i<allStatus.count; i++) {
            AVStatus* status = allStatus[i];
            if (![self canSaveInDB:status]) {  //不在数据库里面，就会插进去了
                
            }
           
        }
    }
    
}

+ (void)saveWithItem:(HYNewFriendItem*)newFriendItem{
    AppDelegate* appD = [UIApplication sharedApplication].delegate;
    _db = appD._db;
    if ([_db open]) {
//        BOOL result = [_db executeUpdate:@"update status_table set isAgree = ? where otherObjId like ? and imObjId like ?;", @"agree", newFriendItem.objId, [AVUser currentUser].objectId];
         BOOL result = [_db executeUpdate:@"update status_table set isAgree = ?", @"agree"];
        HYLog(@"%d", result);
    }
}

@end
