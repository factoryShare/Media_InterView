//
//  LZRecorderTool.m
//  录音机
//
//  Created by Mr.Right on 16/3/28.
//  Copyright © 2016年 lizheng. All rights reserved.
///
#define kSTOP stop

#import "LZRecorderTool.h"
#import <AVFoundation/AVAudioRecorder.h>
#import <AVFoundation/AVAudioSession.h>
#import "VoiceConverter.h"

@interface LZRecorderTool () <AVAudioRecorderDelegate>
@property(nonatomic,strong) AVAudioRecorder *recorder;
@property(nonatomic,strong) NSTimer *timer;
@property(nonatomic,copy) NSString *audioFileSavePath;
@property(nonatomic,copy) NSString *fileTime;

@end

@implementation LZRecorderTool

- (void)startRecorde {
        self.timer.fireDate = [NSDate distantPast];// 开启定时器
    
        [self.recorder record];
}

- (void)pauseRecorde {
    if ([self.recorder isRecording]) {
        self.timer.fireDate = [NSDate distantFuture]; // 关闭定时器
        if (self.timer.isValid) {
            [_timer invalidate];
        }
        _timer = nil;

        [self.recorder pause];
    }
}

- (void)stopRecorde {
    
    if ([self.recorder isRecording]) {
        // 告知外部录音文件时常
        self.currentTime = self.recorder.currentTime;
        
        [self.recorder stop];
        // 转化为 mp3格式
        //    [self audio_PCMtoMP3];
        // wav 转 amr∫
        [VoiceConverter wavToAmr:self.audioFileSavePath amrSavePath:self.amrFileSavePath];
    }
}
/**
 *  监测声波变化
 */
- (void)audioPowerChanged {
    if ([self.recorder isRecording]) {
        [self.recorder updateMeters];
        
        float power = [self.recorder averagePowerForChannel:0]; //取得第一个通道的音频，注意音频强度范围时-160到0
        
        self.audioPower = (CGFloat)(power+160.0);
        if (self.delegate && [self.delegate respondsToSelector:@selector(getaudioPower:)]) {
            [self.delegate getaudioPower:self.audioPower];
        } else {
            QMLog(@"没有设置代理或没有实现协议方法");
        }
    } else {
        self.timer.fireDate = [NSDate distantFuture]; // 关闭定时器
        if (self.timer.isValid) {
            [_timer invalidate];
        }
        _timer = nil;
    }
}

#pragma mark - 初始化
- (instancetype)init {
    if (self = [super init]) {
        AVAudioSession *session = [AVAudioSession sharedInstance];
        
        NSError *error;
        [session setCategory:AVAudioSessionCategoryPlayAndRecord error:&error];
        if (error) {
             QMLog(@"AVAudioSessionCategoryPlayback:error---%@", [error description]);
        }
        
        [session setActive:YES error:nil];
    }
    return self;
}

- (AVAudioRecorder *)recorder {
    if (_recorder == nil) {
        self.fileName = [self file];
        NSString *tempDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        // 初始化格式地址
        NSString *path = [tempDir stringByAppendingPathComponent:self.fileName];
        self.audioFileSavePath = path;
        // amr 地址
        NSString *armName = [NSString stringWithFormat:@"%@%@",self.fileTime,@".amr"];
        self.amrFileSavePath = [tempDir stringByAppendingPathComponent:armName];

        _recorder = [[AVAudioRecorder alloc]initWithURL:[NSURL URLWithString: path] settings:[self getAudioSetting] error:nil];
        _recorder.delegate = self;
        _recorder.meteringEnabled = YES;
        [_recorder prepareToRecord];
    }
    return _recorder;
}
/**
 *  缓存地址
 */
- (NSString *)file {
    
    NSDateFormatter *forma = [[NSDateFormatter alloc]init];
    forma.dateFormat = @"yyyymmddhhmmss";
    NSString *time = [forma stringFromDate:[NSDate date]];
    
    NSString *file = [NSString stringWithFormat:@"%@.wav",time];
    
    self.fileTime = time;
    
    return file;
}
/**
 *  取得录音文件设置
 *
 *  @return 录音设置
 */
