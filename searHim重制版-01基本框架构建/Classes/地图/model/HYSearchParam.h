//
//  HYSearchParam.h
//  searHim重制版-01基本框架构建
//
//  Created by 黄远 on 16/10/24.
//  Copyright © 2016年 黄远. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HYSearchParam : NSObject

/** 性别 */
@property (nonatomic, copy) NSString* sex;

/** 城市 */
//@property (nonatomic, copy) NSString* city;

/** 它的特征 */
@property (nonatomic, strong) NSArray* aboutMe;

@end
