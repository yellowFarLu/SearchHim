//
//  HYSexAlerView.m
//  searHim重制版-01基本框架构建
//
//  Created by 黄远 on 16/7/10.
//  Copyright © 2016年 黄远. All rights reserved.
//

#import "HYSexAlerView.h"

@interface HYSexAlerView () 
@property (nonatomic, weak) UISegmentedControl* sgM;
@end

@implementation HYSexAlerView

- (instancetype)init{
    if (self = [super init]) {
        UISegmentedControl* sgM = [[UISegmentedControl alloc] init];
        [sgM insertSegmentWithTitle:@"男" atIndex:0 animated:YES];
        [sgM insertSegmentWithTitle:@"女" atIndex:1 animated:YES];
        sgM.tintColor = backBtnColor;
        [self addSubview:sgM];
        self.sgM = sgM;
        self.sgM.selectedSegmentIndex = 0;
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    //计算value
    CGFloat valueX, valueY, valueWid, valueHei;
    valueY = HYSearHimInset + 5;
    valueHei = (self.keyLable.height - 2*HYSearHimInset);
    valueX = self.keyLable.x + self.keyLable.width;
    valueWid = self.keyLable.width;
    self.sgM.frame = CGRectMake(valueX, valueY, valueWid, valueHei);
}

- (NSString*)returnCurrrentSex{
    if (self.sgM.selectedSegmentIndex == 0) {
        return @"man";
    }else{
        return @"girl";
    }
}

@end
