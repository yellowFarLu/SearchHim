//
//  HYInputView.m
//  searHim重制版-01基本框架构建
//
//  Created by 黄远 on 16/7/15.
//  Copyright © 2016年 黄远. All rights reserved.
//  语音聊天按钮，输入文本框，表情按钮，加号按钮（当用户输入文字的时候，变成发送）

#import "HYInputView.h"
#import "HYInputTextView.h"
#import "HYEmotion.h"
#import "HYRecorderBtn.h"
#import "HYContentItem.h"
#define HYSendBtnFont [UIFont boldSystemFontOfSize:15]
#define HYInputFont [UIFont systemFontOfSize:20]
#define defaultTextViewHeight 40
#define defaultInputViewHeight 50

@interface HYInputView () <HYInputTextViewDelegate, HYRecorderBtnDelegate>
//语音聊天按钮
@property (nonatomic, weak) UIButton* audioRecorderBtn;
//输入文本框
@property (nonatomic, weak) HYInputTextView* textView;
//笑脸按钮
@property (nonatomic, weak) UIButton* expressBtn;
//加号按钮（当用户输入文字的时候，变成发送）
@property (nonatomic, weak) UIButton* addBtn;
//分割线
@property (nonatomic, weak) UIView* diver;
//发送按钮
@property (nonatomic, weak) UIButton* sendBtn;
//点击录音按钮
@property (nonatomic, weak) HYRecorderBtn* recorderBtn;

@property (nonatomic, strong) NSOperationQueue* mQueue;

//设立换行标志
@property (nonatomic, assign, getter=isAlertRow) BOOL alertRow;
@end

@implementation HYInputView

#pragma mark - HYRecorderBtnDelegate
- (void)getData:(NSData *)data andRecorderTime:(NSTimeInterval)recorderTime{
    [self.delegate hasGetAudioData:data andRecorderTime:recorderTime];
}

- (void)setShowEmotion:(BOOL)showEmotion{
    _showEmotion = showEmotion;
    if ([self isShowEmotion]) {
        [self.expressBtn setImage:[UIImage imageNamed:@"chat_bottom_keyboard_nor"] forState:UIControlStateNormal];
    }else{
        [self.expressBtn setImage:[UIImage imageNamed:@"chat_bottom_smile_nor"] forState:UIControlStateNormal];
    }
}

- (NSOperationQueue *)mQueue{
    if (!_mQueue) {
        _mQueue = [NSOperationQueue mainQueue];
    }
    return _mQueue;
}

- (NSString*)realString{
    return [self.textView realString];
}

- (void)didSelectedEmotion:(NSNotification*)notification{
    HYEmotion* emotion = notification.userInfo[HYCurrentEmotion];
    self.textView.emotion = emotion;
    [self textViewDidChange:self.textView];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (NSAttributedString *)getMsg{
    return self.textView.attributedText;
}

#pragma mark - HYTextViewDelegate
- (void)textViewDidChange:(UITextView *)textView{
    //得到当前的，拼接到原来的富文本上面
//    [self setupRichString];

    if ([textView hasText]) {
        self.addBtn.hidden = YES;
        self.sendBtn.hidden = NO;
        [self.textView showClearBtn];
    }else{
        self.addBtn.hidden = NO;
        self.sendBtn.hidden = YES;
        [self.textView hiddenClearBtn];
    }
    
    [self.mQueue addOperationWithBlock:^{
        //每一次换行，相当于滚动，会调用layoutSubviews方法
        CGSize size = textView.contentSize;
        CGFloat newHei, newY;
        if (size.height > textView.height) {
            CGFloat upMargin = size.height - textView.height;
            newHei = self.height + upMargin;
            newY = self.y - upMargin;
            self.alertRow = YES;
            self.frame = CGRectMake(self.x, newY, self.width, newHei);
        }else if(size.height < textView.height){
            CGFloat downMargin = textView.height - size.height;
            CGFloat tem = self.height - downMargin;
            HYLog(@"%f ------ %f", size.height, tem);
            if (tem < defaultInputViewHeight) {
                return;
            }
            newY = self.y + downMargin;
            newHei = self.height - downMargin;
            self.frame = CGRectMake(self.x, newY, self.width, newHei);
        }
        
        //由于可能self.textView.height未更新，然后又再次调用本函数，导致self的高度重复加了，所以在本函数里面要先刷新self.textView.height
        if (self.textView.contentSize.height < defaultTextViewHeight) {
            self.textView.height = defaultTextViewHeight;
        }else{
            self.textView.height = self.textView.contentSize.height;
        }
    }];
}

- (void)setupRichString{
    
}

- (void)didClearTextView:(HYInputTextView *)textView{
    [self textViewDidChange:self.textView];
}

- (UIView*)inputView{
    return self.textView.inputView;
}

- (void)setInputView:(UIView*)inputView{
    self.textView.inputView = inputView;
}

- (BOOL)resignFirstResponder{
    [self.textView resignFirstResponder];
    return [super resignFirstResponder];
}

- (BOOL)becomeFirstResponder{
    [self.textView becomeFirstResponder];
    return [super becomeFirstResponder];
}

//点击了录音图标
- (void)onClickAudio{
    if (self.recorderBtn.hidden) {
        [self.audioRecorderBtn setImage:[UIImage imageNamed:@"chat_bottom_keyboard_nor"] forState:UIControlStateNormal];
        self.recorderBtn.hidden = NO;
        [self.textView endEditing:YES];
        self.textView.hidden = YES;
    }else{
        [self.audioRecorderBtn setImage:[UIImage imageNamed:@"chat_bottom_voice_press"] forState:UIControlStateNormal];
        self.recorderBtn.hidden = YES;
        [self.textView endEditing:NO];
        [self.textView becomeFirstResponder];
        self.textView.hidden = NO;
    }
}

- (instancetype)init{
    if (self = [super init]) {
        self.backgroundColor = [UIColor whiteColor];
        self.sendBtn.hidden = YES;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSelectedEmotion:) name:HYEmotionDidClickNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteEmotion) name:HYEmotionDelegateNotification object:nil];
    }
    return self;
}

