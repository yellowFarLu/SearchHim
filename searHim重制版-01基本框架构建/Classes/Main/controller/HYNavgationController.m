//
//  HYNavgationController.m
//  searHim重制版-01基本框架构建
//
//  Created by 黄远 on 16/7/4.
//  Copyright © 2016年 黄远. All rights reserved.
//

#import "HYNavgationController.h"
#import "HYLoginViewController.h"
#import "HYTabBarController.h"
#import "HYShowInfoController.h"
#import "HYSingleChatViewController.h"
#import "HYCardController.h"
#import "HYAlertInfoController.h"
#import "NavigationInteractiveTransition.h"
#import "HYBaseFriendListController.h"
#import "HYNewFriendRequestController.h"
#import "HYRegisterViewController.h"

@interface HYNavgationController () <UIGestureRecognizerDelegate>
@property (nonatomic, strong) NavigationInteractiveTransition *navT;
@end

@implementation HYNavgationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIGestureRecognizer *gesture = self.interactivePopGestureRecognizer;
    gesture.enabled = NO;
    UIView *gestureView = gesture.view;
    
    UIPanGestureRecognizer *popRecognizer = [[UIPanGestureRecognizer alloc] init];
    popRecognizer.delegate = self;
    popRecognizer.maximumNumberOfTouches = 1;
    [gestureView addGestureRecognizer:popRecognizer];

    _navT = [[NavigationInteractiveTransition alloc] initWithViewController:self];
    [popRecognizer addTarget:_navT action:@selector(handleControllerPop:)];
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    //新的朋友请求界面也不允许执行
    UIViewController* vc = self.topViewController;
    if ([vc isKindOfClass:[HYNewFriendRequestController class]]) {
        return NO;
    }
    
    if ([vc isKindOfClass:[HYRegisterViewController class]]) {
        return NO;
    }
    
    /**
     *  这里有两个条件不允许手势执行，1、当前控制器为根控制器；2、如果这个push、pop动画正在执行（私有属性）
     */
    return self.viewControllers.count != 1 && ![[self valueForKey:@"_isTransitioning"] boolValue];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    [super pushViewController:viewController animated:YES];
    if ([viewController isKindOfClass:[HYLoginViewController class]]) {
        self.navigationBar.hidden = YES;
    }else{
        self.navigationBar.hidden = NO;
    }
    
    if ([viewController isKindOfClass:[HYShowInfoController class]] || [viewController isKindOfClass:[HYSingleChatViewController class]] || [HYCardController class]) {
        HYTabBarController* tabBarVC = (HYTabBarController*)self.tabBarController;
        [tabBarVC hiddenTabBar];
    }
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated{
    HYTabBarController* tabBarVC = (HYTabBarController*)self.tabBarController;
    [tabBarVC showTabBar];
    
    UIViewController* vc = [super popViewControllerAnimated:YES];
    if ([vc isKindOfClass:[HYCardController class]]) {
        [tabBarVC hiddenTabBar];
    }
    
    if ([vc isKindOfClass:[HYAlertInfoController class]] || [vc isKindOfClass:[HYBaseFriendListController class]]) {
        [tabBarVC hiddenTabBar];
    }
    
    UIViewController* currVc = self.topViewController;
    if ([vc isKindOfClass:[HYShowInfoController class]] && [currVc isKindOfClass:[HYSingleChatViewController class]]) {
        [tabBarVC hiddenTabBar];
    }
    
    return vc;
}

/**
 *  当第一次使用这个类的时候调用1次
 */
+ (void)initialize
{
    // 设置UINavigationBarTheme的主
    [self setupNavigationBarTheme];
    
    // 设置UIBarButtonItem的主题
    [self setupBarButtonItemTheme];
}



/**
 *  设置UINavigationBarTheme的主题
 */
+ (void)setupNavigationBarTheme
{
    UINavigationBar *appearance = [UINavigationBar appearance];
    
    // 设置导航栏背景
    [appearance setBackgroundImage:[UIImage resizeImageWithOriginalName:@"timeline_card_bottom_background"] forBarMetrics:UIBarMetricsDefault];
    
    // 设置文字属性
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = [UIColor whiteColor];
    // UITextAttributeFont  --> NSFontAttributeName(iOS7)
    textAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:18];
    // UIOffsetZero是结构体, 只要包装成NSValue对象, 才能放进字典\数组中
    textAttrs[UITextAttributeTextShadowOffset] = [NSValue valueWithUIOffset:UIOffsetZero];
    [appearance setTitleTextAttributes:textAttrs];
}

/**
 *  设置UIBarButtonItem的主题
 */
+ (void)setupBarButtonItemTheme
{
    // 通过appearance对象能修改整个项目中所有UIBarButtonItem的样式
    UIBarButtonItem *appearance = [UIBarButtonItem appearance];
    
    /**设置文字属性**/
    // 设置普通状态的文字属性
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = [UIColor whiteColor];
    textAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:15];
    textAttrs[UITextAttributeTextShadowOffset] = [NSValue valueWithUIOffset:UIOffsetZero];
    [appearance setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    
    // 设置高亮状态的文字属性
    NSMutableDictionary *highTextAttrs = [NSMutableDictionary dictionaryWithDictionary:textAttrs];
    highTextAttrs[NSForegroundColorAttributeName] = [UIColor redColor];
    [appearance setTitleTextAttributes:highTextAttrs forState:UIControlStateHighlighted];
    
    // 设置不可用状态(disable)的文字属性
    NSMutableDictionary *disableTextAttrs = [NSMutableDictionary dictionaryWithDictionary:textAttrs];
    disableTextAttrs[NSForegroundColorAttributeName] = [UIColor lightGrayColor];
    [appearance setTitleTextAttributes:disableTextAttrs forState:UIControlStateDisabled];
    
    //设置选中状态文字
    NSMutableDictionary *selectedTextAttrs = [NSMutableDictionary dictionaryWithDictionary:disableTextAttrs];
    selectedTextAttrs[NSForegroundColorAttributeName] = backBtnColor;
    [appearance setTitleTextAttributes:selectedTextAttrs forState:UIControlStateSelected];
    
    /**设置背景**/
    // 技巧: 为了让某个按钮的背景消失, 可以设置一张完全透明的背景图片
    [appearance setBackgroundImage:[UIImage imageNamed:@"navigationbar_button_background"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
}



@end
