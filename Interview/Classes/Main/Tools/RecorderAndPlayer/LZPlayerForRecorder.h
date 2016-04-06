//
//  LZPlayerForRecorder.h
//  专门为了播放录音服务
//
//  Created by Mr.Right on 16/3/28.
//  Copyright © 2016年 lizheng. All rights reserved.
///

#import <Foundation/Foundation.h>

@interface LZPlayerForRecorder : NSObject

/** 本地播放文件地址 */
@property(nonatomic,strong) NSString *filePath;

- (void)startPlay;
@end
