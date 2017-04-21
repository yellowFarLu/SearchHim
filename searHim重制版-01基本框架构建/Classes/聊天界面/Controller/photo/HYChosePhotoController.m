//
//  HYChosePhotoController.m
//  searHim重制版-01基本框架构建
//
//  Created by 黄远 on 16/7/20.
//  Copyright © 2016年 黄远. All rights reserved.
//

#import "HYChosePhotoController.h"
#import "UIImage+Exstension.h"
#import "HYImageCell.h"
#import "HYCollectionView.h"
#import "HYPhotoItem.h"
#import "HYNetTool.h"
#define HYGetNewImageFromCamera @"从相机得到图片"

static NSString* ID = @"HYImageCell";

@interface HYChosePhotoController () <UICollectionViewDelegate, UICollectionViewDataSource, UINavigationControllerDelegate, UIImagePickerControllerDelegate>
//确定按钮
@property(nonatomic,weak)UIButton *comfirmBtn;
//选中的图片
@property(nonatomic,strong)NSMutableArray *choseArray;
@property (nonatomic, strong) HYCollectionView* colloectionView;
@property (nonatomic, weak) UIView* headerView;
@property (nonatomic, weak) UIView* footerView;
@property (nonatomic, strong) UIImagePickerController *imagePickerController;
@end

@implementation HYChosePhotoController

- (void)setPhotoArr:(NSMutableArray *)photoArr{
    _photoArr = [NSMutableArray array];
    // 插入拍摄照片这个图片
    [_photoArr addObject:[HYPhotoItem getFirstPhoto]];
    for (NSDictionary*dict in photoArr) {
        HYPhotoItem* phoItem = [HYPhotoItem initOfDict:dict];
        [_photoArr addObject:phoItem];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = HYGlobalBg;
    //设置顶部的view
    [self createHeaderView];
    [self createFooterView];
    [self setupColloectionView];
}

#define colCount 3
#define imaMargin 3.0
- (void)setupColloectionView{
    UICollectionViewFlowLayout* layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = imaMargin;
    layout.minimumInteritemSpacing = imaMargin;
    CGFloat imaWid = (self.view.width - 4*imaMargin)/ colCount;
    layout.itemSize = CGSizeMake(imaWid, imaWid);
    
    CGFloat colX, colY, colWid, colHei;
    colX = 0;
    colWid = self.view.width;
    colY = CGRectGetMaxY(self.headerView.frame);
    colHei = (self.view.height - colY - self.footerView.height);
    CGRect frame = CGRectMake(colX, colY, colWid, colHei);
    HYCollectionView* colloectionView = [[HYCollectionView alloc] initWithFrame:frame collectionViewLayout:layout];
    colloectionView.delegate = self;
    colloectionView.dataSource = self;
    [self.view addSubview:colloectionView];
    [colloectionView registerClass:[HYImageCell class] forCellWithReuseIdentifier:ID];
    self.colloectionView = colloectionView;
}

- (NSMutableArray*)choseArray{
    if (!_choseArray) {
        _choseArray = [NSMutableArray array];
    }
    return _choseArray;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.photoArr.count;
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    HYImageCell* cell = (HYImageCell*)[collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    HYPhotoItem* photoItem = self.photoArr[indexPath.item];
    cell.photoItem = photoItem;
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    HYPhotoItem* pho = self.photoArr[indexPath.row];
    // 看是否是第一个按钮，是的话，打开照相机应用
    if ([pho isTheFirst]) {
        [self setUpCamera];
    } else {
        if (pho.selected) {
            [self.choseArray removeObject:pho];
        } else {
            [self.choseArray addObject:pho];
        }
        pho.selected = !pho.selected;
        [collectionView reloadItemsAtIndexPaths:@[indexPath]];
        self.comfirmBtn.enabled = !(self.choseArray.count == 0);
    }
}

// 显示系统所有的照相机供用户选择
- (void)setUpCamera{
    if ([UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController* picV = [[UIImagePickerController alloc] init];
        picV.sourceType = UIImagePickerControllerSourceTypeCamera;
        picV.delegate = self;
        picV.allowsEditing = YES;
        self.imagePickerController = picV;
        [self presentViewController:picV animated:YES completion:^{
            
        }];
    } else {
        [MBProgressHUD showError:@"您的设备不支持"];
    }
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    // 发送图片到聊天界面上 (组装一个HYPhotoItem，通过通知发送过去)
    HYPhotoItem* photoItem = [[HYPhotoItem alloc] init];
    UIImage* image = info[UIImagePickerControllerEditedImage];
    NSData* imageData = nil;
    if (![HYNetTool isInWife]) {
        imageData = UIImageJPEGRepresentation(image, 0.5);
        image = [UIImage imageWithData:imageData];
    }
    photoItem.thumbnail = image;
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    dict[@"photoItemFromCamera"] = photoItem;
    [[NSNotificationCenter defaultCenter] postNotificationName:HYGetNewImageFromCamera object:self userInfo:dict];
    // 写入相册(异步)
    [[[NSOperationQueue alloc] init] addOperationWithBlock:^{
        UIImageWriteToSavedPhotosAlbum(photoItem.thumbnail, nil, nil, nil);
    }];
    
    [self.imagePickerController dismissViewControllerAnimated:YES completion:^{
        
    }];
    
    [self cancelClick];
}


#pragma mark 创建HeaderView
- (void)createHeaderView
{
    UIView *navigationView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 64)];
    navigationView.backgroundColor = customColor(252, 252, 252);
    [self.view addSubview:navigationView];
    self.headerView = navigationView;
    //设置返回按钮
    UIButton *backBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 20, 60, 44)];
    [backBtn setTitle:@"返回" forState:UIControlStateNormal];
    [backBtn setTitleColor:backBtnColor forState:UIControlStateNormal];
    backBtn.titleLabel.font =  [UIFont systemFontOfSize:14.0f];
    backBtn.titleLabel.textAlignment =  NSTextAlignmentCenter;
    [backBtn addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
    [navigationView addSubview:backBtn];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, self.view.bounds.size.width, 44)];
    titleLabel.text = @"图片";
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.font =  [UIFont systemFontOfSize:18.0f];
    titleLabel.textAlignment =  NSTextAlignmentCenter;
    [navigationView addSubview:titleLabel];
    
    
    UIButton *comfirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    comfirmBtn.frame = CGRectMake(self.view.bounds.size.width - 60, 20, 60, 44);
    [comfirmBtn setTitle:@"确定" forState:UIControlStateNormal];
    [comfirmBtn setTitleColor:backBtnColor forState:UIControlStateNormal];
    [comfirmBtn setTitleColor:HYGlobalBg forState:UIControlStateHighlighted];
    [comfirmBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    comfirmBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [comfirmBtn addTarget:self action:@selector(comfirmClick) forControlEvents:UIControlEventTouchUpInside];
    [navigationView addSubview:comfirmBtn];
    comfirmBtn.enabled = NO;
    self.comfirmBtn = comfirmBtn;
}

