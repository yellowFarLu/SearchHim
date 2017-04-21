//
//  HYReportButton.m
//  searHim重制版-01基本框架构建
//
//  Created by 黄远 on 16/9/15.
//  Copyright © 2016年 黄远. All rights reserved.
//

#import "HYReportButton.h"

@implementation HYReportButton

+ (instancetype)reportButton{
    HYReportButton* reportBtn = [[HYReportButton alloc] init];
    return reportBtn;
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setTitle:@"举报" forState:UIControlStateNormal];
        // 到时换举报的图片
        [self setImage:[UIImage imageWithOriginalName:@"reportIma.png"] forState:UIControlStateNormal];
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return self;
}


@end
