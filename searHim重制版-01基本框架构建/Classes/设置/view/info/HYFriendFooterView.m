//
//  HYFriendFooterView.m
//  searHim重制版-01基本框架构建
//
//  Created by 黄远 on 16/7/12.
//  Copyright © 2016年 黄远. All rights reserved.
//

#import "HYFriendFooterView.h"

@interface HYFriendFooterView ()
@property (weak, nonatomic) IBOutlet UIButton *sendMsgBtn;

- (IBAction)sendMsg:(UIButton *)sender;

@end

@implementation HYFriendFooterView



+ (instancetype)friendFooterView{
    return [[[NSBundle mainBundle] loadNibNamed:@"friendFooterView" owner:nil options:nil] lastObject];
}

- (void)awakeFromNib{
    self.sendMsgBtn.layer.cornerRadius = HYCornerRadius;
    self.sendMsgBtn.backgroundColor = backBtnColor;
}


- (IBAction)sendMsg:(UIButton *)sender {
    [self.delegate didClickSendMsgWithFooterView:self];
}

@end
