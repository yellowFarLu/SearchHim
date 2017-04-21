//
//  HYLoginView.h
//  searHim重制版-01基本框架构建
//
//  Created by 黄远 on 16/7/5.
//  Copyright © 2016年 黄远. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HYLoginView;

@protocol HYLoginViewDelegate <NSObject>

- (void)loginViewDidClickRegisterBtn;

@end


@interface HYLoginView : UIView
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UITextField *accountName;
@property (weak, nonatomic) IBOutlet UITextField *pwd;
- (IBAction)onClickRegister:(UIButton *)sender;

+ (instancetype)loginView;


@property (nonatomic, weak) id<HYLoginViewDelegate> delegate;
@end
