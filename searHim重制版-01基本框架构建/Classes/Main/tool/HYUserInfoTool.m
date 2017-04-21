//
//  HYUserInfoTool.m
//  searHim重制版-01基本框架构建
//
//  Created by 黄远 on 16/7/9.
//  Copyright © 2016年 黄远. All rights reserved.
//

#import "HYUserInfoTool.h"
#import <AVQuery.h>
#import "HYUserInfo.h"
#import <AVUser.h>
#import <AVStatus.h>
#import "FMDB.h"
#import "HYPinyinOC.h"

FMDatabase* _myDB;

@implementation HYUserInfoTool

+ (void)loadAllPersonInfoWithParamters:(HYParamters *)paramters success:(void (^)(HYResponseObject *))success failure:(void (^)(NSError *))failure{
    NSMutableArray* allUserInfos = [self loadUserInfoFromDBWithParamters:paramters];
    if (allUserInfos.count == 0) {
        AVQuery *userQuery = [AVQuery queryWithClassName:@"_User"];
        userQuery.limit = paramters.limit;
        [userQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error) {
                if (success) {
                    NSMutableArray* userInfos = [NSMutableArray array];
                    for (NSDictionary*dcit in objects) {
                        HYUserInfo* userInfo = [HYUserInfo initOfDict:dcit];
                        [userInfos addObject:userInfo];
                    }
                    
                    HYResponseObject* responseObject = [[HYResponseObject alloc] init];
                    responseObject.resultInfo = userInfos;
                    success(responseObject);
                    [self saveInDB:userInfos];
                }
            }else{
                if (failure) {
                    failure(error);
                }
            }
        }];
        
    }else{
        if (success) {
            HYResponseObject* responseObject = [[HYResponseObject alloc] init];
            responseObject.resultInfo = allUserInfos;
            success(responseObject);
        }

    }
}


+ (void)loadMorePersonInfoWithParamters:(HYParamters*)paramters success:(void(^)(HYResponseObject* responseObject))success failure:(void(^)(NSError* error)) failure{
    AVQuery *userQuery = [AVQuery queryWithClassName:@"_User"];
//    userQuery.limit = paramters.limit;
    userQuery.limit = MAXFLOAT;
    [userQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            if (success) {
                NSMutableArray* userInfos = [NSMutableArray array];
                for (NSDictionary*dcit in objects) {
                    HYUserInfo* userInfo = [HYUserInfo initOfDict:dcit];
                    //判断数据库里面是否有，如果有，不必添加
                    BOOL result = [self isInDB:userInfo];
                    if(result){
                        continue;
                    }
                    [userInfos addObject:userInfo];
                }
                
                HYResponseObject* responseObject = [[HYResponseObject alloc] init];
                responseObject.resultInfo = userInfos;
                success(responseObject);
                [self saveInDB:userInfos];
            }
        }else{
            if (failure) {
                failure(error);
            }
        }
    }];

}


+ (BOOL)isInDB:(HYUserInfo*)userInfo{
    AppDelegate* appD = [UIApplication sharedApplication].delegate;
    _myDB = appD._db;
    BOOL result = NO;
    if ([_myDB open]) {
        FMResultSet* resultSet = nil;
        //存储陌生人信息到数据库，首先看这个陌生人是否存在数据库里面了
        resultSet = [_myDB executeQuery:@"select * from userInfo_table where objectId like ?", userInfo.objectId];
        
        while ([resultSet next]) {
            NSString* objectId = [resultSet objectForColumnName:@"objectId"];
            if (objectId) {
                result = YES;
                break;
            }
            
        }
    }

    return result;
}

+ (NSMutableArray*)loadUserInfoFromDBWithParamters:(HYParamters*)paramters{
    AppDelegate* appD = (AppDelegate*)[UIApplication sharedApplication].delegate;
    _myDB = appD._db;
    NSMutableArray *userInfoArr = [NSMutableArray array];
    FMResultSet* resultSet = nil;
    if ([_myDB open]) {
        resultSet = [_myDB executeQuery:@"SELECT * FROM userInfo_table;"];
        while (resultSet.next) {
            NSData* userInfoData = [resultSet objectForColumnName:@"userInfoData"];
            HYUserInfo* userInfo = [NSKeyedUnarchiver unarchiveObjectWithData:userInfoData];
            [userInfoArr addObject:userInfo];
        }
    }
    
    
    return userInfoArr;
}

