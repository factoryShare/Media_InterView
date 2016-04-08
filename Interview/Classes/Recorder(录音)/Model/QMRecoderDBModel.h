//
//  QMRecoderDBModel.h
//  Interview
//
//  Created by Mr.Right on 16/4/4.
//  Copyright © 2016年 yonganbo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QMRecoderDBModel : NSObject
/** 录音用户定义文件名 */
@property(nonatomic,copy) NSString *CustomName;
/** 录音默认文件名 */
@property(nonatomic,copy) NSString *recorderName;
/** 录音缓存文件名 */
@property(nonatomic,copy) NSString *recorderPath;
/** 录音文件时长 */
@property(nonatomic,copy) NSString *timeLong;
@end
