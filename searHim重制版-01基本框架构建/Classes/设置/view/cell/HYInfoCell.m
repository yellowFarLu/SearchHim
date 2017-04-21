//
//  HYInfoCell.m
//  searHim重制版-01基本框架构建
//
//  Created by 黄远 on 16/7/10.
//  Copyright © 2016年 黄远. All rights reserved.
//

#import "HYInfoCell.h"
#import "HYArrowItem.h"
#import "HYBottomItemFrame.h"
#import "HYBottomItem.h"
#import "HYTopItem.h"
#import "HYBottomTitleItem.h"
#import "UIButton+WebCache.h"
#import "HYCenterItem.h"
#import "HYShowLocationItem.h"

//  图片btn    名字lable，
//            性别lable，箭头
//名称lable    信息
//名称lable    箭头
//心目中他/她的信息
@interface HYInfoCell ()
@property (nonatomic, strong) UIButton* iconBtn;
@property (nonatomic, strong) UILabel* nameLable; //名字lable
@property (nonatomic, strong) UILabel* sexLable;
@property (nonatomic, strong) UIImageView* arrow; //箭头

@property (nonatomic, strong) UILabel* keyLable; //名称lable
@property (nonatomic, strong) UILabel* valueLable; //信息
@property (nonatomic, strong) UILabel* aboutHimLable; //心目中他/她的信息
@property (nonatomic, strong) UIView* diver;
@end

@implementation HYInfoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        UIButton* iconBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [iconBtn addTarget:self action:@selector(onClickIcon) forControlEvents:UIControlEventTouchUpInside];
        self.iconBtn = iconBtn;
        
        UILabel* nameLable = [[UILabel alloc] init];
        self.nameLable = nameLable;
        self.nameLable.textAlignment = NSTextAlignmentLeft;
        self.nameLable.font = HYKeyFont;
        
        UILabel* sexLable = [[UILabel alloc] init];
        self.sexLable = sexLable;
        self.sexLable.textAlignment = NSTextAlignmentLeft;
        self.sexLable.font = HYValueFont;
        self.sexLable.textColor = [UIColor lightGrayColor];
        
        UIImageView* arrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"CellArrow"]];
        self.arrow = arrow;
        
        self.keyLable = [[UILabel alloc] init];
        self.keyLable.textAlignment = NSTextAlignmentLeft;
        self.keyLable.font = HYKeyFont;
        
        self.valueLable = [[UILabel alloc] init];
        self.valueLable.textAlignment = NSTextAlignmentLeft;
        self.valueLable.font = HYValueFont;
        self.valueLable.textColor = [UIColor lightGrayColor];
        
        self.aboutHimLable = [[UILabel alloc] init];
        self.aboutHimLable.font = bottomItemFont;
        self.aboutHimLable.textColor = [UIColor lightGrayColor];
        
        UIImageView* selectedImaV = [[UIImageView alloc] init];
        selectedImaV.image = [UIImage imageNamed:@"timeline_image_placeholder"];
        self.selectedBackgroundView = selectedImaV;
        
        //设置分割线
        UIView* MyView = [[UIView alloc] init];
        MyView.backgroundColor = [UIColor grayColor];
        MyView.alpha = 0.2;
        [self.contentView addSubview:MyView];
        self.diver = MyView;
    }
    return self;
}

//点击了头像，发通知让控制器进入相册
- (void)onClickIcon{
    [[NSNotificationCenter defaultCenter] postNotificationName:HYOpenImageBook object:nil userInfo:nil];
}


- (void)setBaseItem:(HYBaseItem *)baseItem{
    _baseItem = baseItem;
    
    [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    if ([baseItem isKindOfClass:[HYArrowItem class]] && ![baseItem isOtherInfo]) {
        self.accessoryView = self.arrow;
    }
    
    if ([baseItem isTheLast]) {
        [self.diver removeFromSuperview];
    }else{
        [self.contentView addSubview:self.diver];
    }
    
    if ([baseItem isKindOfClass:[HYTopItem class]]) {
        [self.contentView addSubview:self.iconBtn];
        [self.contentView addSubview:self.nameLable];
        [self.contentView addSubview:self.sexLable];
        HYTopItem* topItem = (HYTopItem*)baseItem;
        self.nameLable.text = topItem.username;
        self.sexLable.text = topItem.sex;
        [self.iconBtn sd_setImageWithURL:[NSURL URLWithString:topItem.iconUrl] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"me"]];
        return;
    } else if([baseItem isKindOfClass:[HYBottomItemFrame class]]){
        HYBottomItemFrame* bottomItemFrame = (HYBottomItemFrame*)baseItem;
        if ([bottomItemFrame.bottomItem isMe]) {
            self.aboutHimLable.text = bottomItemFrame.bottomItem.aboutMe;
        } else {
            self.aboutHimLable.text = bottomItemFrame.bottomItem.aboutHimOrShe;
        }
        self.aboutHimLable.numberOfLines = 0;
        [self.contentView addSubview:self.aboutHimLable];
        return;
    } else if([baseItem isKindOfClass:[HYBottomTitleItem class]]){
        [self.contentView addSubview:self.keyLable];
        HYBottomTitleItem* titlI = (HYBottomTitleItem*)baseItem;
        self.keyLable.text = titlI.title;
        return;
    } else if([self.baseItem isKindOfClass:[HYCenterItem class]]){
        HYCenterItem* centerItem = (HYCenterItem*)baseItem;
        [self.contentView addSubview:self.keyLable];
        [self.contentView addSubview:self.valueLable];
        self.keyLable.text = centerItem.key;
        self.valueLable.text = centerItem.info;
        
        return;
        
    } else if([self.baseItem isKindOfClass:[HYShowLocationItem class]]){
        [self.contentView addSubview:self.keyLable];
        HYShowLocationItem* showLocationItem = (HYShowLocationItem*)self.baseItem;
        self.keyLable.text = @"是否共享您的位置";
        UISwitch* sw = [[UISwitch alloc] init];
        sw.on = showLocationItem.isShowLocation;
        [sw addTarget:self action:@selector(setIsShowLocation:) forControlEvents:UIControlEventValueChanged];
        self.accessoryView = sw;
        
        return;
    } 
}

