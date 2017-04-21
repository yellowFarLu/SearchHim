//
//  HYMarkCell.m
//  searHim重制版-01基本框架构建
//
//  Created by 黄远 on 16/7/19.
//  Copyright © 2016年 黄远. All rights reserved.
//

#import "HYMarkCell.h"

@interface HYMarkCell ()
@property (nonatomic, weak) UIView* diver;
@end

@implementation HYMarkCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor clearColor];
        self.textLabel.font = HYValueFont;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat diverX, diverY, diverWid, diverHei;
    diverX = HYSearHimInset;
    diverWid = self.width - 2*HYSearHimInset;
    diverHei = 1;
    diverY = self.height - diverHei;
    self.diver.frame = CGRectMake(diverX, diverY, diverWid, diverHei);
}


- (UIView*)diver{
    if (!_diver) {
        //设置分割线
        UIView* MyView = [[UIView alloc] init];
        MyView.backgroundColor = [UIColor lightGrayColor];
        MyView.alpha = 0.7;
        [self addSubview:MyView];
        _diver = MyView;
    }
    return _diver;
}


@end
