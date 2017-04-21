//
//  HYMapKitControllerViewController.m
//  searHim重制版-01基本框架构建
//
//  Created by 黄远 on 16/7/5.
//  Copyright © 2016年 黄远. All rights reserved.
//

#import "HYMapKitControllerViewController.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapFoundationKit/AMapServices.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import <AVUser.h>
#import "HYUserInfo.h"
#import "CustomAnnotationView.h"
#import <AVFile.h>
#import <AVQuery.h>
#import "HYFriendInfoController.h"
#import "HYOtherInfoController.h"
#import "HYImInfoController.h"
#import "HYUserInfoTool.h"
#import "HYCustomAnnotation.h"
#import "HYNetTool.h"
#import "HYSortAnnotationViewModel.h"
#import "HYSearchBg.h"
#import <AVQuery.h>
#import "HYSearchParam.h"
#import "HYSearchResult.h"
#import "HYSearchResultController.h"
#import "HYNavgationController.h"

#define wifeSize 100
#define noWifeSize 50
#define bgMarign 150
#define HYZoomLevel 20.0

#define APIKey @"c27d8c6bf22b2e0494938cb4af504a18"

@interface HYMapKitControllerViewController ()<MAMapViewDelegate, AMapNearbySearchManagerDelegate, AMapSearchDelegate, HYSearchBgDelegate, HYSearchResultControllerDeleagte>
{
    MAMapView *_mapView;
    BOOL located;
    UIButton *_locationButton;
    AMapNearbySearchManager *_nearbyManager;
    AMapNearbySearchRequest *request;
    AMapSearchAPI *searchAPI;
    CLLocation *checkinLocation;
    NSString *userId;
    NSString *tempId;
    NSString *tempURL;
    MAPointAnnotation* userAnnotation; // 当前用户的标注
    HYNavgationController* searchNav;
}

 // 是否展示我的位置
@property (nonatomic, assign) Boolean isShowLocation;
// 是否显示用户个人信息在地图上
@property (nonatomic, strong) UIAlertController* alertVC;
/** 加号按钮 */
@property (nonatomic, weak) UIButton* addBtn;
/** 是否选择了附近用户 */
@property (nonatomic, assign) BOOL showSelectedUser;
/** 附近用户的名称 */
@property (nonatomic, copy) NSString* selectedName;

@end

@implementation HYMapKitControllerViewController

#pragma mark - userCalloutViewDelegate
- (void)startChat:(NSString*)clientId{
    //查看clientId来判断是展示自己的信息，还是朋友信息，还是陌生人的信息
    AppDelegate* appD = (AppDelegate*)[UIApplication sharedApplication].delegate;
    if ([clientId isEqualToString:[AVUser currentUser].username]) {
        HYImInfoController* imVC = [[HYImInfoController alloc] init];
        imVC.imUsrInfo = appD.imUserInfo;
        [self.navigationController pushViewController:imVC animated:YES];
        return;
    }
    
    
    [HYUserInfoTool loadAllFriendInfoWithParamters:nil success:^(HYResponseObject *responseObject) {
        HYUserInfo* friendUserInfo = nil;
        for (HYUserInfo* userInfo in responseObject.resultInfo) {
            if ([userInfo.username isEqualToString:clientId]) {
                friendUserInfo = userInfo;
                HYFriendInfoController* friendInfoVC = [[HYFriendInfoController alloc] init];
                friendInfoVC.imUsrInfo = friendUserInfo;
                [self.navigationController pushViewController:friendInfoVC animated:YES];
                return;
            }
        }
        
        if (!friendUserInfo) {
//            AppDelegate* appD = [UIApplication sharedApplication].delegate;
//            for (HYUserInfo* userInfo in appD.allUserInfo) {
//                if ([userInfo.username isEqualToString:clientId]) {
//                }
//            }
            AVQuery* query = [AVQuery queryWithClassName:@"_User"];
            [query whereKey:@"objectId" equalTo:clientId];
            [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                if (objects.count == 0) {
                    return;
                }
                NSDictionary* userDict = [objects firstObject];
                HYUserInfo* userInfo = [HYUserInfo initOfDict:userDict];
                HYOtherInfoController* otherVC = [[HYOtherInfoController alloc] init];
                otherVC.imUsrInfo = userInfo;
                [self.navigationController pushViewController:otherVC animated:YES];

            }];
        }
        
    } failure:^(NSError *error) {
        HYLog(@"%@", error);
        return;
    }];
    
    
    
}



