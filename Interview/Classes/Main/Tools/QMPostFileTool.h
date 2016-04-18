//
//  QMPostFileTool.h
//  Interview
//
//  Created by Mr.Right on 16/4/17.
//  Copyright © 2016年 yonganbo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QMPostFileTool : NSObject
/**
 *  1.新建上传文件
 */
- (void)newUpLoadFileWithFilePath:(NSString *)filePath fileName:(NSString *)fileName fileFormat:(NSString *)fileFormat;
/**
 *  2.上传文件
 */
- (void)upLoadFileWithFileID:(NSString *)fileID;
/**
 *  3.上传文件数据
 */
- (void)upLoadFileDataWithFileID:(NSString *)fileID blockIndex:(NSString *)blockIndex blockSize:(NSString *)blockSize Blockdata:(NSData *)Blockdata;
/**
 *  4.最后上传
 */
- (void)upLoadAudio;
@end
