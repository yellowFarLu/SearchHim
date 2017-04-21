//
//  HYMoreViewController.m
//  searHim重制版-01基本框架构建
//
//  Created by 黄远 on 16/7/19.
//  Copyright © 2016年 黄远. All rights reserved.
//

#import "HYMoreViewController.h"
#import "HYCollectionViewCell.h"
#import "HYMoreItem.h"
#define HYOpenImaPicVC @"打开相册"
#define HYOpenVideoVC @"打开视频"
#define HYOpenFriendInfoVC @"打开朋友名片控制器"
@interface HYMoreViewController () <HYCollectionViewCellDeleagte>

@property (nonatomic, strong) NSMutableArray* group;

@end

@implementation HYMoreViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.collectionView.backgroundColor = HYGlobalBg;
    // Register cell classes
    [self.collectionView registerClass:[HYCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    [self addGroup];
}

- (void)addGroup{
    HYMoreItem* picItem = [HYMoreItem initWithTitle:@"图片" AndIconName:@"pic" btnType:CellBtnTypePic];
    [self.group addObject:picItem];
    
    HYMoreItem* videoItem = [HYMoreItem initWithTitle:@"小视频" AndIconName:@"video" btnType:CellBtnTypeVideo];
    [self.group addObject:videoItem];
    
    HYMoreItem* infoItem = [HYMoreItem initWithTitle:@"名片" AndIconName:@"name" btnType:CellBtnTypeInfo];
    [self.group addObject:infoItem];
}

- (NSMutableArray*)group{
    if (!_group) {
        _group = [NSMutableArray array];
    }
    return _group;
}

#pragma mark <UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.group.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HYCollectionViewCell *cell = (HYCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    HYMoreItem* moreItem = self.group[indexPath.item];
    cell.item = moreItem;
    cell.delegate = self;
    
    return cell;
}

#pragma mark - HYCollectionViewCellDeleagte
- (void)didClickCell:(HYCollectionViewCell *)cell WithCellBtnType:(CellBtnType)btnType{
    switch (btnType) {
        case CellBtnTypePic:
            [self tellSingleOpenImagePicVC];
            break;
            
        case CellBtnTypeVideo:
            [self tellSingleOpenVideoVC];
            break;
            
        case CellBtnTypeInfo:
            [self tellSingleOpenFriendInfoVC];
            break;
        default:
            break;
    }
}

//让聊天室打开名片控制器
- (void)tellSingleOpenFriendInfoVC{
    [[NSNotificationCenter defaultCenter] postNotificationName:HYOpenFriendInfoVC object:nil];
}

- (void)tellSingleOpenImagePicVC{
    [[NSNotificationCenter defaultCenter] postNotificationName:HYOpenImaPicVC object:nil];
}

- (void)tellSingleOpenVideoVC{
    [[NSNotificationCenter defaultCenter] postNotificationName:HYOpenVideoVC object:nil];
}

@end
