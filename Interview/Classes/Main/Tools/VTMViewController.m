//
//  VTMViewController.m
//  VTM
//
//  Created by jinhu zhang on 11-1-15.
//  Copyright 2011 no. All rights reserved.
//

#import "VTMViewController.h"
#import <AudioToolbox/AudioToolbox.h> //音频处理



#define EXPORT_NAME @"exported2.amr"
@implementation VTMViewController

#pragma mark vc lifecycle
//视图已完全过渡到屏幕上时调用
-(void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.view.backgroundColor = [UIColor brownColor];
    
    [self convertTapped:nil];
    
}

#pragma mark event handlers
/*
 选择歌曲， 监听载入Button按钮
 从mediaPlayer.framework里的MPMusicPlayerController类来播放ipod库中自带的音乐
 */
-(IBAction) chooseSongTapped: (id) sender {
    MPMediaPickerController *pickerController =	[[MPMediaPickerController alloc] //初始化
                                                 initWithMediaTypes: MPMediaTypeMusic];
    pickerController.prompt = @"Choose song to export";//提示
    pickerController.allowsPickingMultipleItems = NO; //是否可以多选
    pickerController.delegate = self; //委托给自己
    [self presentModalViewController:pickerController animated:YES]; //播放选中的歌曲
    
}

/*
 剪切歌曲，监听剪切按钮
 大概流程
 1、获取歌曲路径，初始化音频文件
 2、返回音频文件数据，测试是否接收器是否正常
 3、设置新的音频路径，
 4、开始剪切
 */
-(IBAction) convertTapped: (id) sender {
    // set up an AVAssetReader to read from the iPod Library
    NSString *path = [[NSBundle mainBundle]pathForResource:@"20165017035054" ofType:@"wav"];
    
    NSURL *mp3Url = [NSURL fileURLWithPath:path];

//    NSURL *assetURL = [song valueForProperty:MPMediaItemPropertyAssetURL]; //获取歌曲地址
    
    AVURLAsset *songAsset = [AVURLAsset URLAssetWithURL:mp3Url options:nil]; //初始化音频媒体文件
    
    NSError *assetError = nil; //错误标识
    AVAssetReader *assetReader = [AVAssetReader assetReaderWithAsset:songAsset
                                                                error:&assetError];//指定媒体文件返回数据，返回失败抛出一个错误
    /*
     如果有错误，则格式化输出错误后，跳出
     */
    if (assetError) {
        NSLog (@"error: %@", assetError);
        return;
    }
    
    AVAssetReaderOutput *assetReaderOutput = [AVAssetReaderAudioMixOutput
                                               assetReaderAudioMixOutputWithAudioTracks:songAsset.tracks
                                               audioSettings: nil]; //读取指定文件的音频轨道混音
    /*
     判断是否能够接收器能够正常接收，如果不能，格式化输出提示，跳出
     */
    if (! [assetReader canAddOutput: assetReaderOutput]) {
        NSLog (@"can't add reader output... die!");
        return;
    }
    [assetReader addOutput: assetReaderOutput];//输出音乐
    
    NSArray *dirs = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);//获取应用程序私有目录
    /*
     [[[dirs objectAtIndex:0] stringByAppendingPathComponent:EXPORT_NAME]];  简洁版
     */
    NSString *documentsDirectoryPath = [dirs objectAtIndex:0]; //返回第一个对象
    NSString *exportPath = [documentsDirectoryPath stringByAppendingPathComponent:EXPORT_NAME]; //剪切文件名(如果没有就创建，有就打开)
    
    /*
     检查目录是否存在，存在则删除
     */
    if ([[NSFileManager defaultManager] fileExistsAtPath:exportPath]) {
        [[NSFileManager defaultManager] removeItemAtPath:exportPath error:nil];
    }
    
    NSURL *exportURL = [NSURL fileURLWithPath:exportPath];//返回文件路径
    AVAssetWriter *assetWriter = [AVAssetWriter assetWriterWithURL:exportURL
                                                           fileType:AVFileTypeCoreAudioFormat
                                                              error:&assetError];//开始录制
    /*
     如果有错误，则格式化输出错误后，跳出
     */
    if (assetError) {
        NSLog (@"error: %@", assetError);
        return;
    }
    
    [self exportAsset:songAsset toFilePath:exportPath];
        
}




