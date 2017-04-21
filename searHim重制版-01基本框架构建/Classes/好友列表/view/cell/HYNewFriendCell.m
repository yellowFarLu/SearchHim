//
//  HYNewFriendCell.m
//  searHim重制版-01基本框架构建
//
//  Created by 黄远 on 16/7/11.
//  Copyright © 2016年 黄远. All rights reserved.
//

#import "HYNewFriendCell.h"
#import "UIImageView+WebCache.h"
#import "HYNewFriendItem.h"
#import <AVUser.h>
#import <AVStatus.h>
#import "HYUserInfo.h"
#import "HYStatusTool.h"
#import "HYUserInfoTool.h"
#import "HYParamters.h"
#define HYAddNewFriendReloadUI @"添加新朋友了，刷新UI"

@interface HYNewFriendCell ()
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *usernameLable;
@property (weak, nonatomic) IBOutlet UILabel *decripionLable;
@property (weak, nonatomic) IBOutlet UIButton *receiverBtn;
- (IBAction)onClickReceive:(UIButton *)sender;
@property (nonatomic, strong) NSOperationQueue* queue;
@property (nonatomic, weak) UIView* diver;
@end

@implementation HYNewFriendCell

- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat diverX, diverY, diverWid, diverHei;
    diverX = HYSearHimInset;
    diverWid = self.width - 2*HYSearHimInset;
    diverHei = 1;
    diverY = self.height - diverHei;
    self.diver.frame = CGRectMake(diverX, diverY, diverWid, diverHei);
}

- (NSOperationQueue*)queue{
    if (!_queue) {
        _queue = [[NSOperationQueue alloc] init];
    }
    return _queue;
}

- (UIView*)diver{
    if (!_diver) {
        //设置分割线
        UIView* MyView = [[UIView alloc] init];
        MyView.backgroundColor = [UIColor lightGrayColor];
        MyView.alpha = 0.7;
        [self addSubview:MyView];
        _diver = MyView;
    }
    return _diver;
}

- (void)setFriendItem:(HYNewFriendItem *)friendItem{
    _friendItem = friendItem;
    [self.icon sd_setImageWithURL:[NSURL URLWithString:friendItem.iconUrl] placeholderImage:[UIImage imageNamed:@"me"]];
    self.usernameLable.text= friendItem.username;
    self.decripionLable.text = friendItem.decription;
    if ([friendItem.type isEqualToString:@"requested"]) {
        //先根据数据库判断,让UI显示出来
        if ([friendItem.isAgree isEqualToString:@"agree"]) {
            [self setupReceiveBtn];
        }else{
            [self.receiverBtn setTitle:@"接受" forState:UIControlStateNormal];
            self.receiverBtn.enabled = YES;
            self.receiverBtn.alpha = 1.0;
        }

        
        //第一次数据库没有数据，可能那人已经是你的朋友，因此不用点击添加，然后又再发送（同意回复）
        //同时，就算数据库有这个朋友的数据，实际上可能在别的手机上已经删除了这个朋友
        [[AVUser currentUser] getFollowees:^(NSArray *objects, NSError *error) {
            for (AVUser*user in objects) {
                //已经是朋友
                if ([friendItem.objId isEqualToString:user.objectId]) {
                    [self setupReceiveBtn];
                    //把这个朋友存入数据库(在工具类中判断数据库里面是否有这个朋友)
                    HYUserInfo* userInfo = [HYUserInfo initOfUser:user];
                    HYParamters* param = [[HYParamters alloc] init];
                    param.username = [AVUser currentUser].username;
                    [HYUserInfoTool saveFriendInDB:userInfo WithParamter:param];
                    
                    [self.queue addOperationWithBlock:^{
                        //更新为已同意
                        [HYStatusTool saveWithItem:self.friendItem];
                    }];
                    
                    return;
                }
            }
            
            if (objects.count == 0) { //可能在别的手机上已经删除了这个朋友,在本地数据库删除这个朋友
                HYUserInfo* userInfo = [[HYUserInfo alloc] init];
                userInfo.objectId = friendItem.objId;
                HYParamters* param = [[HYParamters alloc] init];
                param.username = [AVUser currentUser].username;
                [HYUserInfoTool deleteFriendFromDB:userInfo WithParamter:param];
            }

        }];
    }else {
        if (friendItem.objId) {
            AVQuery* query = [AVQuery queryWithClassName:@"_User"];
            [query whereKey:@"objectId" equalTo:friendItem.objId];
            [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                if (objects.count == 0) {
                    return;
                }
                NSDictionary* userDict = [objects firstObject];
                HYUserInfo* userInfo = [HYUserInfo initOfDict:userDict];
                //别人发来received，表明别人答应了你的请求，将这个人的信息写入数据库中的friendTable中
                HYParamters* paramters = [[HYParamters alloc] init];
                paramters.username = [AVUser currentUser].username;
                [HYUserInfoTool saveFriendInDB:userInfo WithParamter:paramters];
                
                // 别人点击同意了,我应该加他为好友
                [[AVUser currentUser] follow:userInfo.objectId andCallback:^(BOOL succeeded, NSError * _Nullable error) {
                    //发送通知，让通讯录界面刷新
                    [[NSNotificationCenter defaultCenter] postNotificationName:HYAddNewFriendReloadUI object:nil];
                }];
            }];

        }
        
        //我发了请求并关注了他，他回复receive，我才加为好友
        //因此每次接受请求要看是否我还在关注他，还在关注他才加他为好友
        [[AVUser currentUser] getFollowees:^(NSArray *objects, NSError *error) {
            if (objects.count == 0) {
                return;
            }
            
            for (AVUser*user in objects) {
                if ([user.objectId isEqualToString:friendItem.objId]) {
                    [[AVUser currentUser] follow:friendItem.objId andCallback:^(BOOL succeeded, NSError *error) {
                        if (succeeded) {
                            HYLog(@"添加好友成功");
                            [self setupReceiveBtn];
                        }
                    }];

                }
            }
        }];
    }
}

