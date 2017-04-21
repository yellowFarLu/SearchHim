//
//  HYSearchBar.h
//  新浪微博
//
//  Created by 黄远 on 16/5/29.
//  Copyright © 2016年 黄远. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HYSearchBar;

@protocol HYSearchBarDelegate <UITextViewDelegate>
@required
- (void)showMarkVC;

@end

@interface HYSearchBar : UITextField

+ (instancetype)loadSearchBarWithFrame:(CGRect)frame;

@property (nonatomic, weak) id<HYSearchBarDelegate> searchDelegate;

@end
