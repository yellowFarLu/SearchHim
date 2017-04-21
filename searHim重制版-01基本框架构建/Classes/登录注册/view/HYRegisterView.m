//
//  HYRegisterView.m
//  searHim重制版-01基本框架构建
//
//  Created by 黄远 on 16/7/9.
//  Copyright © 2016年 黄远. All rights reserved.
//

#import "HYRegisterView.h"
#import <AVUser.h>
#import "MBProgressHUD+NJ.h"
#import <AVFile.h>
#import "HYUserInfo.h"

@interface HYRegisterView ()
- (IBAction)clickRegister:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UITextField *registerName;
@property (weak, nonatomic) IBOutlet UITextField *registerPhone;
@property (weak, nonatomic) IBOutlet UITextField *registerEmail;
@property (weak, nonatomic) IBOutlet UITextField *registerPwd;
@property (nonatomic, weak) UIButton* userMust; // 用户须知条例按钮
/** 用户是否同意用户须知协议 */
@property (nonatomic, assign) Boolean agreeUserMust;

- (IBAction)selectIcon:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIButton *registerBtn;

@property (weak, nonatomic) IBOutlet UIButton *icon;
// 添加同意按钮
@property (nonatomic, weak) UIButton* agreeBtn;

@end

@implementation HYRegisterView

//设置头像
- (void)setCurrentIma:(UIImage *)currentIma{
    _currentIma = currentIma;
    [self.icon setBackgroundImage:_currentIma forState:UIControlStateNormal];
}

#define HYHasRegister @"注册成功"
#define hasRegisterName @"hasRegisterName"
#define hasRegisterPWD @"hasRegisterPWD"
- (IBAction)clickRegister:(UIButton *)sender {
    if ([self.registerName.text isEqualToString:@""]) {
        [MBProgressHUD showError:@"账号不能为空"];
        return;
    }
    
    if ([self.registerPhone.text isEqualToString:@""]) {
        [MBProgressHUD showError:@"手机号不能为空"];
        return;
    }
    
    if ([self.registerEmail.text isEqualToString:@""]) {
        [MBProgressHUD showError:@"邮箱不能为空"];
        return;
    }
    
    if ([self.registerPwd.text isEqualToString:@""]) {
        [MBProgressHUD showError:@"密码不能为空"];
        return;
    }
    
    if (!self.agreeUserMust) {
        [MBProgressHUD showError:@"未同意用户须知和隐私保护条例"];
        return;
    }
    
    [MBProgressHUD showMessage:@"正在上传头像..."];
    
    //用于上传到服务器端
    NSData* iconData = UIImageJPEGRepresentation(self.currentIma, 0.1);
    AVFile* file = [AVFile fileWithData:iconData];
    [file saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        NSOperationQueue* mainQueue = [NSOperationQueue mainQueue];
        [mainQueue addOperation:[NSBlockOperation blockOperationWithBlock:^{
            [MBProgressHUD hideHUD];
        }]];
        
        
        AVUser *user = [AVUser user];// 新建 AVUser 对象实例
        user.username = self.registerName.text;// 设置用户名
        user.password =  self.registerPwd.text;// 设置密码
        user.email = self.registerEmail.text;// 设置邮箱
        user.mobilePhoneNumber = self.registerPhone.text;  //设置手机号码
        
        if (succeeded) {
//            [mainQueue addOperation:[NSBlockOperation blockOperationWithBlock:^{
//                 [MBProgressHUD showSuccess:@"头像上传成功"];
//            }]];
            [user setObject:file.url forKey:@"iconUrl"];
            [user setObject:@(self.currentIma.size.width) forKey:@"iconWid"];
            [user setObject:@(self.currentIma.size.height) forKey:@"iconHei"];
        } else {
            [mainQueue addOperation:[NSBlockOperation blockOperationWithBlock:^{
                [MBProgressHUD showError:@"头像上传失败"];
            }]];
        }
        
        AppDelegate* appD = (AppDelegate*)[UIApplication sharedApplication].delegate;
        appD.imUserInfo.username = user.username;
        appD.imUserInfo.email = user.email;
        appD.imUserInfo.mobilePhoneNumber = user.mobilePhoneNumber;
        
        [mainQueue addOperation:[NSBlockOperation blockOperationWithBlock:^{
            [MBProgressHUD showMessage:@"正在注册..."];
        }]];
       
        [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            [mainQueue addOperation:[NSBlockOperation blockOperationWithBlock:^{
                [MBProgressHUD hideHUDForView:nil animated:NO];
            }]];
            
            // 延迟显示提示
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if (succeeded) {
                    [mainQueue addOperation:[NSBlockOperation blockOperationWithBlock:^{
                        // 注册成功
                        [MBProgressHUD showSuccess:@"注册成功"];
                    }]];
                    
                    //自动登录
                    [[NSNotificationCenter defaultCenter] postNotificationName:HYHasRegister object:nil userInfo:@{ hasRegisterName : self.registerName.text, hasRegisterPWD  : self.registerPwd.text}];
                } else {
                    HYLog(@"注册失败--%@", error);
                    // 失败的原因可能有多种，常见的是用户名已经存在。
                    if (error.code == 202) {
                        [mainQueue addOperation:[NSBlockOperation blockOperationWithBlock:^{
                            [MBProgressHUD showError:@"注册失败 : 用户名已存在"];
                        }]];
                        
                    }else if(error.code == 125){  //邮箱格式不正确
                        [mainQueue addOperation:[NSBlockOperation blockOperationWithBlock:^{
                            [MBProgressHUD showError:@"注册失败 : 邮箱格式不正确"];
                        }]];
                        
                    }else if(error.code == 127){ //无效的手机号码
                        [mainQueue addOperation:[NSBlockOperation blockOperationWithBlock:^{
                            [MBProgressHUD showError:@"注册失败 : 无效的手机号码"];
                        }]];
                        
                    }
                }
                //            [MBProgressHUD hideHUD];
            });
 
        }];

    }];
}


