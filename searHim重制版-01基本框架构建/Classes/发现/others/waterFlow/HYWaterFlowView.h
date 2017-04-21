//
//  HYWaterFlowView.h
//  瀑布流实现
//
//  Created by 黄远 on 16/7/8.
//  Copyright © 2016年 黄远. All rights reserved.
//  瀑布流控件

#import <UIKit/UIKit.h>
@class HYWaterFlowView;
@class HYWaterFlowViewCell;

typedef enum {
    HYWaterFlowViewMarginTypeTop,
    HYWaterFlowViewMarginTypeLeft,
    HYWaterFlowViewMarginTypeBottom,
    HYWaterFlowViewMarginTypeRight,
    HYWaterFlowViewMarginTypeColunm,
    HYWaterFlowViewMarginTypeRow
    
} HYWaterFlowViewMarginType;



@protocol HYWaterFlowViewDataSource <NSObject>
@required
//数据源告诉控件有多少个子控件
- (NSUInteger)numberOfCountForWaterFlowView:(HYWaterFlowView*)waterFlowView;

//展示多少列 默认3列
- (NSUInteger)numOfColunmInWaterFlowView:(HYWaterFlowView*)waterFlowView;

//每一个索引位置展示什么控件和数据
- (HYWaterFlowViewCell*)waterFlowView:(HYWaterFlowView*)waterFlowView cellForIndex:(NSUInteger)index;


@end



@protocol HYWaterFlowViewDelegate <UIScrollViewDelegate>

@optional
//第几个控件的行高
- (CGFloat)waterFlowView:(HYWaterFlowView*)waterFlowView heightForIndex:(NSUInteger)index;

//选择了那个控件
- (void)waterFlowView:(HYWaterFlowView*)waterFlowView didSelectRowAtIndex:(NSUInteger)index;

//各种类型的间距
- (CGFloat)waterFlowView:(HYWaterFlowView*)waterFlowView marginForType:(HYWaterFlowViewMarginType)type;

@end




@interface HYWaterFlowView : UIScrollView

@property (nonatomic, weak) id<HYWaterFlowViewDataSource> dataSource;
@property (nonatomic, weak) id<HYWaterFlowViewDelegate> delegate;

//公共接口
- (HYWaterFlowViewCell*)dequeCellFromCellPoolWithIdentifited:(NSString*)identified;
- (CGFloat)cellWidth;

// 刷新子控件
- (void)reloadData;





@end
