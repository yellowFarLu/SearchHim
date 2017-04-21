//
//  HYDeleteButton.m
//  searHim重制版-01基本框架构建
//
//  Created by 黄远 on 16/7/26.
//  Copyright © 2016年 黄远. All rights reserved.
//

#import "HYDeleteButton.h"
#import "UIImage+Exstension.h"

@implementation HYDeleteButton

+ (instancetype)deleteBtn{
    HYDeleteButton* deleBtn = [[HYDeleteButton alloc] init];
    return deleBtn;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setTitle:@"删除好友" forState:UIControlStateNormal];
        [self setImage:[UIImage imageWithOriginalName:@"mic_cancel"] forState:UIControlStateNormal];
        
    }
    return self;
}


@end
