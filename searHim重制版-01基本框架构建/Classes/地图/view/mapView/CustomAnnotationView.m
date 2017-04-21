//
//  CustomAnnotationView.m
//  JLUFind
//
//  Created by 久保謙 on 2016/03/18.
//  Copyright © 2016年 Yakoresya. All rights reserved.
//

#import "CustomAnnotationView.h"
#define bgMarign 100

@interface CustomAnnotationView()
@property (nonatomic, strong, readwrite) UserCalloutView *calloutView;

@end


@implementation CustomAnnotationView

#define kCalloutWidth       200.0
#define kCalloutHeight      70.0

- (instancetype)initWithAnnotation:(id<MAAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier]) {
//        self.layer.cornerRadius = HYCornerRadius;
//        self.clipsToBounds = YES;
        self.canShowCallout = NO;
//        self.backgroundColor = [UIColor redColor];
//        self.annotation = annotation;
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    if (self.selected == selected)
    {
        return;
    }
    
    if (selected)
    {
        if (!self.calloutView)
        {
            self.calloutView = [[UserCalloutView alloc] initWithFrame:CGRectMake(0, 0, kCalloutWidth, kCalloutHeight)];
            self.calloutView.center = CGPointMake(self.width * 0.5, self.height*0.5 - bgMarign*0.55);
            //设置代理
            self.calloutView.delegate = self.diTuVC;
        }
        
        self.calloutView.image = self.calloutIma;
        self.calloutView.title = self.annotation.title;
        self.calloutView.subtitle = self.annotation.subtitle;
        self.calloutView.userInteractionEnabled = YES;
//        self.calloutView.annotation = self.annotation;
        
        // 将当前的坐标转化为anonotationView父控件的坐标
//        [self.calloutView convertPoint:self.calloutView.center toView:self.superview];
        
        // 添加到anonotationView父控件
//        [self.superview addSubview:self.calloutView];
        [self addSubview:self.calloutView];
    }
    else
    {
        [self.calloutView removeFromSuperview];
    }
    
    // 隐藏气泡
    [super setSelected:selected animated:animated];
}


@end
