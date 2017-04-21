//
//  HYFriendInfoController.m
//  SearchHim
//
//  Created by 黄远 on 16/4/27.
//  Copyright © 2016年 黄远. All rights reserved.
//

#import "HYShowInfoController.h"
#import "UIButton+WebCache.h"
#import "HYUserInfo.h"
#import "HYBaseItem.h"
#import "HYBaseItemGroup.h"
#import "HYAlertInfoController.h"
#import "HYInfoCell.h"
#import "HYArrowItem.h"
#import "HYTopItemGroup.h"
#import "HYTopItem.h"
#import "HYCenterItemGroup.h"
#import "HYCenterItem.h"
#import "HYBottomItemFrame.h"
#import "HYBottomItem.h"
#import "HYBottomItemGroup.h"
#import "HYBottomTitleItem.h"
#import "HYBackButton.h"

@interface HYShowInfoController () <HYAlertInfoControllerDelegate>




@end

@implementation HYShowInfoController

- (void)viewDidLoad{
    [super viewDidLoad];
    [self setupNav];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.view.backgroundColor = HYGlobalBg;
    self.tableView.sectionHeaderHeight = 1.7*HYSearHimInset;
    self.tableView.sectionFooterHeight = 0;
    
    //增加内容
    [self addGroupModel];
}

//模型
- (void)addGroupModel{
    //添加顶部模型
    [self addTopItem];
    //添加中间模型
    [self addCenterItem];
    //添加底部模型
    [self addBottomItem];
}

- (void)addTopItem{
    HYTopItemGroup* topItemGroup = [[HYTopItemGroup alloc] init];
    HYTopItem* topItem = [[HYTopItem alloc] initWithUserInfo:self.imUsrInfo];
    topItem.theLast = YES;
    [topItemGroup.items addObject:topItem];
    [self.groups addObject:topItemGroup];
}

- (void)addCenterItem{
    HYCenterItemGroup* centerItemGroup = [[HYCenterItemGroup alloc] init];
    
    NSString* city = self.imUsrInfo.city;
    HYCenterItem* cityItem = [[HYCenterItem alloc] initWithInfo:city andKey:@"城市"];
    [centerItemGroup.items addObject:cityItem];
    
    HYCenterItem* emailItem = [[HYCenterItem alloc] initWithInfo:self.imUsrInfo.email andKey:@"email"];
    [centerItemGroup.items addObject:emailItem];
    
    NSString* mobilePhoneNumber = self.imUsrInfo.mobilePhoneNumber;
    NSString* fromFourNumber = [mobilePhoneNumber substringWithRange:NSMakeRange(0, 4)];
    mobilePhoneNumber = [NSString stringWithFormat:@"%@*******", fromFourNumber];
    HYCenterItem* phoneNumberItem = [[HYCenterItem alloc] initWithInfo:mobilePhoneNumber andKey:@"手机"];
    phoneNumberItem.theLast = YES;
    [centerItemGroup.items addObject:phoneNumberItem];
    
    [self.groups addObject:centerItemGroup];
}


