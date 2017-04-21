//
//  HYDiscoverViewController.m
//  searHim重制版-01基本框架构建
//
//  Created by 黄远 on 16/7/5.
//  Copyright © 2016年 黄远. All rights reserved.
//

#import "HYDiscoverViewController.h"
#import "HYSearchBar.h"
#import "HYUserInfoTool.h"
#import "HYUserInfo.h"
#import "HYWaterFlowView.h"
#import "HYSearchHimCell.h"
#import "HYOtherInfoController.h"
#import "HYImInfoController.h"
#import "HYFriendInfoController.h"
#import <AVQuery.h>
#import <AVStatus.h>
#import "HYMarkController.h"
#import "HYMarkTool.h"
#define userInfoHasGet @"使用者信息已经加载好了"
@interface HYDiscoverViewController () <HYWaterFlowViewDelegate, HYWaterFlowViewDataSource, HYSearchBarDelegate, HYMarkControllerDelegate, UITextFieldDelegate>

//瀑布流控件
@property (nonatomic, weak) HYWaterFlowView* waterFlowView;
//刷新控件
//@property (nonatomic, weak) UIRefreshControl* refreshControler;
@property (nonatomic, strong) NSMutableArray* groups;
@property (nonatomic, weak) HYSearchBar* searchBar;
//用户查找记录的控制器
@property (nonatomic, strong) HYMarkController* markVC;
@end

@implementation HYDiscoverViewController

- (NSMutableArray*)groups{
    if (!_groups) {
        _groups = [NSMutableArray array];
    }
    return _groups;
}


- (void)viewDidLoad{
    [super viewDidLoad];
    [self setupNav];
    [self setupWaterFlowView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadUserInfo) name:userInfoHasGet object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(texetFieldChang:) name:UITextFieldTextDidChangeNotification object:self.searchBar];
    [self setRefreshControl];
    [self setupTableView];
}

- (void)setupTableView{
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)setRefreshControl{
    UIRefreshControl* refreshControler = [[UIRefreshControl alloc] init];
    [refreshControler addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControler;
//    [self.tableView addSubview:refreshControler];
}

- (void)refresh:(UIRefreshControl*)refreshControler{
    HYParamters* paramters = [[HYParamters alloc] init];
    paramters.username = [AVUser currentUser].username;
    paramters.limit = 10;
    [HYUserInfoTool loadMorePersonInfoWithParamters:paramters success:^(HYResponseObject *responseObject) {
        NSIndexSet* indexSet = [[NSIndexSet alloc] initWithIndexesInRange:NSMakeRange(0, responseObject.resultInfo.count)];
        [self.groups insertObjects:responseObject.resultInfo atIndexes:indexSet];
        [self.waterFlowView reloadData];
        [self.refreshControl endRefreshing];
        HYLog(@"%@", self.refreshControl);
        HYLog(@"刷新%d条", (int)responseObject.resultInfo.count);
    } failure:^(NSError *error) {
        [refreshControler endRefreshing];
    }];
    
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#define waterFlowViewHei (mainScreenHei - 64)
- (void)setupWaterFlowView{
    HYWaterFlowView* waterFlowView = [[HYWaterFlowView alloc] init];
    waterFlowView.delegate = self;
    waterFlowView.dataSource = self;
    waterFlowView.frame = CGRectMake(0, 0, mainScreenWid, waterFlowViewHei - 50);
    [self.view addSubview:waterFlowView];
    self.waterFlowView = waterFlowView;
}

- (void)loadUserInfo{
    AppDelegate* appD = (AppDelegate*)[UIApplication sharedApplication].delegate;
    self.groups = [NSMutableArray arrayWithArray:appD.allUserInfo];
    [self.waterFlowView reloadData];
}

- (void)setupNav{
    CGFloat searchBarX, searchBarY, searchBarW, searchBarH;
    searchBarX = 5;
    searchBarY = 4;
    searchBarW = self.view.frame.size.width - 2*searchBarX;
    searchBarH = 44 - 2*searchBarY;
    HYSearchBar* searchBar = [HYSearchBar loadSearchBarWithFrame:CGRectMake(searchBarX, searchBarY, searchBarW, searchBarH)];
    searchBar.searchDelegate = self;
    searchBar.delegate = self;
    self.navigationItem.titleView = searchBar;
    self.searchBar = searchBar;
}


#pragma mark - HYSearBarDelegate
//点击return，收集痕迹
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self queryWithText:textField.text];
    [HYMarkTool saveMarkInDB:textField.text WithImObjectId:[AVUser currentUser].objectId];
    return YES;
}

