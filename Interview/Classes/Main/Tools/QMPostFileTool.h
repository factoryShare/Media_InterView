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

@end
