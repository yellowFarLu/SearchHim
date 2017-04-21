//
//  HYCard.m
//  searHim重制版-01基本框架构建
//
//  Created by 黄远 on 16/7/25.
//  Copyright © 2016年 黄远. All rights reserved.
//

#import "HYCard.h"

@implementation HYCard

+ (instancetype)cardXib{
    return [[[NSBundle mainBundle] loadNibNamed:@"card" owner:nil options:nil] lastObject];
}

- (void)awakeFromNib{
    self.layer.cornerRadius = HYCornerRadius;
    self.clipsToBounds = YES;
}

@end
