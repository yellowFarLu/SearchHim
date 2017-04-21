//
//  HYSingleChatViewController.m
//  searHim重制版-01基本框架构建
//
//  Created by 黄远 on 16/7/11.
//  Copyright © 2016年 黄远. All rights reserved.
//

#import "HYSingleChatViewController.h"
#import "HYFriendInfoController.h"
#import "HYUserInfo.h"
#import "HYInputView.h"
#import "HYAddFriendController.h"
#import "HYCurrentMsgController.h"
#import "HYUserInfoTool.h"
#import "HYParamters.h"
#import <AVUser.h>
#import "HYContentItem.h"
#import "HYCurrentMsgItem.h"
#import "HYContentCell.h"
#import "HYAudioCell.h"
#import "HYVideoCell.h"
#import "HYPicCell.h"
#import "HYAudioItem.h"
#import "HYVideoItem.h"
#import "HYPicItem.h"
#import "HYBaseItem.h"
#import "HYBaseChatCell.h"
#import "HYContentItemFrame.h"
#import "HYBaseChatItemFrame.h"
#import <AVIMConversation.h>
#import <AVIMTextMessage.h>
#import "HYEmotionKeyBoard.h"
#import "HYMsgTool.h"
#import "HYMoreKeyBoard.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "HYChosePhotoController.h"
#import "HYPicItemFrame.h"
#import "HYPicItem.h"
#import "HYPhotoItem.h"
#import <AVIMImageMessage.h>
#import <AVFile.h>
#import "HYImInfoController.h"
#import "HYOtherInfoController.h"
#import "HYFriendInfoController.h"
#import "HYVideoItemFrame.h"
#import <AVIMVideoMessage.h>
#import <AVFoundation/AVFoundation.h>
#import "UIImage+BgIma.h"
#import "NSString+HYRetString.h"
#import "HYAudioItemFrame.h"
#import <AVIMAudioMessage.h>
#import "HYCardController.h"
#import "HYCardItemFrame.h"
#import "HYCardItem.h"
#import "HYCardCell.h"
#import "NSDate+HYRealDate.h"
#import "HYSkillView.h"
#import "HYContentSkillView.h"
#import <AVIMClient.h>
#import "HYSendOtherCardController.h"
#import <AVPush.h>
#define HYDelegateCell @"删除cell"
#define newMsg @"来新消息啦"
#define HYReloadCurrentMsgUI @"更新最近消息"
#define HYOpenImaPicVC @"打开相册"
#define HYOpenVideoVC @"打开视频"
#define HYOpenFriendInfoVC @"打开朋友名片控制器"
#define HYReloadVideo @"播放当前视频，关闭其他视频"
#define HYReloadAudio @"播放当前音频，关闭其他音频"
#define HYWantTtitleSkillView @"设置skillView"
#define HYGetNewImageFromCamera @"从相机得到图片"
#define HYVideoPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"HYMedioFile"]
#define HYAudioPath HYVideoPath
@interface HYSingleChatViewController () <UIScrollViewDelegate, HYInputViewDelegate, HYChosePhotoControllerDelegate, HYChatCellDeleagte, UINavigationControllerDelegate, UIImagePickerControllerDelegate, HYCardControllerDeleagte, HYSkillViewDeleagte, HYSendOtherCardControllerDelegate>
@property (nonatomic, weak) HYInputView* inputView;
/*
 * 用于判断是否打开表情状态
 */
@property (nonatomic, assign, getter=isShowEmotion) BOOL showEmotion;
@property (nonatomic, strong) UIImagePickerController* ImagePickerController;
//用数组保留未显示发送出去的模型，等发送出去后，用来刷新tableView
@property (nonatomic, strong) NSMutableArray* itemArr;
//用来保存要展示在自定义相册的图片
@property (nonatomic, strong) NSMutableArray* photoArr;

//用来显示大图的两个按钮
@property (nonatomic, weak) UIButton* bgView; //黑色蒙板
@property (nonatomic, weak) UIButton* picBtn; //显示大图
//大图在展开前的frame
@property (nonatomic, assign) CGRect picOriginFrame;
//记录大图的两个手指x、y的差距（差距变大，放大）
@property (nonatomic, assign) CGFloat preXmargin;
@property (nonatomic, assign) CGFloat preYmargin;

@property (nonatomic, strong) NSOperationQueue* mQueue;
@property (nonatomic, copy) NSString* mp3FilePath;
@property (nonatomic, weak) UIRefreshControl* refreshControl;
// 相册控制器
@property (nonatomic, strong) HYChosePhotoController* choseVC;
@property (nonatomic, weak) HYSkillView* skillView; //显示 复制、转发、删除
@end

@implementation HYSingleChatViewController

//////////////////////////////////初始化相关//////////////////////////////////////////////////////////

- (NSMutableArray*)itemArr{
    if (!_itemArr) {
        _itemArr = [NSMutableArray array];
    }
    return _itemArr;
}

- (NSOperationQueue *)mQueue{
    if (!_mQueue) {
        _mQueue = [NSOperationQueue mainQueue];
    }
    return _mQueue;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = HYGlobalBg;
    self.tableView.backgroundColor = [UIColor clearColor];
    [self setupNav];
    [self setupInputView];
    [self setupNofitication];
    self.tableView.height = mainScreenHei - 2.5*self.inputView.height;
    [self setRefreshControl];
    //加载历史聊天记录
    [self queryHistoryMsg];
}

- (void)setupNofitication{
    //设定监听键盘的通知 UIKeyboardWillChangeFrameNotification
    NSNotificationCenter* center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(textFieldKeyBoardChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [center addObserver:self selector:@selector(openImaBook) name:HYOpenImaPicVC object:nil];
    [center addObserver:self selector:@selector(openVideoVC) name:HYOpenVideoVC object:nil];
    [center addObserver:self selector:@selector(openFriendInfoVC) name:HYOpenFriendInfoVC object:nil];
    [center addObserver:self selector:@selector(reloadVideo:) name:HYReloadVideo object:nil];
    [center addObserver:self selector:@selector(reloadAudio:) name:HYReloadAudio object:nil];
    [center addObserver:self selector:@selector(didReceiveNewMsg:) name:newMsg object:nil];
    [center addObserver:self selector:@selector(setupSkillView:) name:HYWantTtitleSkillView object:nil];
    [center addObserver:self selector:@selector(deleteCell:) name:HYDelegateCell object:nil];
    [center addObserver:self selector:@selector(getNewPicFromCamera:) name:HYGetNewImageFromCamera object:nil];
}

#pragma mark - SkillViewDelegate
//删除cell
- (void)deleteCell:(NSNotification*)notification{
    NSNumber* index = notification.userInfo[@"row"];
    
    //标志该消息不需被展示了(异步)
    HYBaseChatItemFrame* baseF = self.groups[index.integerValue];
    [self saveIDForMsgTimestamp:baseF.baseChatItem.timestamp and:NO];
    
    //每次删除前，要重新编写cell的row
    for (int i=(int)index.integerValue; i<self.groups.count; i++) {
        HYBaseChatItemFrame* baseF = self.groups[i];
        baseF.baseChatItem.row -= 1;
    }
    
    [self.groups removeObjectAtIndex:index.integerValue];
    [self.itemArr removeObjectAtIndex:index.integerValue];
    NSIndexPath* indexP = [NSIndexPath indexPathForRow:index.integerValue inSection:0];
    
    [self.tableView deleteRowsAtIndexPaths:@[indexP] withRowAnimation:UITableViewRowAnimationFade];
    
}

- (void)setupSkillView:(NSNotification*)nofication{
    if (!_skillView) {
        HYBaseChatItemFrame*baseF = nofication.userInfo[@"itemFrame"];
        HYSkillView* skillView = nil;
        if ([baseF isKindOfClass:[HYContentItemFrame class]]) {
            skillView = [HYContentSkillView skillView];
        } else {
            skillView = [HYSkillView skillView];
        }
        skillView.deleagte = self;
        skillView.frame = CGRectMake(0, 0, mainScreenWid, mainScreenHei);
        UIWindow* lastWindow = [[UIApplication sharedApplication].windows lastObject];
        skillView.baseChatItem = baseF.baseChatItem;
        [lastWindow addSubview:skillView];
        self.skillView = skillView;
    }
}

/** 点击了转发按钮 */
- (void)didClickSendOtherBtn:(HYBaseChatItem*)baseItem{
    HYSendOtherCardController* sendOtherCardVC = [[HYSendOtherCardController alloc] init];
    sendOtherCardVC.baseChatItem = baseItem;
    sendOtherCardVC.otherObjId = self.otherUserInfo.objectId;
    sendOtherCardVC.delegate = self;
    [self.navigationController pushViewController:sendOtherCardVC animated:YES];
}

#pragma mark - HYSendOtherCardControllerDelegate
/** 转发到当前页面 */
- (void)sendMsgToCurrentSingleCharRoomWithChatItem:(HYBaseChatItem*)baseChatItem{
    [self queryHistoryMsg];
}


- (void)setRefreshControl{
    UIRefreshControl* refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl = refreshControl;
    [self.tableView addSubview:refreshControl];
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
}

- (void)refresh:(UIRefreshControl*)refreshControler{
    HYBaseChatItemFrame* baseItemF = [self.groups firstObject];
    HYBaseChatItem* baseItem = baseItemF.baseChatItem;
    int limit = 10;
    
    [self.conversation queryMessagesBeforeId:baseItem.msgId timestamp:baseItem.timestamp limit:limit callback:^(NSArray *objects, NSError *error) {
        [self.refreshControl endRefreshing];
        for (int i=(int)(objects.count-1); i>-1; i--) {
            AVIMTypedMessage* typeMsg = objects[i];
            [self setupItemFrameWith:typeMsg refreh:YES];
        }
        
        //加载完历史消息，利用偏移刷新旧的item的row
        for (int j=limit; j<self.groups.count; j++) {
            HYBaseChatItemFrame* baseItemF = self.groups[j];
            HYBaseChatItem* baseItem = baseItemF.baseChatItem;
            baseItem.row = j;
        }
        
        //利用偏移计算新的的item的row
        for (int m=0; m<limit && m<self.groups.count; m++) {
            HYBaseChatItemFrame* baseItemF = self.groups[m];
            HYBaseChatItem* baseItem = baseItemF.baseChatItem;
            baseItem.row = m;
        }
        
        [self.tableView reloadData];
    }];
}

- (void)setupInputView{
    HYInputView* inputView = [[HYInputView alloc] init];
    CGFloat inputViewX, inputViewY, inputViewWid, inputViewHei;
    inputViewX = self.tableView.x;
    inputViewWid = self.tableView.width;
    inputViewHei = 50;
    inputViewY = self.view.height - 2.3*inputViewHei;
    inputView.frame = CGRectMake(inputViewX, inputViewY, inputViewWid, inputViewHei);
    inputView.delegate = self;
    [self.view addSubview:inputView];
    self.inputView = inputView;
}

- (void)setupNav{
    UIButton* addCurrentFriendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage* adIMa = [UIImage imageNamed:@"addFriend"];
    [addCurrentFriendBtn setImage:adIMa forState:UIControlStateNormal];
    //    addCurrentFriendBtn.imageView.contentMode = UIViewContentModeCenter;
    addCurrentFriendBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [addCurrentFriendBtn addTarget:self action:@selector(onClickAddCurrentFriendBtn) forControlEvents:UIControlEventTouchUpInside];
    CGFloat addCurrentFriendBtnX, addCurrentFriendBtnY, addCurrentFriendBtnH, addCurrentFriendBtnW;
    addCurrentFriendBtnX = addCurrentFriendBtnY = 0;
    addCurrentFriendBtnH = HYBackBtnH - 5;
    addCurrentFriendBtnW = addCurrentFriendBtnH * (adIMa.size.width / adIMa.size.height);
    addCurrentFriendBtn.frame = CGRectMake(addCurrentFriendBtnX, addCurrentFriendBtnY, addCurrentFriendBtnW, addCurrentFriendBtnH);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:addCurrentFriendBtn];
    //    HYFriendInfoController
    if ([self.sourceVC isKindOfClass:[HYFriendInfoController class]]) {
        self.navigationItem.rightBarButtonItem = nil;
    }
    
    if ([self.sourceVC isKindOfClass:[HYCurrentMsgController class]]) {
        //通过数据库，判断是不是朋友
        HYParamters* parm = [[HYParamters alloc] init];
        parm.username = [AVUser currentUser].username;
        BOOL reslut = [HYUserInfoTool queryFriendIsInDB:self.otherUserInfo WithParamter:parm];
        if (reslut) {
            self.navigationItem.rightBarButtonItem = nil;
        }
    }
    
    self.navigationItem.title = self.otherUserInfo.username;
    
    
    //设置返回按钮
    UIButton *backBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 20)];
    [backBtn setTitle:@"返回" forState:UIControlStateNormal];
    [backBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    backBtn.titleLabel.font =  HYValueFont;
    backBtn.titleLabel.textAlignment =  NSTextAlignmentLeft;
    backBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [backBtn addTarget:self action:@selector(onClikeBackBtn:) forControlEvents:UIControlEventTouchUpInside];
    backBtn.width = HYBackBtnW;
    backBtn.height = HYBackBtnH;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
}

