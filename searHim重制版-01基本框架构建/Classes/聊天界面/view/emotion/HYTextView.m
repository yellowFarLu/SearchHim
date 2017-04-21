//
//  HYTextView.m
//  新浪微博
//
//  Created by 黄远 on 16/6/8.
//  Copyright © 2016年 黄远. All rights reserved.
//

#import "HYTextView.h"
#define textFont [UIFont systemFontOfSize:15]

@interface HYTextView ()

@end

@implementation HYTextView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _pacehoder = [[UILabel alloc] init];
        _pacehoder.text = @"请输入文字...";
        _pacehoder.numberOfLines = 0;
        _pacehoder.textColor = [UIColor lightGrayColor];
        [self addSubview:_pacehoder];
        self.font = textFont;
        _pacehoder.font = self.font;
        self.alwaysBounceVertical = YES;
        //发布通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewTextDidChange) name:UITextViewTextDidChangeNotification object:self];
    }
    return self;
}

- (void)textViewTextDidChange{
    self.pacehoder.hidden = self.hasText;
}


- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat pacehoderX, pacehoderY, pacehoderWid, pacehoderHei;
    pacehoderX = 2;
    pacehoderY = 8;
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    dict[NSFontAttributeName] = self.pacehoder.font;
    CGSize size = [self.pacehoder.text boundingRectWithSize:CGSizeMake(self.frame.size.width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
    pacehoderWid = size.width;
    pacehoderHei = size.height;
    self.pacehoder.frame = CGRectMake(pacehoderX, pacehoderY, pacehoderWid, pacehoderHei);
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setPacehoderString:(NSString *)pacehoderString{
    _pacehoderString = [pacehoderString copy];
    self.pacehoder.text = _pacehoderString;
}

- (void)setFont:(UIFont *)font{
    [super setFont:font];
    self.pacehoder.font = font;
    [self setNeedsLayout];
}



@end