/*
 剪切开始工作
 大概流程
 1、获得视频总时长，处理时间，数组格式返回音频数据
 2、创建导出会话
 3、设计导出时间范围，淡出时间范围
 4、设计新音频配置数据，文件路径，类型等
 5、开始剪切
 */
- (BOOL)exportAsset:(AVAsset *)avAsset toFilePath:(NSString *)filePath {    
    // we need the audio asset to be at least 50 seconds long for this snippet
    CMTime assetTime = [avAsset duration];//获取视频总时长,单位秒
    Float64 duration = CMTimeGetSeconds(assetTime); //返回float64格式
    if (duration < 14.0) return NO; //小于14秒跳出
    
    // get the first audio track
    NSArray *tracks = [avAsset tracksWithMediaType:AVMediaTypeAudio]; //返回该音频文件数据的数组
    if ([tracks count] == 0) return NO; //如果没有数据，跳出
    
    AVAssetTrack *track = [tracks objectAtIndex:0];//获取第一个对象
    
    // create the export session
    // no need for a retain here, the session will be retained by the
    // completion handler since it is referenced there
    //创建导出会话
    AVAssetExportSession *exportSession = [AVAssetExportSession
                                           exportSessionWithAsset:avAsset
                                           presetName:AVAssetExportPresetAppleM4A];
    if (nil == exportSession) return NO;//创建失败，则跳出
    
    // create trim time range - 20 seconds starting from 30 seconds into the asset
    CMTime startTime = CMTimeMake(15, 1);//CMTimeMake(第几帧， 帧率) 30
    CMTime stopTime = CMTimeMake(25, 1);//CMTimeMake(第几帧， 帧率)40
    CMTimeRange exportTimeRange = CMTimeRangeFromTimeToTime(startTime, stopTime);//导出时间范围
    
    // create fade in time range - 10 seconds starting at the beginning of trimmed asset
    CMTime startFadeInTime = startTime;//30
    CMTime endFadeInTime = CMTimeMake(25, 1);//40
    CMTimeRange fadeInTimeRange = CMTimeRangeFromTimeToTime(startFadeInTime, //淡入时间范围
                                                            endFadeInTime);
    
    // setup audio mix
    AVMutableAudioMix *exportAudioMix = [AVMutableAudioMix audioMix];//实例新的可变音频混音
    AVMutableAudioMixInputParameters *exportAudioMixInputParameters =
    [AVMutableAudioMixInputParameters audioMixInputParametersWithTrack:track]; //给track 返回一个可变的输入参数对象
    
    [exportAudioMixInputParameters setVolumeRampFromStartVolume:0.0 toEndVolume:1.0
                                                      timeRange:fadeInTimeRange]; //设置指定时间范围内导出
    exportAudioMix.inputParameters = [NSArray
                                      arrayWithObject:exportAudioMixInputParameters]; //返回导出数据转化为数组
        
    // configure export session  output with all our parameters 新的配置信息
    exportSession.outputURL = [NSURL fileURLWithPath:filePath]; // output path 新文件路径
    exportSession.outputFileType = AVFileTypeAppleM4A; // output file type 新文件类型
    exportSession.timeRange = exportTimeRange; // trim time range //剪切时间
    exportSession.audioMix = exportAudioMix; // fade in audio mix //新的混音音频
    
    // perform the export  开始真正工作
    [exportSession exportAsynchronouslyWithCompletionHandler:^{ //block
        
        if (AVAssetExportSessionStatusCompleted == exportSession.status) { //如果信号提示已经完成
            NSLog(@"AVAssetExportSessionStatusCompleted"); //格式化输出成功提示
        } else if (AVAssetExportSessionStatusFailed == exportSession.status) {  //如果信号提示已经完成
            
            // a failure may happen because of an event out of your control
            // for example, an interruption like a phone call comming in
            // make sure and handle this case appropriately
            NSLog(@"AVAssetExportSessionStatusFailed: %@",exportSession.error); //格式化输出失败提示
        } else {
            NSLog(@"Export Session Status: %ld", (long)exportSession.status);  //格式化输出信号状态
        }
    }];
    return YES;
}

@end

