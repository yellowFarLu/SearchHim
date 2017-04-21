//
//  HYBottomAlertView.m
//  searHim重制版-01基本框架构建
//
//  Created by 黄远 on 16/7/10.
//  Copyright © 2016年 黄远. All rights reserved.
//

#import "HYBottomAlertView.h"
#define descrptionCount 108
#define btnCount 6
#define HYRamderColor [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1.0]

@interface HYBottomAlertView ()

@property (nonatomic, strong) NSMutableArray* descrption;

@property (nonatomic, strong) NSMutableArray* btnArr;

//换一批按钮
@property (nonatomic, weak) UIButton* changeBtn;
@end

@implementation HYBottomAlertView

- (NSMutableArray*)btnArr{
    if (!_btnArr) {
        _btnArr = [NSMutableArray array];
    }
    return _btnArr;
}

-(NSMutableArray *)descrption{
    if (!_descrption) {
        _descrption = [NSMutableArray arrayWithArray:@[@"温柔", @"有责任感", @"有男子汉气质", @"有上进心", @"自信", @"机灵", @"诚实", @"善良", @"乐于助人", @"助人为乐", @"诚恳", @"朴素", @"帅气", @"美人胚", @"优雅", @"纯朴", @"稚气", @"俊秀", @"清秀", @"可爱", @"楚楚动人", @"贤淑贤惠", @"聪颖", @"灵秀", @"俊俏", @"俊美", @"美丽", @"大方", @"温柔", @"可人", @"单纯", @"纯洁", @"纯洁", @"娇美", @"成熟", @"雅致", @"体贴", @"清纯可人", @"娇小玲珑", @"豪爽", @"无私", @"精明", @"憨厚", @"高大威武", @"阳光男孩", @"大叔", @"宅男", @"歌声", @"文采彬彬", @"虎背熊腰", @"精明能干", @"懂得疼我", @"怜花惜玉", @"羞涩", @"内敛", @"绅士风度", @"正气凛然", @"会弹吉他", @"钢琴王子", @"二胡老手", @"K歌之王", @"爱好运动", @"运动少年", @"丰满", @"可爱的小酒窝", @"肌肉男", @"猴头猴脑", @"风流倜傥", @"博学多才", @"体贴入微", @"俊俏", @"积极进取", @"豪放不羁", @"健谈", @"好聊天", @"善解人意", @"处事洒脱", @"唯爱我", @"专注", @"只得一人心", @"秀外慧中", @"知书达理", @"贤淑", @"居家好男人", @"端庄娴雅", @"仪态优美", @"楚楚动人", @"细腻", @"亭亭玉立", @"会开导人", @"平易近人", @"妖媚", @"性感", @"女强人", @"冷艳", @"奇幻", @"独立自强", @"无与伦比", @"乐观", @"爱唠叨", @"易于相处", @"啥都行", @"随和", @"小鸟伊人", @"一笑千金", @"五官整洁", @"有一定薪资", @"外貌协会"]];
    }
    return _descrption;
}


- (instancetype)init{
    if (self = [super init]) {
        for (int i=0; i < btnCount; i++) {
            UIButton* btn = [[UIButton alloc] init];
            [btn setTitle:self.descrption[i] forState:UIControlStateNormal];
            [btn setTitleColor:HYRamderColor forState:UIControlStateNormal];
            
            [btn addTarget:self action:@selector(didSelectedBtn:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btn];
            [self.btnArr addObject:btn];
        }
        
        UIButton* changeBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [changeBtn setTitle:@"换一批?" forState:UIControlStateNormal];
        [changeBtn setTitleColor:backBtnColor forState:UIControlStateNormal];
        [changeBtn addTarget:self action:@selector(chang) forControlEvents:UIControlEventTouchUpInside];
        changeBtn.alpha = 0.6;
        [self addSubview:changeBtn];
        self.changeBtn = changeBtn;
    }
    return self;
}

//换一批
- (void)chang{
    
    UIButton* btn = nil;
    int from = arc4random_uniform(descrptionCount);
    int j = from;
    for (int i=0; i<btnCount; i++, j++) {
        btn = self.btnArr[i];
        if (j >= descrptionCount) {
            j = j%descrptionCount;
        }
        [btn setTitle:self.descrption[j] forState:UIControlStateNormal];
        [btn setTitleColor:HYRamderColor forState:UIControlStateNormal];
        btn.enabled = YES;
    }
}

- (void)didSelectedBtn:(UIButton*)btn{
    btn.enabled = NO;
    if ([self.delegate respondsToSelector:@selector(bottomAlertView:didSelectedBtnTitlte:)]) {
        NSString* tem = [NSString stringWithFormat:@"%@ ", btn.currentTitle];
        [self.delegate bottomAlertView:self didSelectedBtnTitlte:tem];
    }
}


- (void)layoutSubviews{
    [super layoutSubviews];
    int col = 3;
    CGFloat margin = HYSearHimInset;
    CGFloat btnX, btnY, btnWid, btnHei;
    btnHei = 44;
    btnWid = (self.width - (col+1)*margin)/col;
    for (int i=0; i < self.btnArr.count; i++) {
        UIButton* btn = self.btnArr[i];
        btnX = margin + (i%col)*(btnWid + margin);
        btnY = (i/col)*(btnHei + margin*0.5);
        btn.frame = CGRectMake(btnX, btnY, btnWid, btnHei);
    }
    
    self.changeBtn.frame = CGRectMake(self.width - btnWid, self.height - btnHei, btnWid, btnHei);
}







@end
