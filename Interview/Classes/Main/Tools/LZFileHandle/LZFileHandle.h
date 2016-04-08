//
//  LZFileHandle.h
//  NSFileManagerDemo
//
//  Created by Mr.Right on 16/4/7.
//  Copyright © 2016年 lizheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LZFileHandle : NSObject
/**
 *  创建文件夹
 */
- (NSString *)createPath;
/**
 *  创建文件
 */
- (void)createFileWithName:(NSString *)file;
/**
 *  移动文件
 */
- (void)moveFileNameAtFilePath:(NSString *)original toPath:(NSString *)toPath ;
/**
 *  移除文件
 */
- (void)removeFileAtPath:(NSString *)filePath;
/**
 *  写文件
 */
- (void)writeToFileWithContent:(NSString *)content;
/**
 *  读取文件
 */
- (void)readFileFromPath:(NSString *)filePath;
/**
 *  判断文件是否存在
 */
- (BOOL)isFileExisting:(NSString *)filePath;
/**
 *  计算文件大小
 */
- (unsigned long long)fileSizeAtFilePath:(NSString *)filePath;
/**
 *  计算整个文件夹文件的大小
 */
- (unsigned long long)folderSizeAtPath:(NSString*)folderPath;
@end
