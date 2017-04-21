//
//  UIImage+Exstension.m
//  新浪微博
//
//  Created by 黄远 on 16/5/27.
//  Copyright © 2016年 黄远. All rights reserved.
//

#import "UIImage+Exstension.h"

@implementation UIImage (Exstension)

+ (instancetype)imageWithOriginalName:(NSString*)imaName;{
    UIImage* ima = [UIImage imageNamed:imaName];
    ima = [ima imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    return ima;
}


+ (instancetype)resizeImageWithOriginalName:(NSString *)imaName{
    UIImage* originIma = [UIImage imageNamed:imaName];
    return [originIma stretchableImageWithLeftCapWidth:originIma.size.width*0.5 topCapHeight:originIma.size.height*0.5];
}

//给图片布上颜色
- (instancetype)imageWithOverlayColor:(UIColor*)overlayColor{
    UIImage* image = self;
    CGRect rect = CGRectMake(0, 0, image.size.width, image.size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef contf = UIGraphicsGetCurrentContext();
    CGContextClipToMask(contf, rect, image.CGImage);
    CGContextSetFillColorWithColor(contf, overlayColor.CGColor);
    CGContextFillRect(contf, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIImage *flippedImage = [UIImage imageWithCGImage:img.CGImage
                                                scale:1.0 orientation:UIImageOrientationDownMirrored];
    
    return flippedImage;

}

//给控制器的view截图
+ (UIImage*)contreollerViewImaForRect:(CGRect)rect andView:(UIView*)indexView{
    CGFloat scale = [[UIScreen mainScreen] scale];
    CGSize pageSize = CGSizeMake(scale*rect.size.width, scale*rect.size.height) ;
    UIGraphicsBeginImageContext(pageSize);
    CGContextScaleCTM(UIGraphicsGetCurrentContext(), scale, scale);
    
    CGContextRef resizedContext =UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(resizedContext,-1*rect.origin.x,-1*rect.origin.y);
    [indexView.layer renderInContext:resizedContext];
    UIImage*imageOriginBackground =UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    imageOriginBackground = [UIImage imageWithCGImage:imageOriginBackground.CGImage scale:scale orientation:UIImageOrientationUp];
    return imageOriginBackground;
}

@end
