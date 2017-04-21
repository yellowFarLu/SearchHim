//
//  HYSearchResultController.h
//  searHim重制版-01基本框架构建
//
//  Created by 黄远 on 16/10/24.
//  Copyright © 2016年 黄远. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HYSearchResult;

@protocol HYSearchResultControllerDeleagte <NSObject>

- (void)didSelectedUserInfo:(HYSearchResult*)searchResult;

@end


@interface HYSearchResultController : UITableViewController

@property (nonatomic, strong) NSArray* group;

@property (nonatomic, weak) id<HYSearchResultControllerDeleagte> delegate;

@end