+ (void)saveInDB:(NSArray*)allUserInfos{
    AppDelegate* appD = (AppDelegate*)[UIApplication sharedApplication].delegate;
    _myDB = appD._db;
    HYLog(@"%@", _myDB.databasePath);
    if ([_myDB open]) {
        //  default 'unagree'  default 'unsend'
        int result = [_myDB executeUpdate:@"create table if not exists userInfo_table(objectId text primary key, userInfoData blob, username text);"];
        if (result) {
            HYLog(@"成功创表");
        } else {
            HYLog(@"创表失败");
        }
        
        for (int i=0; i<allUserInfos.count; i++) {
            HYUserInfo* userInfo = allUserInfos[i];
            //插入数据到数据库
            NSData* userInfoData = [NSKeyedArchiver archivedDataWithRootObject:userInfo];
            [_myDB executeUpdate:@"insert into userInfo_table(objectId, userInfoData, username) values(?, ?, ?);",userInfo.objectId, userInfoData, userInfo.username];
        }
    }

}

+ (void)queryUserInfoWithParamters:(HYParamters *)paramters success:(void (^)(HYResponseObject *responseObject))success failure:(void (^)(NSError *error))failure{
    //本地数据库查询，本地查询不到，网络查询
    NSMutableArray* uniqueUserInfos = [self queryUserInfoWithParamtersFromDB:paramters];
    if (uniqueUserInfos.count == 0) {
        AVQuery *userQuery = [AVQuery queryWithClassName:@"_User"];
        userQuery.limit = paramters.limit;
        [userQuery whereKey:@"username" containsString:paramters.containsString];
//        HYLog(@"%@", paramters.containsString);
        [userQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (objects.count == 0) {
                return;
            }
            if (!error) {
                if (success) {
                    NSMutableArray* uniqueUserInfos = [NSMutableArray array];
                    for (NSDictionary*dcit in objects) {
                        HYUserInfo* userInfo = [HYUserInfo initOfDict:dcit];
                        [uniqueUserInfos addObject:userInfo];
                    }
                    
                    HYResponseObject* responseObject = [[HYResponseObject alloc] init];
                    responseObject.resultInfo = uniqueUserInfos;
                    success(responseObject);
                }
            }else{
                if (failure) {
                    failure(error);
                }
            }
        }];
        
    }else{
        if (success) {
            HYResponseObject* responseObject = [[HYResponseObject alloc] init];
            responseObject.resultInfo = uniqueUserInfos;
            success(responseObject);
        }
        
    }
}

+ (NSMutableArray*)queryUserInfoWithParamtersFromDB:(HYParamters*)paramters{
    NSMutableArray* uniqueUserInfos = [NSMutableArray array];
    AppDelegate* appD = (AppDelegate*)[UIApplication sharedApplication].delegate;
    _myDB = appD._db;
    FMResultSet* resultSet = nil;
    if ([_myDB open]) {
        NSString* lowConStr = [[paramters containsString] lowercaseString];
        resultSet = [_myDB executeQuery:@"SELECT * FROM userInfo_table;"];
        while (resultSet.next) {
            NSString* username = [resultSet objectForColumnName:@"username"];
            username = [username lowercaseString];
            if ([username containsString:lowConStr]) {
                NSData* userInfoData = [resultSet objectForColumnName:@"userInfoData"];
                HYUserInfo* userInfo = [NSKeyedUnarchiver unarchiveObjectWithData:userInfoData];
                [uniqueUserInfos addObject:userInfo];
            }
        }
    }

    
    return uniqueUserInfos;
}

/////////////////////////////////存储朋友相关/////////////////////////////////////


/*
 * friendInfos(objectId text, unserInfoData blob)
 */