-(NSDictionary *)getAudioSetting{
    NSMutableDictionary *dicM=[NSMutableDictionary dictionary];
    //设置录音格式
    [dicM setObject:@(kAudioFormatLinearPCM) forKey:AVFormatIDKey];
    //设置录音采样率，8000是电话采样率，对于一般录音已经够了
    [dicM setObject:@(8000) forKey:AVSampleRateKey];
    //设置通道,这里采用单声道
    [dicM setObject:@(2) forKey:AVNumberOfChannelsKey];
    //每个采样点位数,分为8、16、24、32
    [dicM setObject:@(8) forKey:AVLinearPCMBitDepthKey];
    //是否使用浮点数采样
    [dicM setObject:@(YES) forKey:AVLinearPCMIsFloatKey];
    //....其他设置等
#warning setting2
    //....其他设置等
    NSMutableDictionary *settings = [[NSMutableDictionary alloc] init];
    //录音格式 无法使用
    [settings setValue :[NSNumber numberWithInt:kAudioFormatLinearPCM] forKey: AVFormatIDKey];
    //采样率
    [settings setValue :[NSNumber numberWithFloat:11025.0] forKey: AVSampleRateKey];//44100.0
    //通道数
    [settings setValue :[NSNumber numberWithInt:2] forKey: AVNumberOfChannelsKey];
    //线性采样位数
    //[recordSettings setValue :[NSNumber numberWithInt:16] forKey: AVLinearPCMBitDepthKey];
    //音频质量,采样质量
    [settings setValue:[NSNumber numberWithInt:AVAudioQualityMin] forKey:AVEncoderAudioQualityKey];
#warning setting3
    NSDictionary *recordSetting = [[NSDictionary alloc] initWithObjectsAndKeys:
                                   [NSNumber numberWithFloat: 8000.0],AVSampleRateKey, //采样率
                                   [NSNumber numberWithInt: kAudioFormatLinearPCM],AVFormatIDKey,
                                   [NSNumber numberWithInt:16],AVLinearPCMBitDepthKey,//采样位数 默认 16
                                   [NSNumber numberWithInt: 1], AVNumberOfChannelsKey,//通道的数目
                                   //                                   [NSNumber numberWithBool:NO],AVLinearPCMIsBigEndianKey,//大端还是小端 是内存的组织方式
                                   //                                   [NSNumber numberWithBool:NO],AVLinearPCMIsFloatKey,//采样信号是整数还是浮点数
                                   //                                   [NSNumber numberWithInt: AVAudioQualityMedium],AVEncoderAudioQualityKey,//音频编码质量
                                   nil];
    
    
    return recordSetting;
}
/**
 *  监测声波变化
 */
- (NSTimer *)timer {
    if (_timer == nil) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(audioPowerChanged) userInfo:nil repeats:YES];
    }
    return _timer;
}

#pragma mark - 音频转化
- (void)audio_PCMtoMP3 {
//    NSString *audioTemporarySavePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
//    NSString *mp3FileName = [self.fileTime stringByAppendingString:@".mp3"];
//    
//    NSString *mp3FilePath = [audioTemporarySavePath stringByAppendingPathComponent:mp3FileName];
//    
//    @try {
//        int read, write;
//        
//        FILE *pcm = fopen([self.audioFileSavePath cStringUsingEncoding:1], "rb");  //source 被转换的音频文件位置
//        fseek(pcm, 4*1024, SEEK_CUR);                                   //skip file header
//        FILE *mp3 = fopen([mp3FilePath cStringUsingEncoding:1], "wb");  //output 输出生成的Mp3文件位置
//        
//        const int PCM_SIZE = 8192;
//        const int MP3_SIZE = 8192;
//        short int pcm_buffer[PCM_SIZE*2];
//        unsigned char mp3_buffer[MP3_SIZE];
//        
//        lame_t lame = lame_init();
//        lame_set_in_samplerate(lame, 11025.0);
//        lame_set_VBR(lame, vbr_default);
//        lame_init_params(lame);
//        
//        do {
//            read = fread(pcm_buffer, 2*sizeof(short int), PCM_SIZE, pcm);
//            if (read == 0)
//                write = lame_encode_flush(lame, mp3_buffer, MP3_SIZE);
//            else
//                write = lame_encode_buffer_interleaved(lame, pcm_buffer, read, mp3_buffer, MP3_SIZE);
//            
//            fwrite(mp3_buffer, write, 1, mp3);
//            
//        } while (read != 0);
//        
//        lame_close(lame);
//        fclose(mp3);
//        fclose(pcm);
//    }
//    @catch (NSException *exception) {
//        NSLog(@"%@",[exception description]);
//    }
//    @finally {
//        
//        [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategorySoloAmbient error: nil];
//        //        self.audioFileSavePath = mp3FilePath;
//        //        NSLog(@"MP3生成成功: %@",self.audioFileSavePath);
//        
//    }
    
}


#pragma mark - AVAudioRecorderDelegate 

/* audioRecorderDidFinishRecording:successfully: is called when a recording has been finished or stopped. This method is NOT called if the recorder is stopped due to an interruption. */
- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag {
    QMLog(@"%d",flag);
}

/* if an error occurs while encoding it will be reported to the delegate. */
- (void)audioRecorderEncodeErrorDidOccur:(AVAudioRecorder *)recorder error:(NSError * __nullable)error {
    QMLog(@"%@",error);
}

@end