- (void)onClikeBackBtn:(UIButton*)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.inputView endEditing:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
}

//打开更多键盘
- (void)setupAdd{
    if (!self.inputView.inputView || [self.inputView.inputView isKindOfClass:[HYEmotionKeyBoard class]]) {
        HYMoreKeyBoard* moreKeyB = [HYMoreKeyBoard moreKeyBoard];
        self.inputView.inputView = moreKeyB;
    }else{
        self.inputView.inputView = nil;
    }
    [self.inputView resignFirstResponder];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.inputView becomeFirstResponder];
    });
}

//打开表情键盘
- (void)setupExpress{
    if (![self.inputView inputView] || [self.inputView.inputView isKindOfClass:[HYMoreKeyBoard class]]) {
        HYEmotionKeyBoard* view = [HYEmotionKeyBoard emotionKeyBoard];
        self.inputView.inputView = view;
        self.inputView.showEmotion = YES;
    }else{
        self.inputView.inputView = nil;
        self.inputView.showEmotion = NO;
    }
    
    [self.inputView resignFirstResponder];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.inputView becomeFirstResponder];
    });
}

//这里弹出添加当前好友验证界面
- (void)onClickAddCurrentFriendBtn{
    HYAddFriendController* addFVC = [[HYAddFriendController alloc] init];
    addFVC.userInfo = self.otherUserInfo;
    [self.navigationController pushViewController:addFVC animated:NO];
}

/////////////////////////////////////notification的target////////////////////////////////////////////////
- (void)getNewPicFromCamera:(NSNotification*)notification{
    [self.choseVC cancelClick];
    HYPhotoItem* photoItem = notification.userInfo[@"photoItemFromCamera"];
    [self sendMsgWithPhoto:photoItem];
}

#pragma mark - 实现只播放一个视频或音频
- (void)reloadVideo:(NSNotification*)notification{
    NSNumber* row = notification.userInfo[@"row"];
    HYBaseChatItemFrame* baseChatItemF = nil;
    for (int i=0; i<self.groups.count; i++) {
        baseChatItemF = self.groups[i];
        if ([baseChatItemF isKindOfClass:[HYVideoItemFrame class]]) {
            HYVideoItem* videoItem = (HYVideoItem*)baseChatItemF.baseChatItem;
            videoItem.seeing = NO;
        }else if ([baseChatItemF isKindOfClass:[HYAudioItemFrame class]]) {
            HYAudioItem* audioItem = (HYAudioItem*)baseChatItemF.baseChatItem;
            audioItem.listen = NO;
        }
    }
    
    HYVideoItemFrame* videoF = self.groups[row.integerValue];
    HYVideoItem* videoItem = (HYVideoItem*)videoF.baseChatItem;
    videoItem.seeing = YES;
    
    [self.tableView reloadData];
}

- (void)reloadAudio:(NSNotification*)notification{
    NSNumber* row = notification.userInfo[@"row"];
    HYBaseChatItemFrame* baseChatItemF = nil;
    for (int i=0; i<self.groups.count; i++) {
        baseChatItemF = self.groups[i];
        if ([baseChatItemF isKindOfClass:[HYAudioItemFrame class]]) {
            HYAudioItem* audioItem = (HYAudioItem*)baseChatItemF.baseChatItem;
            audioItem.listen = NO;
        }else if ([baseChatItemF isKindOfClass:[HYVideoItemFrame class]]) {
            HYVideoItem* videoItem = (HYVideoItem*)baseChatItemF.baseChatItem;
            videoItem.seeing = NO;
        }
    }
    
    HYAudioItemFrame* audioF = self.groups[row.integerValue];
    HYAudioItem* audioItem = (HYAudioItem*)audioF.baseChatItem;
    audioItem.listen = YES;
    
    [self.tableView reloadData];
}

#pragma mark - 来自于更多的的通知
//打开视频控制器
- (void)openVideoVC{
    UIAlertController* alertVC = [UIAlertController alertControllerWithTitle:@"小视频" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *locaAction = [UIAlertAction actionWithTitle:@"本地视频" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.allowsEditing = YES;
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.videoQuality = UIImagePickerControllerQualityTypeMedium;
        NSArray *arr = [UIImagePickerController availableMediaTypesForSourceType:imagePicker.sourceType];
        NSMutableArray* marr = [[NSMutableArray alloc] initWithCapacity:1];
        for (int i=0; i<arr.count; i++) {
//            NSLog(@"%@",[arr objectAtIndex:i]);
            if ([[arr objectAtIndex:i] isEqualToString:@"public.movie"]) {
                [marr addObject:[arr objectAtIndex:i]];
            }
        }
        imagePicker.mediaTypes = marr;
        [self presentModalViewController:imagePicker animated:YES];
    }];
    
    [locaAction setValue:backBtnColor forKey:@"titleTextColor"];
    UIAlertAction *cameroAction = [UIAlertAction actionWithTitle:@"打开摄像机" style:UIAlertActionStyleDefault handler:^(UIAlertAction* _Nonnull action){
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            imagePicker.delegate = self;
            imagePicker.allowsEditing = YES;
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            imagePicker.videoQuality = UIImagePickerControllerQualityTypeMedium;
            if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear]) {
                NSArray *arr = [UIImagePickerController availableMediaTypesForSourceType:imagePicker.sourceType];
                NSMutableArray* marr = [[NSMutableArray alloc] initWithCapacity:1];
                for (int i=0; i<arr.count; i++) {
                    HYLog(@"%@",[arr objectAtIndex:i]);
                    if ([[arr objectAtIndex:i] isEqualToString:@"public.movie"]) {
                        [marr addObject:[arr objectAtIndex:i]];
                    }
                }
                imagePicker.mediaTypes = marr;
                imagePicker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModeVideo;
                imagePicker.cameraDevice = UIImagePickerControllerCameraDeviceRear;
            }
            [self presentModalViewController:imagePicker animated:YES];
        }else{
            [MBProgressHUD showError:@"您的设备不支持此功能"];
        }
    }];
    [cameroAction setValue:backBtnColor forKey:@"titleTextColor"];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:^(UIAlertAction* _Nonnull action){
        
    }];
    [cancel setValue:[UIColor grayColor] forKey:@"titleTextColor"];
    [alertVC addAction:locaAction];
    [alertVC addAction:cameroAction];
    [alertVC addAction:cancel];
    
    [self presentViewController:alertVC animated:YES completion:^{
        
    }];
}

- (void)openFriendInfoVC{
    HYCardController* cardVC = [[HYCardController alloc] init];
    cardVC.delegate = self;
    [self.navigationController pushViewController:cardVC animated:YES];
}

//#pragma mark - HYCardControllerDeleagte
- (void)cardVC:(HYCardController *)cardVC didSelectedCard:(HYUserInfo *)userIno{
    //发送名片
    [self sendMsgWithUserInfo:userIno];
}