//先从数据库里面加载，数据库没有好友信息，再从网络加载
+ (void)loadAllFriendInfoWithParamters:(HYParamters *)paramters success:(void (^)(HYResponseObject *))success failure:(void (^)(NSError *))failure{
    NSMutableArray* friendInfo = [self loadAllFriendInfoFromDBWithParamters:paramters];
    if (friendInfo.count == 0) {
        AVQuery *query= [AVUser followerQuery:[AVUser currentUser].objectId];
        [query includeKey:@"follower"];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error) {
                if (success) {
                    NSMutableArray* userInfos = [NSMutableArray array];
                    for (NSDictionary*dcit in objects) {
                        HYUserInfo* userInfo = [HYUserInfo initOfDict:dcit];
                        [userInfos addObject:userInfo];
                    }
                    
                    HYResponseObject* responseObject = [[HYResponseObject alloc] init];
                    responseObject.resultInfo = userInfos;
                    success(responseObject);
                    //存在数据库
                    [self saveFriendsInDB:userInfos WithParamter:paramters];
                }
            }else{
                if (failure) {
                    failure(error);
                }
            }
            
        }];

    } else {
        if (success) {
            HYResponseObject* responseObject = [[HYResponseObject alloc] init];
            responseObject.resultInfo = friendInfo;
            success(responseObject);
        }

    }
    
}

//从网络加载好友信息
+ (void)loadFriendInfoFromInternetWithParamters:(HYParamters *)paramters success:(void (^)(HYResponseObject *))success failure:(void (^)(NSError *))failure{
    [[AVUser currentUser] getFollowees:^(NSArray *objects, NSError *error) {
        if (!error) {
            if (success) {
                NSMutableArray* userInfos = [NSMutableArray array];
                for (NSDictionary*dcit in objects) {
                    HYUserInfo* userInfo = [HYUserInfo initOfDict:dcit];
                    [userInfos addObject:userInfo];
                }
                
                HYResponseObject* responseObject = [[HYResponseObject alloc] init];
                responseObject.resultInfo = userInfos;
                success(responseObject);
                //更新存在数据库
                [self reloadAllFriendInfo:userInfos];
            }
        }else{
            if (failure) {
                failure(error);
            }
        }

    }];
}

+ (void)reloadAllFriendInfo:(NSMutableArray*)userInfos{
    AppDelegate* appD = (AppDelegate*)[UIApplication sharedApplication].delegate;
    _myDB = appD._db;
    
    if ([_myDB open]) {
        BOOL result = [_myDB executeUpdate:@"delete from friend_table"];
        if (result) {
            [self saveFriendsInDB:userInfos WithParamter:nil];
        }
    }

}

/*
 * 从数据库里面加载朋友
 */
+ (NSMutableArray*)loadAllFriendInfoFromDBWithParamters:(HYParamters *)paramters{
    AppDelegate* appD = (AppDelegate*)[UIApplication sharedApplication].delegate;
    _myDB = appD._db;
    NSMutableArray *userInfoArr = [NSMutableArray array];
    FMResultSet* resultSet = nil;
    if ([_myDB open]) {
        resultSet = [_myDB executeQuery:@"SELECT * FROM friend_table where imObjId like ?;", [AVUser currentUser].objectId];
        while (resultSet.next) {
            NSData* userInfoData = [resultSet objectForColumnName:@"userInfoData"];
            HYUserInfo* userInfo = [NSKeyedUnarchiver unarchiveObjectWithData:userInfoData];
            [userInfoArr addObject:userInfo];
        }
    }
    
    
    return userInfoArr;

}



/*
 * 储存从网络请求来的所有朋友
 */
+ (void)saveFriendsInDB:(NSArray*)allUserInfos WithParamter:(HYParamters*)panremters{
    AppDelegate* appD = (AppDelegate*)[UIApplication sharedApplication].delegate;
    _myDB = appD._db;
    HYLog(@"%@", _myDB.databasePath);
    if ([_myDB open]) {
        //  default 'unagree'  default 'unsend'
        int result = [_myDB executeUpdate:@"create table if not exists friend_table(objectId text, userInfoData blob, imObjId text, primary key(objectId, imObjId));"];
        if (result) {
            HYLog(@"成功创表");
        } else {
            HYLog(@"创表失败");
        }
        
        //插入数据到数据库
        for (int i=0; i<allUserInfos.count; i++) {
            HYUserInfo* userInfo = allUserInfos[i];
            NSData* userInfoData = [NSKeyedArchiver archivedDataWithRootObject:userInfo];
            [_myDB executeUpdate:@"insert into friend_table(objectId, userInfoData, imObjId) values(?, ?, ?);",userInfo.objectId, userInfoData, [AVUser currentUser].objectId];
        }
    }

}

