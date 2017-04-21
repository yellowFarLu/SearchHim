//
//  HYCardController.m
//  searHim重制版-01基本框架构建
//
//  Created by 黄远 on 16/7/25.
//  Copyright © 2016年 黄远. All rights reserved.
//

#import "HYCardController.h"



@interface HYCardController () 

@end

@implementation HYCardController

#pragma mark - tableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    HYFriendGroupItem* fiendG = self.groups[indexPath.section];
    HYUserInfo* userInfo = fiendG.items[indexPath.row];
    [self showInfoVCWithTitle:nil message:@"发送该名片到当前聊天？" cancelTitle:@"取消" cancelHandler:^(UIAlertAction * _Nonnull action) {
        
    } andQueTitle:@"发送" cancelHandler:^(UIAlertAction * _Nonnull action) {
        [self.delegate cardVC:self didSelectedCard:userInfo];
    }];
}

- (void)showInfoVCWithTitle:(NSString*)title message:(NSString*)msg cancelTitle:(NSString*)cancelTitle cancelHandler:(void(^)(UIAlertAction * _Nonnull action))cancel andQueTitle:(NSString*)queTitle cancelHandler:(void(^)(UIAlertAction * _Nonnull action))que{
    UIAlertController* alertVC = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        if (cancel) {
            cancel(action);
        }
    }];
    
    [cancelAction setValue:[UIColor lightGrayColor] forKey:@"titleTextColor"];
    UIAlertAction *queAction = [UIAlertAction actionWithTitle:queTitle style:UIAlertActionStyleDestructive handler:^(UIAlertAction* _Nonnull action){
        if (que) {
            que(action);
        }
    }];
    UIColor* btnColor = backBtnColor;
    [queAction setValue:btnColor forKey:@"titleTextColor"];
    
    [alertVC addAction:cancelAction];
    [alertVC addAction:queAction];
    [self presentViewController:alertVC animated:YES completion:^{
        
    }];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"选择联系人";
    [self setupBackBtn];
}

- (void)setupBackBtn{
    UIButton* backBtn = [[UIButton alloc] init];
    [backBtn setTitle:@"返回" forState:UIControlStateNormal];
    [backBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backBtn setTitleColor:backBtnColor forState:UIControlStateHighlighted];
    backBtn.frame = CGRectMake(0, 0, 30, 20);
    backBtn.titleLabel.font = HYValueFont;
    [backBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
}

- (void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addItemWithArr:(NSArray*)resultInfo{
    for (HYUserInfo*userInfo in resultInfo) {
        NSString* tem = [userInfo.username lowercaseString];
        unichar temC = [tem characterAtIndex:0];
        int index = [HYPinyinOC pinyinFirstLetter:temC];
        if (index >= 97) {
            index = index - 97;
        }
        HYFriendGroupItem* groupItem = nil;
        if(index >=0 && index < 26){
            groupItem = self.groups[index];
        }else{
            //如果账号名字首字母是数字或其他  //27固定存放其他不能识别首字母的对象
            groupItem = self.groups[27];
        }
        [groupItem.items addObject:userInfo];
    }
}


@end
