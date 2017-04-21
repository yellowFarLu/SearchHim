//
//  UserCalloutView.h
//  JLUFind
//
//  Created by 久保謙 on 2016/03/18.
//  Copyright © 2016年 Yakoresya. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define kPortraitMargin     5
#define kPortraitWidth      50
#define kPortraitHeight     50

#define kTitleWidth         120
#define kTitleHeight        20

//@class MAPointAnnotation;

@protocol userCalloutViewDelegate <NSObject>

- (void)startChat:(NSString*)clientId;

@end




@interface UserCalloutView : UIView

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, strong) UIImageView *portraitView;
@property (nonatomic, strong) UILabel *subtitleLabel;
@property (nonatomic, strong) UILabel *titleLabel;


@property (nonatomic, weak) id<userCalloutViewDelegate> delegate;

//@property (nonatomic, strong) MAPointAnnotation* annotation;




@end