-(void)onNearbyInfoUploadedWithError:(NSError *)error{//test
    HYLog(@"Error: %@", error);
}

#define userInfoHasGet @"使用者信息已经加载好了"
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"  Who Waitting For Search ?";
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hasGetUserInfo) name:userInfoHasGet object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hasResetLocationCfg:) name:@"改变是否展示我的位置" object:nil];
    self.isShowLocation = [[NSUserDefaults standardUserDefaults] boolForKey:@"isShowLocation"];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            // 提示用户地图显示相关
            [self setupIsShowInfo];
        });
    });
}



// 提示用户是否显示自己的位置信息
// 根据选择改变沙盒的内容 [[NSUserDefaults standardUserDefaults] boolForKey:@"isShowLocation"]
// 根据选择发送通知让地图刷新刷新界面
- (void)setupIsShowInfo{
    UIAlertController* alertVC = [UIAlertController alertControllerWithTitle:@"信息提示" message:@"是否允许共享您的位置"  preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    UIAlertAction *queAction = [UIAlertAction actionWithTitle:@"显示" style:UIAlertActionStyleDestructive handler:^(UIAlertAction* _Nonnull action){
        
        [[NSUserDefaults standardUserDefaults] setBool:true forKey:@"isShowLocation"];
        NSString* onStr = @"true";
        NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:onStr, @"isShowLocation",nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"改变是否展示我的位置" object:self userInfo:dict];
        [MBProgressHUD showSuccess:@"共享用户部分信息在地图上"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self setupSearchView];
        });
        
    }];
    
    UIAlertAction *notQueAction = [UIAlertAction actionWithTitle:@"隐藏" style:UIAlertActionStyleDestructive handler:^(UIAlertAction* _Nonnull action){
        
        [[NSUserDefaults standardUserDefaults] setBool:false forKey:@"isShowLocation"];
        NSString* onStr = @"false";
        NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:onStr, @"isShowLocation",nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"改变是否展示我的位置" object:self userInfo:dict];
        [MBProgressHUD showSuccess:@"隐藏用户信息"];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self setupSearchView];
        });
    }];
    
    
    
    [alertVC addAction:queAction];
    [alertVC addAction:notQueAction];
    [alertVC addAction:cancelAction];
    [self presentViewController:alertVC animated:YES completion:^{
        
    }];
    self.alertVC = alertVC;
}


#pragma mark - searchBg
/** 展示检索view */
- (void)setupSearchView{
    // 显示检索
    HYSearchBg* searchBg = [HYSearchBg searchBg];
    searchBg.delegate = self;
    [self.view addSubview:searchBg];
    [searchBg start];
}


- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)hasResetLocationCfg:(NSNotification*)nofi{
    NSString* isShowLocationStr = nofi.userInfo[@"isShowLocation"];
    self.isShowLocation = [isShowLocationStr isEqualToString:@"true"] ? true : false;
    if (!self.isShowLocation) {
        // 清除服务器中用户的信息
        [[AMapNearbySearchManager sharedInstance] clearUserInfoWithID:userId];
        [_mapView removeAnnotation:userAnnotation];
    } else {
        // 重新加载用户信息
        if (userAnnotation) {
            //判断是否添加过了，添加过了，就不再添加
            if (![_mapView viewForAnnotation:userAnnotation]) {
                [_mapView addAnnotation:userAnnotation];
                
            }
        } else {// 没有该用户信息的时候
            // 重新加载地图的人物信息
            [self initNearby];
        }
        
        if (!_locationButton) {
            [self initControls];
            [self initAddBtn];
        }
        [self locateAction];
    }
    
//    HYLog(@"是否显示 ------- %d", self.isShowLocation);
    _mapView.showsUserLocation = self.isShowLocation;

}

