//
//  HYRecorderBtn.m
//  searHim重制版-01基本框架构建
//
//  Created by 黄远 on 16/7/23.
//  Copyright © 2016年 黄远. All rights reserved.
//

#import "HYRecorderBtn.h"
#import "RecordHUD.h"
#import "AACRecorder.h"

@interface HYRecorderBtn () <AACRecorderDelegate>

@end

@implementation HYRecorderBtn

+ (instancetype)initWithDelegata:(id<HYRecorderBtnDelegate>)delegate maxtime:(int)maxtime buttonTitle:(NSString*)title andRecorderFilePath:(NSString*)filePath{
    HYRecorderBtn* recordBtn = [[HYRecorderBtn alloc] init];
    recordBtn.delegate = delegate;
    [recordBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    recordBtn.maxtime = maxtime;
    recordBtn.buttomTitle = title;
    AACRecorder* recorder = [[AACRecorder alloc] init];
    recorder.delegate = recordBtn;
    //document路径 + 64位随机字符串 + otherObjectId
    recorder.filePath = filePath;
    recordBtn.recorder = recorder;
    return recordBtn;
}

- (instancetype)init{
    if (self = [super init]) {
        [self addTarget:self action:@selector(startRecord) forControlEvents:UIControlEventTouchDown];
        [self addTarget:self action:@selector(stopRecord) forControlEvents:UIControlEventTouchUpInside];
        [self addTarget:self action:@selector(cancelRecord) forControlEvents:UIControlEventTouchUpOutside | UIControlEventTouchCancel];
        [self addTarget:self action:@selector(RemindDragExit) forControlEvents:UIControlEventTouchDragExit];
        [self addTarget:self action:@selector(RemindDragEnter) forControlEvents:UIControlEventTouchDragEnter];

    }
    return self;
}

//取消录音
- (void)cancelRecord{
    [self.recorder cancelRecord];
    [RecordHUD dismiss];
    [RecordHUD setTitle:@"已取消录音"];
}

- (void)RemindDragExit{
    [RecordHUD setTitle:@"松手取消录音"];
}

//进入按钮范围
- (void)RemindDragEnter
{
    [self setHUDTitle];
}


- (void)startRecord{
    [self.recorder benginRecorder];
    [RecordHUD show];
    [self setHUDTitle];
}

- (void)stopRecord{
    [self.recorder stopRecorder];
    [RecordHUD dismiss];
}

-(void)setHUDTitle{
    if (self.buttomTitle != nil) {
        [RecordHUD setTitle:self.buttomTitle];
    }
    else{
        [RecordHUD setTitle:@"离开按钮取消录音"];
    }
}


#pragma mark - recorderDelegate
- (void)failRecord{
    [MBProgressHUD showError:@"录制时间太短"];
}

- (void)beginConvert{
    
}

//回调录音资料
- (void)endConvertWithData:(NSData *)voiceData andRecorderTime:(NSTimeInterval)recorderTime
{
    [RecordHUD setTitle:@"录音成功"];
    [_delegate getData:voiceData andRecorderTime:recorderTime];
}

//更新按钮的播放图片
- (void)recording:(CGFloat)recordTime volume:(double)lowPassResult{
    if (recordTime >= self.maxtime) {
        [self stopRecord];
    }
    [RecordHUD setImage:[NSString stringWithFormat:@"mic_%d.png",lowPassResult*100 > 5 ? 5 : (int)(lowPassResult*100)]];
    [RecordHUD setTimeTitle:[NSString stringWithFormat:@"录音: %.0f\"",recordTime]];
}


@end
