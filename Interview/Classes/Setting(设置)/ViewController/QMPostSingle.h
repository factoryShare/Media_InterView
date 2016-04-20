//
//  QMPostSingle.h
//  Interview
//
//  Created by Mr.Right on 16/4/18.
//  Copyright © 2016年 yonganbo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QMPostSingle : NSObject
/**
 *  1.新建上传文件
 */
- (void)newUpLoadFileWithFilePath:(NSString *)filePath fileName:(NSString *)fileName fileFormat:(NSString *)fileFormat;
@end
