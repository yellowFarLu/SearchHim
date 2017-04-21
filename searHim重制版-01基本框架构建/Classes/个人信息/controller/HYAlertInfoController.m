//
//  HYAlertInfoController.m
//  searHim重制版-01基本框架构建
//
//  Created by 黄远 on 16/7/10.
//  Copyright © 2016年 黄远. All rights reserved.
//

#import "HYAlertInfoController.h"
#import "HYTopItem.h"
#import "HYCenterItem.h"
#import "HYBottomItemFrame.h"
#import "HYCommonAlertVew.h"
#import "HYSexAlerView.h"
#import "HYAboutSearHimAlertView.h"
#import <AVUser.h>
#import "HYUserInfo.h"
#import "HYUserInfoTool.h"

@interface HYAlertInfoController () <HYAboutSearHimAlertViewDelegate>
@property (nonatomic, weak) HYCommonAlertVew* alertView;
@property (nonatomic, weak) HYSexAlerView* sexAlerView;
@property (nonatomic, weak) HYAboutSearHimAlertView* aboutSearHimAlertView;
@end

@implementation HYAlertInfoController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = HYGlobalBg;
    [self setupNav];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)keyboardDidChange:(NSNotification*)notification{
    self.navigationItem.rightBarButtonItem.enabled = self.alertView.valueTextFied.text.length > 0;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if ([_baseItem isKindOfClass:[HYTopItem class]]) {
        [self.alertView textFieldBecomeFirstRespoinder];
    } else if([_baseItem isKindOfClass:[HYCenterItem class]]){
        [self.alertView textFieldBecomeFirstRespoinder];
    } else if([_baseItem isKindOfClass:[HYBottomItemFrame class]]){
//        [self.aboutSearHimAlertView becomeFirstResponder];
    }

}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    if ([_baseItem isKindOfClass:[HYTopItem class]]) {
        [self.alertView textFieldLostFirstRespoinder];
    } else if([_baseItem isKindOfClass:[HYCenterItem class]]){
        [self.alertView textFieldLostFirstRespoinder];
    } else if([_baseItem isKindOfClass:[HYBottomItemFrame class]]){
        [self.aboutSearHimAlertView resignFirstResponder];
    }
}

- (void)setBaseItem:(HYBaseItem *)baseItem{
    _baseItem = baseItem;
    if ([_baseItem isKindOfClass:[HYTopItem class]]) {   //修改昵称、性别
        HYTopItem* topItem = (HYTopItem*)_baseItem;
        [self setupViewForTopItemWithPacehoder:topItem.username];
    } else if([_baseItem isKindOfClass:[HYCenterItem class]]){
        HYCenterItem* centerItem = (HYCenterItem*)_baseItem;
        [self setupViewForCenterItemWithKey:centerItem.key andPacehoder:centerItem.info];
    } else if([_baseItem isKindOfClass:[HYBottomItemFrame class]]){
        [self setupViewForBottomItem];
    }
}

- (void)setupViewForBottomItem{
    HYAboutSearHimAlertView* aboutSeHim = [[HYAboutSearHimAlertView alloc] init];
    [self.view addSubview:aboutSeHim];
    aboutSeHim.delegate = self;
    aboutSeHim.frame = self.view.bounds;
    HYBottomItemFrame* bif = (HYBottomItemFrame*)_baseItem;
    aboutSeHim.me = bif.bottomItem.me;
    self.aboutSearHimAlertView = aboutSeHim;
}

- (void)setupViewForCenterItemWithKey:(NSString*)key andPacehoder:(NSString*)pacehoder{
    HYCommonAlertVew* alertView = [[HYCommonAlertVew alloc] init];
    alertView.key = key;
    alertView.frame = CGRectMake(0, 0, mainScreenWid, 54);
    [self.view addSubview:alertView];
    self.alertView = alertView;
    alertView.pacehoder = pacehoder;
}

- (void)setupViewForTopItemWithPacehoder:(NSString*)pacehoder{
    //昵称
    HYCommonAlertVew* alertView = [[HYCommonAlertVew alloc] init];
    alertView.key = @"昵称";
    alertView.frame = CGRectMake(0, 0, mainScreenWid, 54);
    [self.view addSubview:alertView];
    self.alertView = alertView;
    self.alertView.pacehoder = pacehoder;
    //性别
    CGFloat sexAlerViewX, sexAlerViewY, sexAlerViewWid, sexAlerViewHei;
    sexAlerViewX = 0;
    sexAlerViewY = CGRectGetMaxY(self.alertView.frame);
    sexAlerViewWid = mainScreenWid;
    sexAlerViewHei = 54;
    HYSexAlerView* sexAlertView = [[HYSexAlerView alloc] init];
    [self.view addSubview:sexAlertView];
    sexAlertView.frame = CGRectMake(sexAlerViewX, sexAlerViewY, sexAlerViewWid, sexAlerViewHei);
    self.sexAlerView = sexAlertView;
    self.sexAlerView.key = @"性别";
}

