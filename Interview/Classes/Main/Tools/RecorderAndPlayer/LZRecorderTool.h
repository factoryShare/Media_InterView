//
//  LZRecorderTool.h
//  录音机
//
//  Created by Mr.Right on 16/3/28.
//  Copyright © 2016年 lizheng. All rights reserved.
///

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol LZRecorderDeleagte <NSObject>

@optional
/**
 *  获得录音的音量
 */
- (void)getaudioPower:(float)power;

@end

@interface LZRecorderTool : NSObject
/** 录音时长短 */
@property(nonatomic,assign) int currentTime;
/** 录音文件默认名 */
@property(nonatomic,strong) NSString *fileName;
/** 录音文件存储地址(amr) */
@property(nonatomic,copy) NSString *amrFileSavePath;

/** 音频波动峰值 */
@property(nonatomic,assign)  CGFloat audioPower; //每 0.1f 更新一次
@property(nonatomic,weak) id<LZRecorderDeleagte> delegate;

/**
 *  开始录音
 */
- (void)startRecorde;

/**
 *  暂停录音
 */
- (void)pauseRecorde;
/**
 *  停止录音
 */
- (void)stopRecorde;


@end