- (void)deleteEmotion{
    [self.textView deleteBackward];
}

- (void)layoutSubviews{
    [super layoutSubviews];

    CGFloat audioX, audioY, audioWid,audioHei;
    CGFloat margin = 5;
    audioX = 0;
    audioWid = audioHei = self.audioRecorderBtn.imageView.image.size.width * 0.6; //图片的0.7倍
    audioY = self.height - audioHei -margin*2;
    self.audioRecorderBtn.frame = CGRectMake(audioX, audioY, audioWid, audioHei);
    
    CGFloat addX, addY, addWid, addHei;
    addWid = addHei = audioWid + 10;
    addY = self.height - addHei - 3;
    addX = self.width - addWid - margin;
    self.addBtn.frame = CGRectMake(addX, addY, addWid, addHei);
    
    
    CGFloat diverX, diverY, diverWid, diverHei;
    diverX = self.audioRecorderBtn.width;
    diverY = self.height - margin;
    diverHei = 1;
    diverWid = self.width - self.audioRecorderBtn.width - self.addBtn.width - margin;
    self.diver.frame = CGRectMake(diverX, diverY, diverWid, diverHei);

    
    CGFloat expressX, expressY, expressWid, expressHei;
    expressWid = expressHei = self.expressBtn.imageView.image.size.width * 0.5;
    expressY = diverY - expressHei - 2;
    expressX = self.width - self.addBtn.width - expressWid - margin;
    self.expressBtn.frame = CGRectMake(expressX, expressY, expressWid, expressHei);
    
    
    CGFloat textViewX, textViewY, textViewWid, textViewHei;
    textViewX = self.audioRecorderBtn.width + margin;
    textViewY = 0;
    if (self.textView.contentSize.height < defaultTextViewHeight) {
        textViewHei = defaultTextViewHeight;
    }else{
        textViewHei = self.textView.contentSize.height;
    }
    textViewWid = (self.width - audioWid - addWid - expressWid - margin*2);
    self.textView.frame = CGRectMake(textViewX, textViewY, textViewWid, textViewHei);
    
    self.sendBtn.frame = self.addBtn.frame;
    self.sendBtn.height -= 10;
    self.sendBtn.y += 5;
    self.sendBtn.x += 2.5;
    self.sendBtn.width -= 5;
    
    self.recorderBtn.frame = self.textView.frame;
    
    /*
     * 由于每次换行，系统都会改变偏移，因此，我们自己改回来
     */
    if ([self isAlertRow]) {
        self.textView.contentOffset = CGPointMake(0, -15);
        self.alertRow = NO;
    }
//    HYLog(@"加号的x = %f   表情的x = %f", self.addBtn.frame.origin.x, self.expressBtn.frame.origin.x);
}

- (BOOL)endEditing:(BOOL)force{
    [self.textView endEditing:YES];
    return [super endEditing:force];
}

