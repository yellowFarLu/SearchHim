//
//  HYCollectionViewCell.m
//  searHim重制版-01基本框架构建
//
//  Created by 黄远 on 16/7/19.
//  Copyright © 2016年 黄远. All rights reserved.
//

#import "HYCollectionViewCell.h"
#import "HYMoreItem.h"

@interface HYCollectionViewCell ()

@property (nonatomic, weak) UIButton* icon;
@property (nonatomic, weak) UILabel* titleLa;

@end

@implementation HYCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {

    }
    return self;
}

-(void)setItem:(HYMoreItem *)item{
    _item = item;
    self.titleLa.text = item.title;
    [self.icon setBackgroundImage:item.icon forState:UIControlStateNormal];
    self.icon.tag = item.btnType;
}

- (UIButton*)icon{
    if (!_icon) {
        UIButton* icon = [[UIButton alloc] init];
        [icon addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:icon];
        _icon = icon;
    }
    return _icon;
}

- (void)onClick:(UIButton*)sender{
    [self.delegate didClickCell:self WithCellBtnType:(int)sender.tag];
}

- (UILabel*)titleLa{
    if (!_titleLa) {
        UILabel* titleLa = [[UILabel alloc] init];
        titleLa.textAlignment = NSTextAlignmentCenter;
        titleLa.font = HYValueFont;
        titleLa.textColor = customColor(142, 142, 142);
        [self.contentView addSubview:titleLa];
        _titleLa = titleLa;
    }
    return _titleLa;
}

- (void)layoutSubviews{
    [super layoutSubviews];
//    HYLog(@"%@", NSStringFromCGRect(self.frame));
    CGFloat titleLaX, titleLaY, titleLaWid, titleLaHei;
    titleLaHei = 20;
    titleLaY = self.height - titleLaHei;
    titleLaWid = self.width;
    titleLaX = 0;
    self.titleLa.frame = CGRectMake(titleLaX, titleLaY, titleLaWid, titleLaHei);
    
    CGFloat iconX, iconY, iconWid, iconHei;
    iconX = titleLaX;
    iconWid = titleLaWid;
    iconY = 0;
    iconHei = titleLaY;
    self.icon.frame = CGRectMake(iconX, iconY, iconWid, iconHei);
}


@end
