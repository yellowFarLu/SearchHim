//
//  HYAllEmotionView.m
//  新浪微博
//
//  Created by 黄远 on 16/6/16.
//  Copyright © 2016年 黄远. All rights reserved.
//

#import "HYEmotionListView.h"
#import "HYEmotionsView.h"
#import "UIImage+Exstension.h"

@interface HYEmotionListView ()<UIScrollViewDelegate>
@property (nonatomic, weak) UIScrollView* scrollView;
@property (nonatomic, weak) UIPageControl* pageControl;
@end


@implementation HYEmotionListView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        UIScrollView* scrollView = [[UIScrollView alloc] init];
        self.scrollView = scrollView;
        self.scrollView.pagingEnabled = YES;
//        self.scrollView.backgroundColor = [UIColor redColor];
        self.scrollView.delegate = self;
        self.scrollView.showsHorizontalScrollIndicator = NO;
        self.scrollView.showsVerticalScrollIndicator = NO;
        [self addSubview:scrollView];
        
        UIPageControl* pageControl = [[UIPageControl alloc] init];
        self.pageControl = pageControl;
//        self.pageControl.backgroundColor = [UIColor blueColor];
        [pageControl setValue:[UIImage imageNamed:@"compose_keyboard_dot_selected"] forKeyPath:@"_currentPageImage"];
        [pageControl setValue:[UIImage imageNamed:@"compose_keyboard_dot_normal"] forKeyPath:@"_pageImage"];
        [self addSubview:self.pageControl];
        pageControl.currentPage = 0;
    }
    return self;
}

-(void)setEmotions:(NSArray *)emotions{
    _emotions = emotions;
    int pageCount;
    if (emotions.count % emotionPageMaxCount == 0) {
        pageCount = (int)emotions.count / emotionPageMaxCount;
    }else{
        pageCount = (int)(emotions.count / emotionPageMaxCount + 1);
    }
//    HYLog(@"%ld", emotions.count);

    
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    //创建对应页数的HYEmotionsView
    int loc;
    int len = 20;
    for (int i=0; i<pageCount; i++) {
        HYEmotionsView* emotionsView = nil;
        if (i < self.scrollView.subviews.count) {
            emotionsView = self.scrollView.subviews[i];
        } else {
            emotionsView = [[HYEmotionsView alloc] init];
            [self.scrollView addSubview:emotionsView];
        }
        
        loc = i * len;
        if ((loc + len) > _emotions.count) {
            len = (int)(_emotions.count - loc);
        }
        NSRange range = NSMakeRange(loc, len);
        NSArray* currentEmotionsArray = [_emotions subarrayWithRange:range];
        emotionsView.currentEmotions = currentEmotionsArray;
        
        emotionsView.hidden = NO;
    }
    
    for (int i=pageCount; i<self.scrollView.subviews.count; i++) {
        HYEmotionsView* emotionsView = self.scrollView.subviews[i];
        emotionsView.hidden = YES;
    }
    
    self.pageControl.numberOfPages = pageCount;
    self.pageControl.hidden = pageCount == 1;
    self.scrollView.contentOffset = CGPointZero;
    
    [self setNeedsLayout];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.pageControl.width = mainScreenWid;
    self.pageControl.height = 30;
    self.pageControl.x = 0;
    self.pageControl.y = self.height - self.pageControl.height;
    
    self.scrollView.x = 0;
    self.scrollView.y = 0;
    self.scrollView.height = self.pageControl.y;
    self.scrollView.width = mainScreenWid;
    int count = (int)self.pageControl.numberOfPages;
    self.scrollView.contentSize = CGSizeMake(count*mainScreenWid, self.scrollView.height);
    
    //设置scrollVIew的子控件
    for (int i = 0; i<count; i++) {
        HYEmotionsView * emotionsView = self.scrollView.subviews[i];
        emotionsView.width = self.scrollView.width;
        emotionsView.height = self.scrollView.height;
        emotionsView.x = i * emotionsView.width;
        emotionsView.y = 0;
    }
}


#pragma mark - scrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    HYLog(@"%f", scrollView.contentOffset.x);
    self.pageControl.currentPage = (int)(scrollView.contentOffset.x/self.scrollView.width + 0.5);
}


- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    
    [[UIImage resizeImageWithOriginalName:@"emoticon_keyboard_background"] drawInRect:rect];
}





@end
