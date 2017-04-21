//
//  HYBaseItemGroup.h
//  searHim重制版-01基本框架构建
//
//  Created by 黄远 on 16/7/10.
//  Copyright © 2016年 黄远. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HYBaseItemGroup : NSObject

@property (nonatomic, strong) NSMutableArray* items;
@property (nonatomic, copy) NSString* header;
@property (nonatomic, copy) NSString* footer;

@end
