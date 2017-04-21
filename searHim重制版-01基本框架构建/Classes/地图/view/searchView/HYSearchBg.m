//
//  HYSeaerchBg.m
//  searHim重制版-01基本框架构建
//
//  Created by 黄远 on 16/10/24.
//  Copyright © 2016年 黄远. All rights reserved.
//  检索view的背景

#import "HYSearchBg.h"
#import "HYSearchView.h"
#import "HYDiverVersionTool.h"
#define HYTopMargin HYSearHimInset * 2.0 + 64
#define HYTopToBar 64 + HYSearHimInset

@interface HYSearchBg () <HYSearchViewDelegate>

/** 提示lable：“点击左侧+号可触发” */
@property (nonatomic, weak) UILabel* tips;

/** searchView（在+号按钮的监听函数中加载） */
@property (nonatomic, weak) HYSearchView* searchView;

@end


@implementation HYSearchBg

+ (instancetype)searchBg{
    HYSearchBg* searchBg = [[HYSearchBg alloc] init];
    searchBg.frame = CGRectMake(0, 0, mainScreenWid, mainScreenHei);
    
    return searchBg;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor blackColor];
        self.alpha = 0.2;
        [self setupTips];
        [self setupSearchView];
        [self addTarget:self action:@selector(stop) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)setupSearchView{
    HYSearchView* searchView = [HYSearchView searchView];
    UIWindow* lastWindow = [[UIApplication sharedApplication].windows lastObject];
//    HYLog(@"所有的窗口 %@--- 最后一个窗口---%@", [UIApplication sharedApplication].windows, lastWindow);
    [lastWindow addSubview:searchView];
    _searchView = searchView;
    [_searchView addTargetWithDelegate:self WithAction:@selector(stop) toBtnType:btnTypeQuto];
    _searchView.delegate = self;
}


- (void)setupTips{
    UILabel* lb = [[UILabel alloc] init];
    lb.text = @"点击右侧+按钮可触发";
    lb.numberOfLines = 0;
    lb.textColor = [UIColor whiteColor];
    lb.backgroundColor = [UIColor clearColor];
//    lb.backgroundColor = [UIColor redColor];
//    NSString* divers = [UIDevice currentDevice].model;
//    if ([divers containsString:@"iPad"]) {
        lb.font = HYPadKeyFont;
//    };
    
    [self addSubview:lb];
    _tips = lb;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat topMargin, leftMargin;
    topMargin = HYTopMargin;
    leftMargin = HYSearHimInset * 4.0;
    CGFloat searchViewW, searchViewH;
    searchViewW = (self.width - 2*leftMargin);
    searchViewH = self.height * 0.27;
    if ([[HYDiverVersionTool deviceVersion] isEqualToString:@"iPhone 5S"] ||
        [[HYDiverVersionTool deviceVersion] isEqualToString:@"iPhone 5"] ||
        [[HYDiverVersionTool deviceVersion] isEqualToString:@"iPhone 5C"] ) { // 适配iPhone5S
        searchViewH = self.height * HYI5Height;
    } else if([[HYDiverVersionTool deviceVersion] isEqualToString:@"iPhone 4S"]){
        searchViewH = self.height * HYI4Height;
    };
    
    if ([HYDiverVersionTool isPad]) {
        searchViewH = self.height * HYPadHeight;
    }
    
    // 一开始searchView在屏幕下方
    self.searchView.frame = CGRectMake(leftMargin, mainScreenHei, searchViewW, searchViewH);
    
    CGFloat tipsH = 180;
    CGFloat tipsW = 27;
//    if ([divers containsString:@"iPad"]) {
        tipsW = 15;
//    };
    self.tips.frame = CGRectMake(CGRectGetMaxX(self.searchView.frame)+HYSearHimInset, 0, tipsW, tipsH);
}

/** 显示searchView */
- (void)start{
    [UIView animateWithDuration:0.4 animations:^{
        self.alpha = 0.8;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.6 animations:^{
           NSString* divers = [UIDevice currentDevice].model;
           if (![divers containsString:@"iPad"]) {
               self.searchView.y = HYTopToBar;
           } else {
               self.searchView.y = HYPadTopMargin;
           };
        }];
    }];
}

/** 关闭searchView和自己 */
- (void)stop{
    // 关闭键盘
    [self.searchView endKeyBoard];
    
    [UIView animateWithDuration:0.6 animations:^{
        self.searchView.y = mainScreenHei;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.4 animations:^{
            self.alpha = 0.2;
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    }];
}

#pragma mark - HYSearchViewDelegate
- (void)toFindPeopleWithSearchParam:(HYSearchParam*)searchParam{
    [self.delegate searchBg:self toFindPeopleWithSearchParam:searchParam];
}

- (CGRect)rectForSearchView{
    return self.searchView.frame;
}

@end