+ (BOOL)queryFriendIsInDB:(HYUserInfo *)userInfo WithParamter:(HYParamters *)panremters{
    AppDelegate* appD = (AppDelegate*)[UIApplication sharedApplication].delegate;
    _myDB = appD._db;
    
    BOOL result = NO;
    //先查看在数据库里面有没有这个人，没有再插入
    FMResultSet* resultSet = nil;
    if ([_myDB open]) {
        resultSet = [_myDB executeQuery:@"SELECT * FROM friend_table where imObjId like ? and objectId like ?;", [AVUser currentUser].objectId, userInfo.objectId];
        while ([resultSet next]) {
            NSString* objectId = [resultSet objectForColumnName:@"objectId"];
            if (objectId) {  //有这个人了
                result = YES;
                break;
            }
        }
    }
    
    return result;
}


/*
 * 存储一个新的朋友
 */
+ (void)saveFriendInDB:(HYUserInfo*)userInfo WithParamter:(HYParamters*)panremters{
    AppDelegate* appD = (AppDelegate*)[UIApplication sharedApplication].delegate;
    _myDB = appD._db;
    
    HYLog(@"%@", _myDB.databasePath);
    if ([_myDB open]) {
        //  default 'unagree'  default 'unsend'
        int result = [_myDB executeUpdate:@"create table if not exists friend_table(objectId text, userInfoData blob, imObjId text, primary key(objectId, imObjId));"];
        if (result) {
            HYLog(@"成功创表");
        } else {
            HYLog(@"创表失败");
        }
        
        NSData* userInfoData = [NSKeyedArchiver archivedDataWithRootObject:userInfo];
        Boolean rr = [_myDB executeUpdate:@"insert into friend_table values(?, ?, ?);",userInfo.objectId, userInfoData,  [AVUser currentUser].objectId];
        HYLog(@"%d", rr);
    }
}


+ (void)deleteFriendFromDB:(HYUserInfo *)userInfo WithParamter:(HYParamters *)panremters{
    AppDelegate* appD = (AppDelegate*)[UIApplication sharedApplication].delegate;
    _myDB = appD._db;
    
    if ([_myDB open]) {
        bool result = [_myDB executeUpdate:@"delete FROM friend_table where imObjId like ? and objectId like ?;", [AVUser currentUser].objectId, userInfo.objectId];
        if (result) {
            HYLog(@"删除成功");
        } else {
            HYLog(@"删除失败");
        }
    }
}

//查询朋友
+ (void)queryFriendUserInfoWithParamters:(HYParamters *)paramters success:(void (^)(HYResponseObject *responseObject))success failure:(void (^)(NSError *error))failure{
    //本地数据库查询，本地查询不到，网络查询
    NSMutableArray* uniqueUserInfos = [self queryFriendUserInfoWithParamtersFromDB:paramters];
    if (uniqueUserInfos.count == 0) {
        AVQuery *query= [AVUser followeeQuery:[AVUser currentUser].objectId];
        query.limit = paramters.limit;
        [query includeKey:@"followee"];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (objects.count == 0) {
                return;
            }
            if (!error) {
                if (success) {
                    NSMutableArray* uniqueUserInfos = [NSMutableArray array];
                    for (NSDictionary*dcit in objects) {
                        HYUserInfo* userInfo = [HYUserInfo initOfDict:dcit];
                        [uniqueUserInfos addObject:userInfo];
                    }
                    
                    HYResponseObject* responseObject = [[HYResponseObject alloc] init];
                    responseObject.resultInfo = uniqueUserInfos;
                    success(responseObject);
                }
            }else{
                if (failure) {
                    failure(error);
                }
            }

        }];
        
    }else{
        if (success) {
            HYResponseObject* responseObject = [[HYResponseObject alloc] init];
            responseObject.resultInfo = uniqueUserInfos;
            success(responseObject);
        }
        
    }

}