- (void)addBottomItem{
    //lable的item、正文的item
    HYBottomItemGroup* bottomItemGroup = [[HYBottomItemGroup alloc] init];
    
    HYBottomTitleItem* titlItem = [[HYBottomTitleItem alloc] init];
    titlItem.title = @"心目中的他/她";
    [bottomItemGroup.items addObject:titlItem];
    
    HYBottomItem* bottomItem = [[HYBottomItem alloc] init];
    bottomItem.aboutHimOrShe = self.imUsrInfo.searchHim;
    bottomItem.theLast = YES;
    HYBottomItemFrame* bottomItemFrame = [[HYBottomItemFrame alloc] init];
    bottomItemFrame.bottomItem = bottomItem;
    [bottomItemGroup.items addObject:bottomItemFrame];
    [self.groups addObject:bottomItemGroup];
    
    
    HYBottomItemGroup* bottomItemAboutMeGroup = [[HYBottomItemGroup alloc] init];
    
    HYBottomTitleItem* titlAboutMeItem = [[HYBottomTitleItem alloc] init];
    titlAboutMeItem.title = @"我的特征";
    [bottomItemAboutMeGroup.items addObject:titlAboutMeItem];
    
    HYBottomItem* aboutMebottomItem = [[HYBottomItem alloc] init];
    aboutMebottomItem.aboutMe = self.imUsrInfo.aboutMe;
    aboutMebottomItem.theLast = YES;
    aboutMebottomItem.me = YES;
    HYBottomItemFrame* aboutMebottomItemFrame = [[HYBottomItemFrame alloc] init];
    aboutMebottomItemFrame.bottomItem = aboutMebottomItem;
    [bottomItemAboutMeGroup.items addObject:aboutMebottomItemFrame];
    [self.groups addObject:bottomItemAboutMeGroup];
    
}





- (UITableView*)tableView{
    return [super tableView];
}

//- (HYUserInfo*)imUsrInfo{
//    AppDelegate* appD = [UIApplication sharedApplication].delegate;
//    return appD.imUserInfo;
//}


- (void)setupNav{
    self.navigationItem.title = @"个人信息";
    self.navigationController.navigationBar.hidden = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupBackBtn];
}


- (void)setupBackBtn{
    HYBackButton* backBtn = [HYBackButton backButton];
    [backBtn addTarget:self action:@selector(onClickBackBtn) forControlEvents:UIControlEventTouchUpInside];
    CGFloat backBtnX, backBtnY, backBtnH, backBtnW;
    backBtnX = backBtnY = 0;
    backBtnH = HYBackBtnH;
    backBtnW = HYBackBtnW;
    backBtn.frame = CGRectMake(backBtnX, backBtnY, backBtnW, backBtnH);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
}

- (void)onClickBackBtn{
    [self.navigationController popViewControllerAnimated:YES];
}

/** 设置模型，似的不显示箭头 */
- (void)setupModel{
    for (HYBaseItemGroup* baseGroup in self.groups) {
        for (HYBaseItem* baseItem in baseGroup.items) {
            baseItem.other = YES;
        }
    }
}


- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - tableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.groups.count;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    HYBaseItemGroup* baseGroup = self.groups[section];
    return baseGroup.items.count;
}


- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* ID = @"HYInfoCell";
    HYInfoCell* infoCell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!infoCell) {
        infoCell = [[HYInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    HYBaseItemGroup* baseItemGroup = self.groups[indexPath.section];
    HYBaseItem* baseItem = baseItemGroup.items[indexPath.row];
    infoCell.baseItem = baseItem;
    
    return infoCell;
}


#pragma mark - tableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView reloadData];
    HYBaseItemGroup* baseItemGroup = self.groups[indexPath.section];
    HYBaseItem* baseItem = baseItemGroup.items[indexPath.row];
    if ([baseItem isKindOfClass:[HYArrowItem class]]) {
        HYAlertInfoController* alertVC = [[HYAlertInfoController alloc] init];
        alertVC.baseItem = baseItem;
        alertVC.delegate = self;
        [self.navigationController pushViewController:alertVC animated:YES];
    }
}

#define topHei 70
#pragma mark - tableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    HYBaseItemGroup* baseItemGroup = self.groups[indexPath.section];
    HYBaseItem* baseItem = baseItemGroup.items[indexPath.row];
    if ([baseItem isKindOfClass:[HYTopItem class]]) {
        return topHei;
    }else if([baseItem isKindOfClass:[HYBottomItemFrame class]]){
        HYBottomItemFrame* bottomItemFrame = (HYBottomItemFrame*)baseItem;
        HYLog(@"底部的高 ---%@  %f", indexPath, CGRectGetMaxY(bottomItemFrame.itemframe));
        return CGRectGetMaxY(bottomItemFrame.itemframe);
    }
    return 44;
}

@end
