//
//  HYNewFriendItem.m
//  searHim重制版-01基本框架构建
//
//  Created by 黄远 on 16/7/11.
//  Copyright © 2016年 黄远. All rights reserved.
//

#import "HYNewFriendItem.h"
#import "HYUserInfo.h"
#import <AVQuery.h>

@implementation HYNewFriendItem


//@property (nonatomic, copy) NSString* iconUrl;
//@property (nonatomic, copy) NSString* username;
//
////验证信息
//@property (nonatomic, copy) NSString* decription;
- (instancetype)initWithDict:(NSDictionary*)dict{
    if (self = [super init]) {
        self.objId = dict[@"objId"];
        self.iconUrl = dict[@"iconUrl"];
        self.username = dict[@"username"];
        self.decription = dict[@"decription"];
        self.type = dict[@"type"];
        self.statusObjectId = dict[@"statusObjectId"];
        self.isAgree = dict[@"isAgree"];
        self.isSend = dict[@"isSend"];
        
//        AppDelegate* appD = [UIApplication sharedApplication].delegate;
//        for (HYUserInfo* userInfo  in appD.allUserInfo) {
//            if ([userInfo.objectId isEqualToString:self.objId]) {
//                self.username = userInfo.username;
//                self.iconUrl = userInfo.iconUrl;
//            }
//        }
        
        if (self.objId) {
            AVQuery* query = [AVQuery queryWithClassName:@"_User"];
            [query whereKey:@"objectId" equalTo:self.objId];
            [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                if (objects.count == 0) {
                    return;
                }
                NSDictionary* userDict = [objects firstObject];
                HYUserInfo* userInfo = [HYUserInfo initOfDict:userDict];
                self.username = userInfo.username;
                self.iconUrl = userInfo.iconUrl;
            }];

        }
    }
    
    return self;
}

+ (instancetype)initOfDict:(NSDictionary*)dict{
    return [[self alloc] initWithDict:dict];
}

@end