#pragma mark 创建FooterView
- (void)createFooterView
{
    //设置UIView
    UIView *footerView = [[UIView alloc]init];
    footerView.frame = CGRectMake(0, self.view.frame.size.height - 44, self.view.frame.size.width, 44);
    [self.view addSubview:footerView];
    self.footerView = footerView;
    //设置背景图片
    UIImage *bgImage = [UIImage resizeImageWithOriginalName:@"tabbar_background"];
    UIImageView *bgImageView = [[UIImageView alloc]initWithImage:bgImage];
    bgImageView.frame = CGRectMake(0, 0, footerView.bounds.size.width, footerView.bounds.size.height);
    [footerView addSubview:bgImageView];
    
    
    //设置图片确定按钮
    UILabel *countLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)];
    countLabel.text = [NSString stringWithFormat:@"共%zd张照片",self.photoArr.count];
    countLabel.textColor = [UIColor grayColor];
    countLabel.font =  [UIFont systemFontOfSize:14.0f];
    countLabel.textAlignment =  NSTextAlignmentCenter;
    [footerView addSubview:countLabel];
}

#pragma mark 确定
- (void)comfirmClick
{
    [self dismissViewControllerAnimated:YES completion:^{
        //把选中的图片传给代理
        if([self.delegate respondsToSelector:@selector(getPhotos:)])
        {
            [self.delegate getPhotos:self.choseArray];
        }
    }];
}

#pragma mark 取消
- (void)cancelClick
{
    [self dismissViewControllerAnimated:YES completion:^{
        //NSLog(@"业务处理");
    }];
}

@end
