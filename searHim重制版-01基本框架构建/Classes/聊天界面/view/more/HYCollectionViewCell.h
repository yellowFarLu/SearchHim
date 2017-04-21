//
//  HYCollectionViewCell.h
//  searHim重制版-01基本框架构建
//
//  Created by 黄远 on 16/7/19.
//  Copyright © 2016年 黄远. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HYMoreItem,HYCollectionViewCell;

typedef enum {
    CellBtnTypePic,   //图片
    CellBtnTypeVideo, //小视频
    CellBtnTypeInfo  //名片
}CellBtnType;


@protocol HYCollectionViewCellDeleagte <NSObject>
@required
- (void)didClickCell:(HYCollectionViewCell*)cell WithCellBtnType:(CellBtnType)btnType;

@end

@interface HYCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) HYMoreItem* item;
@property (nonatomic, weak) id<HYCollectionViewCellDeleagte> delegate;

@end
