//
//  HYTabBar.h
//  新浪微博
//
//  Created by 黄远 on 16/5/27.
//  Copyright © 2016年 黄远. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HYTabBar;

typedef enum {
    btnTypeCurrentMsg,  //最近消息
    btnTypeFriendList, //通讯录
    btnTypeFind, //发现
    btnTypeMapKit  //地图
}btnType;

@protocol HYTabBarDelegate <NSObject>

- (void)reloadSelectedVC:(HYTabBar*)tabBar WithIndex:(int)index;

@optional
- (void)presentSendWeiBoController;

@end


@interface HYTabBar : UIView
@property (nonatomic, strong) NSMutableArray* items;
@property (nonatomic, assign) CGSize imaSize;
@property (nonatomic, weak) id<HYTabBarDelegate> delegate;

//- (void)reloadUnreadCountInTabBar:(HYUnreadCountResult*)result;

@end