- (void)setupNav{
    self.title = @"修改信息";
    UIButton* saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    saveBtn.titleLabel.font = HYValueFont;
    [saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [saveBtn setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
    [saveBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    saveBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [saveBtn addTarget:self action:@selector(onClickSaveBtn) forControlEvents:UIControlEventTouchUpInside];
    CGFloat saveBtnX, saveBtnY, saveBtnH, saveBtnW;
    saveBtnX = saveBtnY = 0;
    saveBtnH = HYBackBtnH;
    saveBtnW = HYBackBtnW;
    saveBtn.frame = CGRectMake(saveBtnX, saveBtnY, saveBtnW, saveBtnH);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:saveBtn];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    UIButton* backBtn = [[UIButton alloc] init];
    [backBtn setTitle:@"返回" forState:UIControlStateNormal];
    [backBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backBtn setTitleColor:backBtnColor forState:UIControlStateHighlighted];
    backBtn.frame = CGRectMake(0, 0, 30, 20);
    backBtn.titleLabel.font = HYValueFont;
    [backBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
}

- (void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
}

//点击保存并更新用户信息（服务器，本地缓存，UI, 数据库）
- (void)onClickSaveBtn{
    AppDelegate* appD = (AppDelegate*)[UIApplication sharedApplication].delegate;
    HYUserInfo* imUserInfo = appD.imUserInfo;
    
    [MBProgressHUD showMessage:@"正在保存信息,请稍后.."];
    AVUser* imUser = [AVUser currentUser];
    if ([_baseItem isKindOfClass:[HYTopItem class]]) {
        [imUser setUsername:self.alertView.valueTextFied.text];
        [imUser setObject:[self.sexAlerView returnCurrrentSex] forKey:@"sex"];
        imUserInfo.username = imUser.username;
        imUserInfo.sex = [self.sexAlerView returnCurrrentSex];
        
        [HYUserInfoTool saveImInDB:imUserInfo ForKey:@"username" WithValue:imUserInfo.username];
        [HYUserInfoTool saveImInDB:imUserInfo ForKey:@"sex" WithValue:imUserInfo.sex];
    } else if([_baseItem isKindOfClass:[HYCenterItem class]]){
        if ([self.alertView.key isEqualToString:@"城市"]) {
            [imUser setObject:[self.alertView getValue] forKey:@"city"];
            imUserInfo.city = [self.alertView getValue];
            [HYUserInfoTool saveImInDB:imUserInfo ForKey:@"city" WithValue:imUserInfo.city];
        }else if([self.alertView.key isEqualToString:@"手机"]){
            [imUser setObject:[self.alertView getValue] forKey:@"mobilePhoneNumber"];
            imUserInfo.mobilePhoneNumber = [self.alertView getValue];
            [HYUserInfoTool saveImInDB:imUserInfo ForKey:@"mobilePhoneNumber" WithValue:imUserInfo.mobilePhoneNumber];
        }else {
            [imUser setObject:[self.alertView getValue] forKey:self.alertView.key];
            imUserInfo.email = [self.alertView getValue];
            [HYUserInfoTool saveImInDB:imUserInfo ForKey:@"email" WithValue:imUserInfo.email];
        }
        
    } else if([_baseItem isKindOfClass:[HYBottomItemFrame class]]){
        if (self.aboutSearHimAlertView.me) {
            [imUser setObject:[self.aboutSearHimAlertView getValue] forKey:@"aboutMe"];
            imUserInfo.aboutMe = [self.aboutSearHimAlertView getValue];
            [HYUserInfoTool saveImInDB:imUserInfo ForKey:@"aboutMe" WithValue:imUserInfo.aboutMe];
        } else {
            [imUser setObject:[self.aboutSearHimAlertView getValue] forKey:@"searchHim"];
            imUserInfo.searchHim = [self.aboutSearHimAlertView getValue];
            [HYUserInfoTool saveImInDB:imUserInfo ForKey:@"searchHim" WithValue:imUserInfo.searchHim];
        }
    }
    
    [imUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        [MBProgressHUD hideHUD];
        if (succeeded) {
            [MBProgressHUD showSuccess:@"修改成功"];
            [self.delegate reloadForAlertInfoController:self];
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            if (error.code == 202) {
                 [MBProgressHUD showError:@"用户名已存在"];
            } else{
                [MBProgressHUD showError:@"该信息已经被使用"];
            }
        }
    }];
}

#pragma mark - HYAboutSearHimAlertViewDelegate
- (void)aboutSearHimAlertView:(HYAboutSearHimAlertView *)aboutSearHimAlertView WithTextViewLenth:(NSInteger)length{
    self.navigationItem.rightBarButtonItem.enabled = length > 0;
}






@end
