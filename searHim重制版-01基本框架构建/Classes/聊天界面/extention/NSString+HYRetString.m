//
//  NSString+HYRetString.m
//  searHim重制版-01基本框架构建
//
//  Created by 黄远 on 16/7/23.
//  Copyright © 2016年 黄远. All rights reserved.
//

#import "NSString+HYRetString.h"

@implementation NSString (HYRetString)

+(NSString *)ret64bitString

{
    char data[64];
    for (int x=0;x<64;data[x++] = (char)('A' + (arc4random_uniform(26))));
    return [[NSString alloc] initWithBytes:data length:32 encoding:NSUTF8StringEncoding];
    
}

@end
