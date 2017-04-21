//
//  HYSearchResultController.m
//  searHim重制版-01基本框架构建
//
//  Created by 黄远 on 16/10/24.
//  Copyright © 2016年 黄远. All rights reserved.
//

#import "HYSearchResultController.h"
#import "HYSearchResultCell.h"

@interface HYSearchResultController ()

@end

@implementation HYSearchResultController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
}

- (void)setupNav{
    self.navigationItem.title = @"匹配的用户";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"隐藏" style:UIBarButtonItemStylePlain target:self action:@selector(quto)];
}

#pragma mark - target
- (void)quto{
    [UIView animateWithDuration:0.6 animations:^{
        self.navigationController.view.y = mainScreenHei;
    }];
}



#pragma mark - delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.group.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* ID = @"HYSearchResultCell";
    HYSearchResultCell* cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[HYSearchResultCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.searchResult = self.group[indexPath.row];
    }
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.view endEditing:YES];
    HYSearchResult* sr = self.group[indexPath.row];
    [self.delegate didSelectedUserInfo:sr];
}


@end
