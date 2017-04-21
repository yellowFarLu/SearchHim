//
//  HYContentItem.h
//  searHim重制版-01基本框架构建
//
//  Created by 黄远 on 16/7/15.
//  Copyright © 2016年 黄远. All rights reserved.
//

#import "HYBaseChatItem.h"

@interface HYContentItem : HYBaseChatItem

//用于展示的文字
@property (nonatomic, copy) NSAttributedString* content;

//用于存储的文字
@property (nonatomic, copy) NSString* realString;

- (void)setContentWithMsgText:(NSString*)text;

@end
