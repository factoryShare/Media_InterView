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

#pragma mark 外部方法
- (void)startPlay {
    if (![self.player isPlaying]) {
        [self.player play];
    }
}

- (void)pause {
    if ([self.player isPlaying]) {
        [self.player pause];
    }
}

- (void)setFilePath:(NSString *)filePath {
    _filePath = filePath;
}

- (NSTimeInterval)MusicDuring {
    return self.player.duration;
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
    }
    return _player;
}
@end
