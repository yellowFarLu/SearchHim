//
//  HYFriendListCell.m
//  searHim重制版-01基本框架构建
//
//  Created by 黄远 on 16/7/11.
//  Copyright © 2016年 黄远. All rights reserved.
//

#import "HYFriendListCell.h"
#import "HYUserInfo.h"
#import "UIImageView+WebCache.h"
#define HYNewStatus @"来新的请求了"
#define HYUserHasSeeStatus @"用户已经查看请求了"
@interface HYFriendListCell ()
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *usernameLable;
@property (nonatomic, weak) UIButton* bdgeBtn;
@end

@implementation HYFriendListCell

- (void)awakeFromNib{
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    NSNotificationCenter* center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(getNewStatus:) name:HYNewStatus object:nil];
    [center addObserver:self selector:@selector(cancalShowBgde) name:HYUserHasSeeStatus object:nil];
}

- (void)getNewStatus:(NSNotification*)notification{
    if ([self.userInfo.username isEqualToString:@"新的朋友"]) {
        [self addBdgeBtn];
        NSMutableArray* arr = notification.userInfo[@"newStatus"];
        NSString* temStr = [NSString stringWithFormat:@"%d", (int)arr.count];
        [self.bdgeBtn setTitle:temStr forState:UIControlStateNormal];
        self.bdgeBtn.hidden = NO;
    }
}

- (void)cancalShowBgde{
    if ([self.userInfo.username isEqualToString:@"新的朋友"]) {
        [self.bdgeBtn removeFromSuperview];
        self.bdgeBtn = nil;
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat x,y,w,h;
    h = w = 20;
    x = CGRectGetMaxX(self.icon.frame) + 10.0*HYSearHimInset;
    y = (self.height - h) * 0.5;
    self.bdgeBtn.frame = CGRectMake(x, y, w, h);
}

- (void)addBdgeBtn{
    UIButton* bdgeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [bdgeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [bdgeBtn setBackgroundImage:[UIImage imageNamed:@"main_badge"] forState:UIControlStateNormal];
    bdgeBtn.titleLabel.font = [UIFont  systemFontOfSize:11];
    [self addSubview:bdgeBtn];
    bdgeBtn.hidden = YES;
    self.bdgeBtn = bdgeBtn;
}


+ (instancetype)friendListCell{
    return [[[NSBundle mainBundle] loadNibNamed:@"HYFriendListCell" owner:nil options:nil] lastObject];
}


- (void)setUserInfo:(HYUserInfo *)userInfo{
    _userInfo = userInfo;
    self.usernameLable.text = userInfo.username;
    
    if ([userInfo.username isEqualToString:@"新的朋友"]) {
        self.icon.image = [UIImage imageNamed:@"find_people"];
        [self addBdgeBtn];
    }else{
        [self.icon sd_setImageWithURL:[NSURL URLWithString:userInfo.iconUrl] placeholderImage:[UIImage imageNamed:@"me"]];
        [self.bdgeBtn removeFromSuperview];
    }
   
}



@end
