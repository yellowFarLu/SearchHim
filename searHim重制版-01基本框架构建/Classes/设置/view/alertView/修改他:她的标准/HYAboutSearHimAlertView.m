//
//  HYAboutSearHimAlertView.m
//  searHim重制版-01基本框架构建
//
//  Created by 黄远 on 16/7/10.
//  Copyright © 2016年 黄远. All rights reserved.
//

#import "HYAboutSearHimAlertView.h"
#import "HYBottomAlertView.h"

@interface HYAboutSearHimAlertView () <UITextViewDelegate, HYBottomAlertViewDelegate>

@property (nonatomic, weak) UITextView* textView;
@property (nonatomic, weak) HYBottomAlertView* bottomAlertView;
@property (nonatomic, strong) UILabel* pacehoder;
@end

@implementation HYAboutSearHimAlertView

- (instancetype)init{
    if (self = [super init]) {
        UITextView* textView = [[UITextView alloc] init];
        textView.font = HYValueFont;
        [self addSubview:textView];
        textView.delegate = self;
        self.textView = textView;
        
        _pacehoder = [[UILabel alloc] init];
        _pacehoder.text = @"快写下心目中的他/她吧...";
        _pacehoder.numberOfLines = 0;
        _pacehoder.textColor = [UIColor lightGrayColor];
        _pacehoder.font = self.textView.font;
        [self addSubview:_pacehoder];
        
        HYBottomAlertView* bottomAlertView = [[HYBottomAlertView alloc] init];
        [self addSubview:bottomAlertView];
        self.bottomAlertView = bottomAlertView;
        bottomAlertView.delegate =self;
    }
    return self;
}

- (NSString*)getValue{
    return self.textView.text;
}

#pragma mark - HYBottomAlertViewDelegate
- (void)bottomAlertView:(HYBottomAlertView *)bottomAlertView didSelectedBtnTitlte:(NSString *)title{
    NSString* tem = [NSString stringWithFormat:@"%@%@", self.textView.text, title];
    self.textView.text = tem;
    self.pacehoder.hidden = !(self.textView.text.length == 0);
    if ([self.delegate respondsToSelector:@selector(aboutSearHimAlertView:WithTextViewLenth:)]) {
        [self.delegate aboutSearHimAlertView:self WithTextViewLenth:self.textView.text.length];
    }
}

- (void)textViewDidChange:(UITextView *)textView{
    self.pacehoder.hidden = self.textView.hasText;
    if ([self.delegate respondsToSelector:@selector(aboutSearHimAlertView:WithTextViewLenth:)]) {
        [self.delegate aboutSearHimAlertView:self WithTextViewLenth:self.textView.text.length];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if (self.textView.text.length <= 120) {
        return YES;
    }else{
        return NO;
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.textView.frame = self.bounds;
    
    CGFloat bottomAlertViewX, bottomAlertViewY, bottomAlertViewWid, bottomAlertViewHei;
    bottomAlertViewWid = self.width;
    bottomAlertViewHei = 150;
    bottomAlertViewX = 0;
    bottomAlertViewY = 150;
    self.bottomAlertView.frame = CGRectMake(bottomAlertViewX, bottomAlertViewY, bottomAlertViewWid, bottomAlertViewHei);
    
    CGFloat pacehoderX, pacehoderY, pacehoderWid, pacehoderHei;
    pacehoderX = 6;
    pacehoderY = 8;
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    dict[NSFontAttributeName] = self.pacehoder.font;
    CGSize size = [self.pacehoder.text boundingRectWithSize:CGSizeMake(self.frame.size.width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
    pacehoderWid = size.width;
    pacehoderHei = size.height;
    self.pacehoder.frame = CGRectMake(pacehoderX, pacehoderY, pacehoderWid, pacehoderHei);
}

- (BOOL)becomeFirstResponder{
    [self.textView becomeFirstResponder];
    return [super becomeFirstResponder];
}

- (BOOL)resignFirstResponder{
    [self.textView resignFirstResponder];
    return [super resignFirstResponder];
}

- (void)setMe:(BOOL)me{
    _me = me;
    
    if (me) {
        _pacehoder.text = @"准确的介绍自己，能提高匹配率呢！";
    } else {
        _pacehoder.text = @"快写下心目中的他/她吧...";
    }
}



@end