// 获取相册里面的图片
- (void)openImaBook{
    //获取相册里面的图片
    ALAssetsLibrary* assetl = [[ALAssetsLibrary alloc] init];
    self.photoArr = [NSMutableArray array];
    [assetl enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        if (group) {
            if([[group valueForProperty:ALAssetsGroupPropertyType] intValue] == 16) //表示是系统默认的相册
            {
                [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                    if (result) {
                        //获取资源图片的详细资源信息
                        ALAssetRepresentation* representation = [result defaultRepresentation];
                        NSURL* url = [representation UTI];
                        //把本地所有图片放在数组
                        NSDictionary *dictionary = @{
                                                     @"thumbnail":[UIImage imageWithCGImage:[result aspectRatioThumbnail]],
                                                     @"representation":representation,
                                                     @"iconUrl" : url
                                                     };
                        [self.photoArr addObject:dictionary];
                    }
                    
                }];
                HYChosePhotoController* choseVC = [[HYChosePhotoController alloc] init];
                choseVC.photoArr = self.photoArr;
                choseVC.delegate = self;
                self.choseVC = choseVC;
                [self presentViewController:choseVC animated:YES completion:^{
                    
                }];
            }
        }
    } failureBlock:^(NSError *error) {
        //图片获取失败
        [MBProgressHUD showMessage:@"图片获取失败，请检查“设置”中本应用是否有权限" toView:self.view];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
    }];
}

