//
//  HYWebViewController.m
//  SearchHim
//
//  Created by 黄远 on 16/5/10.
//  Copyright © 2016年 黄远. All rights reserved.
//

#import "HYWebViewController.h"

@implementation HYWebViewController

#pragma mark - 懒加载
- (UIWebView*)webView{
    if (!_webView) {
        CGFloat x,y, w, h;
        x = 0;
        y = 64;
        w = [UIScreen mainScreen].bounds.size.width;
        h = [UIScreen mainScreen].bounds.size.height - 64;
        CGRect frame = CGRectMake(x, y, w, h);
        _webView = [[UIWebView alloc] initWithFrame:frame];
    }

    return _webView;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    self.view = self.webView;
    [self loadReturnBtn];
    NSURL* url = [[NSBundle mainBundle] URLForResource:@"bjdc_howto.html" withExtension:nil];
    NSURLRequest* urlRequest = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:urlRequest];
    self.navigationItem.title = @"关于searchHim";
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

- (void)close{
    [self.navigationController popViewControllerAnimated:YES];
}




@end
