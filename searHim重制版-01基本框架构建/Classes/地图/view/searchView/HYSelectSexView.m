//
//  HYSelectSexView.m
//  searHim重制版-01基本框架构建
//
//  Created by 黄远 on 16/10/24.
//  Copyright © 2016年 黄远. All rights reserved.
//

#import "HYSelectSexView.h"

@interface HYSelectSexView ()

/** sexLable */
@property (nonatomic, weak) UILabel* sexLable;
/** sexSegement */
@property (nonatomic, weak) UISegmentedControl* sexSegement;

@end

@implementation HYSelectSexView

+ (instancetype)selectSexView{
    return [[HYSelectSexView alloc] init];
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupSexLable];
        [self setupSege];
    }
    return self;
}

- (void)setupSege{
    UISegmentedControl* sgc = [[UISegmentedControl alloc] initWithItems:@[@"男", @"女"]];
    sgc.tintColor = backBtnColor;
    sgc.selectedSegmentIndex = 0;
    [self addSubview:sgc];
    _sexSegement = sgc;
}

- (void)setupSexLable{
    UILabel* sexlb = [[UILabel alloc] init];
    sexlb.textColor = backBtnColor;
    sexlb.text = @"性别";
    sexlb.font = HYKeyFont;
//    NSString* divers = [UIDevice currentDevice].model;
//    if ([divers containsString:@"iPad"]) {
        sexlb.font = HYPadKeyFont;
//    }
    [self addSubview:sexlb];
    _sexLable = sexlb;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat sexLableX, sexLableY, sexLableW, sexLableH;
    sexLableX = HYSearHimInset * 2.0;
    sexLableY = 5;
    sexLableH = (self.height - 2*sexLableY);
    sexLableW = 80;
    self.sexLable.frame = CGRectMake(sexLableX, sexLableY, sexLableW, sexLableH);

    self.sexSegement.center = CGPointMake(CGRectGetMaxX(self.sexLable.frame)+HYSearHimInset*6.0, self.sexLable.center.y);
//    NSString* divers = [UIDevice currentDevice].model;
//    if ([divers containsString:@"iPad"]) {
        self.sexSegement.height = sexLableH;
        UIFont *font = [UIFont boldSystemFontOfSize:10.0f];
        NSDictionary *attributes = [NSDictionary dictionaryWithObject:font
                                                               forKey:NSFontAttributeName];
        [self.sexSegement setTitleTextAttributes:attributes
                                   forState:UIControlStateNormal];
//    };
//    HYLog(@"性别选择frame ---- %@", NSStringFromCGRect(self.sexSegement.frame));
}

- (NSString *)getSex{
    NSString* sex = nil;
    if (self.sexSegement.selectedSegmentIndex == 0) {
        sex = @"man";
    } else if (self.sexSegement.selectedSegmentIndex == 1) {
        sex = @"girl";
    }
    return sex;
}


@end
