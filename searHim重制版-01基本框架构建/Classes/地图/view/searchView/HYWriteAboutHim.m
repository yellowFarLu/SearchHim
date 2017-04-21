//
//  HYWriteAboutHim.m
//  searHim重制版-01基本框架构建
//
//  Created by 黄远 on 16/10/24.
//  Copyright © 2016年 黄远. All rights reserved.
//

#import "HYWriteAboutHim.h"
#import "HYAboutHimTextField.h"
#define maxChatCount 18

@interface HYWriteAboutHim () 

/** Ta的特征 */
@property (nonatomic, weak) UILabel* aboutHim;

/** 3个输入框 */
@property (nonatomic, weak) HYAboutHimTextField* oneTf;
@property (nonatomic, weak) HYAboutHimTextField* twoTf;
@property (nonatomic, weak) HYAboutHimTextField* threeTf;

/** 保存输入框的数组 */
@property (nonatomic, strong) NSMutableArray* arr;

@end

@implementation HYWriteAboutHim

+ (instancetype)writeAboutHim{
    return [[HYWriteAboutHim alloc] init];
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        [self setupAboutHimLb];
        [self setupTf];
    }
    return self;
}

- (void)setupTf{
    _arr = [NSMutableArray array];
    HYAboutHimTextField* oneTf = [HYAboutHimTextField AboutHimTextField];
    [self addSubview:oneTf];
    _oneTf = oneTf;
    [_arr addObject:oneTf];
//    oneTf.backgroundColor = [UIColor redColor];
    
    HYAboutHimTextField* twoTf = [HYAboutHimTextField AboutHimTextField];
    [self addSubview:twoTf];
    _twoTf = twoTf;
    [_arr addObject:twoTf];
//    twoTf.backgroundColor = [UIColor yellowColor];
    
    HYAboutHimTextField* threeTf = [HYAboutHimTextField AboutHimTextField];
    [self addSubview:threeTf];
    _threeTf = threeTf;
    [_arr addObject:threeTf];
//    threeTf.backgroundColor = [UIColor blueColor];
}

- (void)setupAboutHimLb{
    UILabel* aboutHim = [[UILabel alloc] init];
    aboutHim.textColor = backBtnColor;
    aboutHim.font = HYKeyFont;
//    NSString* divers = [UIDevice currentDevice].model;
//    if ([divers containsString:@"iPad"]) {
        aboutHim.font = HYPadKeyFont;
//    }
    aboutHim.text = @"Ta的特征";
    [self addSubview:aboutHim];
    _aboutHim = aboutHim;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat aboutHimX, aboutHimY,aboutHimW, aboutHimH;
    aboutHimX = HYSearHimInset * 2.0;
    aboutHimH = 70;
//    NSString* divers = [UIDevice currentDevice].model;
//    if ([divers containsString:@"iPad"]) {
        aboutHimH = 50;
//    };
    aboutHimY = (self.height - aboutHimH) * 0.5;
    aboutHimW = 80;
    
//    if ([divers containsString:@"iPad"]) {
        aboutHimW = 55;
//    };
    self.aboutHim.frame = CGRectMake(aboutHimX, aboutHimY, aboutHimW, aboutHimH);
    
    CGFloat tfX, tfY, tfW, tfH;
    tfX = CGRectGetMaxX(self.aboutHim.frame)+HYSearHimInset*3.0;
    tfW = self.width - tfX - HYSearHimInset;
    tfH = self.height / _arr.count;
//    if ([divers containsString:@"iPad"]) {
//    }
    
    for (int i=0; i<_arr.count; i++) {
        HYAboutHimTextField* tf = [_arr objectAtIndex:i];
        tfY = i * tfH;
        tf.frame = CGRectMake(tfX, tfY, tfW, tfH);
    }
}

- (NSArray *)getAboutHim{
    NSMutableArray* mulArr = [NSMutableArray array];
    for (int i=0; i<_arr.count; i++) {
        HYAboutHimTextField* tf = [_arr objectAtIndex:i];
        [mulArr addObject:[tf getValue]];
    }
    
    return [NSArray arrayWithArray:mulArr];
}

- (void)endKeyBoard{
    [self endEditing:YES];
    [self.oneTf endEditing:YES];
    [self.twoTf endEditing:YES];
    [self.threeTf endEditing:YES];
}

@end
