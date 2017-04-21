//
//  HYNetTool.m
//  searHim重制版-01基本框架构建
//
//  Created by 黄远 on 16/7/24.
//  Copyright © 2016年 黄远. All rights reserved.
//

#import "HYNetTool.h"
#import "Reachability.h"

@implementation HYNetTool

+ (BOOL)isInConnectNet{
    Reachability *connenct = [Reachability reachabilityForInternetConnection];
    return  [connenct currentReachabilityStatus] != NotReachable;
}


+ (BOOL)isInWife{
    Reachability *wife = [Reachability reachabilityForLocalWiFi];
    return wife != NotReachable;
}


+ (BOOL)isInConnectNetNotWife{
    return [self isInConnectNet]&&![self isInWife];
}


@end