- (void)awakeFromNib{
    [super awakeFromNib];
    self.registerBtn.layer.cornerRadius = HYCornerRadius;
    self.registerBtn.backgroundColor = backBtnColor;
    self.userInteractionEnabled = YES;
    self.registerBtn.enabled = YES;
    for (UIView* sv in self.registerBtn.subviews) {
        if ([sv isKindOfClass:[UIImageView class]]) {
            sv.frame = CGRectZero;
        }
        sv.userInteractionEnabled = NO;
    }
    
    self.height = CGRectGetMaxY(self.registerBtn.frame); // 为了让注册按钮能够在注册控件的范围之内。
    
    // 添加用户须知条例按钮
    UIButton* userMust = [[UIButton alloc] init];
    [userMust setTitle:@"用户须知条例" forState:UIControlStateNormal];
    [userMust setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [userMust setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    userMust.titleLabel.font = HYKeyFont;
    [userMust addTarget:self action:@selector(onClickUserMust) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:userMust];
    self.userMust = userMust;
    
    // 添加同意按钮
    UIButton* agreeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [agreeBtn setTitle:@"同意" forState:UIControlStateNormal];
    [agreeBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [agreeBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [agreeBtn setImage:[UIImage imageNamed:@"Snip20161015_4.png"] forState:UIControlStateNormal];
    [agreeBtn setImage:[UIImage imageNamed:@"Snip20161015_1.png"] forState:UIControlStateSelected];
    agreeBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    agreeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    agreeBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 15);
    agreeBtn.titleLabel.font = HYKeyFont;
    
//    agreeBtn.backgroundColor = [UIColor redColor];
//    agreeBtn.imageView.backgroundColor = [UIColor orangeColor];
    [agreeBtn addTarget:self action:@selector(agreeUserMustClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:agreeBtn];
    self.agreeBtn = agreeBtn;
    
    UITapGestureRecognizer* lg = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(lgFunction)];
    [self addGestureRecognizer:lg];
}

- (void)lgFunction{
    [self endEditing:YES];
}

- (void)agreeUserMustClick:(UIButton*)sender{
    sender.selected = !sender.selected;
    self.agreeUserMust = sender.selected;
}

- (void)onClickUserMust{
    // 调用代理方法，显示用户须知控制器
    [self.delegate openUserMust];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat agreeX, agreeY, agreeW, agreeH;
    agreeW = 100;
    
    CGFloat x,y,w,h;
    h = 45;
    w = [self.userMust.titleLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, h) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : HYKeyFont} context:nil].size.width;
    y = CGRectGetMaxY(self.registerBtn.frame) + HYSearHimInset;
    x = (self.width - w) * 0.5 + agreeW * 0.5;
    self.userMust.frame = CGRectMake(x, y, w, h);
    
   
    agreeH = h;
    agreeY = y;
    agreeX = x - agreeW;
    self.agreeBtn.frame = CGRectMake(agreeX, agreeY, agreeW, agreeH);
}





- (IBAction)selectIcon:(UIButton *)sender {
    //调用代理方法，让注册控制器选好图片，然后把图片传过来
    if ([self.delegate respondsToSelector:@selector(openImagePicViewController)]) {
        [self.delegate openImagePicViewController];
    }
}



@end