- (HYRecorderBtn*)recorderBtn{
    if (!_recorderBtn) {
        NSString* filePath = [self.delegate getCafFilePath];
        HYRecorderBtn* recorderBtn = [HYRecorderBtn initWithDelegata:self maxtime:60 buttonTitle:@"上滑取消录音" andRecorderFilePath:filePath];
        [recorderBtn setTitle:@"按住 说话" forState:UIControlStateNormal];
        [recorderBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [recorderBtn setBackgroundImage:[UIImage resizeImageWithOriginalName:@"searchbar_textfield_background"] forState:UIControlStateNormal];
        recorderBtn.hidden = YES;
        [self addSubview:recorderBtn];
        _recorderBtn = recorderBtn;
    }
    return _recorderBtn;
}

#define sendBtnCornerRadius 5
- (UIButton*)sendBtn{
    if (!_sendBtn) {
        UIButton *sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [sendBtn setTitle:@"发送" forState:UIControlStateNormal];
        [sendBtn setTitleColor:backBtnColor forState:UIControlStateNormal];
        [sendBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        [sendBtn addTarget:self action:@selector(sendMsg) forControlEvents:UIControlEventTouchUpInside];
        sendBtn.tag = InputBtnTypeSend;
//        sendBtn.backgroundColor = [UIColor lightGrayColor];
        sendBtn.layer.cornerRadius = sendBtnCornerRadius;
        sendBtn.clipsToBounds = YES;
        sendBtn.titleLabel.font = HYSendBtnFont;
        sendBtn.alpha = 0.6;
        [self addSubview:sendBtn];
        _sendBtn = sendBtn;
    }
    return _sendBtn;
}

- (void)sendMsg{
    [self.delegate inputView:self didClickBtnType:(int)self.sendBtn.tag];
    self.textView.text = nil;
    self.textView.attributedText = nil;
    [self textViewDidChange:self.textView];
}

- (UIView*)diver{
    if (!_diver) {
        //设置分割线
        UIView* MyView = [[UIView alloc] init];
        MyView.backgroundColor = backBtnColor;
        MyView.alpha = 0.2;
        _diver = MyView;
        [self addSubview:MyView];
    }
    return _diver;
}

- (UITextView*)textView{
    if (!_textView) {
        HYInputTextView* textView = [[HYInputTextView alloc] init];
        textView.font = statusOriginTextFont;
        textView.delegate = self;
//        textView.backgroundColor = [UIColor redColor];
        [self addSubview:textView];
        _textView = textView;
    }
    return _textView;
}

- (UIButton*)addBtn{
    if (!_addBtn) {
        UIButton* addBtn= [UIButton buttonWithType:UIButtonTypeCustom];
        [addBtn setImage:[UIImage imageNamed:@"chat_bottom_up_nor"] forState:UIControlStateNormal];
        addBtn.tag = InputBtnTypeAdd;
        [addBtn addTarget:self action:@selector(onClickAdd) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:addBtn];
        _addBtn = addBtn;
    }
    return _addBtn;
}

- (void)onClickAdd{
    [self.delegate inputView:self didClickBtnType:(int)self.addBtn.tag];
}

- (UIButton*)expressBtn{
    if (!_expressBtn) {
        UIButton* expressBtn= [UIButton buttonWithType:UIButtonTypeCustom];
        [expressBtn setImage:[UIImage imageNamed:@"chat_bottom_smile_nor"] forState:UIControlStateNormal];
        expressBtn.tag = InputBtnTypeExpress;
        [expressBtn addTarget:self action:@selector(clickExpress) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:expressBtn];
        _expressBtn = expressBtn;
    }
    return _expressBtn;
}

- (void)clickExpress{
    [self.delegate inputView:self didClickBtnType:(int)self.expressBtn.tag];
}

- (UIButton*)audioRecorderBtn{
    if (!_audioRecorderBtn) {
        UIButton* audioRecorderBtn= [UIButton buttonWithType:UIButtonTypeCustom];
        [audioRecorderBtn setImage:[UIImage imageNamed:@"chat_bottom_voice_press"] forState:UIControlStateNormal];
        [audioRecorderBtn addTarget:self action:@selector(onClickAudio) forControlEvents:UIControlEventTouchUpInside];
        audioRecorderBtn.tag = InputBtnTypeAudio;
        [self addSubview:audioRecorderBtn];
        _audioRecorderBtn = audioRecorderBtn;
    }
    return _audioRecorderBtn;
}




@end
