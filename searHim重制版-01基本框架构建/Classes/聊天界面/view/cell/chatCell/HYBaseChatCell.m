//
//  HYBaseChatCell.m
//  searHim重制版-01基本框架构建
//
//  Created by 黄远 on 16/7/15.
//  Copyright © 2016年 黄远. All rights reserved.
//

#import "HYBaseChatCell.h"
#import "HYBaseChatItem.h"


@interface HYBaseChatCell ()

@end

@implementation HYBaseChatCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        //添加长按手势，弹出（复制，转发， 删除）白色， 背景黑色，透明度0.6；
        [self setupSkill];
    }
    return self;
}


- (void)setupSkill{
    UILongPressGestureRecognizer* longPreG = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(setupSkillView:)];
    [self addGestureRecognizer:longPreG];
}

- (void)setupSkillView:(UILongPressGestureRecognizer*)longPreG{

}


- (UIButton *)iconBtn{
    if (!_iconBtn) {
        UIButton* iconBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:iconBtn];
        _iconBtn = iconBtn;
    }
    return _iconBtn;
}

- (UILabel *)timeLa{
    if (!_timeLa) {
        UILabel* timeLa = [[UILabel alloc] init];
        timeLa.backgroundColor = [UIColor lightGrayColor];
        timeLa.textColor = [UIColor whiteColor];
        timeLa.font = HYValueFont;
        timeLa.textAlignment = NSTextAlignmentCenter;
        [self addSubview:timeLa];
        _timeLa = timeLa;
    }
    return _timeLa;
}

- (UIActivityIndicatorView*)indicatorView{
    if (!_indicatorView) {
        UIActivityIndicatorView* indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [self addSubview:indicatorView];
        _indicatorView = indicatorView;
    }
    return _indicatorView;
}

- (void)layoutSubviews{
    [super layoutSubviews];
}


//不使用父类的
+ (HYBaseChatCell *)cellForTableView:(UITableView *)tableView andItem:(HYBaseChatItemFrame *)baseChatItemFrame{
    
    return nil;
}

@end
