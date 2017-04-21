//
//  HYUserMustViewController.m
//  searHim重制版-01基本框架构建
//
//  Created by 黄远 on 16/10/15.
//  Copyright © 2016年 黄远. All rights reserved.
//

#import "HYUserMustViewController.h"
#import "HYBackButton.h"

@interface HYUserMustViewController ()

@end

@implementation HYUserMustViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.webView];
    [self loadReturnBtn];
    NSURL* url = [[NSBundle mainBundle] URLForResource:@"userMustNet.html" withExtension:nil];
    NSURLRequest* urlRequest = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:urlRequest];
    self.navigationItem.title = @"注册和隐私保护须知";
}

- (void)loadReturnBtn{
    UIButton* backBtn = [[UIButton alloc] init];
    [backBtn setTitle:@"返回" forState:UIControlStateNormal];
    [backBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backBtn setTitleColor:backBtnColor forState:UIControlStateHighlighted];
    backBtn.frame = CGRectMake(0, 0, 30, 20);
    backBtn.titleLabel.font = HYValueFont;
    [backBtn addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
}

- (UIWebView*)webView{
    if (!_webView) {
        CGFloat x,y, w, h;
        x = 0;
        y = 0;
        w = [UIScreen mainScreen].bounds.size.width;
        h = [UIScreen mainScreen].bounds.size.height - 64;
        CGRect frame = CGRectMake(x, y, w, h);
        _webView = [[UIWebView alloc] initWithFrame:frame];
    }
    
    return _webView;
}

- (void)close{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
