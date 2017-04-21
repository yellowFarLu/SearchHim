//
//  HYTabBar.m
//  新浪微博
//
//  Created by 黄远 on 16/5/27.
//  Copyright © 2016年 黄远. All rights reserved.
//

#import "HYTabBar.h"
#import "HYCustomButtom.h"
#define HYNewStatus @"来新的请求了"
#define HYUserHasSeeStatus @"用户已经查看请求了"
#define HYUnreadCount @"未读消息数"
#define HYDidChangeVCatIndex @"改变控制器"

@interface HYTabBar ()
@property (nonatomic, weak) HYCustomButtom* preBtn;
@property (nonatomic, strong) NSMutableArray* btnArr;
@end


@implementation HYTabBar

- (NSMutableArray*)btnArr{
    if (!_btnArr) {
        _btnArr = [NSMutableArray array];
    }
    return _btnArr;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tabbar_background"]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getNewStatus:) name:HYNewStatus object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hasSeeStatus) name:HYUserHasSeeStatus object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getUnreadCount:) name:HYUnreadCount object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getSelectedIndex:) name:HYDidChangeVCatIndex object:nil];
    return self;
}

- (void)getSelectedIndex:(NSNotification*)nofi{
    NSNumber* num = nofi.userInfo[@"selectedIndex"];
    NSInteger selectedIndex = num.integerValue;
    [self onSelected:self.btnArr[selectedIndex]];
}

- (void)getUnreadCount:(NSNotification*)notification{
    NSNumber* unreadCount = notification.userInfo[@"unreadCount"];

    for (HYCustomButtom* btn in self.subviews) {
        if ([btn isKindOfClass:NSClassFromString(@"UIButton")]) {
            if (btn.tag == btnTypeCurrentMsg) {
                if (unreadCount.integerValue == 0) {
                    btn.bdgeBtn.hidden = YES;
                    break;
                }
                NSString* temStr = [NSString stringWithFormat:@"%@", unreadCount];
                if (unreadCount.integerValue > 10) {
                    temStr = @"...";
                }
                [btn.bdgeBtn setTitle:temStr forState:UIControlStateNormal];
                btn.bdgeBtn.hidden = NO;
                break;
            }
        }
    }

}

- (void)hasSeeStatus{
    for (HYCustomButtom* btn in self.subviews) {
        if ([btn isKindOfClass:[UIButton class]]) {
            if (btn.tag == btnTypeFriendList) {
                [UIView animateWithDuration:0.2 animations:^{
                    btn.bdgeBtn.hidden = YES;
                }];
                break;
            }
        }
    }

}

- (void)getNewStatus:(NSNotification*)notification{
    for (HYCustomButtom* btn in self.subviews) {
        if ([btn isKindOfClass:NSClassFromString(@"UIButton")]) {
            if (btn.tag == btnTypeFriendList) {
                NSMutableArray* arr = notification.userInfo[@"newStatus"];
                NSUInteger count = arr.count;
                NSString* temStr = [NSString stringWithFormat:@"%@", @(count)];
                if (count > 10) {
                    temStr = @"...";
                }
                
                [btn.bdgeBtn setTitle:temStr forState:UIControlStateNormal];
                btn.bdgeBtn.hidden = NO;
                break;
            }
        }
    }
}

- (void)setItems:(NSMutableArray *)items{
    _items = items;
    UITabBarItem* item1 = items[0];
    self.imaSize = item1.image.size;
    for (int i=0; i<items.count; i++) {
        HYCustomButtom* btn = [HYCustomButtom buttonWithType:UIButtonTypeCustom];
        UITabBarItem* item = items[i];
        [btn setTitle:item.title forState:UIControlStateNormal];
        [btn setImage:item.image forState:UIControlStateNormal];
        [btn setImage:item.selectedImage forState:UIControlStateSelected];
        btn.item = item;
        btn.tag = i;
        if (btn.tag == 0) {
            btn.selected = YES;
            self.preBtn = btn;
        }
//        btn.backgroundColor = [UIColor redColor];
        [btn addTarget:self action:@selector(onSelected:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        [self.btnArr addObject:btn];
    }

}


- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat x,y,w,h;
    y = 0;
    w = self.frame.size.width / self.items.count;
//    h = self.frame.size.height;
    h = self.frame.size.height;
    
    int index = 0;
    for (UIButton* btn in self.subviews) {
        if ([btn isKindOfClass:NSClassFromString(@"UIButton")]) {
            x = w * index;
            btn.frame = CGRectMake(x, y, w, h);
            index++;
        }
    }
    
}

- (void)onSelected:(HYCustomButtom*)btn{
    if (self.preBtn) {
        self.preBtn.selected = NO;
    }
    
    btn.selected = YES;
    self.preBtn = btn;
    
    //调用代理方法
    if ([self.delegate respondsToSelector:@selector(reloadSelectedVC: WithIndex:)]) {
        [self.delegate reloadSelectedVC:self WithIndex:(int)btn.tag];
    }
}





@end
