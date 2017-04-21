//
//  HYEmotion.h
//  新浪微博
//
//  Created by 黄远 on 16/6/17.
//  Copyright © 2016年 黄远. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HYEmotion : NSObject <NSCoding>

/** 表情的文字描述 */
@property (nonatomic, copy) NSString *chs;
/** 表情的文字描述 */
@property (nonatomic, copy) NSString *cht;
/** 表情的文png图片名 */
@property (nonatomic, copy) NSString *png;
/** emoji表情的编码 */
@property (nonatomic, copy) NSString *code;


/** 表情的存放文件夹\目录 */
@property (nonatomic, copy) NSString *directory;
/** emoji表情的字符 */
@property (nonatomic, copy) NSString *emoji;


@end
