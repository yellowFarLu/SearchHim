//
//  HYMoreKeyBoard.m
//  searHim重制版-01基本框架构建
//
//  Created by 黄远 on 16/7/19.
//  Copyright © 2016年 黄远. All rights reserved.
//

#import "HYMoreKeyBoard.h"
#import "HYMoreViewController.h"

//一页最多显示多少个按钮
#define maxInPage 8

@interface HYMoreKeyBoard ()
@property (nonatomic, strong) HYMoreViewController* moreVC;
@property (nonatomic, weak) UIPageControl* pageC;
@end


@implementation HYMoreKeyBoard

+ (instancetype)moreKeyBoard{
    return [[self alloc] init];
}


- (instancetype)init{
    if (self = [super init]) {
        self.frame = CGRectMake(0, 0, mainScreenWid, 250);
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}



#define topMargin HYSearHimInset*4
#define leftMargin HYSearHimInset*2.5
#define rowMargin HYSearHimInset*3
#define colMargin leftMargin
#define bottomMargin topMargin
#define rightMargin leftMargin
- (HYMoreViewController*)moreVC{
    if (!_moreVC) {
        // 创建一个流水布局
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        // 设置cell的尺寸
        layout.itemSize = CGSizeMake(50, 70);
        // 行间距
        layout.minimumLineSpacing = rowMargin;
        // 设置cell之间的间距
        layout.minimumInteritemSpacing = colMargin;
        layout.sectionInset = UIEdgeInsetsMake(topMargin, leftMargin, bottomMargin, rightMargin);
        HYMoreViewController* moreVC = [[HYMoreViewController alloc] initWithCollectionViewLayout:layout];
        [self addSubview:moreVC.view];
        _moreVC = moreVC;
    }
    return _moreVC;
}

- (UIPageControl*)pageC{
    if (!_pageC) {
        UIPageControl* pageC = [[UIPageControl alloc] init];
        [self addSubview:pageC];
        pageC.pageIndicatorTintColor = [UIColor grayColor];
        pageC.currentPageIndicatorTintColor = backBtnColor;
        pageC.hidesForSinglePage = YES;
        _pageC = pageC;
    }
    return _pageC;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat pageCX, pageCY, pageCWid, pageCHei;
    pageCWid = 200;
    pageCHei = 30;
    pageCX = (self.width - pageCWid)*0.5;
    pageCY = self.height - pageCHei;
    self.pageC.frame = CGRectMake(pageCX, pageCY, pageCWid, pageCHei);
    
    CGFloat moreVX, moreVY, moreVWid, moreVHei;
    moreVX = moreVY = 0;
    moreVWid = self.width;
    moreVHei = self.height - pageCHei - HYSearHimInset;
    self.moreVC.view.frame = CGRectMake(moreVX, moreVY, moreVWid, moreVHei);
    self.pageC.numberOfPages = self.moreVC.group.count % maxInPage == 0 ? self.moreVC.group.count % maxInPage : (self.moreVC.group.count / maxInPage)+1;
}


@end
