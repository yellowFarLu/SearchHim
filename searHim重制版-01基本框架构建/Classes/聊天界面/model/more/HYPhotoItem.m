//
//  HYPhotoItem.m
//  searHim重制版-01基本框架构建
//
//  Created by 黄远 on 16/7/20.
//  Copyright © 2016年 黄远. All rights reserved.
//

#import "HYPhotoItem.h"
#import <AssetsLibrary/AssetsLibrary.h>

@implementation HYPhotoItem

+ (instancetype)initOfDict:(NSDictionary *)dict{
    HYPhotoItem* photoItem = [[HYPhotoItem alloc] init];
    photoItem.thumbnail = dict[@"thumbnail"];
    photoItem.representation = dict[@"representation"];
    photoItem.iconUrl = dict[@"iconUrl"];
    return photoItem;
}

#define strNil @"无"
// 得到拍摄照片的图片
+ (instancetype)getFirstPhoto{
    HYPhotoItem* photoItem = [[HYPhotoItem alloc] init];
    photoItem.thumbnail = [UIImage imageNamed:@"6f9"];
    photoItem.representation = nil;
    photoItem.iconUrl = strNil;
    photoItem.first = YES;
    
    return photoItem;
}


@end
