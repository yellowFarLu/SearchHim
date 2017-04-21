//
//  HYRightMenu.h
//  网易新闻框架
//
//  Created by 黄远 on 16/7/4.
//  Copyright © 2016年 黄远. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    HYMenuButtonTypeMyInfo, //我的信息
    HYMenuButtonTypeClearCache, //清理缓存
    HYMenuButtonTypeReceiveNews, //接收推送
    HYMenuButtonTypeQuitAccount, //退出账号
    HYMenuButtonTypeQuitApp, //退出searchHim
    HYMenuButtonTypeAboutSearchHim //关于searchHim
} HYMenuButtonType;


@class HYRightMenu;

@protocol HYRightMenuDelegate <NSObject>
@optional
- (void)leftMenu:(HYRightMenu *)menu didSelectedButtonWithType:(HYMenuButtonType)type;
@end


@interface HYRightMenu : UIView
@property (nonatomic, weak) id<HYRightMenuDelegate> delegate;
@end
