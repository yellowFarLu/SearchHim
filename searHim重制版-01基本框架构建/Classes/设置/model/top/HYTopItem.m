//
//  HYTopItem.m
//  searHim重制版-01基本框架构建
//
//  Created by 黄远 on 16/7/10.
//  Copyright © 2016年 黄远. All rights reserved.
//

#import "HYTopItem.h"
#import "HYUserInfo.h"

@implementation HYTopItem

- (void)setSex:(NSString *)sex{
    if (!sex) {
        _sex = @"性别 : ?";
        return;
    }
    
//    if ([sex isEqualToString:@"男"]) {
//        _sex = @"man";
//    }else{
//        _sex = @"girl";
//    }
    
    _sex = sex;
}

- (instancetype)initWithUserInfo:(HYUserInfo *)userInfo{
    if (self = [super init]) {
        self.iconUrl = userInfo.iconUrl;
        self.username = userInfo.username;
        self.sex = userInfo.sex;
    }
    return self;
}


@end
