//
//  HYEmotionResult.h
//  新浪微博
//
//  Created by 黄远 on 16/6/21.
//  Copyright © 2016年 黄远. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HYEmotionResult : NSObject

/*
 * 这个子串在原来父串中的位置
 */
@property (nonatomic, assign) NSRange range;

/*
 * 子串本身
 */
@property (nonatomic, copy) NSString* resultStr;

@property (nonatomic, assign, getter=isEmotion) BOOL emotion;

@end
