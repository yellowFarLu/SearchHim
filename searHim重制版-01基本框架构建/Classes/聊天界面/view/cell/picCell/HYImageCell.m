//
//  HYImageCell.m
//  searHim重制版-01基本框架构建
//
//  Created by 黄远 on 16/7/20.
//  Copyright © 2016年 黄远. All rights reserved.
//

#import "HYImageCell.h"
#import "HYPhotoItem.h"

@interface HYImageCell ()
//展示图片
@property (nonatomic, weak) UIImageView* picView;
//展示选中
@property (nonatomic, weak) UIView* pan;
@property (nonatomic, weak) UIImageView* hasGet;
@end

@implementation HYImageCell


- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}

- (UIImageView*)picView{
    if (!_picView) {
        UIImageView* picView = [[UIImageView alloc] init];
        [self.contentView addSubview:picView];
        _picView = picView;
    }
    return _picView;
}

- (UIImageView*)hasGet{
    if (!_hasGet) {
        UIImageView* hasGet = [[UIImageView alloc] init];
        hasGet.backgroundColor = [UIColor clearColor];
        hasGet.image = [UIImage imageNamed:@"check"];
//        hasGet.hidden = YES;
        [self.contentView addSubview:hasGet];
        _hasGet = hasGet;
    }
    return _hasGet;
}

- (UIView*)pan{
    if (!_pan) {
        UIView* pan = [[UIView alloc] init];
        pan.backgroundColor = [UIColor blackColor];
        pan.alpha = 0.2;
//        pan.hidden = YES;
        [self.contentView addSubview:pan];
        _pan = pan;
    }
    return _pan;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.picView.frame = self.bounds;
    self.pan.frame = self.picView.frame;
    CGFloat hasGetX, hasGetY, hasGetWid, hasGetHei;
    hasGetWid = hasGetHei = 30;
    hasGetY = 0;
    hasGetX = self.width - hasGetWid;
    self.hasGet.frame = CGRectMake(hasGetX, hasGetY, hasGetWid, hasGetHei);
}

- (void)setPhotoItem:(HYPhotoItem *)photoItem{
    _photoItem = photoItem;
    
    self.picView.image = photoItem.thumbnail;
    if ([photoItem isSelected]) {
        self.pan.hidden = NO;
        self.hasGet.hidden = NO;
    }else{
        self.pan.hidden = YES;
        self.hasGet.hidden = YES;
    }
}

@end
