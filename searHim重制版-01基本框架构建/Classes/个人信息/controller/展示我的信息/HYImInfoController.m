//
//  HYImInfoController.m
//  searHim重制版-01基本框架构建
//
//  Created by 黄远 on 16/7/10.
//  Copyright © 2016年 黄远. All rights reserved.
//

#import "HYImInfoController.h"
#import "HYTopItemGroup.h"
#import "HYTopItem.h"
#import "HYCenterItemGroup.h"
#import "HYCenterItem.h"
#import "HYBottomItem.h"
#import "HYBottomItemFrame.h"
#import "HYBottomTitleItem.h"
#import "HYBottomItemGroup.h"
#import "HYUserInfo.h"
#import <AVFile.h>
#import <AVUser.h>
#import <AVQuery.h>
#import "HYAlertInfoController.h"
#import "HYUserInfoTool.h"
#import "HYShowLocationItem.h"
#import "HYShowLocationGroup.h"

@interface HYImInfoController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (nonatomic, strong) UIImagePickerController* ImagePickerController;
@end

@implementation HYImInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 添加是否显示“我的位置”
    [self addShowMyLocationModel];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectImage) name:HYOpenImageBook object:nil];
}

// 添加是否显示“我的位置”
- (void)addShowMyLocationModel{
    HYShowLocationGroup* showLocationGroup = [[HYShowLocationGroup alloc] init];
    HYShowLocationItem* item = [[HYShowLocationItem alloc] init];
    [showLocationGroup.items addObject:item];
    item.theLast = YES;
    [self.groups addObject:showLocationGroup];
}



- (void)selectImage{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    self.ImagePickerController = picker;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    //设置选择后的图片可被编辑
    picker.allowsEditing = YES;
    [self presentModalViewController:picker animated:YES];
}

#pragma mark - UIImagePickerControllerDelegate
//当选择一张图片后进入这里
-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [MBProgressHUD showMessage:@"正在上传头像..."];
    UIImage*image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    //用于上传到服务器端
    NSData* iconData = UIImageJPEGRepresentation(image, 0.1);
    AVFile* file = [AVFile fileWithData:iconData];
    [file saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        [MBProgressHUD hideHUD];
        AVUser* imUser = [AVUser currentUser];
        if (succeeded) {
            [MBProgressHUD showSuccess:@"头像上传成功"];
            [imUser setObject:file.url forKey:@"iconUrl"];
            [imUser setObject:@(image.size.width) forKey:@"iconWid"];
            [imUser setObject:@(image.size.height) forKey:@"iconHei"];
            
        } else {
            [MBProgressHUD showError:@"头像上传失败"];
        }
        
        [imUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            [MBProgressHUD hideHUD];
            if (succeeded) {
                //                    [MBProgressHUD showSuccess:@"更新成功"];
                AppDelegate* appD = [UIApplication sharedApplication].delegate;
                appD.imUserInfo.iconUrl = file.url;
                for (HYUserInfo* userInfo  in appD.allUserInfo) {
                    if ([userInfo.username isEqualToString:appD.imUserInfo.username]) {
                        userInfo.iconUrl = appD.imUserInfo.iconUrl;
                        break;
                    }
                }
                self.imUsrInfo = appD.imUserInfo;
                self.groups = nil;
                [self addGroupModel];
                [self.tableView reloadData];
                //本地数据库也要改（数据库，缓存，服务器，ui）
                [HYUserInfoTool saveImInDB:self.imUsrInfo ForKey:@"iconUrl" WithValue:file.url];
                
                [MBProgressHUD hideHUD];
                [self.ImagePickerController dismissViewControllerAnimated:YES completion:^{
                    
                }];
                
            } else {
                NSLog(@"%@", error);
                //                    [MBProgressHUD showError:@"网络繁忙，请稍后再试..."];
            }

        }];
        
    }];
    
}


#pragma mark - HYAlertInfoControllerDelegate
- (void)reloadForAlertInfoController:(HYAlertInfoController *)alertInfoController{
//    AppDelegate* appD = (AppDelegate*)[UIApplication sharedApplication].delegate;
//    self.imUsrInfo = appD.imUserInfo;
    self.groups = nil;
    [self addGroupModel];
    [self.tableView reloadData];
}





@end
