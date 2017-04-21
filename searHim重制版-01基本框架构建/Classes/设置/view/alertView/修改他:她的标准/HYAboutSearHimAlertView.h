//
//  HYAboutSearHimAlertView.h
//  searHim重制版-01基本框架构建
//
//  Created by 黄远 on 16/7/10.
//  Copyright © 2016年 黄远. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HYAboutSearHimAlertView;

@protocol HYAboutSearHimAlertViewDelegate <NSObject>

- (void)aboutSearHimAlertView:(HYAboutSearHimAlertView*)aboutSearHimAlertView WithTextViewLenth:(NSInteger)length;

@end

@interface HYAboutSearHimAlertView : UIView
@property (nonatomic, weak) id<HYAboutSearHimAlertViewDelegate> delegate;

/** 接口 */
/** 判断是个人介绍还是心目中的Ta */
@property (nonatomic, assign) BOOL me;

- (NSString*)getValue;
@end
