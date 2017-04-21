//
//  HYNewFriendItem.h
//  searHim重制版-01基本框架构建
//
//  Created by 黄远 on 16/7/11.
//  Copyright © 2016年 黄远. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HYNewFriendItem : NSObject

//* 值等于userInfo的objectId
@property (nonatomic, copy) NSString* objId;

@property (nonatomic, copy) NSString* iconUrl;
@property (nonatomic, copy) NSString* username;

                    //received         //requested
//通过type判断是别人发来的“已同意”消息， 还是“请求”消息
@property (nonatomic, copy) NSString* type;

//验证信息
@property (nonatomic, copy) NSString* decription;

//status的id
@property (nonatomic, copy) NSString* statusObjectId;

//是否同意
@property (nonatomic, copy) NSString* isAgree;

//是否发送
@property (nonatomic, copy) NSString* isSend;

- (instancetype)initWithDict:(NSDictionary*)dict;
+ (instancetype)initOfDict:(NSDictionary*)dict;
@end
