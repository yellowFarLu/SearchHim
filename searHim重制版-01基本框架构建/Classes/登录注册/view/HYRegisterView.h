//
//  HYRegisterView.h
//  searHim重制版-01基本框架构建
//
//  Created by 黄远 on 16/7/9.
//  Copyright © 2016年 黄远. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HYRegisterView;

@protocol HYRegisterViewDelegate <NSObject>
- (void)openImagePicViewController;

- (void)openUserMust;

@end

@interface HYRegisterView : UIView
@property (nonatomic, weak) id<HYRegisterViewDelegate> delegate;
//当前图片
@property (nonatomic, strong) UIImage* currentIma;

@end
