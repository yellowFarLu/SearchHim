//
//  HYMarkController.m
//  searHim重制版-01基本框架构建
//
//  Created by 黄远 on 16/7/18.
//  Copyright © 2016年 黄远. All rights reserved.
//

#import "HYMarkController.h"
#import "HYMarkTool.h"
#import <AVUser.h>
#import "HYMarkCell.h"
#define HYRowHeight 30.0
#define HYFooterHight HYRowHeight

@interface HYMarkController ()

@end

@implementation HYMarkController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupGroup];
    [self setTableView];
    [self setupFooterView];
}

- (void)setupGroup{
    self.groups = nil;
    self.groups = [HYMarkTool loadMarkFromDBWithImObjectId:[AVUser currentUser].objectId];
    [self.tableView reloadData];
}

- (void)setTableView{
    CGFloat tableViewX, tableViewY, tableViewWid, tableViewHei;
    tableViewX = 0;
    tableViewWid = (mainScreenWid - 3*tableViewX);
    tableViewHei = self.groups.count * HYRowHeight + HYFooterHight;
    tableViewY = self.tableView.y;
    self.tableView.frame = CGRectMake(tableViewX, tableViewY, tableViewWid, tableViewHei);
    self.view.frame = self.tableView.frame;
    self.tableView.contentInset = UIEdgeInsetsMake(-34, 0, 0, 0);
//    HYLog(@"%@  ----  %@", NSStringFromCGRect(self.view.frame), NSStringFromCGRect(self.tableView.frame));
//    self.tableView.backgroundColor = [UIColor blueColor];
//    self.view.backgroundColor = [UIColor yellowColor];
    CGFloat x = 0;
    CGFloat wid = mainScreenWid - 2*x;
    self.view.frame = CGRectMake(x, 64, wid, self.tableView.height);
}

- (void)setupFooterView{
    UIButton* clearBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [clearBtn setTitle:@"清除历史记录" forState:UIControlStateNormal];
    [clearBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    clearBtn.titleLabel.font = HYValueFont;
    clearBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    clearBtn.contentEdgeInsets = UIEdgeInsetsMake(0, HYSearHimInset, 0, 0);
    [clearBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [clearBtn addTarget:self action:@selector(clear:) forControlEvents:UIControlEventTouchUpInside];
    clearBtn.frame = CGRectMake(0, 0, self.tableView.width, HYFooterHight);
    self.tableView.tableFooterView = clearBtn;
//    self.tableView.tableFooterView.backgroundColor = [UIColor redColor];
}

- (void)clear:(UIButton*)sender{
    [HYMarkTool deleteAllMarkWithImObjectId:[AVUser currentUser].objectId];
    self.groups = [NSMutableArray array];
    [self.tableView reloadData];
    [self.tableView.tableFooterView removeFromSuperview];
    self.view.frame = self.tableView.frame = self.tableView.tableFooterView.frame =CGRectZero;
    //代理方法，让发现控制器清空对本控制器的索引
    [self.delegate closeMarkVC];
}

#pragma mark - tableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return HYRowHeight;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* ID = @"markCell";
    HYMarkCell* cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[HYMarkCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.textLabel.text = self.groups[indexPath.row];
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.delegate didSelectMark:self.groups[indexPath.row]];
     self.view.frame = self.tableView.frame = self.tableView.tableFooterView.frame =CGRectZero;
    //代理方法，让发现控制器清空对本控制器的索引
    [self.delegate closeMarkVC];
}



@end
