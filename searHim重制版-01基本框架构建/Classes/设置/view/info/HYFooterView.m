//
//  HYFooterView.m
//  searHim重制版-01基本框架构建
//
//  Created by 黄远 on 16/7/11.
//  Copyright © 2016年 黄远. All rights reserved.
//

#import "HYFooterView.h"

@interface HYFooterView ()
@property (weak, nonatomic) IBOutlet UIButton *addFriendBtn;
@property (weak, nonatomic) IBOutlet UIButton *sendMsgBtn;
- (IBAction)addFriend:(UIButton *)sender;

- (IBAction)sendMsg:(UIButton *)sender;
@end

@implementation HYFooterView

+ (instancetype)footerView{
    return [[[NSBundle mainBundle] loadNibNamed:@"footerView" owner:nil options:nil] lastObject];
}

- (void)awakeFromNib{
    self.sendMsgBtn.layer.cornerRadius = HYCornerRadius;
    self.sendMsgBtn.backgroundColor = backBtnColor;
    self.addFriendBtn.layer.cornerRadius = HYCornerRadius;
    self.addFriendBtn.backgroundColor = backBtnColor;
}

- (IBAction)addFriend:(UIButton *)sender {
    [self.delegate didClickAddFriendWithFooterView:self];
}

- (IBAction)sendMsg:(UIButton *)sender {
    [self.delegate didClickSendMsgWithFooterView:self];
}















@end
