//
//  HYShowSearchViewBtn.h
//  searHim重制版-01基本框架构建
//
//  Created by 黄远 on 16/10/24.
//  Copyright © 2016年 黄远. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HYShowSearchViewBtn : UIButton


/** 展示searchView（程序第一次启动时地图界面时，调用此函数） 
 *  先展示朦胧背景， 然后searchView从底部从上来
 */
- (void)showSearchView;

@end
