//
//  HYFriendListController.m
//  searHim重制版-01基本框架构建
//
//  Created by 黄远 on 16/7/5.
//  Copyright © 2016年 黄远. All rights reserved.
//

#import "HYFriendListController.h"
#import <AVStatus.h>
#import "HYFriendInfoController.h"
#define HYAddNewFriendReloadUI @"添加新朋友了，刷新UI"
#define HYUserHasSeeStatus @"用户已经查看请求了"
#define HYReloadFriendFromDele @"删除好友了"

@interface HYFriendListController ()

@end

@implementation HYFriendListController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSNotificationCenter* center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(reloadFriendListUI) name:HYAddNewFriendReloadUI object:nil];
    [center addObserver:self selector:@selector(reloadFriendListUI) name:HYReloadFriendFromDele object:nil];
}

//添加新朋友后，刷新界面
- (void)reloadFriendListUI{
    self.groups = nil;
    [self addGroup];
}


- (void)initGroup{
    HYFriendGroupItem* newFriendGroupItem = [[HYFriendGroupItem alloc] init];
    HYUserInfo* newFriend = [[HYUserInfo alloc] init];
    newFriend.username = @"新的朋友";
    [newFriendGroupItem.items addObject:newFriend];
    [self.groups addObject:newFriendGroupItem];
    [super initGroup];
}


#pragma mark - tableDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    HYFriendGroupItem* groupItem = self.groups[indexPath.section];
    HYUserInfo* item = groupItem.items[indexPath.row];
    if ([item.username isEqualToString:@"新的朋友"]) {
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        //发送通知，让通讯录红点隐藏
        [[NSNotificationCenter defaultCenter] postNotificationName:HYUserHasSeeStatus object:nil];
        HYNewFriendRequestController* newFriendRequestController = [[HYNewFriendRequestController alloc] init];
        [self.navigationController pushViewController:newFriendRequestController animated:YES];
        
    }else{
        HYFriendInfoController* friendInfoVC = [[HYFriendInfoController alloc] init];
        friendInfoVC.imUsrInfo = item;
        [self.navigationController pushViewController:friendInfoVC animated:YES];
    }
}


@end
