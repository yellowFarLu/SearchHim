//
//  HYRegisterViewController.m
//  searHim重制版-01基本框架构建
//
//  Created by 黄远 on 16/7/5.
//  Copyright © 2016年 黄远. All rights reserved.
//

#import "HYRegisterViewController.h"
#import "HYRegisterView.h"
#import "HYUserMustViewController.h"

@interface HYRegisterViewController () <UIImagePickerControllerDelegate, HYRegisterViewDelegate, UINavigationControllerDelegate>
@property (nonatomic, strong) UIImagePickerController* ImagePickerController;
@property (nonatomic, weak) HYRegisterView* registerView;
@property (nonatomic, strong) HYUserMustViewController * userMuset;
@end

@implementation HYRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"注册信息";
    [self setupRegisterView];
    [self setupBackBtn];
}

- (void)setupBackBtn{
    UIButton* backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setTitle:@"返回" forState:UIControlStateNormal];
    backBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [backBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    backBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [backBtn addTarget:self action:@selector(onClickBackBtn) forControlEvents:UIControlEventTouchUpInside];
    CGFloat backBtnX, backBtnY, backBtnH, backBtnW;
    backBtnX = backBtnY = 0;
    backBtnH = 35;
    backBtnW = 80;
    backBtn.frame = CGRectMake(backBtnX, backBtnY, backBtnW, backBtnH);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
}

- (void)onClickBackBtn{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)setupRegisterView{
    HYRegisterView* registerView = [[[NSBundle mainBundle] loadNibNamed:@"registerView" owner:nil options:nil] lastObject];
    [self.view addSubview:registerView];
    registerView.frame = CGRectMake(0, 64, mainScreenWid, registerView.frame.size.height);
    self.view.backgroundColor = [UIColor whiteColor];
    self.view.userInteractionEnabled = YES;
    registerView.delegate = self;
    self.registerView = registerView;
}

#pragma mark - HYRegisterViewDelegate
- (void)openImagePicViewController{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    self.ImagePickerController = picker;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    //设置选择后的图片可被编辑
    picker.allowsEditing = YES;
    [self presentModalViewController:picker animated:YES];
}

- (void)openUserMust{
    HYUserMustViewController * userMuset = [[HYUserMustViewController alloc] init];
    [self.navigationController pushViewController:userMuset animated:YES];
    self.userMuset = userMuset;
}

#pragma mark - UIImagePickerControllerDelegate
//当选择一张图片后进入这里
-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage*image = [info objectForKey:UIImagePickerControllerOriginalImage];
    self.registerView.currentIma = image;
    [self.ImagePickerController dismissViewControllerAnimated:YES completion:^{
        
    }];
    
}




@end
