//
//  HYSeaerchBg.h
//  searHim重制版-01基本框架构建
//
//  Created by 黄远 on 16/10/24.
//  Copyright © 2016年 黄远. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HYSearchParam, HYSearchBg;

@protocol HYSearchBgDelegate <NSObject>

- (void)searchBg:(HYSearchBg*)searchBg toFindPeopleWithSearchParam:(HYSearchParam *)searchParam;

@end

@interface HYSearchBg : UIButton

/** 默认显示在整个屏幕上 */
+ (instancetype)searchBg;

/** 显示searchView */
- (void)start;

/** 关闭searchView和自己 */
- (void)stop;

/** 获取searchView的frame */
- (CGRect)rectForSearchView;

@property (nonatomic, weak) id<HYSearchBgDelegate> delegate;

@end
