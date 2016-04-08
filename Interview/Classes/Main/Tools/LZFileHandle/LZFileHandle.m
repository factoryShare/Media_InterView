//
//  LZFileHandle.m
//  NSFileManagerDemo
//
//  Created by Mr.Right on 16/4/7.
//  Copyright © 2016年 lizheng. All rights reserved.
//
#ifdef DEBUG

#define LZLog(...) NSLog(@"%s %d \n %@\n\n",__func__,__LINE__,[NSString stringWithFormat:__VA_ARGS__])

#else
#define LZLog(...)
#endif


#import "LZFileHandle.h"

@implementation LZFileHandle
/**
 *  移动文件
 */
- (void)moveFileNameAtFilePath:(NSString *)original toPath:(NSString *)toPath {
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isSuccess = [fileManager moveItemAtPath:original toPath:toPath error:nil];
    if (isSuccess) {
        LZLog(@"rename success");
    }else{
        LZLog(@"rename fail");
    }
}
/**
 *  移除文件
 */
- (void)removeFileAtPath:(NSString *)filePath {
    NSFileManager *manager = [NSFileManager defaultManager];
    
    if ([self isFileExisting:filePath]) {
        BOOL isSuccess = [manager removeItemAtPath:filePath error:nil];
        if (isSuccess) {
            LZLog(@"移除文件成功");
        } else {
            LZLog(@"移除文件失败");
        }
    }
}

/**
 *  创建文件夹
 */
- (NSString *)createPath {
    NSString *homeDoc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *path = [homeDoc stringByAppendingPathComponent:@"Doc"];
    
    NSError *error;
    [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
    
    if (error) {
        LZLog(@"创建文件夹失败");
    } else {
        LZLog(@"创建文件夹成功");
    }
    return path;
}
/**
 *  创建文件
 */
- (void)createFileWithName:(NSString *)file {
    NSString *fileName = [[self createPath] stringByAppendingPathComponent:file];
    
    NSError *error;
    [[NSFileManager defaultManager] createFileAtPath:fileName contents:nil attributes:nil];
    if (error) {
        LZLog(@"创建文件失败");
    } else {
        LZLog(@"创建文件成功");
    }
}

/**
 *  写文件
 */
- (void)writeToFileWithContent:(NSString *)content {
    NSString *file = [[self createPath] stringByAppendingPathComponent:@"file.text"];
    BOOL isSuccess = [content writeToFile:file atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
    if (isSuccess) {
        LZLog(@"写入文件成功");
    } else {
        LZLog(@"写入文件失败");
    }
}

/**
 *  读取文件
 */
- (void)readFileFromPath:(NSString *)filePath {
    NSError *error;
    
    NSString *content = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error];
    
    if (!error) {
        LZLog(@"读取文件成功content:%@",content);
    } else {
        LZLog(@"读取文件失败error:%@",error);
    }
}
/**
 *  判断文件是否存在
 */
- (BOOL)isFileExisting:(NSString *)filePath {
    NSFileManager *manager = [NSFileManager defaultManager];
    BOOL isExisting = [manager fileExistsAtPath:filePath];
    if (isExisting) {
        LZLog(@"文件存在");
    } else {
        LZLog(@"文件不存在");
    }
    return isExisting;
}

/**
 *  计算文件大小
 */
- (unsigned long long)fileSizeAtFilePath:(NSString *)filePath {
    NSFileManager *manager = [NSFileManager defaultManager];
    if ([self isFileExisting:filePath]) {
        
        unsigned long long fileSize = [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
        
        return fileSize;
    } else {
        NSLog(@"文件不存在");
        return 0;
    }
}
/**
 *  计算整个文件夹文件的大小
 */
- (unsigned long long)folderSizeAtPath:(NSString*)folderPath {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isExist = [fileManager fileExistsAtPath:folderPath];
    if (isExist){
        NSEnumerator *childFileEnumerator = [[fileManager subpathsAtPath:folderPath] objectEnumerator];
        unsigned long long folderSize = 0;
        NSString *fileName = @"";
        while ((fileName = [childFileEnumerator nextObject]) != nil){
            NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
            folderSize += [self fileSizeAtFilePath:fileAbsolutePath];
        }
        return folderSize / (1024.0 * 1024.0);
    } else {
        NSLog(@"file is not exist");
        return 0;
    }
}
/**
 *  重命名文件
 */
//- (void)renameFileAtPath:(NSString *)originalPath WithName(NSString *)newName {
//    //通过移动该文件对文件重命名
//    NSString *documentsPath =[self getDocumentsPath];
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    NSString *filePath = [documentsPath stringByAppendingPathComponent:@"iOS.txt"];
//    NSString *moveToPath = [documentsPath stringByAppendingPathComponent:@"rename.txt"];
//    BOOL isSuccess = [fileManager moveItemAtPath:filePath toPath:moveToPath error:nil];
//    if (isSuccess) {
//        NSLog(@"rename success");
//    }else{
//        NSLog(@"rename fail");
//    }
//}

@end