- (void)hasGetUserInfo{
    [_mapView removeFromSuperview];
    _mapView = nil;
    [_locationButton removeFromSuperview];
    _locationButton = nil;
    [_addBtn removeFromSuperview];
    _addBtn = nil;
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    userId = [AVUser currentUser].username;//get self userid
    tempId = userId;
    [self initMapView];
    [self initControls];
    [self initAddBtn];
    
    [self initNearby];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self locateAction];
    });
}

-(void)initNearby{
    _nearbyManager = [AMapNearbySearchManager sharedInstance];
    _nearbyManager.delegate = self;
}

/** 初始化定位按钮 */
-(void)initControls{
    if (_locationButton == nil) {
        _locationButton =[UIButton buttonWithType:UIButtonTypeCustom];
        _locationButton.frame = CGRectMake(20,CGRectGetHeight(_mapView.bounds)- 100,40,40);
        _locationButton.autoresizingMask=UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
        _locationButton.backgroundColor =[UIColor clearColor];
        _locationButton.layer.cornerRadius = 10;
        _locationButton.clipsToBounds = YES;
        
        [_locationButton addTarget:self action:@selector(locateAction) forControlEvents:UIControlEventTouchUpInside];
        [_locationButton setImage:[UIImage imageNamed:@"location"] forState:UIControlStateNormal];//图标
        [self.view addSubview:_locationButton];
    }
}

/** 初始化加号按钮 */
- (void)initAddBtn{
    if (!_addBtn) {
        UIButton* addBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        addBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        addBtn.frame = CGRectMake(20, CGRectGetHeight(_mapView.bounds)- 150, 40, 40);
        addBtn.autoresizingMask=UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
        addBtn.backgroundColor =[UIColor clearColor];
        addBtn.layer.cornerRadius = 10;
        addBtn.clipsToBounds = YES;
    
        [addBtn addTarget:self action:@selector(setupSearchView) forControlEvents:UIControlEventTouchUpInside];
        [addBtn setImage:[UIImage imageNamed:@"addImaForSearch"] forState:UIControlStateNormal];
        [self.view addSubview:addBtn];
        _addBtn = addBtn;
    }
}

// 左下角的按钮监听事件
- (void)locateAction{//定位按钮动作
    if(_mapView.userTrackingMode != MAUserTrackingModeFollow){
        [_mapView setUserTrackingMode:MAUserTrackingModeFollow animated:YES];
    }
    [UIView animateWithDuration:0.3 animations:^{
         [_mapView setCenterCoordinate:_mapView.userLocation.coordinate animated:YES];
    }];
   
    _mapView.zoomLevel=HYZoomLevel; //调整比例尺
}

#pragma mark - 初始化地图
- (void)initMapView{//初始化 画定位圆点
    if (!_mapView) {
        [AMapServices sharedServices].apiKey = APIKey;
        _mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds))];
        _mapView.delegate = self;
        _mapView.mapType = MAMapTypeStandard;
        [_mapView setZoomLevel:HYZoomLevel];//缩放范围
        [_mapView setCameraDegree:55.0];
        _mapView.showsUserLocation = YES; // 默认为显示
        [_mapView setUserTrackingMode: MAUserTrackingModeFollow animated:YES];
        [self.view addSubview:_mapView];
        located = false;
        _mapView.showsCompass = NO;
        _mapView.showsScale = NO;
        _mapView.showsBuildings = YES;
        _mapView.showsIndoorMap = YES;
        _mapView.showsIndoorMapControl = YES;
    }
}

//添加自身标注数据对象
-(void)performNewPoint{
    // 如果用户关闭了展示我的位置，直接ruturn
    if (!self.isShowLocation) {
        return;
    }
    
    MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
    pointAnnotation.coordinate = CLLocationCoordinate2DMake((double)checkinLocation.coordinate.latitude, (double)checkinLocation.coordinate.longitude);
    pointAnnotation.title = userId; //用户的objectId
    //    pointAnnotation.subtitle = @"我不知道这一条东西能显示多长的消息所以我试试说一些废话看看能显示出多少个字恍恍惚惚红红火";
    AppDelegate* appD = (AppDelegate*)[UIApplication sharedApplication].delegate;
    NSString* title = appD.imUserInfo.searchHim;
    if (!title) {
        title = @"心目中的他/她";
    }
    pointAnnotation.subtitle = title;
    
    located = true;
    [_mapView addAnnotation:pointAnnotation];
}