+ (NSMutableArray*)queryFriendUserInfoWithParamtersFromDB:(HYParamters*)paramters{
    NSMutableArray* uniqueUserInfos = [NSMutableArray array];
    AppDelegate* appD = [UIApplication sharedApplication].delegate;
    _myDB = appD._db;
    FMResultSet* resultSet = nil;
    if ([_myDB open]) {
        NSString* lowConStr = [[paramters containsString] lowercaseString];
        resultSet = [_myDB executeQuery:@"SELECT * FROM friend_table where imObjId like ?;", [AVUser currentUser].objectId];
        while (resultSet.next) {
            NSData* userInfoData = [resultSet objectForColumnName:@"userInfoData"];
            HYUserInfo* userInfo = [NSKeyedUnarchiver unarchiveObjectWithData:userInfoData];
            NSString* lowStr = [userInfo.username lowercaseString];
            unichar temC;
            for (int i=0; i<lowStr.length; i++) {
                temC = [lowStr characterAtIndex:i];
                BOOL result = [self isContainsStringFromChar:temC andlowConStr:lowConStr];
                if (result) {
                    [uniqueUserInfos addObject:userInfo];
                    break;
                }
            }
        }
    }
    
    
    return uniqueUserInfos;
}

+ (BOOL)isContainsStringFromChar:(unichar)c andlowConStr:(NSString*)lowConStr{
    BOOL result = NO;
    char realC = [HYPinyinOC pinyinFirstLetter:c];
    NSString* temStr = [NSString stringWithFormat:@"%c", realC];
    if ([lowConStr containsString:temStr] || [temStr containsString:lowConStr]) {
        result = YES;
    }
    return result;
}


/////////////////////////////////修改当前用户信息相关/////////////////////////////////////
+ (void)saveImInDB:(HYUserInfo*)imUserInfo ForKey:(NSString*)key WithValue:(NSString*)value{
    //取出来，修改对象的值，再存入数据库
    AppDelegate* appD = (AppDelegate*)[UIApplication sharedApplication].delegate;
    _myDB = appD._db;
    
    
    FMResultSet* resultSet = nil;
    if ([_myDB open]) {
        resultSet = [_myDB executeQuery:@"SELECT * FROM userInfo_table where objectId like ?;", imUserInfo.objectId];
        NSData* userInfoData = nil;
        while (resultSet.next) {
            userInfoData = [resultSet objectForColumnName:@"userInfoData"];
        }
        
        if (userInfoData) {
            HYUserInfo* userInfo = [NSKeyedUnarchiver unarchiveObjectWithData:userInfoData];
            [userInfo setValue:value forKey:key];
            NSData* imUesrInfoData = [NSKeyedArchiver archivedDataWithRootObject:userInfo];
            [_myDB executeUpdate:@"update userInfo_table set userInfoData = ? where objectId like ?", imUesrInfoData, imUserInfo.objectId];
        }
    }

}


#pragma mark - 拉黑系统
/** 把用户拉入黑名单的数据库表 */
+ (Boolean)putUser:(HYUserInfo *)userInfo ToBlackTableWithParamters:(HYParamters *)paramters{
    Boolean bresult = false;
    
    AppDelegate* appD = (AppDelegate*)[UIApplication sharedApplication].delegate;
    _myDB = appD._db;

    if ([_myDB open]) {
        //  default 'unagree'  default 'unsend'
        int result = [_myDB executeUpdate:@"create table if not exists black_table(objectId text, imObjId text, primary key(objectId, imObjId));"];
        if (result) {
            HYLog(@"成功创表");
        } else {
            HYLog(@"创表失败");
        }
        
        bresult = [_myDB executeUpdate:@"insert into black_table values(?, ?);",userInfo.objectId,[AVUser currentUser].objectId];
        
    }
    
    return bresult;
}

/** 查询用户是否在黑名单中 */
+ (Boolean)UserisInBlackTable:(HYUserInfo*)userInfo{
    Boolean bresult = false;
    AppDelegate* appD = (AppDelegate*)[UIApplication sharedApplication].delegate;
    _myDB = appD._db;
    
    if ([_myDB open]) {
        FMResultSet* resultSet = [_myDB executeQuery:@"select * from black_table where objectId like ? and imObjId like ?", userInfo.objectId, [AVUser currentUser].objectId];
        if (resultSet.next) {
            bresult = true;
        }
    }
    
    return bresult;
}

+ (Boolean)DeleteUserInBlackTable:(HYUserInfo *)userInfo{
    Boolean bresult = false;
    AppDelegate* appD = (AppDelegate*)[UIApplication sharedApplication].delegate;
    _myDB = appD._db;
    
    if ([_myDB open]) {
       bresult = [_myDB executeUpdate:@"delete from table black_table where objectId like ? and imObjId like ?", userInfo.objectId, [AVUser currentUser].objectId];
    }
    return bresult;
}


@end
