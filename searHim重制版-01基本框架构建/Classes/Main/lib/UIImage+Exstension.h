//
//  UIImage+Exstension.h
//  新浪微博
//
//  Created by 黄远 on 16/5/27.
//  Copyright © 2016年 黄远. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Exstension)

+ (instancetype)imageWithOriginalName:(NSString*)imaName;

+ (instancetype)resizeImageWithOriginalName:(NSString*)imaName;
//给图片布上颜色
- (instancetype)imageWithOverlayColor:(UIColor*)overlayColor;

//给控制器的view截图
+ (UIImage*)contreollerViewImaForRect:(CGRect)rect andView:(UIView*)indexView;

@end
