//
//  HYBaseFriendListController.m
//  searHim重制版-01基本框架构建
//
//  Created by 黄远 on 16/7/25.
//  Copyright © 2016年 黄远. All rights reserved.
//

#import "HYBaseFriendListController.h"
#import <AVUser.h>
#import "HYNetTool.h"

@interface HYBaseFriendListController ()

@end

@implementation HYBaseFriendListController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.contentInset = UIEdgeInsetsMake(30, 0, 0, 0);
    [self addGroup];
    [self setupSearBar];
 
}

- (void)setupSearBar{
    CGFloat searchBarX, searchBarY, searchBarW, searchBarH;
    searchBarX = 0;
    searchBarY = 0;
    searchBarW = self.view.frame.size.width - 2*searchBarX;
    searchBarH = HYSearBarHei;
    HYSearchBar* searchBar = [HYSearchBar loadSearchBarWithFrame:CGRectMake(searchBarX, searchBarY, searchBarW, searchBarH)];
    searchBar.delegate = self;
    [self.view addSubview:searchBar];
    [self.view bringSubviewToFront:searchBar];
    self.searchBar = searchBar;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(texetFieldChang:) name:UITextFieldTextDidChangeNotification object:self.searchBar];
}

//点击return，收集痕迹
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self queryWithText:textField.text];
    [HYMarkTool saveMarkInDB:textField.text WithImObjectId:[AVUser currentUser].objectId];
    return YES;
}

- (void)texetFieldChang:(NSNotification*)notification{
    [self queryWithText:self.searchBar.text];
}



//展示历史记录
- (void)showMarkVC{
    if (!self.markVC) {
        HYMarkController* showMarkVC = [[HYMarkController alloc] init];
        [self.view addSubview:showMarkVC.view];  //这一句用到控制器的view，会调用该控制器的viewDidload方法
        [self.view bringSubviewToFront:showMarkVC.view];
        showMarkVC.delegate = self;
        showMarkVC.view.y = CGRectGetMaxY(self.searchBar.frame) - 5;
        self.markVC = showMarkVC;
    }
}


#pragma mark - HYMarkControllerDelegate
- (void)didSelectMark:(NSString *)mark{
    self.searchBar.text = mark;
    [self queryWithText:mark];
}

- (void)closeMarkVC{
    self.markVC = nil;
}

- (void)queryWithText:(NSString*)text{
    HYParamters* param = [[HYParamters alloc] init];
    param.containsString = self.searchBar.text;
    [HYUserInfoTool queryFriendUserInfoWithParamters:param success:^(HYResponseObject *responseObject) {
        self.groups = nil;
        [self initGroup];
        [self addItemWithArr:responseObject.resultInfo];
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        HYLog(@"%@", error);
    }];
}

#pragma mark - tableViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.markVC.tableView removeFromSuperview];
    [self.markVC.view removeFromSuperview];
    self.markVC = nil;
    [self.searchBar resignFirstResponder];
    [self.tableView reloadData];
}



- (void)initGroup{
    for (int i=0; i<26; i++) {
        HYFriendGroupItem* groupItem = [[HYFriendGroupItem alloc] init];
        char c = i + 65;
        NSString* cStr = [NSString stringWithFormat:@"%c", c];
        groupItem.header = cStr;
        [self.groups addObject:groupItem];
    }
    HYFriendGroupItem* oterhGroupItem = [[HYFriendGroupItem alloc] init];
    oterhGroupItem.header = @"#";
    [self.groups addObject:oterhGroupItem];
}

- (void)addItemWithArr:(NSArray*)resultInfo{
    for (HYUserInfo*userInfo in resultInfo) {
        NSString* tem = [userInfo.username lowercaseString];
        unichar temC = [tem characterAtIndex:0];
        int index = [HYPinyinOC pinyinFirstLetter:temC];
        if (index >= 97) {
            index = index - 97;
        }
        HYFriendGroupItem* groupItem = nil;
        if(index >=0 && index < 26){
            index = index + 1;
            groupItem = self.groups[index];
        }else{
            //如果账号名字首字母是数字或其他  //27固定存放其他不能识别首字母的对象
            groupItem = self.groups[27];
        }
        [groupItem.items addObject:userInfo];
    }
}

- (void)addGroup{
    [self initGroup];
    //先从数据库请求，再从网络请求
    [HYUserInfoTool loadAllFriendInfoWithParamters:nil success:^(HYResponseObject *responseObject) {
        [self addItemWithArr:responseObject.resultInfo];
        [self.tableView reloadData];
        
        //如果是wife环境下，从网络加载
        if ([HYNetTool isInWife]) {
            [self addGourpsFromInternet];
        }
    } failure:^(NSError *error) {
        HYLog(@"%@", error);
    }];
}

- (void)addGourpsFromInternet{
    [HYUserInfoTool loadFriendInfoFromInternetWithParamters:nil success:^(HYResponseObject *responseObject) {
        self.groups = nil;
        [self initGroup];
        [self addItemWithArr:responseObject.resultInfo];
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.groups.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    HYFriendGroupItem* groupItem = self.groups[section];
    return groupItem.items.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* ID = @"HYFriendListCell";
    HYFriendListCell* cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [HYFriendListCell friendListCell];
    }
    HYFriendGroupItem* groupItem = self.groups[indexPath.section];
    HYUserInfo* item = groupItem.items[indexPath.row];
    cell.userInfo = item;
    return cell;
}

#pragma mark - tableDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55;
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    HYFriendGroupItem* groupItem = self.groups[section];
    if (groupItem.items.count !=0) {
        return groupItem.header;
    } else {
        return nil;
    }
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView* bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 2.5*HYSearHimInset)];
    UILabel* titLa = [[UILabel alloc] initWithFrame:CGRectMake(HYSearHimInset, 0, 20, 2.5*HYSearHimInset)];
    [bgView addSubview:titLa];
    HYFriendGroupItem* groupItem = self.groups[section];
    titLa.text = groupItem.header;
    titLa.textColor = [UIColor lightGrayColor];
    if (groupItem.items.count !=0) {
        return bgView;
    } else {
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    HYFriendGroupItem* groupItem = self.groups[section];
    if (groupItem.items.count !=0) {
        return 2.5*HYSearHimInset;
    } else {
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}

@end
