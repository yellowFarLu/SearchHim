//
//  HYSearchHimCell.m
//  searHim重制版-01基本框架构建
//
//  Created by 黄远 on 16/7/9.
//  Copyright © 2016年 黄远. All rights reserved.
//

#import "HYSearchHimCell.h"
#import "UIImageView+WebCache.h"
#import "HYUserInfo.h"

@interface HYSearchHimCell ()
@property (nonatomic, weak) UIImageView* iconImav;
@property (nonatomic, weak) UIButton* descriptionBtn;

@end

@implementation HYSearchHimCell

- (instancetype)init{
    if (self = [super init]) {
        UIImageView* imaV = [[UIImageView alloc] init];
        [self addSubview:imaV];
        self.iconImav = imaV;
        
        UIButton* descriptionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:descriptionBtn];
        self.descriptionBtn = descriptionBtn;
        [descriptionBtn setBackgroundColor:[UIColor lightGrayColor]];
        [descriptionBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        descriptionBtn.titleLabel.font = [UIFont boldSystemFontOfSize:12];
    }
    return self;
}


- (void)setUserInfo:(HYUserInfo *)userInfo{
    _userInfo = userInfo;
    [self.iconImav sd_setImageWithURL:[NSURL URLWithString:self.userInfo.iconUrl] placeholderImage:[UIImage imageNamed:@"6f9"]];
    if (userInfo.searchHim) {
        [self.descriptionBtn setTitle:userInfo.searchHim forState:UIControlStateNormal];
    } else {
        [self.descriptionBtn setTitle:@"寻找心目中的ta" forState:UIControlStateNormal];
    }
}



- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat iconX, iconY, iconWid, iconHei;
    iconX = iconY = 0;
    iconWid = self.frame.size.width;
    
    CGFloat descriptionX, descriptionY, descriptionHei, descriptionWid;
    descriptionX = iconX;
    descriptionHei = 30;
    iconHei = self.frame.size.height - descriptionHei;
    descriptionY = iconHei;
    descriptionWid = iconWid;
    
    self.iconImav.frame = CGRectMake(iconX, iconY, iconWid, iconHei);
    self.descriptionBtn.frame = CGRectMake(descriptionX, descriptionY, descriptionWid, descriptionHei);
}









@end
