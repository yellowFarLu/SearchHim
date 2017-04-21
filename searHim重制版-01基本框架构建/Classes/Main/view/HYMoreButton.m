//
//  HYMoreButton.m
//  searHim重制版-01基本框架构建
//
//  Created by 黄远 on 16/9/15.
//  Copyright © 2016年 黄远. All rights reserved.
//

#import "HYMoreButton.h"

@implementation HYMoreButton

+ (instancetype)moreButton{
    return [[HYMoreButton alloc] init];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setImage:[UIImage imageNamed:@"top_navigation_menuicon"] forState:UIControlStateNormal];
        CGFloat moreBtnX, moreBtnY, moreBtnH, moreBtnW;
        moreBtnX = moreBtnY = 0;
        moreBtnH = HYBackBtnH;
        moreBtnW = HYBackBtnW;
        self.frame = CGRectMake(moreBtnX, moreBtnY, moreBtnW, moreBtnH);
        self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;

    }
    return self;
}

@end
