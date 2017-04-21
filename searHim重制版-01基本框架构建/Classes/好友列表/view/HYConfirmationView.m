//
//  HYConfirmationView.m
//  searHim重制版-01基本框架构建
//
//  Created by 黄远 on 16/7/11.
//  Copyright © 2016年 黄远. All rights reserved.
//

#import "HYConfirmationView.h"

@interface HYConfirmationView () <UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIView *diver;

@end

@implementation HYConfirmationView

+ (instancetype)confirmationView{
    return [[[NSBundle mainBundle] loadNibNamed:@"confirmationView" owner:nil options:nil] lastObject];
}

- (void)awakeFromNib{
    [super awakeFromNib];
    self.textView.delegate = self;
    self.diver.backgroundColor = [UIColor redColor];
    
}

- (void)textViewDidChange:(UITextView *)textView{
    if ([self.delegate respondsToSelector:@selector(confirmationView:WithTextViewLenth:)]) {
        [self.delegate confirmationView:self WithTextViewLenth:self.textView.text.length];
    }
}

- (NSString*)getValue{
    return self.textView.text;
}

@end
