//
//  AACRecorder.m
//  searHim重制版-01基本框架构建
//
//  Created by 黄远 on 16/7/23.
//  Copyright © 2016年 黄远. All rights reserved.
//  

#import "AACRecorder.h"
#import <AVFoundation/AVFoundation.h>
#import "lame.h"

@interface AACRecorder () <AVAudioRecorderDelegate>
@property (nonatomic, strong) AVAudioSession* session;
@property (nonatomic, strong) AVAudioRecorder* recorder;
//负责记录录音时间
@property (nonatomic, assign) CGFloat recorderTime;
//负责调用刷新按钮界面
@property (nonatomic, strong) NSTimer* playTimer;
@property (nonatomic, assign) double lowPassResults;

@end


@implementation AACRecorder


//停止录音
- (void)stopRecorder{
    if (self.playTimer) {
        double cTime = _recorder.currentTime;
        self.recorderTime = cTime;
        [self.recorder stop];
        if (cTime < 1) {
            [_recorder deleteRecording];
            if ([_delegate respondsToSelector:@selector(failRecord)]) {
                [_delegate failRecord];
            }
        } else {
            [self audio_PCMtoMP3];
        }
        [self.playTimer invalidate];
        self.playTimer = nil;
    }
}

- (void)cancelRecord{
    if (self.playTimer) {
        [_recorder stop];
        [_recorder deleteRecording];
        [self.playTimer invalidate];
        self.playTimer = nil;
    }
}

#pragma mark - Convert Utils
- (void)audio_PCMtoMP3
{                           //64随机字符 + otherObjectId + .caf
    NSString *cafFilePath = self.filePath;
    NSString *mp3FilePath = [cafFilePath stringByReplacingOccurrencesOfString:@".caf" withString:@".mp3"];
    
    HYLog(@"MP3转换开始");
    if (_delegate && [_delegate respondsToSelector:@selector(beginConvert)]) {
        [_delegate beginConvert];
    }
    @try {
        int read, write;
        
        FILE *pcm = fopen([cafFilePath cStringUsingEncoding:1], "rb");  //source 被转换的音频文件位置
        fseek(pcm, 4*1024, SEEK_CUR);                                   //skip file header
        FILE *mp3 = fopen([mp3FilePath cStringUsingEncoding:1], "wb");  //output 输出生成的Mp3文件位置
        
        const int PCM_SIZE = 8192;
        const int MP3_SIZE = 8192;
        short int pcm_buffer[PCM_SIZE*2];
        unsigned char mp3_buffer[MP3_SIZE];
        
        lame_t lame = lame_init();
        lame_set_in_samplerate(lame, 11025.0);
        lame_set_VBR(lame, vbr_default);
        lame_init_params(lame);
        
        do {
            read = (int)fread(pcm_buffer, 2*sizeof(short int), PCM_SIZE, pcm);
            if (read == 0)
                write = lame_encode_flush(lame, mp3_buffer, MP3_SIZE);
            else
                write = lame_encode_buffer_interleaved(lame, pcm_buffer, read, mp3_buffer, MP3_SIZE);
            
            fwrite(mp3_buffer, write, 1, mp3);
            
        } while (read != 0);
        
        lame_close(lame);
        fclose(mp3);
        fclose(pcm);
    }
    @catch (NSException *exception) {
        HYLog(@"%@",[exception description]);
    }
    @finally {
        [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategorySoloAmbient error: nil];
    }
    
    [self deleteCafCache];
    HYLog(@"MP3转换结束");
    if (_delegate && [_delegate respondsToSelector:@selector(endConvertWithData: andRecorderTime:)]) {
        NSData *voiceData = [NSData dataWithContentsOfFile:mp3FilePath];
        [_delegate endConvertWithData:voiceData andRecorderTime:self.recorderTime];
    }
}

- (void)deleteCafCache
{
    [self deleteFileWithPath:self.filePath];
}

- (void)deleteFileWithPath:(NSString *)path
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if([fileManager removeItemAtPath:path error:nil])
    {
        HYLog(@"删除音频文件");
    }
}

//开始录音
- (void)benginRecorder{
    //改变Sesstion状态,方法启动会话
    [self setSesstion];
    [self setRecorder];
    [self.recorder record];
    self.recorderTime = 0.0;
    self.playTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(countVoiceTime) userInfo:nil repeats:YES];
}

- (void)countVoiceTime{
    self.recorderTime += 0.1;
    //更新测量值
    [_recorder updateMeters];
    const double ALPHA = 0.05;
    double peakPowerForChannel = pow(10, (0.05 * [_recorder peakPowerForChannel:0]));
    self.lowPassResults = ALPHA * peakPowerForChannel + (1.0 - ALPHA) * self.lowPassResults;
    if ([_delegate respondsToSelector:@selector(recording:volume:)]) {
        [_delegate recording:self.recorderTime volume:self.lowPassResults];
    }
}

- (void)setSesstion
{
    _session = [AVAudioSession sharedInstance];
    NSError *sessionError;
    [_session setCategory:AVAudioSessionCategoryPlayAndRecord error:&sessionError];
    
    if(_session == nil)
        HYLog(@"Error creating session: %@", [sessionError description]);
    else
        [_session setActive:YES error:nil];
}

- (void)setRecorder
{
    _recorder = nil;
    NSError *recorderSetupError = nil;
    NSURL *url = [NSURL fileURLWithPath:self.filePath];
    NSMutableDictionary *settings = [[NSMutableDictionary alloc] init];
    //录音格式
    [settings setValue :[NSNumber numberWithInt:kAudioFormatLinearPCM] forKey:AVFormatIDKey];
    //采样率
    [settings setValue :[NSNumber numberWithFloat:11025.0] forKey: AVSampleRateKey];//44100.0
    //通道数
    [settings setValue :[NSNumber numberWithInt:2] forKey: AVNumberOfChannelsKey];
    //音频质量,采样质量
    [settings setValue:[NSNumber numberWithInt:AVAudioQualityMin] forKey:AVEncoderAudioQualityKey];
    _recorder = [[AVAudioRecorder alloc] initWithURL:url
                                            settings:settings
                                               error:&recorderSetupError];
    if (recorderSetupError) {
        HYLog(@"%@",recorderSetupError);
    }
    _recorder.meteringEnabled = YES;  //监控声波
    _recorder.delegate = self;
    [_recorder prepareToRecord];
}


@end