#pragma mark - target
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
        MAPinAnnotationView* view = (MAPinAnnotationView*)[_mapView viewForAnnotation:userAnnotation];
        UILongPressGestureRecognizer* lg = [view.gestureRecognizers firstObject];
        CGPoint currPoint = [lg locationInView:_mapView];
    
        NSMutableArray* mulArr = [NSMutableArray array];
        UIView* SurperView = view.superview;
        for (UIView* sview in SurperView.subviews) {
            if ([view isKindOfClass:[CustomAnnotationView class]]) {
                HYSortAnnotationViewModel* sortAM = [[HYSortAnnotationViewModel alloc] init];
                // 计算各个MAAnnotationView的中心点距离，放入数组
                sortAM.annotationView = (MAAnnotationView*)sview;
                sortAM.margin = [self marginFromOriginPoint:sview.center toDestintPoint:currPoint];
                [mulArr addObject:sortAM];
            }
        }
    
        // 排序，距离最大越前
        [mulArr sortUsingComparator:^NSComparisonResult(HYSortAnnotationViewModel*  _Nonnull obj1, HYSortAnnotationViewModel*  _Nonnull obj2) {
            return NSOrderedDescending;
        }];
    
        // 按顺序将数组中的MAAnnotationView放在视图前
        for (HYSortAnnotationViewModel* sortAM in mulArr) {
            MAPinAnnotationView* pV = (MAPinAnnotationView*)sortAM.annotationView;
            [SurperView bringSubviewToFront:pV];
        }
}


// 计算两个点之间的距离
- (double)marginFromOriginPoint:(CGPoint)originPoint toDestintPoint:(CGPoint)destintPoint{
    double result = 0.0;
    CGFloat xMargin = originPoint.x - destintPoint.x;
    CGFloat yMargin = originPoint.y - destintPoint.y;
    result = sqrt((xMargin* xMargin) + (yMargin * yMargin));
    
    return result;
}


#pragma mark - delegate