#pragma mark - 加载历史消息相关
/////////////////////////////////加载历史消息相关///////////////////////////////////////////////
- (void)queryHistoryMsg{
    NSArray* msgArr = [self.conversation queryMessagesFromCacheWithLimit:5];
    for (AVIMTypedMessage* typeMsg in msgArr) {
        [self setupItemFrameWith:typeMsg refreh:NO];
    }
    
    [self.tableView reloadData];
    NSIndexPath* indexP = [NSIndexPath indexPathForRow:self.groups.count - 1 inSection:0];
    //把最后一行弹上
    if (indexP.row > -1) {
        [self.tableView scrollToRowAtIndexPath:indexP atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
    [self saveNewItemInDB];
}

- (void)setupItemFrameWith:(AVIMTypedMessage*)typeMsg refreh:(BOOL)refresh{
    //判断需不需要展示
    if (![self shouldShowForTimestamp:typeMsg.sendTimestamp]) {
        return;
    }
    
    if (typeMsg.mediaType == kAVIMMessageMediaTypeText) {
        [self getContentMsg:typeMsg refreh:refresh];
    }else if(typeMsg.mediaType == kAVIMMessageMediaTypeImage){
        [self getPicMsg:typeMsg refreh:refresh];
    }else if(typeMsg.mediaType == kAVIMMessageMediaTypeVideo){
        [self getVideoMsg:typeMsg refreh:refresh];
    }else if(typeMsg.mediaType == kAVIMMessageMediaTypeAudio){
        [self getAudioMsg:typeMsg refreh:refresh];
    }else if(typeMsg.mediaType == kAVIMMessageMediaTypeFile){
        [self getCardMsg:typeMsg refreh:refresh];
    }
}

//将不同类型的msg转化为不同的模型
- (void)getContentMsg:(AVIMTypedMessage*)typeMsg refreh:(BOOL)refresh{
    HYContentItem* contentItem = [[HYContentItem alloc] init];
    if (typeMsg.ioType == AVIMMessageIOTypeIn) {
        contentItem.iconUrl = self.otherUserInfo.iconUrl;
        contentItem.me = NO;
    } else {
        contentItem.iconUrl = [[AVUser currentUser] objectForKey:@"iconUrl"];
        contentItem.me = YES;
    }
    AVIMTextMessage* textMsg = (AVIMTextMessage*)typeMsg;
    contentItem.msgId = textMsg.messageId;
    contentItem.timestamp = textMsg.sendTimestamp;
    [contentItem setContentWithMsgText:textMsg.text];
    
    NSString* timeStr = textMsg.attributes[@"timeStr"];
    contentItem.timeStr = timeStr;
    contentItem.lastMessageAtString = [NSDate currentStringFromPreString:timeStr];
    
    //通过和上一个模型比较，看用不用显示时间
    HYBaseChatItemFrame* preItemFrame = [self.groups lastObject];
    HYBaseChatItem* preItem = preItemFrame.baseChatItem;
    if ([preItem.lastMessageAtString isEqualToString:contentItem.lastMessageAtString]) {
        contentItem.showTime = NO;
    }else{
        contentItem.showTime = YES;
    }
    
    contentItem.showIndicator = NO;
    HYContentItemFrame* contentItemFrame = [[HYContentItemFrame alloc] init];
    contentItemFrame.baseChatItem = contentItem;
    contentItem.row = self.groups.count;
    if (refresh) {
        [self.itemArr insertObject:contentItemFrame atIndex:0];
        [self.groups insertObject:contentItemFrame atIndex:0];
    } else {
        contentItem.row = self.groups.count;
        [self.itemArr addObject:contentItemFrame];
        [self.groups addObject:contentItemFrame];
    }
}

- (void)getPicMsg:(AVIMTypedMessage*)typeMsg refreh:(BOOL)refresh{
    AVIMImageMessage* imaMsg = (AVIMImageMessage*)typeMsg;
    HYPicItemFrame* picFrame = [[HYPicItemFrame alloc] init];
    HYPicItem* picItem = [[HYPicItem alloc] init];
    picItem.msgId = imaMsg.messageId;
    picItem.timestamp = imaMsg.sendTimestamp;
    if (typeMsg.ioType == AVIMMessageIOTypeIn) {
        picItem.iconUrl = self.otherUserInfo.iconUrl;
    } else {
        picItem.iconUrl = [[AVUser currentUser] objectForKey:@"iconUrl"];
    }
    picItem.iconUrl = self.otherUserInfo.iconUrl;
    
    NSString* timeStr = imaMsg.attributes[@"timeStr"];
    picItem.timeStr = timeStr;
    picItem.lastMessageAtString = [NSDate currentStringFromPreString:timeStr];
    
    if (imaMsg.ioType == AVIMMessageIOTypeIn) {
        picItem.me = NO;
    }else{
        picItem.me = YES;
    }
    
    //通过和上一个模型比较，看用不用显示时间
    HYBaseChatItemFrame* preItemFrame = [self.groups lastObject];
    HYBaseChatItem* preItem = preItemFrame.baseChatItem;
    if ([preItem.lastMessageAtString isEqualToString:picItem.lastMessageAtString]) {
        picItem.showTime = NO;
    }else{
        picItem.showTime = YES;
    }
    picItem.sliderValue = 1.0;
    AVFile* file = imaMsg.file;
    NSData*data = [file getData];
    picItem.pic = [UIImage imageWithData:data];
    picFrame.baseChatItem = picItem;
    if (refresh) {
        [self.itemArr insertObject:picFrame atIndex:0];
        [self.groups insertObject:picFrame atIndex:0];
    } else {
         picItem.row = self.groups.count;
        [self.groups addObject:picFrame];
        [self.itemArr addObject:picFrame];
    }
}

- (void)getVideoMsg:(AVIMTypedMessage*)typeMsg refreh:(BOOL)refresh{
    AVIMVideoMessage* videoMsg = (AVIMVideoMessage*)typeMsg;
    HYVideoItem* videoItem = [[HYVideoItem alloc] init];
    videoItem.msgId = videoMsg.messageId;
    videoItem.timestamp = videoMsg.sendTimestamp;
    HYVideoItemFrame* videoItemFrame = [[HYVideoItemFrame alloc] init];
    AppDelegate* appD = [UIApplication sharedApplication].delegate;
    
    NSString* timeStr = videoMsg.attributes[@"timeStr"];
    videoItem.timeStr = timeStr;
    videoItem.lastMessageAtString = [NSDate currentStringFromPreString:timeStr];
    
    HYLog(@"%@", videoMsg.file.url);
    //接收的时候，已经写进去了
    NSString* documentPath = HYVideoPath;
    NSString* realStr = [videoMsg.file.url stringByReplacingOccurrencesOfString:@"/" withString:@"h"];
    NSString* videoName = [NSString stringWithFormat:@"%@.mov", realStr];
    NSString* videoPath = [documentPath stringByAppendingPathComponent:videoName];
    videoItem.videoBgIma = [UIImage getPicFromVideoUrl:[NSURL fileURLWithPath:videoPath]];
    videoItem.videoUrl = videoPath;
    if (videoMsg.ioType == AVIMMessageIOTypeIn) {
        videoItem.me = NO;
        videoItem.iconUrl = self.otherUserInfo.iconUrl;
    }else{
        videoItem.me = YES;
        videoItem.iconUrl = appD.imUserInfo.iconUrl ;
    }
    videoItem.sliderValue = 1.0;
    videoItem.time = CMTimeMake(1, 1);
    //通过和上一个模型比较，看用不用显示时间
    HYBaseChatItemFrame* preItemFrame = [self.groups lastObject];
    HYBaseChatItem* preItem = preItemFrame.baseChatItem;
    if ([preItem.lastMessageAtString isEqualToString:videoItem.lastMessageAtString]) {
        videoItem.showTime = NO;
    }else{
        videoItem.showTime = YES;
    }
    videoItemFrame.baseChatItem = videoItem;
    videoItem.proViewHidden = YES;
    if (refresh) {
        [self.itemArr insertObject:videoItemFrame atIndex:0];
        [self.groups insertObject:videoItemFrame atIndex:0];
    } else {
        videoItem.row = self.groups.count;
        [self.groups addObject:videoItemFrame];
        [self.itemArr addObject:videoItemFrame];
    }
}

- (void)getAudioMsg:(AVIMTypedMessage*)typeMsg refreh:(BOOL)refresh{
    AVIMAudioMessage* audioMsg = (AVIMAudioMessage*)typeMsg;
    HYAudioItem* audioItem = [[HYAudioItem alloc] init];
    HYAudioItemFrame* audioItemFrame = [[HYAudioItemFrame alloc] init];
    audioItem.msgId = audioMsg.messageId;
    audioItem.timestamp = audioMsg.sendTimestamp;
    
    NSString* timeStr = audioMsg.attributes[@"timeStr"];
    audioItem.timeStr = timeStr;
    audioItem.lastMessageAtString = [NSDate currentStringFromPreString:timeStr];
    
    audioItem.audio = [audioMsg.file getData];
    NSNumber* recoderTime = audioMsg.attributes[@"recorderTime"];
    audioItem.audioTime = recoderTime.doubleValue;
    if (audioMsg.ioType == AVIMMessageIOTypeIn) {
        audioItem.me = NO;
        audioItem.iconUrl = self.otherUserInfo.iconUrl;
    }else{
        audioItem.me = YES;
        AppDelegate* appD = (AppDelegate*)[UIApplication sharedApplication].delegate;
        audioItem.iconUrl = appD.imUserInfo.iconUrl;
    }

    //通过和上一个模型比较，看用不用显示时间
    HYBaseChatItemFrame* preItemFrame = [self.groups lastObject];
    HYBaseChatItem* preItem = preItemFrame.baseChatItem;
    if ([preItem.lastMessageAtString isEqualToString:audioItem.lastMessageAtString]) {
        audioItem.showTime = NO;
    }else{
        audioItem.showTime = YES;
    }
    audioItemFrame.baseChatItem = audioItem;
   
    if (refresh) {
        [self.itemArr insertObject:audioItemFrame atIndex:0];
        [self.groups insertObject:audioItemFrame atIndex:0];
    } else {
        audioItem.row = self.groups.count;
        [self.groups addObject:audioItemFrame];
        [self.itemArr addObject:audioItemFrame];
    }
}

- (void)getCardMsg:(AVIMTypedMessage*)typeMsg refreh:(BOOL)refresh{
    HYCardItem *cardItem = [[HYCardItem alloc] init];
    HYCardItemFrame* cardItemFrame = [[HYCardItemFrame alloc] init];
    cardItem.msgId = typeMsg.messageId;
    cardItem.timestamp = typeMsg.sendTimestamp;
    
    NSString* timeStr = typeMsg.attributes[@"timeStr"];
    cardItem.timeStr = timeStr;
    cardItem.lastMessageAtString = [NSDate currentStringFromPreString:timeStr];
    
    if (typeMsg.ioType == AVIMMessageIOTypeIn) {
        cardItem.iconUrl = self.otherUserInfo.iconUrl;
        cardItem.me = NO;
    }else{
        AppDelegate* appD = (AppDelegate*)[UIApplication sharedApplication].delegate;
        cardItem.iconUrl = appD.imUserInfo.iconUrl;
        cardItem.me = YES;
    }

    NSData* data = [typeMsg.file getData];
    cardItem.userInfo = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    //通过和上一个模型比较，看用不用显示时间
    HYBaseChatItemFrame* preItemFrame = [self.groups lastObject];
    HYBaseChatItem* preItem = preItemFrame.baseChatItem;
    if ([preItem.lastMessageAtString isEqualToString:cardItem.lastMessageAtString]) {
        cardItem.showTime = NO;
    }else{
        cardItem.showTime = YES;
    }
    cardItemFrame.baseChatItem = cardItem;
    if (refresh) {
        [self.groups insertObject:cardItemFrame atIndex:0];
        [self.itemArr insertObject:cardItemFrame atIndex:0];
    } else {
          cardItem.row = self.groups.count;
        [self.groups addObject:cardItemFrame];
        [self.itemArr addObject:cardItemFrame];
    }
}

//利用 他人id + 本人id + 时间戳  这个字符串作为key 存储一个BOOL,表示这条消息要不要展示
//这里key指时间戳
- (BOOL)shouldShowForTimestamp:(int64_t)timestamp{
    BOOL result;
    NSString* key = [NSString stringWithFormat:@"%@%@%lld", self.otherUserInfo.objectId, [AVUser currentUser].objectId, timestamp];
    result = [[NSUserDefaults standardUserDefaults] boolForKey:key];
    return result;
}

//存储消息要不要被展示的标志
- (void)saveIDForMsgTimestamp:(int64_t)timestamp and:(BOOL)show{
    dispatch_queue_t queue = dispatch_queue_create("存储标志", DISPATCH_QUEUE_PRIORITY_DEFAULT);
    dispatch_async(queue, ^{
        //标志该消息需被展示了(异步)
        NSString* key = [NSString stringWithFormat:@"%@%@%lld", self.otherUserInfo.objectId, [AVUser currentUser].objectId, timestamp];
        NSUserDefaults* def = [NSUserDefaults standardUserDefaults];
        [def setBool:show forKey:key];
        [def synchronize];
    });
}

#pragma mark - 存储信息相关
/////////////////////////////////存储信息相关///////////////////////////////////////////////

//更新最近消息的界面，同时存数据到数据库（异步）
- (void)saveNewItemInDB{
    
    dispatch_queue_t queue = dispatch_queue_create("queue", DISPATCH_QUEUE_PRIORITY_DEFAULT);
    dispatch_async(queue, ^{
        HYBaseChatItemFrame* baseItemF = [self.groups lastObject];
        if ([baseItemF.baseChatItem isKindOfClass:[HYContentItem class]]) {
            [self saveNewItemInDBWithContentItemFrame:baseItemF];
        } if ([baseItemF.baseChatItem isKindOfClass:[HYPicItem class]]){
            [self saveNewItemInDBWithPictItemFrame:baseItemF];
        } if ([baseItemF.baseChatItem isKindOfClass:[HYVideoItem class]]) {
            [self saveNewItemInDBWithVideoItemFrame:baseItemF];
        } if ([baseItemF.baseChatItem isKindOfClass:[HYAudioItem class]]) {
            [self saveNewItemInDBWithAudioItemFrame:baseItemF];
        } if ([baseItemF.baseChatItem isKindOfClass:[HYCardItem class]]) {
            [self saveNewItemInDBWithCardItemFrame:baseItemF];
        }
        
         [[NSNotificationCenter defaultCenter] postNotificationName:HYReloadCurrentMsgUI object:self];
    });
}

//存储普通文本
- (void)saveNewItemInDBWithContentItemFrame:(HYBaseChatItemFrame*)baseItemF{
    HYContentItem* contentItem = (HYContentItem*)baseItemF.baseChatItem;
    [HYMsgTool reloadMsgToDBWithOtherObjectId:self.otherUserInfo.objectId conversation:self.conversation otherIconUrl:self.otherUserInfo.iconUrl otherUsername:self.otherUserInfo.username lastMessageAtStr:baseItemF.baseChatItem.timeStr lastContent:contentItem.realString unreadCount:0];
}

//存储图片文本
- (void)saveNewItemInDBWithPictItemFrame:(HYBaseChatItemFrame*)baseItemF{
//    HYPicItem* picItem = (HYPicItem*)baseItemF.baseChatItem;
    [HYMsgTool reloadMsgToDBWithOtherObjectId:self.otherUserInfo.objectId conversation:self.conversation otherIconUrl:self.otherUserInfo.iconUrl otherUsername:self.otherUserInfo.username lastMessageAtStr:baseItemF.baseChatItem.timeStr lastContent:@"[图片]" unreadCount:0];

}

//存储视频消息
- (void)saveNewItemInDBWithVideoItemFrame:(HYBaseChatItemFrame*)baseItemF{
    [HYMsgTool reloadMsgToDBWithOtherObjectId:self.otherUserInfo.objectId conversation:self.conversation otherIconUrl:self.otherUserInfo.iconUrl otherUsername:self.otherUserInfo.username lastMessageAtStr:baseItemF.baseChatItem.timeStr lastContent:@"[视频]" unreadCount:0];
}

//存储音频消息
- (void)saveNewItemInDBWithAudioItemFrame:(HYBaseChatItemFrame*)baseItemF{
    [HYMsgTool reloadMsgToDBWithOtherObjectId:self.otherUserInfo.objectId conversation:self.conversation otherIconUrl:self.otherUserInfo.iconUrl otherUsername:self.otherUserInfo.username lastMessageAtStr:baseItemF.baseChatItem.timeStr lastContent:@"[音频]" unreadCount:0];
}

//存储名片消息
- (void)saveNewItemInDBWithCardItemFrame:(HYBaseChatItemFrame*)baseItemF{
    [HYMsgTool reloadMsgToDBWithOtherObjectId:self.otherUserInfo.objectId conversation:self.conversation otherIconUrl:self.otherUserInfo.iconUrl otherUsername:self.otherUserInfo.username lastMessageAtStr:baseItemF.baseChatItem.timeStr lastContent:@"[名片]" unreadCount:0];
}

#pragma mark - 发送信息相关
//////////////////////////////////发送信息相关//////////////////////////////////////////////

//#pragma mark - HYInputViewDelegate
- (void)inputView:(HYInputView *)inputView didClickBtnType:(InputBtnType)type{
    switch (type) {
        case InputBtnTypeAudio:
        
            break;
        
        case InputBtnTypeExpress:
            [self setupExpress]; break;
        
        case InputBtnTypeAdd:
            [self setupAdd]; break;
        
        case InputBtnTypeSend:
            [self sendMsg]; break;
        default:
            break;
    }
}

- (NSString*)getCafFilePath{
    //确定录音路径
    NSString* documentPath = HYAudioPath;
    [[NSFileManager defaultManager] createDirectoryAtPath:documentPath withIntermediateDirectories:YES attributes:nil error:nil];
    NSString* cafStr = [NSString stringWithFormat:@"%@%@.caf", [NSString ret64bitString], self.otherUserInfo.objectId];
    NSString* mp3Str = [cafStr stringByReplacingOccurrencesOfString:@"caf" withString:@"mp3"];
    NSString* cafFilePath = [documentPath stringByAppendingPathComponent:cafStr];
    //本地储存的唯一路径，由于这个字符串会存在message的attribute中，接收方也可作为唯一路径存储
    self.mp3FilePath = [documentPath stringByAppendingPathComponent:mp3Str];
    return cafFilePath;
}

#pragma mark - 得到录音文件了
- (void)hasGetAudioData:(NSData *)data andRecorderTime:(NSTimeInterval)recorderTime{
    HYLog(@"mp3FilePath ---------  %@", self.mp3FilePath);
    [self sendMsgWithAudioData:data andRecorderTime:recorderTime];
}


//#pragma mark -UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary*)info
{
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    BOOL success;
//    NSError *error;
    if ([mediaType isEqualToString:@"public.movie"]){
        NSURL *videoURL = [info objectForKey:UIImagePickerControllerMediaURL];
//        NSData *videoData = [NSData dataWithContentsOfURL:videoURL];
//        NSString *videoFile = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"temp.mov"];
//        success = [fileManager fileExistsAtPath:videoFile];
//        if(success) {
//            success = [fileManager removeItemAtPath:videoFile error:&error];
//        }
        NSString* temUrlStr = [videoURL.absoluteString stringByReplacingOccurrencesOfString:@".MOV" withString:@".MP4"];
        NSURL *newVideoUrl = [NSURL URLWithString:temUrlStr];
        [MBProgressHUD showMessage:@"正在处理视频.." toView:self.view];
        [self convertVideoQuailtyWithInputURL:videoURL outputURL:newVideoUrl quality:AVAssetExportPresetLowQuality completeHandler:^(AVAssetExportSession* exportSession) {
            [self.mQueue addOperationWithBlock:^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            }];
            
            [self.mQueue addOperationWithBlock:^{
                //发送视频(把压缩后的视频进行发送)
                NSData* newData = [NSData dataWithContentsOfURL:newVideoUrl];
                [self sendMsgWithVideoData:newData];
            }];
        }];
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}

//视频压缩
- (void) convertVideoQuailtyWithInputURL:(NSURL*)inputURL outputURL:(NSURL*)outputURL quality:(NSString*)quality completeHandler:(void (^)(AVAssetExportSession*))handler {
    AVURLAsset *asset = [AVURLAsset URLAssetWithURL:inputURL options:nil];
    AVAssetExportSession *exportSession= [[AVAssetExportSession alloc] initWithAsset:asset presetName:quality];
    exportSession.outputURL = outputURL;
    exportSession.outputFileType = AVFileTypeQuickTimeMovie;
    [exportSession exportAsynchronouslyWithCompletionHandler:^(void) {
        switch (exportSession.status)
        {
            case AVAssetExportSessionStatusUnknown:
                break;
            case AVAssetExportSessionStatusWaiting:
                break;
            case AVAssetExportSessionStatusExporting:
                break;
            case AVAssetExportSessionStatusCompleted: {
                handler(exportSession);
                break;
            }
            case AVAssetExportSessionStatusFailed:
                break;
            case AVAssetExportSessionStatusCancelled:
                break;
        }
    }];
}


//从图片控制器里面得到图片
- (void)getPhotos:(NSMutableArray *)photos{
    for (HYPhotoItem* photoItem in photos) {
        [self sendMsgWithPhoto:photoItem];
    }
}

#pragma mark - 发送各种信息
/** 发送名片 */
- (void)sendMsgWithUserInfo:(HYUserInfo*)userIno{
    HYCardItem *cardItem = [[HYCardItem alloc] init];
    HYCardItemFrame* cardItemFrame = [[HYCardItemFrame alloc] init];
    AppDelegate* appD = (AppDelegate*)[UIApplication sharedApplication].delegate;
    cardItem.iconUrl = appD.imUserInfo.iconUrl;
    cardItem.lastMessageAtString = [NSDate currentStringFromPreString:[[NSDate date] stringFromDate]];
    cardItem.me = YES;
    cardItem.row = self.groups.count;
    cardItem.userInfo = userIno;
    //通过和上一个模型比较，看用不用显示时间
    HYBaseChatItemFrame* preItemFrame = [self.groups lastObject];
    HYBaseChatItem* preItem = preItemFrame.baseChatItem;
    if ([preItem.lastMessageAtString isEqualToString:cardItem.lastMessageAtString]) {
        cardItem.showTime = NO;
    }else{
        cardItem.showTime = YES;
    }
    cardItemFrame.baseChatItem = cardItem;
    
    [self.groups addObject:cardItemFrame];
    [self.itemArr addObject:cardItemFrame];
    [self.tableView reloadData];
    NSIndexPath* indexP = [NSIndexPath indexPathForRow:self.groups.count - 1 inSection:0];
    //把最后一行弹上
    if (indexP.row > -1) {
        [self.tableView scrollToRowAtIndexPath:indexP atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
    [self.navigationController popViewControllerAnimated:YES];
    
    NSData* infoData = [NSKeyedArchiver archivedDataWithRootObject:userIno];
    AVFile* file = [AVFile fileWithData:infoData];
    NSMutableDictionary* mulDict = [NSMutableDictionary dictionary];
    NSString* timeStr = [[NSDate date] stringFromDate];
    cardItem.timeStr = timeStr;
    [mulDict setObject:timeStr forKey:@"timeStr"];
    AVIMTextMessage* infoMsg = [AVIMTextMessage messageWithText:@"名片" file:file attributes:mulDict];
    infoMsg.mediaType = kAVIMMessageMediaTypeFile;
    [self pushMsg:infoMsg];
    
    [self.conversation sendMessage:infoMsg callback:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            HYLog(@"发送名片成功");
            cardItem.msgId = infoMsg.messageId;
            cardItem.timestamp = infoMsg.sendTimestamp;
            [self saveNewItemInDB];
            [self saveIDForMsgTimestamp:infoMsg.sendTimestamp and:YES];
            
        }else{
            HYLog(@"发送名片失败 --- %@", error);
        }
    }];
}

//发送音频信息
- (void)sendMsgWithAudioData:(NSData*)data andRecorderTime:(NSTimeInterval)recorderTime{
    HYAudioItem* audioItem = [[HYAudioItem alloc] init];
    HYAudioItemFrame* audioItemFrame = [[HYAudioItemFrame alloc] init];
    AppDelegate* appD = (AppDelegate*)[UIApplication sharedApplication].delegate;
    audioItem.iconUrl = appD.imUserInfo.iconUrl;

    audioItem.lastMessageAtString = [NSDate currentStringFromPreString:[[NSDate date] stringFromDate]];
    audioItem.me = YES;
    audioItem.audio = data;
    audioItem.row = self.groups.count;
    audioItem.showIndicator = YES;
    audioItem.audioTime = recorderTime;
    //通过和上一个模型比较，看用不用显示时间
    HYBaseChatItemFrame* preItemFrame = [self.groups lastObject];
    HYBaseChatItem* preItem = preItemFrame.baseChatItem;
    if ([preItem.lastMessageAtString isEqualToString:audioItem.lastMessageAtString]) {
        audioItem.showTime = NO;
    }else{
        audioItem.showTime = YES;
    }
    audioItemFrame.baseChatItem = audioItem;
    
    [self.groups addObject:audioItemFrame];
    [self.itemArr addObject:audioItemFrame];
    [self.tableView reloadData];
    NSIndexPath* indexP = [NSIndexPath indexPathForRow:self.groups.count - 1 inSection:0];
    //把最后一行弹上
    if (indexP.row > -1) {
        [self.tableView scrollToRowAtIndexPath:indexP atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
    
    NSMutableDictionary* mulDict = [NSMutableDictionary dictionary];
    NSString* timeStr = [[NSDate date] stringFromDate];
    [mulDict setObject:timeStr forKey:@"timeStr"];
    audioItem.timeStr = timeStr;
    [mulDict setValue:@(recorderTime) forKey:@"recorderTime"];
    
    AVFile* file = [AVFile fileWithData:data];
    AVIMAudioMessage* audioMsg = [AVIMAudioMessage messageWithText:@"音频" file:file attributes:mulDict];
    [self pushMsg:audioMsg];
    __weak typeof(self) weakSelf = self;
    [self.conversation sendMessage:audioMsg callback:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            HYLog(@"发送成功");
            audioItem.msgId = audioMsg.messageId;
            audioItem.timestamp = audioMsg.sendTimestamp;
            audioItem.showIndicator = NO;
            NSIndexPath* indP = [NSIndexPath indexPathForRow:audioItem.row inSection:0];
            [weakSelf.tableView reloadRowsAtIndexPaths:@[indP] withRowAnimation:UITableViewRowAnimationNone];
            [weakSelf saveNewItemInDB];
            [weakSelf saveIDForMsgTimestamp:audioMsg.sendTimestamp and:YES];
           
        }else{
            HYLog(@"发送失败 ---- %@", error);
        }
    }];
}

//发送视频消息
- (void)sendMsgWithVideoData:videoData{
    HYVideoItem* videoItem = [[HYVideoItem alloc] init];
    HYVideoItemFrame* videoItemFrame = [[HYVideoItemFrame alloc] init];
    AppDelegate* appD = (AppDelegate*)[UIApplication sharedApplication].delegate;
    videoItem.iconUrl = appD.imUserInfo.iconUrl;
   
    videoItem.lastMessageAtString = [NSDate currentStringFromPreString:[[NSDate date] stringFromDate]];
    videoItem.me = YES;
    videoItem.videoUrl = nil;
    videoItem.row = self.groups.count;
    videoItem.time = CMTimeMake(1, 1);
    //通过和上一个模型比较，看用不用显示时间
    HYBaseChatItemFrame* preItemFrame = [self.groups lastObject];
    HYBaseChatItem* preItem = preItemFrame.baseChatItem;
    if ([preItem.lastMessageAtString isEqualToString:videoItem.lastMessageAtString]) {
        videoItem.showTime = NO;
    }else{
        videoItem.showTime = YES;
    }
    videoItemFrame.baseChatItem = videoItem;
    
    [self.groups addObject:videoItemFrame];
    [self.itemArr addObject:videoItemFrame];
    [self.tableView reloadData];
    NSIndexPath* indexP = [NSIndexPath indexPathForRow:self.groups.count - 1 inSection:0];
    //把最后一行弹上
    if (indexP.row > -1) {
        [self.tableView scrollToRowAtIndexPath:indexP atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
    
    AVFile* file = [AVFile fileWithData:videoData];
    [file saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            [self.mQueue addOperationWithBlock:^{
                NSString* documentPath = HYVideoPath;
                [[NSFileManager defaultManager] createDirectoryAtPath:documentPath withIntermediateDirectories:YES attributes:nil error:nil];
                NSString* realStr = [file.url stringByReplacingOccurrencesOfString:@"/" withString:@"h"];
                NSString* videoName = [NSString stringWithFormat:@"%@.mov", realStr];
                NSString* videoPath = [documentPath stringByAppendingPathComponent:videoName];
                [videoData writeToFile:videoPath atomically:YES];
                
                //视屏截图，在cell上面先显示视频的截图，然后用户点击播放再进行播放
                UIImage *image = [UIImage getPicFromVideoUrl:[NSURL fileURLWithPath:videoPath]];

                //更新video的url，然后展示到tableView上
                HYVideoItemFrame* videoFrame = self.itemArr[videoItem.row];
                HYVideoItem* viItem = (HYVideoItem*)videoFrame.baseChatItem;
                viItem.videoUrl = videoPath;
                viItem.videoBgIma = image;
                NSIndexPath* indp = [NSIndexPath indexPathForRow:videoItem.row inSection:0];
                [self.tableView reloadRowsAtIndexPaths:@[indp] withRowAnimation:UITableViewRowAnimationNone];
                
                NSMutableDictionary* mulDict = [NSMutableDictionary dictionary];
                NSString* timeStr = [[NSDate date] stringFromDate];
                viItem.timeStr = timeStr;
                [mulDict setObject:timeStr forKey:@"timeStr"];
                [mulDict setObject:videoPath forKey:@"videoUrl"];
                AVIMVideoMessage* videoMsg = [AVIMVideoMessage messageWithText:@"[视频]" file:file attributes:mulDict];
                [self pushMsg:videoMsg];
                [self.conversation sendMessage:videoMsg progressBlock:^(NSInteger percentDone) {
                    
                } callback:^(BOOL succeeded, NSError *error) {
                    if (succeeded) {
                        HYLog(@"发送视频成功");
                        //更新最近消息的界面，同时存数据到数据库（异步)
                        viItem.msgId = videoMsg.messageId;
                        viItem.timestamp = videoMsg.sendTimestamp;
                        [self saveNewItemInDB];
                        [self saveIDForMsgTimestamp:videoMsg.sendTimestamp and:YES];
                       
                    } else {
                        HYLog(@"发送视频失败 --- %@", error);
                    }
                }];

            }];
        } else {
            [MBProgressHUD showError:@"网络繁忙，请稍后再试.."];
        }
    } progressBlock:^(NSInteger percentDone) {
        [self.mQueue addOperationWithBlock:^{
            //更新video的url，然后展示到tableView上
            HYVideoItemFrame* videoFrame = self.groups[videoItem.row];
            HYVideoItem* viItem = (HYVideoItem*)videoFrame.baseChatItem;
            viItem.sliderValue = (CGFloat)percentDone/100.0;
            NSIndexPath* indp = [NSIndexPath indexPathForRow:videoItem.row inSection:0];
            [self.tableView reloadRowsAtIndexPaths:@[indp] withRowAnimation:UITableViewRowAnimationNone];

        }];
    }];
}

//显示信息到cell，发送图片信息(只有自己发的图片类型信息通过这里发送)
- (void)sendMsgWithPhoto:(HYPhotoItem*)photoItem{
    HYPicItemFrame* picFrame = [[HYPicItemFrame alloc] init];
    HYPicItem* picItem = [[HYPicItem alloc] init];
    AppDelegate* appD = (AppDelegate*)[UIApplication sharedApplication].delegate;
    picItem.iconUrl = appD.imUserInfo.iconUrl;
    picItem.lastMessageAtString = [NSDate currentStringFromPreString:[[NSDate date] stringFromDate]];
    
    //通过和上一个模型比较，看用不用显示时间
    HYBaseChatItemFrame* preItemFrame = [self.groups lastObject];
    HYBaseChatItem* preItem = preItemFrame.baseChatItem;
    if ([preItem.lastMessageAtString isEqualToString:picItem.lastMessageAtString]) {
        picItem.showTime = NO;
    }else{
        picItem.showTime = YES;
    }
    picItem.me = YES;
    picItem.pic = photoItem.thumbnail;
    picItem.row = self.groups.count;
    picFrame.baseChatItem = picItem;
    [self.groups addObject:picFrame];
    [self.itemArr addObject:picFrame];
    [self.tableView reloadData];
    NSIndexPath* indexP = [NSIndexPath indexPathForRow:self.groups.count - 1 inSection:0];
    //把最后一行弹上
    if (indexP.row > -1) {
        [self.tableView scrollToRowAtIndexPath:indexP atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
    
    NSMutableDictionary* mulDict = [NSMutableDictionary dictionary];
    NSString* timeStr = [[NSDate date] stringFromDate];
    [mulDict setObject:timeStr forKey:@"timeStr"];
    picItem.timeStr = timeStr;
    //最近消息显示的时候，内容为[图片]
    NSData* photoData = UIImageJPEGRepresentation(photoItem.thumbnail, 1.0);
    AVFile* imaFile = [AVFile fileWithData:photoData];
    AVIMImageMessage* imageMsg = [AVIMImageMessage messageWithText:@"[图片]" file:imaFile attributes:mulDict];
    [self pushMsg:imageMsg];
    [self.conversation sendMessage:imageMsg progressBlock:^(NSInteger percentDone) {
        //计算比例，刷新cell
        HYPicItemFrame* picFrame = self.itemArr[picItem.row];
        HYPicItem* picItem = (HYPicItem*)picFrame.baseChatItem;
        picItem.sliderValue = percentDone / 100.0;
        [self.groups replaceObjectAtIndex:picItem.row withObject:picFrame];
        NSIndexPath* indp = [NSIndexPath indexPathForRow:picItem.row inSection:0];
        [self.tableView reloadRowsAtIndexPaths:@[indp] withRowAnimation:UITableViewRowAnimationNone];
    } callback:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            HYLog(@"发送图片成功");
            picItem.msgId = imageMsg.messageId;
            picItem.timestamp = imageMsg.sendTimestamp;
            //更新最近消息的界面，同时存数据到数据库（异步)
            [self saveNewItemInDB];
            [self saveIDForMsgTimestamp:imageMsg.sendTimestamp and:YES];

        } else {
            HYLog(@"发送图片失败 --- %@", error);
        }
    }];
}

//显示信息到cell，发送信息(只有自己发的文字类型信息通过这里发送)
- (void)sendMsg{
    HYContentItem* contentItem = [[HYContentItem alloc] init];
    AppDelegate* appD = (AppDelegate*)[UIApplication sharedApplication].delegate;
    contentItem.iconUrl = appD.imUserInfo.iconUrl;
    contentItem.lastMessageAtString = [NSDate currentStringFromPreString:[[NSDate date] stringFromDate]];
    contentItem.content = [self.inputView getMsg];
    contentItem.realString = [self.inputView realString];
    
    //通过和上一个模型比较，看用不用显示时间
    HYBaseChatItemFrame* preItemFrame = [self.groups lastObject];
    HYBaseChatItem* preItem = preItemFrame.baseChatItem;
    if ([preItem.lastMessageAtString isEqualToString:contentItem.lastMessageAtString]) {
        contentItem.showTime = NO;
    }else{
        contentItem.showTime = YES;
    }
    contentItem.me = YES;
    contentItem.showIndicator = YES;
    contentItem.row = self.groups.count;
    HYContentItemFrame* contentItemFrame = [[HYContentItemFrame alloc] init];
    contentItemFrame.baseChatItem = contentItem;
    
    [self.groups addObject:contentItemFrame];
    [self.tableView reloadData];
    [self.itemArr addObject:contentItemFrame];
    
    NSIndexPath* indexP = [NSIndexPath indexPathForRow:self.groups.count - 1 inSection:0];
    //把最后一行弹上
    if (indexP.row > -1) {
        [self.tableView scrollToRowAtIndexPath:indexP atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
    
    NSMutableDictionary* mulDict = [NSMutableDictionary dictionary];
    NSString* timeStr = [[NSDate date] stringFromDate];
    [mulDict setObject:timeStr forKey:@"timeStr"];
    contentItem.timeStr = timeStr;
    //发送对话
    AVIMTextMessage* textMsg = [AVIMTextMessage messageWithText:[self.inputView realString] attributes:mulDict];
    [self pushMsg:textMsg];
    [self.conversation sendMessage:textMsg callback:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            HYContentItemFrame* contF = self.itemArr[contentItem.row];
            contF.baseChatItem.showIndicator = NO;
            contentItem.msgId = textMsg.messageId;
            contentItem.timestamp = textMsg.sendTimestamp;
            [self.groups replaceObjectAtIndex:contF.baseChatItem.row withObject:contF];
            NSIndexPath* indp = [NSIndexPath indexPathForRow:contF.baseChatItem.row inSection:0];
            [self.tableView reloadRowsAtIndexPaths:@[indp] withRowAnimation:UITableViewRowAnimationNone];
            //更新最近消息的界面，同时存数据到数据库（异步)
            [self saveNewItemInDB];
            [self saveIDForMsgTimestamp:textMsg.sendTimestamp and:YES];

        }else{
            HYLog(@"%@", error);
        }
    }];
}


/** 发送提送到聊天用户的频道 */
- (void)pushMsg:(AVIMTypedMessage*)typeMsg{
    AVPush *push = [[AVPush alloc] init];
    [push setChannel:self.otherUserInfo.objectId];
    if (typeMsg.mediaType == kAVIMMessageMediaTypeText) {
        [push setMessage:typeMsg.text];
    }else if(typeMsg.mediaType == kAVIMMessageMediaTypeImage){
        [push setMessage:@"图片"];
    }else if(typeMsg.mediaType == kAVIMMessageMediaTypeVideo){
        [push setMessage:@"视频"];
    }else if(typeMsg.mediaType == kAVIMMessageMediaTypeAudio){
        [push setMessage:@"录音"];
    }else if(typeMsg.mediaType == kAVIMMessageMediaTypeFile){
        [push setMessage:@"名片"];
    }
    [push sendPushInBackground];
}

////////////////////////////////////////////////////////////////////////////////


/*
 * 改变tableView的思想：
 * 1：当键盘弹出的时候，设置tableView的frame为bottomView的y值。同时tableView的设置推到最上面。
 * 2：当键盘回收时，设置tableView的frame为bottomView的y值。同时tableView的设置推到最上面。
 */
- (void)textFieldKeyBoardChange:(NSNotification*)notification{
    CGRect keyBR = [notification.userInfo[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    if (keyBR.origin.y < self.view.frame.size.height) {
        //向上
        self.inputView.transform = CGAffineTransformMakeTranslation(0, (-keyBR.size.height));
    } else {
        //向下
        self.inputView.transform = CGAffineTransformMakeTranslation(0, 0);
    }
    CGFloat hei;
    hei = self.inputView.y;
    self.tableView.height = hei;
    NSIndexPath* indexP = [NSIndexPath indexPathForRow:self.groups.count - 1 inSection:0];
    //把最后一行弹上
    if (indexP.row > -1) {
        [self.tableView scrollToRowAtIndexPath:indexP atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
}


#pragma mark - 接收到新消息
////////////////////////////////////接收到新消息/////////////////////////////////////////////

/*
 * 接收到新消息时做处理
 */
- (void)didReceiveNewMsg:(NSNotification*)notification{
    //查看传来的用户id和当前他人用户id是否一样，一样的话，修改模型，刷新界面
    NSString* objectId = notification.userInfo[@"objectId"];
    if ([objectId isEqualToString:self.otherUserInfo.objectId]) {
        //根据传过来的msg类型，判断使用什么类型的Item模型，代理方法根据不同模型使用不同类型的cell
        AVIMTypedMessage* typeMsg = notification.userInfo[@"AVIMTypedMessage"];
        //传过来是文本模型
        if (typeMsg.mediaType == kAVIMMessageMediaTypeText) {
            [self createTextItemWithNotification:notification];
        } else if(typeMsg.mediaType == kAVIMMessageMediaTypeImage){
            [self createPicItemWithNotification:notification];
        } else if(typeMsg.mediaType == kAVIMMessageMediaTypeVideo){
            [self createVideoItemWithNotification:notification];
        } else if(typeMsg.mediaType == kAVIMMessageMediaTypeAudio){
            [self createAudioItemWithNotification:notification];
        } else if(typeMsg.mediaType == kAVIMMessageMediaTypeFile){
            [self createCardItemWithNotification:notification];
        }
        [self saveIDForMsgTimestamp:typeMsg.sendTimestamp and:YES];
    }
}

- (void)createTextItemWithNotification:(NSNotification*)notification{
    HYContentItem* contentItem = [[HYContentItem alloc] init];
    contentItem.iconUrl = self.otherUserInfo.iconUrl;
    AVIMTypedMessage* typeMsg = notification.userInfo[@"AVIMTypedMessage"];
    AVIMTextMessage* textMsg = (AVIMTextMessage*)typeMsg;
    [contentItem setContentWithMsgText:textMsg.text];
    contentItem.lastMessageAtString = [NSDate currentStringFromPreString:textMsg.attributes[@"timeStr"]];
    contentItem.msgId = textMsg.messageId;
    contentItem.timestamp = textMsg.sendTimestamp;

    //通过和上一个模型比较，看用不用显示时间
    HYBaseChatItemFrame* preItemFrame = [self.groups lastObject];
    HYBaseChatItem* preItem = preItemFrame.baseChatItem;
    if ([preItem.lastMessageAtString isEqualToString:contentItem.lastMessageAtString]) {
        contentItem.showTime = NO;
    }else{
        contentItem.showTime = YES;
    }
    contentItem.me = NO;
    contentItem.showIndicator = NO;
    contentItem.row = self.groups.count;
    HYContentItemFrame* contentItemFrame = [[HYContentItemFrame alloc] init];
    contentItemFrame.baseChatItem = contentItem;
    
    [self.groups addObject:contentItemFrame];
    [self.itemArr addObject:contentItemFrame];
    [self.tableView reloadData];
    
    NSIndexPath* indexP = [NSIndexPath indexPathForRow:self.groups.count - 1 inSection:0];
    //把最后一行弹上
    if (indexP.row > -1) {
        [self.tableView scrollToRowAtIndexPath:indexP atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
}

- (void)createPicItemWithNotification:(NSNotification*)notification{
    HYPicItem* picItem = [[HYPicItem alloc] init];
    picItem.iconUrl = self.otherUserInfo.iconUrl;
    AVIMTypedMessage* typeMsg = notification.userInfo[@"AVIMTypedMessage"];
    AVIMImageMessage* imaMsg = (AVIMImageMessage*)typeMsg;
    picItem.lastMessageAtString = [NSDate currentStringFromPreString:imaMsg.attributes[@"timeStr"]];
    picItem.msgId = imaMsg.messageId;
    picItem.timestamp = imaMsg.sendTimestamp;
    //通过和上一个模型比较，看用不用显示时间
    HYBaseChatItemFrame* preItemFrame = [self.groups lastObject];
    HYBaseChatItem* preItem = preItemFrame.baseChatItem;
    if ([preItem.lastMessageAtString isEqualToString:picItem.lastMessageAtString]) {
        picItem.showTime = NO;
    }else{
        picItem.showTime = YES;
    }
    picItem.me = NO;
    picItem.row = self.groups.count;
    picItem.sliderValue = 1.0;
    AVFile* file = imaMsg.file;
    NSData*data = [file getData];
    picItem.pic = [UIImage imageWithData:data];
    HYPicItemFrame* picItemFrame = [[HYPicItemFrame alloc] init];
    picItemFrame.baseChatItem = picItem;
    
    [self.groups addObject:picItemFrame];
    [self.itemArr addObject:picItemFrame];
    [self.tableView reloadData];
    
    NSIndexPath* indexP = [NSIndexPath indexPathForRow:self.groups.count - 1 inSection:0];
    //把最后一行弹上
    if (indexP.row > -1) {
        [self.tableView scrollToRowAtIndexPath:indexP atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
}

- (void)createVideoItemWithNotification:(NSNotification*)notification{
    HYVideoItem* videoItem = [[HYVideoItem alloc] init];
    videoItem.iconUrl = self.otherUserInfo.iconUrl;
   
    AVIMTypedMessage* typeMsg = notification.userInfo[@"AVIMTypedMessage"];
    AVIMVideoMessage* videoMsg = (AVIMVideoMessage*)typeMsg;
    videoItem.lastMessageAtString = [NSDate currentStringFromPreString:typeMsg.attributes[@"timeStr"]];
    videoItem.msgId = videoMsg.messageId;
    videoItem.timestamp = videoMsg.sendTimestamp;
    //通过和上一个模型比较，看用不用显示时间
    HYBaseChatItemFrame* preItemFrame = [self.groups lastObject];
    HYBaseChatItem* preItem = preItemFrame.baseChatItem;
    if ([preItem.lastMessageAtString isEqualToString:videoItem.lastMessageAtString]) {
        videoItem.showTime = NO;
    }else{
        videoItem.showTime = YES;
    }
    videoItem.me = NO;
    videoItem.row = self.groups.count;
    videoItem.sliderValue = 1.0;
    videoItem.time = CMTimeMake(1, 1);
    //被压缩过的视频
    NSData*data = [videoMsg.file getData];
    NSString* documentPath = HYVideoPath;
    [[NSFileManager defaultManager] createDirectoryAtPath:documentPath withIntermediateDirectories:YES attributes:nil error:nil];
    NSString* realStr = [videoMsg.file.url stringByReplacingOccurrencesOfString:@"/" withString:@"h"];
    NSString* videoName = [NSString stringWithFormat:@"%@.mov", realStr];
    NSString* videoPath = [documentPath stringByAppendingPathComponent:videoName];
    [data writeToFile:videoPath atomically:YES];
    videoItem.videoBgIma = [UIImage getPicFromVideoUrl:[NSURL fileURLWithPath:videoPath]];
    HYVideoItemFrame* videoItemFrame = [[HYVideoItemFrame alloc] init];
    videoItemFrame.baseChatItem = videoItem;
    videoItem.videoUrl = videoPath;
    [self.groups addObject:videoItemFrame];
    [self.itemArr addObject:videoItemFrame];
    [self.tableView reloadData];
    
    NSIndexPath* indexP = [NSIndexPath indexPathForRow:self.groups.count - 1 inSection:0];
    //把最后一行弹上
    if (indexP.row > -1) {
        [self.tableView scrollToRowAtIndexPath:indexP atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }

}

- (void)createAudioItemWithNotification:(NSNotification*)notification{
    HYAudioItem* audioItem = [[HYAudioItem alloc] init];
    audioItem.iconUrl = self.otherUserInfo.iconUrl;
    AVIMTypedMessage* typeMsg = notification.userInfo[@"AVIMTypedMessage"];
    AVIMAudioMessage* audioMsg = (AVIMAudioMessage*)typeMsg;
    audioItem.lastMessageAtString = [NSDate currentStringFromPreString:audioMsg.attributes[@"timeStr"]];
    audioItem.msgId = audioMsg.messageId;
    audioItem.timestamp = audioMsg.sendTimestamp;
    //通过和上一个模型比较，看用不用显示时间
    HYBaseChatItemFrame* preItemFrame = [self.groups lastObject];
    HYBaseChatItem* preItem = preItemFrame.baseChatItem;
    if ([preItem.lastMessageAtString isEqualToString:audioItem.lastMessageAtString]) {
        audioItem.showTime = NO;
    }else{
        audioItem.showTime = YES;
    }
    audioItem.me = NO;
    audioItem.row = self.groups.count;

    audioItem.audio = [audioMsg.file getData];
    NSNumber* audioTim = audioMsg.attributes[@"recorderTime"];
    audioItem.audioTime = audioTim.doubleValue;
    
    HYAudioItemFrame* audioItemFrame = [[HYAudioItemFrame alloc] init];
    audioItemFrame.baseChatItem = audioItem;

    [self.groups addObject:audioItemFrame];
    [self.itemArr addObject:audioItemFrame];
    [self.tableView reloadData];
    
    NSIndexPath* indexP = [NSIndexPath indexPathForRow:self.groups.count - 1 inSection:0];
    //把最后一行弹上
    if (indexP.row > -1) {
        [self.tableView scrollToRowAtIndexPath:indexP atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
}

- (void)createCardItemWithNotification:(NSNotification*)notification{
    HYCardItem* cardItem = [[HYCardItem alloc] init];
    cardItem.iconUrl = self.otherUserInfo.iconUrl;
    AVIMTypedMessage* typeMsg = notification.userInfo[@"AVIMTypedMessage"];
    cardItem.lastMessageAtString = [NSDate currentStringFromPreString:typeMsg.attributes[@"timeStr"]];
    cardItem.msgId = typeMsg.messageId;
    cardItem.timestamp = typeMsg.sendTimestamp;
    //通过和上一个模型比较，看用不用显示时间
    HYBaseChatItemFrame* preItemFrame = [self.groups lastObject];
    HYBaseChatItem* preItem = preItemFrame.baseChatItem;
    if ([preItem.lastMessageAtString isEqualToString:cardItem.lastMessageAtString]) {
        cardItem.showTime = NO;
    }else{
        cardItem.showTime = YES;
    }
    cardItem.me = NO;
    cardItem.row = self.groups.count;
    NSData*data = [typeMsg.file getData];
    cardItem.userInfo = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    HYCardItemFrame* cardItemFrame = [[HYCardItemFrame alloc] init];
    cardItemFrame.baseChatItem = cardItem;
    
    [self.groups addObject:cardItemFrame];
    [self.itemArr addObject:cardItemFrame];
    [self.tableView reloadData];
    
    NSIndexPath* indexP = [NSIndexPath indexPathForRow:self.groups.count - 1 inSection:0];
    //把最后一行弹上
    if (indexP.row > -1) {
        [self.tableView scrollToRowAtIndexPath:indexP atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }

}

////////////////////////////////////////////////////////////////////////////////


#pragma mark - tableViewDelegate
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HYBaseChatItemFrame* baseItemFrame = self.groups[indexPath.row];
    HYBaseChatItem* item = baseItemFrame.baseChatItem;
    HYBaseChatCell* cell = nil;
    if ([item isKindOfClass:[HYContentItem class]]) {
        cell = [HYContentCell cellForTableView:tableView andItem:baseItemFrame];
    }else if([item isKindOfClass:[HYAudioItem class]]){
        cell = [HYAudioCell cellForTableView:tableView andItem:baseItemFrame];
    }else if([item isKindOfClass:[HYVideoItem class]]){
        cell = [HYVideoCell cellForTableView:tableView andItem:baseItemFrame];
    }else if([item isKindOfClass:[HYPicItem class]]){
        cell = [HYPicCell cellForTableView:tableView andItem:baseItemFrame];
    }else if([item isKindOfClass:[HYCardItem class]]){
        cell = [HYCardCell cellForTableView:tableView andItem:baseItemFrame];
    }
    cell.delegate = self;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    HYBaseChatItemFrame* baseItemFrame = self.groups[indexPath.row];
    return baseItemFrame.height;
}



#pragma mark - HYPicCellDeleagte
-(void)cell:(HYBaseChatCell *)cell didClickBtnType:(cellBtnType)type WithBtn:(UIButton *)sender Item:(HYBaseChatItem *)item{
    switch (type) {
        case cellBtnTypeIcon:
            [self setupInfoVCWithIcon:sender andItem:item];
            break;
        case cellBtnTypePic:
            [self setupPicWithIcon:sender AndPicItem:(HYPicItem*)item andCell:(HYPicCell*)cell];
            break;
        case cellBtnTypeCard:
            [self setupInfoVCWithItem:item];
            break;
        default:
            break;
    }
}


//展示个人信息
- (void)setupInfoVCWithIcon:(UIButton*)sender andItem:(HYBaseChatItem*)item{
    if ([item isMe]) {
        HYImInfoController* imInfoVC = [[HYImInfoController alloc] init];
        AppDelegate* appD = [UIApplication sharedApplication].delegate;
        imInfoVC.imUsrInfo = appD.imUserInfo;
        [self.navigationController pushViewController:imInfoVC animated:YES];
    } else {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [HYUserInfoTool loadAllFriendInfoWithParamters:nil success:^(HYResponseObject *responseObject) {
            for (HYUserInfo*userInfo  in responseObject.resultInfo) {
                if ([userInfo.objectId isEqualToString:self.otherUserInfo.objectId]) {
                    HYFriendInfoController* friendInVC = [[HYFriendInfoController alloc] init];
                    friendInVC.imUsrInfo = self.otherUserInfo;
                    [self.navigationController pushViewController:friendInVC animated:YES];
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    return;
                }
            }
            
            HYOtherInfoController* otherVC = [[HYOtherInfoController alloc] init];
            otherVC.imUsrInfo = self.otherUserInfo;
            [self.navigationController pushViewController:otherVC animated:YES];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
 
        } failure:^(NSError *error) {
            
        }];
    }
}

//展示大图
- (void)setupPicWithIcon:(UIButton*)sender AndPicItem:(HYPicItem*)picItem andCell:(HYPicCell*)picCell{
    UIWindow* lastWindow = [[UIApplication sharedApplication].windows lastObject];
    UIButton* bgView = [[UIButton alloc] init];
    [bgView addTarget:self action:@selector(backPic) forControlEvents:UIControlEventTouchUpInside];
    bgView.backgroundColor = [UIColor blackColor];
    bgView.frame = CGRectMake(0, 0, mainScreenWid, mainScreenHei);
    bgView.alpha = 0.0;
    [lastWindow addSubview:bgView];
    self.bgView = bgView;
    
    UIButton* picBtn = [[UIButton alloc] init];
    [picBtn setBackgroundImage:sender.currentImage forState:UIControlStateNormal];
    CGRect currentFrame = [picCell convertRect:sender.frame toView:lastWindow];
    [picBtn addTarget:self action:@selector(backPic) forControlEvents:UIControlEventTouchUpInside];
    UIPanGestureRecognizer* panPressG = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    UIPinchGestureRecognizer* scalePinG = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(scale:)];
    [picBtn addGestureRecognizer:panPressG];
    [picBtn addGestureRecognizer:scalePinG];
    picBtn.frame = currentFrame;
    self.picOriginFrame = currentFrame;
    [lastWindow addSubview:picBtn];
    self.picBtn = picBtn;
    [UIView animateWithDuration:0.001 animations:^{
        self.picBtn.frame = self.picOriginFrame;
    }completion:^(BOOL finished) {
        if (finished) {
            [UIView animateWithDuration:0.8 animations:^{
                self.bgView.alpha = 0.6;
                CGFloat picX, picY, picWid, picHei;
                picWid = mainScreenWid;
                picHei = picWid * (picItem.pic.size.height / picItem.pic.size.width);
                picX = 0;
                picY = mainScreenHei * 0.12;
                picBtn.frame = CGRectMake(picX, picY, picWid, picHei);
            }];
        }
    }];
}

//展示名片详细信息
- (void)setupInfoVCWithItem:(HYBaseChatItem *)item{
    HYCardItem* cardItem = (HYCardItem*)item;
    if ([cardItem.userInfo.objectId isEqualToString:[AVUser currentUser].objectId]) {
        HYImInfoController* imInfoVC = [[HYImInfoController alloc] init];
        AppDelegate* appD = [UIApplication sharedApplication].delegate;
        imInfoVC.imUsrInfo = appD.imUserInfo;
        [self.navigationController pushViewController:imInfoVC animated:YES];
    } else {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [HYUserInfoTool loadAllFriendInfoWithParamters:nil success:^(HYResponseObject *responseObject) {
            for (HYUserInfo*userInfo  in responseObject.resultInfo) {
                if ([userInfo.objectId isEqualToString:cardItem.userInfo.objectId]) {
                    HYFriendInfoController* friendInVC = [[HYFriendInfoController alloc] init];
                    friendInVC.imUsrInfo = cardItem.userInfo;
                    [self.navigationController pushViewController:friendInVC animated:YES];
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    return;
                }
            }
            
            HYOtherInfoController* otherVC = [[HYOtherInfoController alloc] init];
            otherVC.imUsrInfo = cardItem.userInfo;
            [self.navigationController pushViewController:otherVC animated:YES];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
        } failure:^(NSError *error) {
            
        }];
    }

}

//监听大图的拖拽
- (void)longPress:(UIPanGestureRecognizer*)panPressG{
        CGPoint point = [panPressG locationInView:self.view];
        CGFloat currX, currY;
        currX = point.x;
        currY = point.y;
        self.picBtn.center = CGPointMake(currX, currY);
}

//监听大图的缩放
- (void)scale:(UIPinchGestureRecognizer*)pinG{
    self.picBtn.transform = CGAffineTransformScale(self.picBtn.transform, pinG.scale, pinG.scale);
    pinG.scale = 1.0;
}

//撤销大图
- (void)backPic{
    [UIView animateWithDuration:1.0 animations:^{
        self.bgView.alpha = 0.0;
        self.picBtn.frame = self.picOriginFrame;
    } completion:^(BOOL finished) {
        if (finished) {
            [self.bgView removeFromSuperview];
            [self.picBtn removeFromSuperview];
        }
    }];

}


- (void)dealloc
{
    HYLog(@"销毁了");
}




@end
