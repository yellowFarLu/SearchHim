//
//  HYCommonAlertVew.m
//  searHim重制版-01基本框架构建
//
//  Created by 黄远 on 16/7/10.
//  Copyright © 2016年 黄远. All rights reserved.
//

#import "HYCommonAlertVew.h"

@interface HYCommonAlertVew () <UITextFieldDelegate>
//修改的项对应的内容
@property (nonatomic, weak) UITextField* valueTextFied;
@end

@implementation HYCommonAlertVew

- (instancetype)init{
    if (self = [super init]) {
        
    }
    return self;
}


#pragma mark - textFieldDelegate

- (void)setPacehoder:(NSString *)pacehoder{
    _pacehoder = pacehoder;
    self.valueTextFied.placeholder = pacehoder;
}

- (UITextField*)valueTextFied{
    if (!_valueTextFied) {
        UITextField* valueTextFied = [[UITextField alloc] init];
        [self addSubview:valueTextFied];
        _valueTextFied = valueTextFied;
        _valueTextFied.delegate = self;
    }
    return _valueTextFied;
}

- (NSString*)getValue{
    return self.valueTextFied.text;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    //计算value
    CGFloat valueX, valueY, valueWid, valueHei;
    valueY = self.keyLable.y;
    valueHei = self.keyLable.height;
    valueX = self.keyLable.x + self.keyLable.width;
    valueWid = self.width - self.keyLable.width;
    self.valueTextFied.frame = CGRectMake(valueX, valueY, valueWid, valueHei);
}


- (void)textFieldBecomeFirstRespoinder{
    [self.valueTextFied becomeFirstResponder];
}


- (void)textFieldLostFirstRespoinder{
    [self.valueTextFied resignFirstResponder];
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}


@end
