//
//  HYChosePhotoController.h
//  searHim重制版-01基本框架构建
//
//  Created by 黄远 on 16/7/20.
//  Copyright © 2016年 黄远. All rights reserved.
//  自定义相册

#import "HYCommonTableViewController.h"

@protocol HYChosePhotoControllerDelegate <NSObject>

//获取返回的是模型
-(void)getPhotos:(NSMutableArray *)photos;

@end

@interface HYChosePhotoController : UIViewController

//用来保存要展示在自定义相册的图片
@property (nonatomic, strong) NSMutableArray* photoArr;

@property (nonatomic, weak) id<HYChosePhotoControllerDelegate> delegate;

#pragma mark 取消
- (void)cancelClick;

@end
