//
//  HYSearchView.h
//  searHim重制版-01基本框架构建
//
//  Created by 黄远 on 16/10/24.
//  Copyright © 2016年 黄远. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYSearchParam.h"

@protocol HYSearchViewDelegate <NSObject>

- (void)toFindPeopleWithSearchParam:(HYSearchParam*)searchParam;

@end

@interface HYSearchView : UIView

typedef enum {
    btnTypeQue,
    btnTypeQuto // 取消按钮
} btnType;

+ (instancetype)searchView;

/** 提供一个接口，让别人监听我的控件，使用枚举让别人区分是哪个控件，为了不让别人直接访问我的控件*/
- (void)addTargetWithDelegate:(id)deleagte WithAction:(SEL)action toBtnType:(btnType)type;

@property (nonatomic, weak) id<HYSearchViewDelegate> delegate;

- (void)endKeyBoard;

@end