/** alter the size of PNG */
// 由于annotationView的大小由图片决定，因此，要构造足够大小的annotationView来包含气泡，就要构造足够的小的图片
// 解决方案：先画一张足够大的透明的图片，然后在这个图片上面画圆。
-(UIImage*)reSizeImage:(UIImage *)image toSize:(CGSize)reSize{
    if (!image) {
        image = HYSystemIcon;
    }
    
    // 1.创建图片上下文
    CGFloat margin = 5;
    CGFloat sizeWid,sizeHei;
    BOOL result = [HYNetTool isInWife];
    if (result) {
        sizeWid = sizeHei = wifeSize * 0.5;
    } else {
        sizeWid = sizeHei = noWifeSize *0.5;
    }
    
    CGSize circleSize = CGSizeMake(sizeWid + margin, sizeHei + margin);

    CGFloat topMarginToBg = bgMarign*0.75;
    // 背景图的尺寸
    CGSize bgSize = CGSizeMake(circleSize.width + bgMarign, circleSize.height + topMarginToBg);
    
    
    // YES 不透明 NO 透明
    UIGraphicsBeginImageContextWithOptions(bgSize, NO, 0);
    
    // 2.绘制大圆
    CGFloat circleX, circleY;
    circleX = ((bgSize.width - circleSize.width)*0.5);
    circleY = ((bgSize.height - circleSize.height)*0.5);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextAddEllipseInRect(ctx, CGRectMake(circleX, circleY, circleSize.width, circleSize.height));
    [[UIColor whiteColor] set];
    CGContextFillPath(ctx);
    
    // 3.绘制小圆
    CGFloat smallX = circleX + margin * 0.5;
    CGFloat smallY = circleY + margin * 0.5;
    CGFloat smallW = sizeWid;
    CGFloat smallH = sizeHei;
    CGContextAddEllipseInRect(ctx, CGRectMake(smallX, smallY, smallW, smallH));
    
    // 4.指点可用范围, 可用范围的适用范围是在指定之后,也就说在在指定剪切的范围之前绘制的东西不受影响
    CGContextClip(ctx);
    
    // 5.绘图图片
    [image drawInRect:CGRectMake(smallX, smallY, smallW, smallH)];
    
    // 6.取出图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}

//单次上传位置信息
-(void)uploadLocation{
    //构造上传数据对象
    AMapNearbyUploadInfo *info = [[AMapNearbyUploadInfo alloc] init];
    info.userID = [AVUser currentUser].objectId;//在这里写入标记id，用于区分用户，用户ID
    info.coordinateType = AMapSearchCoordinateTypeAMap;//坐标系类型
    info.coordinate = CLLocationCoordinate2DMake(checkinLocation.coordinate.latitude, checkinLocation.coordinate.longitude);

    //////////////测试附近用户代码///////////////
    
    //    AMapNearbyUploadInfo *infoTest = [[AMapNearbyUploadInfo alloc]init];
    //    infoTest.userID = @"abc";//ID:abc
    //    infoTest.coordinateType = AMapSearchCoordinateTypeAMap;
    //    infoTest.coordinate = CLLocationCoordinate2DMake(checkinLocation.coordinate.latitude+0.000500, checkinLocation.coordinate.longitude+0.000500);
    //    [_nearbyManager uploadNearbyInfo:infoTest];
    
    /////////////////////////////////////////
    
    if ([_nearbyManager uploadNearbyInfo:info])
    {
        HYLog(@"%f  %f   坐标已上传",info.coordinate.latitude,info.coordinate.longitude);
    }
    else
    {
//        HYLog(@"上传失败 -- %@", info);
    }
    
}


- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation//定制气泡样式
{
    if (!annotation.title || !annotation.subtitle) {
        return nil;
    }
    
    if ([annotation isKindOfClass:[MAPointAnnotation class]]){
        static NSString *reuseIndetifier = @"annotationReuseIndetifier";
        CustomAnnotationView *annotationView = (CustomAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseIndetifier];
        if (annotationView == nil)
        {
            annotationView = [[CustomAnnotationView alloc] initWithAnnotation:annotation
                                                              reuseIdentifier:reuseIndetifier];
        }
        
        
        
        //显示自己的信息
        if([annotation.title isEqualToString:userId]){//user asking for img
            userAnnotation = annotation;
//            HYLog(@"% @ asking for local	 img",annotation.title);
            AppDelegate* appD = (AppDelegate*)[UIApplication sharedApplication].delegate;
            NSString* url = appD.imUserInfo.iconUrl;//get self img's url
            AVFile *file =[AVFile fileWithURL:url];
            BOOL isWife = [HYNetTool isInWife];
            if (isWife) {
                [file getThumbnail:YES width:wifeSize height:wifeSize withBlock:^(UIImage *image, NSError *error) {
                    annotationView.image = [self reSizeImage:image toSize:CGSizeMake(wifeSize, wifeSize)];
                    annotationView.calloutIma = image;
                    if (!annotationView.calloutIma) {
                        annotationView.calloutIma = HYSystemIcon;
                    }
                }];
                
            }else{
                [file getThumbnail:YES width:noWifeSize height:noWifeSize withBlock:^(UIImage *image, NSError *error){
                    annotationView.image = [self reSizeImage:image toSize:CGSizeMake(noWifeSize, noWifeSize)];
                    annotationView.calloutIma = image;
                    if (!annotationView.calloutIma) {
                        annotationView.calloutIma = HYSystemIcon;
                    }
                }];
            }
            
            
        } else {////local user asking for img
        //显示他人的信息
            HYCustomAnnotation* cusAnnota = (HYCustomAnnotation*)annotation;
//            HYLog(@"%@ asking for img %f, %f ",annotation.title , annotation.coordinate.latitude,annotation.coordinate.longitude);//test
            AVQuery* query = [AVQuery queryWithClassName:@"_User"];
            [query whereKey:@"objectId" equalTo:cusAnnota.objId];
            [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                NSArray<AVUser*> *priorityEqualsOneClient = objects;// 符合 当前id的数组
                for (AVUser* object in priorityEqualsOneClient) {
                    if (object) {
                        tempURL =[object objectForKey:@"iconUrl"];
                        
                        AVFile *file =[AVFile fileWithURL:tempURL];
                        
                        BOOL isWife = [HYNetTool isInWife];
                        if (isWife) {
                            [file getThumbnail:YES width:wifeSize height:wifeSize withBlock:^(UIImage *image, NSError *error) {
                                annotationView.image =[self reSizeImage:image toSize:CGSizeMake(wifeSize, wifeSize)];;
                                annotationView.calloutIma = image;
                                if (!annotationView.calloutIma) {
                                    annotationView.calloutIma = HYSystemIcon;
                                }
                            }];
                        }else{
                            [file getThumbnail:YES width:noWifeSize height:noWifeSize withBlock:^(UIImage *image, NSError *error){
                                annotationView.image =[self reSizeImage:image toSize:CGSizeMake(noWifeSize, noWifeSize)];
                                annotationView.calloutIma = image;
                                if (!annotationView.calloutIma) {
                                    annotationView.calloutIma = HYSystemIcon;
                                }
                            }];

                        }
                    }
                    
                }
            }];
        }
        
        if ([self showSelectedUser] && [annotation.title isEqualToString:self.selectedName]) {
            [_mapView setCenterCoordinate:annotation.coordinate animated:YES];
        }
        
        annotationView.diTuVC = self;
        return annotationView;
    }
    return nil;
}


