//
//  HYMarkTool.m
//  searHim重制版-01基本框架构建
//
//  Created by 黄远 on 16/7/19.
//  Copyright © 2016年 黄远. All rights reserved.


#import "HYMarkTool.h"
#import "FMDB.h"

@implementation HYMarkTool

FMDatabase* _markDB;  //值等于全局的数据库

+ (void)saveMarkInDB:(NSString*)mark WithImObjectId:(NSString*)imObjectId{
    AppDelegate* appD = (AppDelegate*)[UIApplication sharedApplication].delegate;
    _markDB = appD._db;
    if ([_markDB open]) {
        // 设定主键，防止重复的添加历史记录
        int result = [_markDB executeUpdate:@"create table if not exists mark_table(imObjectId text, mark text, primary key(imObjectId, mark));"];
        if (result) {
            HYLog(@"创建mark_table成功");
        } else {
            HYLog(@"创建mark_table失败");
        }
        
        result = [_markDB executeUpdate:@"insert into mark_table values(?, ?)", imObjectId, mark];
        if (result) {
            HYLog(@"插入成功");
        }else{
            HYLog(@"插入失败");
        }
    }
}

+ (NSMutableArray*)loadMarkFromDBWithImObjectId:(NSString*)imObjectId{
    AppDelegate* appD = (AppDelegate*)[UIApplication sharedApplication].delegate;
    _markDB = appD._db;
    NSMutableArray* markArr = [NSMutableArray array];
    if ([_markDB open]) {
        FMResultSet* resultSet = [_markDB executeQuery:@"SELECT * from mark_table where imObjectId like ?", imObjectId];
        while ([resultSet next]) {
            NSString* mark = [resultSet objectForColumnName:@"mark"];
            [markArr addObject:mark];
        }
    }
    
    return markArr;
}

+ (void)deleteAllMarkWithImObjectId:(NSString*)imObjectId{
    AppDelegate* appD = [UIApplication sharedApplication].delegate;
    _markDB = appD._db;
    if ([_markDB open]) {
       int result = [_markDB executeUpdate:@"delete from mark_table where imObjectId like ?", imObjectId];
        if (result) {
            HYLog(@"删除成功");
        } else {
            HYLog(@"删除失败");
        }
    }
}


@end
