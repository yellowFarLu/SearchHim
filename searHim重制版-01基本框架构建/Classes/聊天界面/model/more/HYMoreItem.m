//
//  HYMoreItem.m
//  searHim重制版-01基本框架构建
//
//  Created by 黄远 on 16/7/19.
//  Copyright © 2016年 黄远. All rights reserved.
//

#import "HYMoreItem.h"
#import "UIImage+Exstension.h"

@implementation HYMoreItem

+ (instancetype)initWithTitle:(NSString*)title AndIconName:(NSString*)icon btnType:(int)btnType{
    HYMoreItem* item = [[HYMoreItem alloc] init];
    item.title = title;
    item.icon = [UIImage imageWithOriginalName:icon];
    item.btnType = btnType;
    return item;
}

@end
