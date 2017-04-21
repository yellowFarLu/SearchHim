//
//  HYCommonTableViewController.h
//  searHim重制版-01基本框架构建
//
//  Created by 黄远 on 16/7/5.
//  Copyright © 2016年 黄远. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HYCommonTableViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
- (NSMutableArray*)groups;

- (void)setGroups:(NSMutableArray *)groups;

- (UITableView*)tableView;
-(void)setTableView:(UITableView *)tableView;
@end