/** 每次位置更新会调用此函数 */
- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation
updatingLocation:(BOOL)updatingLocation
{
    //    HYLog(@"%f",_mapView.zoomLevel);//get zoomLevel
    if(updatingLocation)
    {
        //实时更新位置
        
        
        //            HYLog(@"%f  %f",checkinLocation.coordinate.latitude,checkinLocation.coordinate.longitude);
        
    }
    if (!located) {
        checkinLocation = userLocation.location;
        if (checkinLocation) {
            [self performNewPoint];//标注自身位置气泡
            [self uploadLocation];//上传用户数据 nearbymanager
            //构造AMapNearbySearchRequest对象，配置周边搜索参数
            request = [[AMapNearbySearchRequest alloc] init];
            request.center = [AMapGeoPoint locationWithLatitude:(CGFloat)checkinLocation.coordinate.latitude longitude:(CGFloat)checkinLocation.coordinate.longitude];//中心点 had been test
            request.radius = 1000;//搜索半径 单位米
            request.timeRange = 1800;//查询的时间
            request.searchType = AMapNearbySearchTypeLiner;//AMapNearbySearchTypeLiner表示直线距离
            searchAPI = [[AMapSearchAPI alloc]init];
            searchAPI.delegate = self;
            [searchAPI AMapNearbySearch:request];//调用查找附近用户操作
        }
    }
}


#pragma mark - HYSearchBgDelegate
/** 检索leanClound */
- (void)searchBg:(HYSearchBg*)searchBg toFindPeopleWithSearchParam:(HYSearchParam *)searchParam{
    AVQuery* query = [AVQuery queryWithClassName:@"_User"];
    [query whereKey:@"sex" equalTo:searchParam.sex];
//    [query whereKey:@"city" equalTo:searchParam.city];
    [query whereKey:@"aboutMe" containedIn:searchParam.aboutMe];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [searchBg stop];
        }];
        
        if (objects.count != 0) {
            NSMutableArray* mulArr = [NSMutableArray array];
            // 1、 转化成模型
            for (AVUser* user in objects) {
                HYSearchResult* searchR = [[HYSearchResult alloc] init];
                searchR.username = [user objectForKey:@"username"];
                searchR.iconUrl = [user objectForKey:@"iconUrl"];
                searchR.city = [user objectForKey:@"city"];
                [mulArr addObject:searchR];
            }
            
            // 2、传递给用户表
            HYSearchResultController* searchRC = [[HYSearchResultController alloc] init];
            searchRC.group = [NSArray arrayWithArray:mulArr];
            searchRC.delegate = self;
            searchNav = [[HYNavgationController alloc] initWithRootViewController:searchRC];
            [self.view addSubview:searchNav.view];
            CGFloat searchViewMarin = 200;
            searchNav.view.frame = CGRectMake(0, mainScreenHei, searchViewMarin, searchViewMarin);
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [UIView animateWithDuration:0.6 animations:^{
                    searchNav.view.frame = CGRectMake(0, 64, searchViewMarin, searchViewMarin);
                } completion:^(BOOL finished) {
//                    HYLog(@"%@---------%@", NSStringFromCGRect(searchNav.view.frame), NSStringFromCGRect([searchBg rectForSearchView]));
                }];
            }];
        } else {
            [MBProgressHUD showError:@"未能找到匹配用户"];
        }
    }];
}

