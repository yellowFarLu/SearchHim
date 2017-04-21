//
//  CustomAnnotationView.h
//  JLUFind
//
//  Created by 久保謙 on 2016/03/18.
//  Copyright © 2016年 Yakoresya. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>
#import "UserCalloutView.h"
#import "HYMapKitControllerViewController.h"

@interface CustomAnnotationView : MAAnnotationView 

@property (nonatomic, readonly) UserCalloutView *calloutView;
@property (nonatomic, strong) HYMapKitControllerViewController* diTuVC;
//@property (nonatomic, strong) MAPointAnnotation* annotation;

//专门用来做calloutView的图片
@property (nonatomic, strong) UIImage* calloutIma;

@end
