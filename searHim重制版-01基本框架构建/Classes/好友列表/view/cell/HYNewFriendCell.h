//
//  HYNewFriendCell.h
//  searHim重制版-01基本框架构建
//
//  Created by 黄远 on 16/7/11.
//  Copyright © 2016年 黄远. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HYNewFriendItem;
@interface HYNewFriendCell : UITableViewCell

+ (instancetype)newFriendCell;
@property (nonatomic, strong) HYNewFriendItem* friendItem;
@end
