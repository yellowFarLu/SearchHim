//
//  HYSearchResultCell.m
//  searHim重制版-01基本框架构建
//
//  Created by 黄远 on 16/10/24.
//  Copyright © 2016年 黄远. All rights reserved.
//

#import "HYSearchResultCell.h"
#import "HYSearchResult.h"
#import "UIImageView+WebCache.h"

@interface HYSearchResultCell ()

@property (nonatomic, weak) UILabel* userName;
@property (nonatomic, weak) UIImageView* icon;
@property (nonatomic, weak) UIView* diver;
@end

@implementation HYSearchResultCell

- (void)setSearchResult:(HYSearchResult *)searchResult{
    UIImage* paceIma = [UIImage imageNamed:@"375250"];
    _searchResult = searchResult;
    self.userName.text = searchResult.username;
    [self.icon sd_setImageWithURL:[NSURL URLWithString:searchResult.iconUrl] placeholderImage:paceIma];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //设置分割线
        UIView* MyView = [[UIView alloc] init];
        MyView.backgroundColor = backBtnColor;
        MyView.alpha = 0.2;
        [self addSubview:MyView];
        _diver = MyView;
        
        UILabel* userName = [[UILabel alloc] init];
        userName.textColor = backBtnColor;
        userName.font = HYKeyFont;
        [self addSubview:userName];
        _userName = userName;
        
        UIImageView* icon = [[UIImageView alloc] init];
        [self addSubview:icon];
        _icon = icon;
    }
    
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    //计算分割线
    CGFloat hei,wid,x,y;
    hei = 1;
    x = HYSearHimInset;
    wid = (self.frame.size.width - 2*HYSearHimInset);
    y = self.frame.size.height - 1;
    self.diver.frame = CGRectMake(x, y, wid, hei);
    
    CGFloat iconX, iconY, iconW, iconH;
    iconX = HYSearHimInset;
    iconY = HYSearHimInset;
    iconH = (self.height - 2*iconY);
    iconW = iconH;
    _icon.frame = CGRectMake(iconX, iconY, iconW, iconH);
    
    CGFloat userNameX, userNameY, userNameW, userNameH;
    userNameX = CGRectGetMaxX(_icon.frame) + HYSearHimInset;
    userNameY = iconY;
    userNameH = iconH;
    userNameW = (self.width - userNameX);
    _userName.frame = CGRectMake(userNameX, userNameY, userNameW, userNameH);
}






@end
