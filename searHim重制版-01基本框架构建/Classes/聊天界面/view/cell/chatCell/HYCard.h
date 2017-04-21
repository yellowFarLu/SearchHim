//
//  HYCard.h
//  searHim重制版-01基本框架构建
//
//  Created by 黄远 on 16/7/25.
//  Copyright © 2016年 黄远. All rights reserved.
//  用于展示名片

#import <UIKit/UIKit.h>

@interface HYCard : UIView
@property (weak, nonatomic) IBOutlet UIImageView *iconInfo;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *sexInfo;

+ (instancetype)cardXib;

@end
