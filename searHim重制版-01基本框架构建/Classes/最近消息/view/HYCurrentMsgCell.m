//
//  HYCurrentMsgCell.m
//  searHim重制版-01基本框架构建
//
//  Created by 黄远 on 16/7/14.
//  Copyright © 2016年 黄远. All rights reserved.
//

#import "HYCurrentMsgCell.h"
#import "UIImageView+WebCache.h"
#import "HYCurrentMsgItem.h"
#import "HYUserInfo.h"
#import "NSDate+HYRealDate.h"
#define HYTimeFont [UIFont systemFontOfSize:14]

@interface HYCurrentMsgCell ()
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *userNameLable;
@property (weak, nonatomic) IBOutlet UILabel *lastContentLable;
@property (weak, nonatomic) UILabel *lastMsgAtLable;
@property (weak, nonatomic) IBOutlet UIImageView *badge;

@end


@implementation HYCurrentMsgCell

- (void)setCurrentMsgItem:(HYCurrentMsgItem *)currentMsgItem{
    _currentMsgItem = currentMsgItem;

    [self.icon sd_setImageWithURL:[NSURL URLWithString:currentMsgItem.otherUserInfo.iconUrl] placeholderImage:[UIImage imageNamed:@"375250"]];
    self.userNameLable.text = currentMsgItem.otherUserInfo.username;
    if ([currentMsgItem isShowRing]) {
        self.badge.hidden = NO;
    }else{
        self.badge.hidden = YES;
    }
    self.lastMsgAtLable.text = currentMsgItem.lastMessageAtString;
    if (currentMsgItem.unReadCount > 1) {
        NSString* temStr = [NSString stringWithFormat:@"[%ld条]%@", currentMsgItem.unReadCount, currentMsgItem.lastContent];
        self.lastContentLable.text = temStr;
    } else{
        self.lastContentLable.text = currentMsgItem.lastContent;
    }
    
}

- (void)awakeFromNib{
    self.icon.contentMode = UIViewContentModeScaleAspectFill;
    self.icon.clipsToBounds = YES;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
}

+ (instancetype)currentMsgCell{
    return [[[NSBundle mainBundle] loadNibNamed:@"messageCellView" owner:nil options:nil] lastObject];
}

- (UILabel*)lastMsgAtLable{
    if (!_lastMsgAtLable) {
        UILabel *lastMsgAtLable = [[UILabel alloc] init];
        lastMsgAtLable.textColor = [UIColor grayColor];
        lastMsgAtLable.font = HYTimeFont;
        [self.contentView addSubview:lastMsgAtLable];
        _lastMsgAtLable = lastMsgAtLable;
    }
    return _lastMsgAtLable;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat lastMsgX, lastMsgY, lastMsgWid, lastMsgHei;
    CGSize size = [self.currentMsgItem.lastMessageAtString sizeWithFont:HYTimeFont];
    lastMsgWid = size.width;
    lastMsgHei = size.height;
    lastMsgY = HYSearHimInset;
    lastMsgX = self.width - HYSearHimInset - lastMsgWid;
    self.lastMsgAtLable.frame = CGRectMake(lastMsgX, lastMsgY, lastMsgWid, lastMsgHei);
}

@end
