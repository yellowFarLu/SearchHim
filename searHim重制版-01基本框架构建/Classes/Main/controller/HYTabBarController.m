//
//  HYTabBarController.m
//  searHim重制版-01基本框架构建
//
//  Created by 黄远 on 16/7/4.
//  Copyright © 2016年 黄远. All rights reserved.
//

#import "HYTabBarController.h"
#import "HYTabBar.h"
#import "HYCurrentMsgController.h"
#import "HYFriendListController.h"
#import "HYDiscoverViewController.h"
#import "HYNavgationController.h"
#import "HYMapKitControllerViewController.h"
#import "HYCurrentClient.h"
#define HYDidChangeVCatIndex @"改变控制器"

@interface HYTabBarController () <HYTabBarDelegate>
@property (nonatomic, weak) HYTabBar* tcustomTabBar;
@property (nonatomic, strong) NSMutableArray* items;

@end

@implementation HYTabBarController

- (void)hiddenTabBar{
    self.tcustomTabBar.hidden = YES;
}

- (void)showTabBar{
    self.tcustomTabBar.hidden = NO;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    //添加子控制器
    [self setUpAllChildViewController];
    //自定义tabBar
    [self setTabBar];
}



//- (void)setupGes{
//    //添加左右滑动手势pan
//    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
//    [self.view addGestureRecognizer:pan];
//}

//左右滑动切换视图，第0个和最后一个切换特殊处理
#define time 0.2f
//#pragma mark Pan手势
//- (void) handlePan:(UIPanGestureRecognizer*)recongizer{
//    NSUInteger index = [self.tabBarController selectedIndex];
//    CGPoint point = [recongizer translationInView:self.view];
//    
//    recongizer.view.center = CGPointMake(recongizer.view.center.x + point.x, recongizer.view.center.y);
//    [recongizer setTranslation:CGPointMake(0, 0) inView:self.view];
//    
//    if (recongizer.state == UIGestureRecognizerStateEnded) {
//        if (recongizer.view.center.x < [UIScreen mainScreen].bounds.size.width && recongizer.view.center.x > 0 ) {
//            [UIView animateWithDuration:time delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
//                recongizer.view.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2 ,[UIScreen mainScreen].bounds.size.height/2);
//            }completion:^(BOOL finished) {
//                
//            }];
//        } else if (recongizer.view.center.x <= 0 ){
//            [UIView animateWithDuration:time delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
//                recongizer.view.center = CGPointMake(-[UIScreen mainScreen].bounds.size.width/2 ,[UIScreen mainScreen].bounds.size.height/2);
//            }completion:^(BOOL finished) {
//                [self changWithSelectedIndex:(int)index+1];
//                recongizer.view.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2 ,[UIScreen mainScreen].bounds.size.height/2);
//            }];
//        } else {
//            [UIView animateWithDuration:time delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
//                recongizer.view.center = CGPointMake([UIScreen mainScreen].bounds.size.width*1.5 ,[UIScreen mainScreen].bounds.size.height/2);
//            }completion:^(BOOL finished) {
//                [self changWithSelectedIndex:(int)index-1];
//                recongizer.view.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2 ,[UIScreen mainScreen].bounds.size.height/2);
//            }];
//        }
//    }
//}

//改变tabBar的选中按钮
- (void)changWithSelectedIndex:(int)selectedIndex{
    [[NSNotificationCenter defaultCenter] postNotificationName:HYDidChangeVCatIndex object:nil userInfo:@{@"selectedIndex" : @(selectedIndex)}];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //添加监听
//    [self setupGes];
}

- (void)setTabBar{
    HYTabBar* tabBar = [[HYTabBar alloc] init];
    tabBar.frame = self.tabBar.frame;
    [self.view addSubview:tabBar];
    tabBar.delegate = self;
    tabBar.items = self.items;
    self.tcustomTabBar = tabBar;
    /*
     * 注意！！！
     如果不把原来的tabBar移除，原来的tabBar上会有默认的tabBarButton，从而影响界面
     */
    [self.tabBar removeFromSuperview];
}

- (void)setUpAllChildViewController{
    // 最近消息
    HYCurrentMsgController *currentMsgVC = [[HYCurrentMsgController alloc] init];
    HYCurrentClient* currentClient = [HYCurrentClient shareCurrentClient];
    currentClient.delegate = currentMsgVC;
    [self setUpOneChildViewController:currentMsgVC image:[UIImage imageNamed:@"tab_recent_nor"] selectedImage:[UIImage imageWithOriginalName:@"tab_recent_selected"] title:@"最近消息"];
    
    // 好友列表
    HYFriendListController *message = [[HYFriendListController alloc] init];
    [self setUpOneChildViewController:message image:[UIImage imageNamed:@"tab_buddy_nor"] selectedImage:[UIImage imageWithOriginalName:@"tab_buddy_selected"] title:@"通讯录"];
    
    // 地图
    HYMapKitControllerViewController *mapKitVC = [[HYMapKitControllerViewController alloc] init];
    [self setUpOneChildViewController:mapKitVC image:[UIImage imageNamed:@"tab_qworld_nor"] selectedImage:[UIImage imageWithOriginalName:@"tab_qworld_selected@2x02"] title:@"地图"];
    
    // 发现
    HYDiscoverViewController *discover = [[HYDiscoverViewController alloc] init];
    [self setUpOneChildViewController:discover image:[UIImage imageNamed:@"tabbar_discover"] selectedImage:[UIImage imageWithOriginalName:@"tabbar_discover_selected"] title:@"发现"];
}

#pragma mark - 添加一个子控制器
- (void)setUpOneChildViewController:(UIViewController *)vc image:(UIImage *)image selectedImage:(UIImage *)selectedImage title:(NSString *)title
{
    vc.title = title;
    vc.tabBarItem.image = image;
    vc.tabBarItem.selectedImage = selectedImage;
    
    // 保存tabBarItem模型到数组
    [self.items addObject:vc.tabBarItem];
    vc.view.backgroundColor = HYGlobalBg;
    HYNavgationController *nav = [[HYNavgationController alloc] initWithRootViewController:vc];
    [self addChildViewController:nav];
    
    if ([vc isKindOfClass:[HYDiscoverViewController class]]) {
        return;
    }
    //设置左上角设置按钮
    UIButton* moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [moreBtn setImage:[UIImage imageNamed:@"top_navigation_menuicon"] forState:UIControlStateNormal];
    [moreBtn addTarget:self action:@selector(onClickSetting:) forControlEvents:UIControlEventTouchUpInside];
    CGFloat moreBtnX, moreBtnY, moreBtnH, moreBtnW;
    moreBtnX = moreBtnY = 0;
    moreBtnH = HYBackBtnH;
    moreBtnW = HYBackBtnW;
    moreBtn.frame = CGRectMake(moreBtnX, moreBtnY, moreBtnW, moreBtnH);
    moreBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    moreBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -HYSearHimInset);
    vc.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:moreBtn];
}

#define HYMoveTabBar @"移动tabBar"
- (void)onClickSetting:(UIButton*)btn{
    //发通知让mainViewController移动tabbVC
    [[NSNotificationCenter defaultCenter] postNotificationName:HYMoveTabBar object:nil];
}


#pragma mark - HYTabBarDelegate
- (void)reloadSelectedVC:(HYTabBar *)tabBar WithIndex:(int)index{
    self.selectedIndex = index;
}


#pragma mark - 懒加载
- (NSMutableArray*)items{
    if (!_items) {
        _items= [NSMutableArray array];
    }
    return _items;
}



@end
