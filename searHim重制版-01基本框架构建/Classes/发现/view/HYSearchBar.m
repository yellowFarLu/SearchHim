//
//  HYSearchBar.m
//  新浪微博
//
//  Created by 黄远 on 16/5/29.
//  Copyright © 2016年 黄远. All rights reserved.
//

#import "HYSearchBar.h"

@implementation HYSearchBar

+ (instancetype)loadSearchBarWithFrame:(CGRect)frame{
    HYSearchBar* searchBar = [[HYSearchBar alloc] initWithFrame:frame];
    searchBar.backgroundColor = [UIColor clearColor];
    UIImage* originIma = [UIImage imageNamed:@"searchbar_textfield_background"];
    originIma = [originIma stretchableImageWithLeftCapWidth:originIma.size.width*0.5 topCapHeight:originIma.size.height*0.5];
    searchBar.background = originIma;
    searchBar.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    
    //设置leftView
    UIImageView* imaV = [[UIImageView alloc] init];
    UIImage *leftIma = [UIImage imageNamed:@"searchbar_textfield_search_icon"];
    imaV.image = leftIma;
    CGFloat imaX, imaY, imaH, imaW;
    imaX = imaY = 0;
    imaW = leftIma.size.width + 10;
    imaH = leftIma.size.height;
    imaV.frame = CGRectMake(imaX, imaY, imaW, imaH);
    imaV.contentMode = UIViewContentModeCenter;
    searchBar.leftViewMode = UITextFieldViewModeAlways;
    searchBar.leftView = imaV;
    searchBar.placeholder = @"搜索";
    searchBar.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, HYSearHimInset*2, 1)];
    searchBar.leftViewMode = UITextFieldViewModeAlways;
    searchBar.keyboardType = UIKeyboardTypeDefault;
    
    return searchBar;
}

- (BOOL)becomeFirstResponder{
    [self.searchDelegate showMarkVC];
    return [super becomeFirstResponder];
}


@end
