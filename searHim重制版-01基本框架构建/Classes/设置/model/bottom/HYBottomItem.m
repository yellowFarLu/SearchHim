//
//  HYBottomItem.m
//  searHim重制版-01基本框架构建
//
//  Created by 黄远 on 16/7/10.
//  Copyright © 2016年 黄远. All rights reserved.
//

#import "HYBottomItem.h"

@implementation HYBottomItem

- (void)setAboutHimOrShe:(NSString *)aboutHimOrShe{
    if (aboutHimOrShe == nil) {
        _aboutHimOrShe = @"朋友，还没写下择偶标准呢~~";
    }else{
        _aboutHimOrShe = aboutHimOrShe;
    }
}

- (void)setAboutMe:(NSString *)aboutMe{
    if (!aboutMe) {
        _aboutMe = @"介绍下自己，更容易匹配到意中人哦~~";
    } else {
        _aboutMe = aboutMe;
    }
}

@end
