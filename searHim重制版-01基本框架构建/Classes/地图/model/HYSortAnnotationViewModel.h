//
//  HYSortAnnotationViewModel.h
//  searHim重制版-01基本框架构建
//
//  Created by 黄远 on 16/10/23.
//  Copyright © 2016年 黄远. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MAAnnotationView;

@interface HYSortAnnotationViewModel : NSObject

// 距离触碰点的距离
@property (nonatomic, assign) double margin;
@property (nonatomic, weak) MAAnnotationView* annotationView;


@end