- (void)setupReceiveBtn{
    [self.receiverBtn setTitle:@"已同意" forState:UIControlStateNormal];
    self.receiverBtn.enabled = NO;
    self.receiverBtn.alpha = 0.6;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.receiverBtn.layer.cornerRadius = HYCornerRadius;
    self.receiverBtn.backgroundColor = backBtnColor;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.receiverBtn.enabled = NO;
}

+ (instancetype)newFriendCell{
    return [[[NSBundle mainBundle] loadNibNamed:@"newFriendCell" owner:nil options:nil] lastObject];
}

- (IBAction)onClickReceive:(UIButton *)sender {
    //点击修改以后，要把用户同意 / 已发送 状态写入数据库，方便下次从数据库里面读取
    if ([self.friendItem.type isEqualToString:@"requested"]) {
        self.friendItem.isAgree = @"agree";
        //把这个请求状态写入数据库
        [HYStatusTool saveWithItem:self.friendItem];
        
        AVQuery* query = [AVQuery queryWithClassName:@"_User"];
        if (self.friendItem.objId) {
            [query whereKey:@"objectId" equalTo:self.friendItem.objId];
            [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                if (objects.count == 0) {
                    return;
                }
                NSDictionary* userDict = [objects firstObject];
                HYUserInfo* userInfo = [HYUserInfo initOfDict:userDict];
                
                //点击了接收，添加新的朋友进入数据库
                [self.queue addOperationWithBlock:^{
                    HYParamters* paramters = [[HYParamters alloc] init];
                    paramters.username = [AVUser currentUser].username;
                    [HYUserInfoTool saveFriendInDB:userInfo WithParamter:paramters];
                    
                    //发送通知，让通讯录界面刷新
                    [[NSNotificationCenter defaultCenter] postNotificationName:HYAddNewFriendReloadUI object:nil];
                }];
                
            }];
        }
      
        
        
        [[AVUser currentUser] follow:self.friendItem.objId andCallback:^(BOOL succeeded, NSError *error) {
            [self setupReceiveBtn];
            AppDelegate* appD = (AppDelegate*)[UIApplication sharedApplication].delegate;
            AVStatus *status=[[AVStatus alloc] init];
            status.data=@{ @"username" : [AVUser currentUser].username,
                           @"type": @"received",
                           @"iconUrl" : appD.imUserInfo.iconUrl,
                           @"objId" : [AVUser currentUser].objectId
                           };
            
            if (self.friendItem.objId) {
                [AVStatus sendPrivateStatus:status toUserWithID:self.friendItem.objId andCallback:^(BOOL succeeded, NSError *error) {
                    [MBProgressHUD hideHUD];
                    if (succeeded) {
                        
                    } else {
                        HYLog(@"============ Send %@", error);
                    }
                    
                    HYLog(@"============ Send %@", [status debugDescription]);
                }];
                

            }
        }];

    }
}



@end
