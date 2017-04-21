//
//  HYFooterView.h
//  searHim重制版-01基本框架构建
//
//  Created by 黄远 on 16/7/11.
//  Copyright © 2016年 黄远. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HYFooterView;

@protocol HYFooterViewDelegate <NSObject>
@required
- (void)didClickSendMsgWithFooterView:(HYFooterView*)footerView;

- (void)didClickAddFriendWithFooterView:(HYFooterView*)footerView;
@end

@interface HYFooterView : UIView

+ (instancetype)footerView;

@property (nonatomic, weak) id<HYFooterViewDelegate> delegate;
@end
