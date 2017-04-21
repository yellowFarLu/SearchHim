//
//  HYLoginViewController.m
//  searHim重制版-01基本框架构建
//
//  Created by 黄远 on 16/7/4.
//  Copyright © 2016年 黄远. All rights reserved.
//

#import "HYLoginViewController.h"
#import "HYLoginView.h"
#import "HYRegisterViewController.h"

@interface HYLoginViewController () <HYLoginViewDelegate>
@property (nonatomic, weak) UIImageView* iconImaV;
@end

@implementation HYLoginViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupIcon];
    [self setupLoginView];
    UIPanGestureRecognizer* panGerR = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(cancelEdi)];
    [self.view addGestureRecognizer:panGerR];
}

- (void)cancelEdi{
    [self.view endEditing:YES];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)setupLoginView{
    HYLoginView* loginView = [HYLoginView loginView];
    loginView.x = 0;
    loginView.y = CGRectGetMaxY(self.iconImaV.frame);
    loginView.width = mainScreenWid;
    loginView.height = 200;
    loginView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:loginView];
    loginView.delegate = self;
}


- (void)setupIcon{
    UIImage* iconIma = [UIImage imageNamed:@"6f9.jpg"];
    UIImageView* iconImaV = [[UIImageView alloc] initWithImage:iconIma];
    CGFloat iconImaX, iconImaY, iconImaW, iconImaH;
    iconImaH = 200;
    iconImaW = 200 * (iconIma.size.width / iconIma.size.height);
    iconImaX = (mainScreenWid - iconImaW)*0.5;
    iconImaY = (mainScreenHei - iconImaH)*0.5 - 150;
    iconImaV.frame = CGRectMake(iconImaX, iconImaY, iconImaW, iconImaH);
    [self.view addSubview:iconImaV];
    self.iconImaV = iconImaV;
    self.iconImaV.layer.shadowColor = [UIColor grayColor].CGColor;
    self.iconImaV.layer.shadowOpacity = 0.8;
    self.iconImaV.layer.shadowOffset = CGSizeMake(2, 2);
}


#pragma mark - HYLoginViewDelegate
- (void)loginViewDidClickRegisterBtn{
    HYRegisterViewController* registerVC = [[HYRegisterViewController alloc] init];
    [self.navigationController pushViewController:registerVC animated:YES];
}

@end
