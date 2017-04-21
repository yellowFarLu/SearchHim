//
//  HYBottomItemFrame.h
//  searHim重制版-01基本框架构建
//
//  Created by 黄远 on 16/7/10.
//  Copyright © 2016年 黄远. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HYBottomItem.h"
#import "HYArrowItem.h"

@interface HYBottomItemFrame : HYArrowItem

@property (nonatomic, strong) HYBottomItem* bottomItem;
@property (nonatomic, assign) CGRect itemframe;

@end
