//
//  HYSearchView.m
//  searHim重制版-01基本框架构建
//
//  Created by 黄远 on 16/10/24.
//  Copyright © 2016年 黄远. All rights reserved.
//

#import "HYSearchView.h"
#import "HYSelectSexView.h"
#import "HYSelectCityView.h"
#import "HYWriteAboutHim.h"

@interface HYSearchView ()
/** 顶部 */
@property (nonatomic, weak) UILabel* header;

/** 性别 */
@property (nonatomic, weak) HYSelectSexView* selectSex;

/** 城市 */
//@property (nonatomic, weak) HYSelectCityView* selectCity;

/** Ta的特征 */
@property (nonatomic, weak) HYWriteAboutHim* aboutHim;

/** 确定 */
@property (nonatomic, weak) UIButton* que;

/** 取消 */
@property (nonatomic, weak) UIButton* quto;

@end

@implementation HYSearchView

- (void)addTargetWithDelegate:(id)deleagte WithAction:(SEL)action toBtnType:(btnType)type{
    switch (type) {
//        case btnTypeQue:
//            [self.que addTarget:deleagte action:action forControlEvents:UIControlEventTouchUpInside];
//            break;
        
        case btnTypeQuto:
            [self.quto addTarget:deleagte action:action forControlEvents:UIControlEventTouchUpInside];
            
        default:
            break;
    }
}

+ (instancetype)searchView{
    return [[HYSearchView alloc] init];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setupHeader];
        [self setupSex];
//        [self setupCity];
        [self setupAboutHim];
        [self setupQue];
        [self setupQuto];
    }
    return self;
}

- (void)setupQue{
    UIButton* que = [UIButton buttonWithType:UIButtonTypeSystem];
    [que setTitle:@"确定" forState:UIControlStateNormal];
    [que setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [que setBackgroundColor:backBtnColor];
    que.titleLabel.font = HYKeyFont;
    
//    NSString* divers = [UIDevice currentDevice].model;
//    if ([divers containsString:@"iPad"]) {
        que.titleLabel.font = HYPadKeyFont;
//    };
    
    que.layer.cornerRadius = HYPadCornerRadius;
    que.layer.masksToBounds = YES;
    [self addSubview:que];
    [que addTarget:self action:@selector(getSearchParam) forControlEvents:UIControlEventTouchUpInside];
    _que = que;
}

/** 取消按钮 */
- (void)setupQuto{
    UIButton* Quto = [UIButton buttonWithType:UIButtonTypeSystem];
    [Quto setTitle:@"取消" forState:UIControlStateNormal];
    [Quto setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [Quto setBackgroundColor:backBtnColor];
    Quto.titleLabel.font = HYKeyFont;
//    NSString* divers = [UIDevice currentDevice].model;
//    if ([divers containsString:@"iPad"]) {
        Quto.titleLabel.font = HYPadKeyFont;
//    };
    
    Quto.layer.cornerRadius = HYPadCornerRadius;
    Quto.layer.masksToBounds = YES;
    [self addSubview:Quto];
    _quto = Quto;
}

- (void)setupAboutHim{
    HYWriteAboutHim* aboutHim = [HYWriteAboutHim writeAboutHim];
    [self addSubview:aboutHim];
//    aboutHim.backgroundColor = [UIColor yellowColor];
//    aboutHim.backgroundColor = [UIColor whiteColor];
    _aboutHim = aboutHim;
}

//- (void)setupCity{
//    HYSelectCityView* selectCity = [[HYSelectCityView alloc] init];
//    [self addSubview:selectCity];
//    _selectCity = selectCity;
//}

- (void)setupSex{
    HYSelectSexView* selectSex = [HYSelectSexView selectSexView];
    [self addSubview:selectSex];
    _selectSex = selectSex;
}

- (void)setupHeader{
    UILabel* header = [[UILabel alloc] init];
    header.backgroundColor = backBtnColor;
    header.textColor = [UIColor whiteColor];
    header.text = @"搜索心目中的Ta";
    header.textAlignment = NSTextAlignmentCenter;
    [self addSubview:header];
    _header = header;
}

#pragma mark - target
/** 点击确定，搜集查找信息 */
- (void)getSearchParam{
    HYSearchParam* searchParam = [[HYSearchParam alloc] init];
    // 收集信息
    searchParam.sex = [self.selectSex getSex];
//    searchParam.city = [self.selectCity getCity];
    searchParam.aboutMe = [self.aboutHim getAboutHim];
    
    // 通过代理方法传给searcBg
    [self.delegate toFindPeopleWithSearchParam:searchParam];
    [self.aboutHim endKeyBoard];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat headW, headH, headX, headY;
    headW = self.width;
    
    headH = 80;
//    if ([divers containsString:@"iPad"]) {
        headH = 40;
//    };
    headX = 0;
    headY = 0;
    self.header.frame = CGRectMake(headX, headY, headW, headH);
    
    CGFloat sexX, sexY, sexW, sexH;
    sexX = headX;
    sexY = CGRectGetMaxY(self.header.frame);
    sexW = headW;
    sexH = 70;
//    if ([divers containsString:@"iPad"]) {
        sexH = 30;
//    };
    self.selectSex.frame = CGRectMake(sexX, sexY, sexW, sexH);
    
//    CGFloat cityX, cityY, cityW, cityH;
//    cityX = sexX;
//    cityY = CGRectGetMaxY(self.selectSex.frame);
//    cityH = sexH;
//    cityW = sexW;
//    self.selectCity.frame = CGRectMake(cityX, cityY, cityW, cityH);
    
    CGFloat aboutHimX, aboutHimY, aboutHimW, aboutHimH;
    aboutHimX = sexX;
    aboutHimY = CGRectGetMaxY(self.selectSex.frame);
    aboutHimW = sexW;
    aboutHimH = sexH * 2.5;
    self.aboutHim.frame = CGRectMake(aboutHimX, aboutHimY, aboutHimW, aboutHimH);
    
    CGFloat queX,queY, queW, queH, leftMargin, centerMargin;

//    queW = 80;
//    queH = 40;
    queH = 20;
    queY = (self.height - CGRectGetMaxY(self.aboutHim.frame) - queH) * 0.5 + CGRectGetMaxY(self.aboutHim.frame);
//    if ([divers containsString:@"iPad"]) {
    queW = 40;
//    };
    queX = leftMargin = HYSearHimInset * 4.0;
    centerMargin = (self.width - 2.0*leftMargin - 2.0*queW);
    
    self.que.frame = CGRectMake(queX, queY, queW, queH);
    
    self.quto.frame = CGRectMake(CGRectGetMaxX(self.que.frame)+centerMargin, queY, queW, queH);
}

- (void)endKeyBoard{
    [self.aboutHim endKeyBoard];
}

@end
