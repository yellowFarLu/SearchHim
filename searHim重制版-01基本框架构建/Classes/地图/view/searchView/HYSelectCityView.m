//
//  HYSelectCityView.m
//  searHim重制版-01基本框架构建
//
//  Created by 黄远 on 16/10/24.
//  Copyright © 2016年 黄远. All rights reserved.
//

#import "HYSelectCityView.h"

@interface HYSelectCityView ()

/** 城市Lable */
@property (nonatomic, weak) UILabel* cityLable;
/** 城市输入框 */
@property (nonatomic, weak) UITextField* cityTextField;

@end

@implementation HYSelectCityView

+ (instancetype)selectCityView{
    return [[HYSelectCityView alloc] init];
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupCityLb];
        [self setupTxf];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat cityLableX, cityLableY, cityLableW, cityLableH;
    cityLableX = HYSearHimInset * 2.0;
    cityLableY = 5;
    cityLableW = 80;
    cityLableH = (self.height - 2*cityLableY);
    _cityLable.frame = CGRectMake(cityLableX, cityLableY, cityLableW, cityLableH);
    
    _cityTextField.frame = CGRectMake(CGRectGetMaxX(self.cityLable.frame)+HYSearHimInset*3.0, cityLableY, 200, cityLableH);
}

- (void)setupTxf{
    UITextField* cityTextField = [[UITextField alloc] init];
    cityTextField.placeholder = @"要搜索的城市";
    cityTextField.font = HYValueFont;
    [self addSubview:cityTextField];
    _cityTextField = cityTextField;
}

- (void)setupCityLb{
    UILabel* cityLb = [[UILabel alloc] init];
    cityLb.textColor = backBtnColor;
    cityLb.text = @"城市";
    cityLb.font = HYKeyFont;
    [self addSubview:cityLb];
    _cityLable = cityLb;
}

- (NSString *)getCity{
    return self.cityTextField.text;
}

- (void)endKeyBoard{
    [self.cityTextField endEditing:YES];
}

@end
