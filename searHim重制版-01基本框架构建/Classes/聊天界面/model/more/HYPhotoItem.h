//
//  HYPhotoItem.h
//  searHim重制版-01基本框架构建
//
//  Created by 黄远 on 16/7/20.
//  Copyright © 2016年 黄远. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ALAssetRepresentation;
@interface HYPhotoItem : NSObject


@property (nonatomic, strong) UIImage* thumbnail;
@property (nonatomic, strong) ALAssetRepresentation* representation;
@property (nonatomic, assign, getter=isSelected) BOOL selected;
@property (nonatomic, copy) NSString* iconUrl;
// 查看是否第一个按钮
@property (nonatomic, assign, getter=isTheFirst) BOOL first;

+ (instancetype)initOfDict:(NSDictionary*)dict;

// 得到拍摄照片的图片
+ (instancetype)getFirstPhoto;

@end
