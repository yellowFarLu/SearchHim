//
//  HYBottomAlertView.h
//  searHim重制版-01基本框架构建
//
//  Created by 黄远 on 16/7/10.
//  Copyright © 2016年 黄远. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HYBottomAlertView;

@protocol HYBottomAlertViewDelegate <NSObject>

- (void)bottomAlertView:(HYBottomAlertView*)bottomAlertView didSelectedBtnTitlte:(NSString*)title;

@end


@interface HYBottomAlertView : UIView
@property (nonatomic, weak) id<HYBottomAlertViewDelegate> delegate;
@end
