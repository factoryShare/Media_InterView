//
//  LZPlayerForRecorder.m
//  录音机
//
//  Created by Mr.Right on 16/3/28.
//  Copyright © 2016年 lizheng. All rights reserved.
///

#import "LZPlayerForRecorder.h"
#import <AVFoundation/AVFoundation.h>

@interface LZPlayerForRecorder ()
@property(nonatomic,strong) AVAudioPlayer *player;

@end

@implementation LZPlayerForRecorder

- (void)dealloc {
    QMLog(@"dealloc");
}

#pragma mark 外部方法
- (void)startPlay {
    if (![self.player isPlaying]) {
        [self.player play];
        self.isPlaying = YES;
        QMLog(@"startPlay");
    }
}

- (void)pause {
    if ([self.player isPlaying]) {
        [self.player pause];
        self.isPlaying = NO;
        QMLog(@"pause");
    }
}

- (void)stop {
    if ([self.player isPlaying]) {
        [self.player stop];
        QMLog(@"stop");
    }
}

- (void)setFilePath:(NSString *)filePath {
    _filePath = filePath;
    _player = nil;
    NSError *error = nil;
    self.player =  [[AVAudioPlayer alloc]initWithContentsOfURL:[NSURL fileURLWithPath:_filePath] error:&error];
    _player.volume = 1.0;
    if (error) {
        QMLog(@"%@",error);
    }
}

- (NSTimeInterval)currentTime {
    return _player.currentTime;
}

- (NSTimeInterval)MusicDuring {
    return self.player.duration;
}

- (void)playAtTime:(NSTimeInterval)time {
    if ([self.player isPlaying]) {
        self.player.currentTime = time;
    }
}

#pragma mark - 初始化
- (AVAudioPlayer *)player {
    if (!_player) {
        NSError *error = nil;
        _player = [[AVAudioPlayer alloc]initWithContentsOfURL:[NSURL fileURLWithPath:_filePath] error:&error];
        _player.volume = 1.0;
        if (error) {
            QMLog(@"%@",error);
        }
        QMLog(@"创建_player%@",_player);
    }

    return _player;
}

@end
