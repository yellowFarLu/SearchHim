//
//  HYUserInfo.m
//  searHim重制版-01基本框架构建
//
//  Created by 黄远 on 16/7/9.
//  Copyright © 2016年 黄远. All rights reserved.
//

#import "HYUserInfo.h"
#import <AVUser.h>
@implementation HYUserInfo

- (instancetype)initWithDict:(NSDictionary*)dict{
    if (self = [super init]) {
        self.username = dict[@"username"];
        self.sex = dict[@"sex"];
        self.mobilePhoneNumber = dict[@"mobilePhoneNumber"];
        self.email = dict[@"email"];
        self.city = dict[@"city"];
        self.iconUrl = dict[@"iconUrl"];
        self.searchHim = dict[@"searchHim"];
        self.iconWid = dict[@"iconWid"];
        self.iconHei = dict[@"iconHei"];
        self.objectId = dict[@"objectId"];
        self.aboutMe = dict[@"aboutMe"];
    }
    return self;
}



+ (instancetype)initOfDict:(NSDictionary*)dict{
    return [[self alloc] initWithDict:dict];
}


+ (instancetype)initOfUser:(AVUser *)user{
    HYUserInfo* userInfo = [[HYUserInfo alloc] init];
    userInfo.username = user.username;
    userInfo.sex = [user objectForKey:@"sex"];
    userInfo.mobilePhoneNumber = [user objectForKey:@"mobilePhoneNumber"];
    userInfo.email = [user objectForKey:@"email"];
    userInfo.city = [user objectForKey:@"city"];
    userInfo.iconUrl = [user objectForKey:@"iconUrl"];
    userInfo.searchHim = [user objectForKey:@"searchHim"];
    userInfo.iconWid = [user objectForKey:@"iconWid"];
    userInfo.iconHei = [user objectForKey:@"iconHei"];
    userInfo.objectId = [user objectForKey:@"objectId"];
    userInfo.aboutMe = [user objectForKey:@"aboutMe"];
    
    return userInfo;
}


- (void)encodeWithCoder:(NSCoder *)enoder{
    [enoder encodeObject:self.username forKey:@"username"];
    [enoder encodeObject:self.sex forKey:@"sex"];
    [enoder encodeObject:self.mobilePhoneNumber forKey:@"mobilePhoneNumber"];
    [enoder encodeObject:self.email forKey:@"email"];
    [enoder encodeObject:self.city forKey:@"city"];
    [enoder encodeObject:self.iconUrl forKey:@"iconUrl"];
    [enoder encodeObject:self.searchHim forKey:@"searchHim"];
    [enoder encodeObject:self.iconWid forKey:@"iconWid"];
    [enoder encodeObject:self.iconHei forKey:@"iconHei"];
    [enoder encodeObject:self.objectId forKey:@"objectId"];
}

- (instancetype)initWithCoder:(NSCoder *)decoder{
    if (self = [super init]) {
        self.username = [decoder decodeObjectForKey:@"username"];
        self.sex = [decoder decodeObjectForKey:@"sex"];
        self.mobilePhoneNumber = [decoder decodeObjectForKey:@"mobilePhoneNumber"];
        self.email = [decoder decodeObjectForKey:@"email"];
        self.city = [decoder decodeObjectForKey:@"city"];
        self.iconUrl = [decoder decodeObjectForKey:@"iconUrl"];
        self.searchHim = [decoder decodeObjectForKey:@"searchHim"];
        self.iconWid = [decoder decodeObjectForKey:@"iconWid"];
        self.iconHei = [decoder decodeObjectForKey:@"iconHei"];
        self.objectId = [decoder decodeObjectForKey:@"objectId"];
    }
    return self;
}

- (NSString*)iconUrl{
    return _iconUrl == nil ? @"nil" : _iconUrl;
}







@end
