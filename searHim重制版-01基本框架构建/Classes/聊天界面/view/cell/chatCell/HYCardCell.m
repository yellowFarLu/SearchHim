//
//  HYCardCell.m
//  searHim重制版-01基本框架构建
//
//  Created by 黄远 on 16/7/25.
//  Copyright © 2016年 黄远. All rights reserved.
//

#import "HYCardCell.h"
#import "HYCard.h"
#import "HYCardItem.h"
#import "HYCardItemFrame.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"
#import "HYUserInfo.h"

@interface HYCardCell ()
@property (nonatomic, weak) HYCard* card;
@end

@implementation HYCardCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        HYCard* card = [HYCard cardXib];
        [self.contentView addSubview:card];
        card.tag = cellBtnTypeCard;
        self.card = card;
        UITapGestureRecognizer* tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cardOnClick)];
        [self.card addGestureRecognizer:tapGes];
        
        self.iconBtn.tag = cellBtnTypeIcon;
        [self.iconBtn addTarget:self action:@selector(iconOnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)setupSkillView:(UILongPressGestureRecognizer*)longPreG{
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    [dict setValue:@(self.cardItemFrame.baseChatItem.row) forKey:@"row"];
    [dict setValue:self.cardItemFrame forKey:@"itemFrame"];
    //通知控制器显示skillView
    [[NSNotificationCenter defaultCenter] postNotificationName:HYWantTtitleSkillView object:nil userInfo:dict];
}

- (void)iconOnClick{
    [self.delegate cell:self didClickBtnType:(int)self.iconBtn.tag WithBtn:self.iconBtn Item:(HYCardItem*)self.cardItemFrame.baseChatItem];
}

- (void)cardOnClick{
    [self.delegate cell:self didClickBtnType:(int)self.card.tag WithBtn:nil Item:(HYCardItem*)self.cardItemFrame.baseChatItem];
}

+ (HYBaseChatCell *)cellForTableView:(UITableView *)tableView andItem:(HYBaseChatItemFrame *)baseChatItemFrame{
    static NSString* cardCellId = @"cardCellId";
    HYCardCell* cell = [tableView dequeueReusableCellWithIdentifier:cardCellId];
    if (!cell) {
        cell = [[HYCardCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cardCellId];
    }
    cell.cardItemFrame = (HYCardItemFrame*)baseChatItemFrame;
    return cell;
}

- (void)setCardItemFrame:(HYCardItemFrame *)cardItemFrame{
    _cardItemFrame = cardItemFrame;
    HYCardItem* cardItem = (HYCardItem*)cardItemFrame.baseChatItem;
    self.timeLa.text = cardItem.lastMessageAtString;
    [self.iconBtn sd_setImageWithURL:[NSURL URLWithString:cardItem.iconUrl] forState:UIControlStateNormal placeholderImage:HYSystemIcon];
    
    
    if (![cardItem.userInfo.iconUrl isEqualToString:@"nil"]) {
        [self.card.iconInfo sd_setImageWithURL:[NSURL URLWithString:cardItem.userInfo.iconUrl] placeholderImage:[UIImage resizeImageWithOriginalName:@"tabbar_background"]];
    }else{
        self.card.iconInfo.image = [UIImage imageNamed:@"375250"];
    }
    
    if (cardItem.userInfo.username) {
        self.card.name.text = cardItem.userInfo.username;
    }else{
        self.card.name.text = @"未知";
    }
    
    if (cardItem.userInfo.sex) {
        self.card.sexInfo.text = cardItem.userInfo.sex;
    } else {
        self.card.sexInfo.text = @"未知";
    }
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.timeLa.frame = self.cardItemFrame.timeFrame;
    self.iconBtn.frame = self.cardItemFrame.iconFrame;
    self.card.frame = self.cardItemFrame.cardFrame;
}

@end
