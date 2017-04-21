//
//  HYCurrentMsgCell.h
//  searHim重制版-01基本框架构建
//
//  Created by 黄远 on 16/7/14.
//  Copyright © 2016年 黄远. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HYCurrentMsgItem;

@interface HYCurrentMsgCell : UITableViewCell

@property (nonatomic, strong) HYCurrentMsgItem* currentMsgItem;

+ (instancetype)currentMsgCell;

@end
