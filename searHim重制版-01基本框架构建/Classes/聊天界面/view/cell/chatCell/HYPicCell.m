//
//  HYPicCell.m
//  searHim重制版-01基本框架构建
//
//  Created by 黄远 on 16/7/15.
//  Copyright © 2016年 黄远. All rights reserved.
//

#import "HYPicCell.h"
#import "HYPicItem.h"
#import "HYPicItemFrame.h"
#import "UIButton+WebCache.h"

@interface HYPicCell ()
@property (nonatomic, weak) UIButton* picBtn;
@property (nonatomic, weak) UIProgressView* proView;
@end

@implementation HYPicCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.iconBtn.tag = cellBtnTypeIcon;
        [self.iconBtn addTarget:self action:@selector(iconOnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)setupSkillView:(UILongPressGestureRecognizer*)longPreG{
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    [dict setValue:@(self.picItemFrame.baseChatItem.row) forKey:@"row"];
    [dict setValue:self.picItemFrame forKey:@"itemFrame"];
    //通知控制器显示skillView
    [[NSNotificationCenter defaultCenter] postNotificationName:HYWantTtitleSkillView object:nil userInfo:dict];
}

- (void)iconOnClick{
    [self.delegate cell:self didClickBtnType:(int)self.iconBtn.tag WithBtn:self.iconBtn Item:(HYPicItem*)self.picItemFrame.baseChatItem];
}

- (UIButton*)picBtn{
    if (!_picBtn) {
        UIButton* picBtn = [[UIButton alloc] init];
        [self.contentView addSubview:picBtn];
        picBtn.layer.cornerRadius = HYCornerRadius;
        picBtn.clipsToBounds = YES;
        picBtn.tag = cellBtnTypePic;
        [picBtn addTarget:self action:@selector(picOnClick) forControlEvents:UIControlEventTouchUpInside];
        _picBtn = picBtn;
    }
    return _picBtn;
}

- (void)picOnClick{
    [self.delegate cell:self didClickBtnType:(int)self.picBtn.tag WithBtn:self.picBtn Item:(HYPicItem*)self.picItemFrame.baseChatItem];
}

- (UIProgressView*)proView{
    if (!_proView) {
        UIProgressView* proView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
        proView.progressTintColor = backBtnColor;
        [self.contentView addSubview:proView];
        _proView = proView;
    }
    return _proView;
}

- (void)setPicItemFrame:(HYPicItemFrame *)picItemFrame{
    _picItemFrame = picItemFrame;
    HYPicItem* picItem = (HYPicItem*)picItemFrame.baseChatItem;
    [self.iconBtn sd_setImageWithURL:[NSURL URLWithString:picItem.iconUrl] forState:UIControlStateNormal placeholderImage:HYSystemIcon];
    self.timeLa.text = picItem.lastMessageAtString;
    [self.picBtn setImage:picItem.pic forState:UIControlStateNormal];
    [UIView animateWithDuration:1.0 animations:^{
        self.proView.hidden = NO;
        [self.proView setProgress:picItem.sliderValue];
    } completion:^(BOOL finished) {
        if (finished) {
            HYPicItem* picItem = (HYPicItem*)picItemFrame.baseChatItem;
            if (picItem.sliderValue == 1.0) {
                self.proView.hidden = YES;
            }
        }
    }];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.timeLa.frame = self.picItemFrame.timeFrame;
    self.iconBtn.frame = self.picItemFrame.iconFrame;
    self.picBtn.frame = self.picItemFrame.picFrame;
    self.proView.frame = self.picItemFrame.sliderFrame;
}

+ (HYBaseChatCell *)cellForTableView:(UITableView *)tableView andItem:(HYBaseChatItemFrame *)baseChatItemFrame{
    static NSString* picCellId = @"picCellId";
    HYPicCell* cell = [tableView dequeueReusableCellWithIdentifier:picCellId];
    if (!cell) {
        cell = [[HYPicCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:picCellId];
    }
    cell.picItemFrame = (HYPicItemFrame*)baseChatItemFrame;
    return cell;
}

@end
