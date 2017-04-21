//
//  HYCommonTableViewController.m
//  searHim重制版-01基本框架构建
//
//  Created by 黄远 on 16/7/5.
//  Copyright © 2016年 黄远. All rights reserved.
//

#import "HYCommonTableViewController.h"
#import "HYCommonItem.h"

@interface HYCommonTableViewController () 
@property (nonatomic, strong) NSMutableArray* groups;
@property (nonatomic, weak) UITableView* tableView;
@end

@implementation HYCommonTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.frame = CGRectMake(0, 0, mainScreenWid, mainScreenHei);
    [self setupTableView];
    self.view.backgroundColor = HYGlobalBg;
}

#define tabBarHeight 50
- (void)setupTableView{
     self.automaticallyAdjustsScrollViewInsets = NO;
    //加载tableView
    CGRect frame = CGRectMake(0, 0, mainScreenWid, mainScreenHei - tabBarHeight);
    UITableView* tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = HYGlobalBg;
    self.tableView.sectionHeaderHeight = 0;
    self.tableView.sectionFooterHeight = 0;
}

- (NSMutableArray*)groups{
    if (!_groups) {
        _groups = [NSMutableArray array];
    }
    return _groups;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.groups.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString* ID = @"cell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }
    return cell;
}



@end
