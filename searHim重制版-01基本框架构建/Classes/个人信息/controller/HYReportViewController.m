//
//  HYReportViewController.m
//  searHim重制版-01基本框架构建
//
//  Created by 黄远 on 16/9/15.
//  Copyright © 2016年 黄远. All rights reserved.
//

#import "HYReportViewController.h"
#import "HYBackButton.h"
#import "HYSendButton.h"

@interface HYReportViewController () <UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation HYReportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = HYGlobalBg;
    self.textView.delegate = self;
    [self setupNav];
}

- (void)setupNav{
    self.navigationItem.title = @"填写原因";
    [self setupBackBtn];
    [self setupSendBtn];
}

- (void)setupSendBtn{
    HYSendButton* sendBtn = [HYSendButton sendButton];
    [sendBtn addTarget:self action:@selector(onClickSendBtn) forControlEvents:UIControlEventTouchUpInside];
    CGFloat sendBtnX, sendBtnY, sendBtnH, sendBtnW;
    sendBtnX = sendBtnY = 0;
    sendBtnH = HYBackBtnH;
    sendBtnW = HYBackBtnW;
    sendBtn.frame = CGRectMake(sendBtnX, sendBtnY, sendBtnW, sendBtnH);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:sendBtn];
    self.navigationItem.rightBarButtonItem.enabled = NO;
}

- (void)onClickSendBtn{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [UIView animateWithDuration:2.0 animations:^{
            [MBProgressHUD showSuccess:@"举报信息已提交，我们将尽快处理！"];
        }];
    });
}

- (void)setupBackBtn{
    HYBackButton* backBtn = [HYBackButton backButton];
    [backBtn addTarget:self action:@selector(onClickBackBtn) forControlEvents:UIControlEventTouchUpInside];
    CGFloat backBtnX, backBtnY, backBtnH, backBtnW;
    backBtnX = backBtnY = 0;
    backBtnH = HYBackBtnH;
    backBtnW = HYBackBtnW;
    backBtn.frame = CGRectMake(backBtnX, backBtnY, backBtnW, backBtnH);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
}

- (void)onClickBackBtn{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView{
    self.textView.text = @"";
}

- (void)textViewDidChange:(UITextView *)textView{
    self.navigationItem.rightBarButtonItem.enabled = (textView.text.length >0);
}

@end