#pragma mark - HYSearchResultControllerDelegate
- (void)didSelectedUserInfo:(HYSearchResult *)searchResult{
    // 查询点击的用户
    self.showSelectedUser = YES;
    self.selectedName = searchResult.username;
  
    //构造AMapNearbySearchRequest对象，配置周边搜索参数
    request = [[AMapNearbySearchRequest alloc] init];
    request.center = [AMapGeoPoint locationWithLatitude:(CGFloat)checkinLocation.coordinate.latitude longitude:(CGFloat)checkinLocation.coordinate.longitude];//中心点 had been test
    request.radius = 10000;//搜索半径 单位米
//    request.timeRange = 1800;//查询的时间
//    request.searchType = AMapNearbySearchTypeLiner;//AMapNearbySearchTypeLiner表示直线距离
    searchAPI = [[AMapSearchAPI alloc] init];
    searchAPI.delegate = self;
    [searchAPI AMapNearbySearch:request];//调用查找附近用户操作
}

/**
 *  当请求发生错误时，会调用代理的此方法.
 *
 *  @param request 发生错误的请求.
 *  @param error   返回的错误.
 */
- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error{
    HYLog(@"%@", error);
}

- (void)onNearbySearchDone:(AMapNearbySearchRequest *)request response:(AMapNearbySearchResponse *)response
{    //附近周边搜索回调   解析数据
    
    if(response.infos.count == 0)
    {
        //        HYLog(@"No response");//test
        return;
    }
    else{
        HYLog(@"Get");
    }
    NSString* imObjId = [AVUser currentUser].objectId;
    for (AMapNearbyUserInfo *info in response.infos) //处理得到的用户数据 在地图上标记
    {
        BOOL idCompare=[info.userID isEqual:imObjId];
        if (idCompare) {//get self id ,ignore
        
            // 是当前用户，而且是唯一一个
            if (info == [response.infos lastObject]) {
                if (self.showSelectedUser) {
                    [MBProgressHUD showError:@"未能找到相关用户信息"];
                    [_mapView setCenterCoordinate:_mapView.userLocation.coordinate animated:YES];
                    return;
                }
            }
            
            continue;
        }
        
        
        tempId = info.userID;
        HYCustomAnnotation *anno = [[HYCustomAnnotation alloc] init];
        //add to the map ,build an annotation
        AVQuery* query = [AVQuery queryWithClassName:@"_User"];
        [query whereKey:@"objectId" equalTo:tempId];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (objects.count == 0) {
                return;
            }
            AVUser* user = [objects firstObject];
            anno.title = user.username;
            anno.subtitle = user[@"searchHim"];
            anno.objId = user.objectId;
            anno.coordinate = CLLocationCoordinate2DMake(info.location.latitude, info.location.longitude);
            //        HYLog(@"%f  %f  坐标已下载",anno.coordinate.latitude,anno.coordinate.longitude);//test
            [_mapView addAnnotation:anno];
            
            if ([_selectedName isEqualToString:user.username]) {
                HYLog(@"检索到的用户 ---- %@", user.username);
                [_mapView setCenterCoordinate:anno.coordinate animated:YES];
                [MBProgressHUD showSuccess:@"定位成功，点击气泡开始聊天"];
            }
            
        }];
    }
}


@end