- (void)texetFieldChang:(NSNotification*)notification{
    [self queryWithText:self.searchBar.text];
}

- (void)queryWithText:(NSString*)text{
    HYParamters* param = [[HYParamters alloc] init];
    param.containsString = self.searchBar.text;
    [HYUserInfoTool queryUserInfoWithParamters:param success:^(HYResponseObject *responseObject) {
        if (responseObject.resultInfo.count == 0) {
            [MBProgressHUD showError:@"没有搜索到该用户信息"];
        } else{
            self.groups = nil;
            self.groups = [NSMutableArray arrayWithArray:responseObject.resultInfo];
            [self.waterFlowView reloadData];
        }
    } failure:^(NSError *error) {
        HYLog(@"%@", error);
    }];
}

//展示历史记录
- (void)showMarkVC{
    if (!self.markVC) {
        HYMarkController* showMarkVC = [[HYMarkController alloc] init];
        [self.view addSubview:showMarkVC.view];  //这一句用到控制器的view，会调用该控制器的viewDidload方法
        self.markVC = showMarkVC;
        showMarkVC.delegate = self;
        showMarkVC.view.y = 0;
    }
}

- (void)closeMarkVC{
    self.markVC = nil;
}

#pragma mark - HYMarkControllerDelegate
- (void)didSelectMark:(NSString *)mark{
    self.searchBar.text = mark;
    [self queryWithText:mark];
}


#pragma mark - HYWaterFlowViewDataSource
- (NSUInteger)numOfColunmInWaterFlowView:(HYWaterFlowView *)waterFlowView{
    return 3;
}

- (NSUInteger)numberOfCountForWaterFlowView:(HYWaterFlowView *)waterFlowView{
    return self.groups.count;
}

- (HYWaterFlowViewCell *)waterFlowView:(HYWaterFlowView *)waterFlowView cellForIndex:(NSUInteger)index{
    static NSString* ID = @"waterFlowViewCell";
    HYSearchHimCell* cell = (HYSearchHimCell*)[waterFlowView dequeCellFromCellPoolWithIdentifited:ID];
    if (!cell) {
        cell= [[HYSearchHimCell alloc] init];
        cell.reuseIdentifier = ID;
    }
    HYUserInfo* userInfo = self.groups[index];
    cell.userInfo = userInfo;
    
    return cell;
}


#pragma mark - HYWaterFlowViewDelegate
- (void)waterFlowView:(HYWaterFlowView *)waterFlowView didSelectRowAtIndex:(NSUInteger)index{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HYUserInfo* usrInfo = self.groups[index];
    //查看clientId来判断是展示自己的信息，还是朋友信息，还是陌生人的信息
    AppDelegate* appD = (AppDelegate*)[UIApplication sharedApplication].delegate;
    if ([usrInfo.objectId isEqualToString:appD.imUserInfo.objectId]) {
        HYImInfoController* imVC = [[HYImInfoController alloc] init];
        imVC.imUsrInfo = appD.imUserInfo;
        [self.navigationController pushViewController:imVC animated:YES];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        return;
    }
    
    
    AVQuery *queryFriend= [AVUser followeeQuery:[AVUser currentUser].objectId];
    [queryFriend includeKey:@"followee"];
    [queryFriend findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        for (AVUser* user in objects) {
            if ([usrInfo.objectId isEqualToString:user.objectId]) {
                HYFriendInfoController* friendInVC = [[HYFriendInfoController alloc] init];
                friendInVC.imUsrInfo = usrInfo;
                [self.navigationController pushViewController:friendInVC animated:YES];
                 [MBProgressHUD hideHUDForView:self.view animated:YES];
                return;
            }
        }
        
        HYOtherInfoController* otherVC = [[HYOtherInfoController alloc] init];
        otherVC.imUsrInfo = usrInfo;
        [self.navigationController pushViewController:otherVC animated:YES];
         [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];

}

- (CGFloat)waterFlowView:(HYWaterFlowView *)waterFlowView heightForIndex:(NSUInteger)index{
    CGFloat cellWid = [waterFlowView cellWidth];
    HYUserInfo* userInfo = self.groups[index];
    if (userInfo.iconUrl && ![userInfo.iconUrl isEqualToString:@"nil"]) {
        return cellWid*(userInfo.iconHei.floatValue / userInfo.iconWid.floatValue);
    }else{
        UIImage* ima = [UIImage imageNamed:@"6f9"];
        return cellWid*(ima.size.height / ima.size.width);
    }
}

#pragma mark - tableViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.markVC.tableView removeFromSuperview];
    [self.markVC.view removeFromSuperview];
    self.markVC = nil;
    [self.searchBar resignFirstResponder];
}

@end