- (void)setIsShowLocation:(UISwitch*)sw{
    // 1、改变沙盒里面的值
    [[NSUserDefaults standardUserDefaults] setBool:sw.on forKey:@"isShowLocation"];
    NSString* onStr = sw.on == true ? @"true" : @"false";
    NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:onStr, @"isShowLocation",nil];
    // 2、通知地图模块，重新从沙盒里面加载
    [[NSNotificationCenter defaultCenter] postNotificationName:@"改变是否展示我的位置" object:self userInfo:dict];
    if (sw.on) {
        [MBProgressHUD showSuccess:@"在地图上展示我的信息"];
    } else {
        [MBProgressHUD showSuccess:@"在地图上隐藏我的信息"];
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    if ([self.baseItem isKindOfClass:[HYTopItem class]]) {
        [self setupTop];
        
    }else if([self.baseItem isKindOfClass:[HYBottomItemFrame class]]){
        [self setupBottomAboutHim];
        
    }else if([self.baseItem isKindOfClass:[HYBottomTitleItem class]]){
        [self setupBottomTitle];
        
    }else if([self.baseItem isKindOfClass:[HYCenterItem class]]){
        [self setupCenter];
    } else if( [self.baseItem isKindOfClass:[HYShowLocationItem class]]){
        [self setupShowLocation];
    }
    self.selectedBackgroundView.frame = self.bounds;
    
    //计算分割线
    CGFloat hei,wid,x,y;
    hei = 1;
    x = HYSearHimInset;
    wid = (self.frame.size.width - 2*HYSearHimInset);
    y = self.contentView.frame.size.height - 1;
    self.diver.frame = CGRectMake(x, y, wid, hei);
}

- (void)setupShowLocation{
    CGFloat keyX, keyY, keyWid, keyHei;
    keyY = 0;
    keyX = HYSearHimInset;
    keyWid = 2*HYIconWid + 4*HYSearHimInset;
    keyHei = self.height;
    self.keyLable.frame = CGRectMake(keyX, keyY, keyWid, keyHei);
}

- (void)setupTop{
    CGFloat iconX, iconY, iconWid, iconHei;
    iconY = iconX = HYSearHimInset;
    iconWid = iconHei = 50;
    self.iconBtn.frame = CGRectMake(iconX, iconY, iconWid, iconHei);
    
    CGFloat nameX, nameY, nameWid, nameHei;
    nameX = 2 * HYSearHimInset + CGRectGetMaxX(self.iconBtn.frame);
    nameY = iconY;
    nameWid = self.frame.size.width - iconWid - 3*HYSearHimInset;
    nameHei = 20;
    self.nameLable.frame = CGRectMake(nameX, nameY, nameWid, nameHei);
    
    CGFloat sexX, sexY, sexWid, sexHei;
    sexX = nameX;
    sexY = CGRectGetMaxY(self.nameLable.frame) + 0.5*HYSearHimInset;
    sexWid = nameWid;
    sexHei = nameHei;
    self.sexLable.frame = CGRectMake(sexX, sexY, sexWid, sexHei);
}


- (void)setupBottomAboutHim{
    HYBottomItemFrame* bottomItemFrame = (HYBottomItemFrame*)self.baseItem;
    self.aboutHimLable.frame = bottomItemFrame.itemframe;
//    NSLog(@"%@", NSStringFromCGRect(self.aboutHimLable.frame));
}

- (void)setupBottomTitle{
    CGFloat bottomTitleX, bottomTitleY, bottomTitleWid, bottomTitleHei;
    bottomTitleX = HYSearHimInset;
    bottomTitleY = 0;
    bottomTitleWid = self.width - self.accessoryView.width - HYSearHimInset;
    bottomTitleHei = self.height;
    self.keyLable.frame = CGRectMake(bottomTitleX, bottomTitleY, bottomTitleWid, bottomTitleHei);
}

- (void)setupCenter{
    CGFloat keyX, keyY, keyWid, keyHei;
    keyY = 0;
    keyX = HYSearHimInset;
    keyWid = HYIconWid + 2*HYSearHimInset;
    keyHei = self.height;
    self.keyLable.frame = CGRectMake(keyX, keyY, keyWid, keyHei);
    
    CGFloat valueX, valueY, valueWid, valueHei;
    valueY = keyY;
    valueX = CGRectGetMaxX(self.keyLable.frame);
    valueHei = keyHei;
    valueWid = self.width - keyWid;
    self.valueLable.frame = CGRectMake(valueX, valueY, valueWid, valueHei);
}









@end
