//
//  HYCollectionView.m
//  searHim重制版-01基本框架构建
//
//  Created by 黄远 on 16/7/20.
//  Copyright © 2016年 黄远. All rights reserved.
//

#import "HYCollectionView.h"
#import "UIImage+Exstension.h"

@implementation HYCollectionView

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    [[UIImage resizeImageWithOriginalName:@"sidebar_bg"] drawInRect:rect];
}


@end
