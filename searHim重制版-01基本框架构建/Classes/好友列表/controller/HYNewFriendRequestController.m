//
//  HYNewFriendRequestController.m
//  searHim重制版-01基本框架构建
//
//  Created by 黄远 on 16/7/11.
//  Copyright © 2016年 黄远. All rights reserved.
//

#import "HYNewFriendRequestController.h"
#import "HYNewFriendCell.h"
#import "HYNewFriendItem.h"
#import <AVStatus.h>
#import "HYStatusTool.h"
#import "HYUserInfo.h"
#define HYNewStatus @"来新的请求了"
//先从本地数据库获取 newFriendTable（）
@interface HYNewFriendRequestController ()

@end

@implementation HYNewFriendRequestController


- (void)setGroups:(NSMutableArray *)groups{
    NSMutableArray* muAr = [NSMutableArray array];
    for (AVStatus*status in groups) {
        HYNewFriendItem* newFriendItem = [[HYNewFriendItem alloc] initWithDict:status.data];
        [muAr addObject:newFriendItem];
    }
    [super setGroups:muAr];
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpFriendLsitNav];
    [self queryFromDBFrist];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(queryStatus:) name:HYNewStatus object:nil];
}

- (void)setUpFriendLsitNav{
    self.title = @"新的朋友";
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

- (void)queryStatus:(NSNotification*)notification{
    NSMutableArray* muAr = [NSMutableArray array];
    NSArray* statusArr = notification.userInfo[@"newStatus"];
    for (AVStatus*status in statusArr) {
        HYNewFriendItem* newFriendItem = [[HYNewFriendItem alloc] initWithDict:status.data];
        [muAr addObject:newFriendItem];
    }
    [self.groups addObjectsFromArray:muAr];
    [self.tableView reloadData];
}

- (void)queryFromDBFrist{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //一开始，先从数据库加载，然后网络慢慢探测新的请求
    NSMutableArray* muAr = [NSMutableArray array];
    NSArray* statusArr = [HYStatusTool statusFromDB];
    for (AVStatus*status in statusArr) {
        HYNewFriendItem* newFriendItem = [[HYNewFriendItem alloc] initWithDict:status.data];
        [muAr addObject:newFriendItem];
    }
    [self.groups addObjectsFromArray:muAr];
    [self.tableView reloadData];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}




#pragma mark - dataSource
- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewRowAction *deletaAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        //删除数据库中对应的请求
        HYNewFriendItem* newFriendItem = self.groups[indexPath.row];
        HYStatusParamters* statusPam = [[HYStatusParamters alloc] init];
        HYUserInfo* userInfo = [[HYUserInfo alloc] init];
        userInfo.objectId = newFriendItem.objId;
        statusPam.userInfo = userInfo;
        [HYStatusTool deleteStatusWithParamters:statusPam success:^(HYStatusResultParamters *resultParamters) {
            
        } failure:^(NSError *err) {
            
        }];
        
        //删除cell之前，要保证对应的模型也删除了，这样子模型的数量才对应cell的数量
        [self.groups removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }];
    
    return @[deletaAction];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* ID = @"HYNewFriendCell";
    HYNewFriendCell* cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [HYNewFriendCell newFriendCell];
    }
    HYNewFriendItem* newFriendItem = self.groups[indexPath.row];
    cell.friendItem = newFriendItem;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55;
}

@end
