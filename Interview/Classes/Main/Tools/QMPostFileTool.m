//
//  QMPostFileTool.m
//  Interview
//
//  Created by Mr.Right on 16/4/17.
//  Copyright © 2016年 yonganbo. All rights reserved.
//

#import "QMPostFileTool.h"
#import "AFNetworking.h"
#import "GTMBase64.h"
#import "QMPostParamterModel.h"

@interface QMPostFileTool ()

@property(nonatomic,strong) NSData *fileData;
@property(nonatomic,copy) NSString *fileTypes;
@property(nonatomic,copy) NSString *fileID;

@property(nonatomic,copy) NSString *BlockCount;
@property(nonatomic,copy) NSString *BlockSize;
@property(nonatomic,copy) NSString *BlockIndex;

@property(nonatomic,assign) int postCount;


@end

@implementation QMPostFileTool

- (instancetype)init {
    if (self = [super init]) {
        _postCount = 1;
    }
    return self;
}

#pragma mark - 上传文件
/**
 *  1.新建上传文件
 */
- (void)newUpLoadFileWithFilePath:(NSString *)filePath fileName:(NSString *)fileName fileFormat:(NSString *)fileFormat {
    //    新建上传文件
    //    地址: http://path-to-service/story/newUploadFile
    //    方式: POST
    //    参数: token, fileSize（文件大小）, fileName（文件名）, fileFormat（后缀比如amr）
    //    返回: status, fileID(文件标识), blockCount(块数), blockSize(块大小)
    _fileTypes = [fileFormat isEqualToString:@"amr"] ? @"1":@"2";
    _fileData = [NSData dataWithContentsOfFile:filePath];
    
    NSString *urlSting = [NSString stringWithFormat:@"http://%@/story/newUploadFile",[[NSUserDefaults standardUserDefaults]objectForKey:kPathToService]];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"token"] forKey:@"token"];
    [parameters setObject:[NSString stringWithFormat:@"%ld",_fileData.length] forKey:@"fileSize"];
    [parameters setObject:fileName forKey:@"fileName"];
    [parameters setObject:fileFormat forKey:@"fileFormat"];
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:urlSting parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:(NSJSONReadingMutableContainers) error:nil];
        QMLog(@"success,responseObject%@",dic);
        
        if (![dic[@"Error"] isKindOfClass:[NSNull class]]) {// 发生错误
            NSDictionary *error = dic[@"Error"];
            QMLog(@"%@",error[@"Message"]);
            [MBProgressHUD showError:error[@"Message"]];
        } else if(![dic[@"Data"] isKindOfClass:[NSNull class]]){ // 有数据返回
            NSDictionary *dataDic = dic[@"Data"];
            _fileID = dataDic[@"FileID"];
            _BlockSize = dataDic[@"BlockSize"];
            _BlockCount = dataDic[@"BlockCount"];

            [self upLoadFileWithFileID:dataDic[@"FileID"] andBlockCount:_BlockCount];
        } else {
            [MBProgressHUD showError:@"请重新登陆"];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        QMLog(@"%@",[error localizedDescription]);
        [MBProgressHUD showError:@"请求失败"];
    }];
}
/**
 *  2.上传文件
 */
- (void)upLoadFileWithFileID:(NSString *)fileID andBlockCount:(NSString *)blockCount{
    //    上传文件
    //    地址: http://path-to-service/story/uploadFile
    //    方式: POST
    //    参数: token, fileID,
    //    返回: status, blockIndex,blockCount(块数),blockSize(块大小)
    
    NSString *urlSting = [NSString stringWithFormat:@"http://%@/story/uploadFile",[[NSUserDefaults standardUserDefaults]objectForKey:kPathToService]];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"token"] forKey:@"token"];
    [parameters setObject:fileID forKey:@"fileID"];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager POST:urlSting parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:(NSJSONReadingMutableContainers) error:nil];
        QMLog(@"success,responseObject%@",dic);
        
        if (![dic[@"Error"] isKindOfClass:[NSNull class]]) {// 发生错误
            NSDictionary *error = dic[@"Error"];
            QMLog(@"%@",error[@"Message"]);
            [MBProgressHUD showError:error[@"Message"]];
        } else if(![dic[@"Data"] isKindOfClass:[NSNull class]]){ // 有数据返回
            NSDictionary *dataDic = dic[@"Data"];
            _BlockIndex = dataDic[@"BlockIndex"];
            
                if ([blockCount intValue] == 1) {
                    NSData *data = [_fileData subdataWithRange:(NSRange){0,_fileData.length}];
                    [self upLoadFileDataWithFileID:_fileID blockIndex:@"0" blockSize:dataDic[@"BlockSize"] Blockdata:[GTMBase64 encodeData:data] BlockCount:_BlockCount];
                } else {
                    NSData *data = [_fileData subdataWithRange:(NSRange){0,[_BlockSize intValue]}];
                    [self upLoadFileDataWithFileID:_fileID blockIndex:@"0" blockSize:dataDic[@"BlockSize"] Blockdata:[GTMBase64 encodeData:data] BlockCount:_BlockCount];
                }
        } else {
            [MBProgressHUD showError:@"请重新登陆"];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        QMLog(@"%@",[error localizedDescription]);
        [MBProgressHUD showError:@"请求失败"];
    }];

}
/**
 *  上传文件数据
 */
- (void)upLoadFileDataWithFileID:(NSString *)fileID blockIndex:(NSString *)blockIndex blockSize:(NSString *)blockSize Blockdata:(NSData *)Blockdata BlockCount:(NSString *)BlockCount{
    //    上传文件数据
    //    地址: http://path-to-service/story/uploadData
    //    方式: POST
    //    参数: token, fileID, blockIndex, blockSize, Blockdata(base64)
    //    返回: status
    
    NSString *urlSting = [NSString stringWithFormat:@"http://%@/story/uploadFile",[[NSUserDefaults standardUserDefaults]objectForKey:kPathToService]];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"token"] forKey:@"token"];
    [parameters setObject:fileID forKey:@"fileID"];
    [parameters setObject:[NSString stringWithFormat:@"%@",blockIndex] forKey:@"blockIndex"];
    [parameters setObject:blockSize forKey:@"blockSize"];
    [parameters setObject:Blockdata forKey:@"Blockdata"];
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:urlSting parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:(NSJSONReadingMutableContainers) error:nil];
        QMLog(@"%d:success,responseObject%@",_postCount, dic);
        
        if (![dic[@"Error"] isKindOfClass:[NSNull class]]) {// 发生错误
            NSDictionary *error = dic[@"Error"];
            QMLog(@"%@",error[@"Message"]);
            [MBProgressHUD showError:error[@"Message"]];
        } else if(![dic[@"Data"] isKindOfClass:[NSNull class]]){ // 有数据返回
#warning 前三步 ok
            NSDictionary *dataDic = dic[@"Data"];
            
            
            for (; _postCount < [BlockCount intValue]; _postCount++) {
                if (_postCount == [BlockCount intValue] - 1) {
                    int rangL = _fileData.length % [_BlockSize intValue];
                    NSData *data = [_fileData subdataWithRange:(NSRange){_postCount * [_BlockSize intValue],rangL}];
                    [self upLoadFileDataWithFileID:_fileID blockIndex:[NSString stringWithFormat:@"%d",_postCount]  blockSize:[NSString stringWithFormat:@"%d",rangL] Blockdata:[GTMBase64 encodeData:data] BlockCount:_BlockCount];
                } else {
                    NSData *data = [_fileData subdataWithRange:(NSRange){_postCount * [_BlockSize intValue],[_BlockSize intValue]}];
                    [self upLoadFileDataWithFileID:_fileID blockIndex:[NSString stringWithFormat:@"%d",_postCount] blockSize:dataDic[@"BlockSize"] Blockdata:[GTMBase64 encodeData:data] BlockCount:_BlockCount];
                }
            }
            
            if (_postCount == [BlockCount intValue]) {
                static dispatch_once_t onceToken;
                dispatch_once(&onceToken, ^{
                    [self upLoadAudio];
                });
            }
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        QMLog(@"%@",[error localizedDescription]);
        [MBProgressHUD showError:@"请求失败"];
    }];
    
}

- (void)upLoadAudio {
    //    上传音频、视频、图片
    //    地址: http://path-to-service/story/UploadMedias
    //    方式: POST
    //    参数:string token, string fileIDs, string fileTypes, string title, string author, string caption, long channelID
    //    说明：channelID=1    author=登录用户名  fileIDs多个文件用，号隔开  fileTypes多个用逗号隔开
    //    fileTypes 图片=2   音频=1
    
    NSString *urlSting = [NSString stringWithFormat:@"http://%@/story/uploadFile",[[NSUserDefaults standardUserDefaults]objectForKey:kPathToService]];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    [parameters setObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"token"] forKey:@"token"];
    [parameters setObject:[NSString stringWithFormat:@"%@",_fileID] forKey:@"fileIDs"];
    [parameters setObject:_fileTypes forKey:@"fileTypes"];
    [parameters setObject:@"filename" forKey:@"title"];
    [parameters setObject:[[NSUserDefaults standardUserDefaults]objectForKey:kUserName] forKey:@"author"];
    [parameters setObject:@"customName" forKey:@"caption"];
    [parameters setObject:@"1" forKey:@"channelID"];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:urlSting parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSError *error1 = nil;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:(NSJSONReadingMutableContainers) error:&error1];
        QMLog(@"success,responseObject%@",dic);
        if (error1) {
            QMLog(@"%@",[error1 localizedDescription]);
        }
        
        if (![dic[@"Error"] isKindOfClass:[NSNull class]]) {// 发生错误
            NSDictionary *error = dic[@"Error"];
            QMLog(@"%@",error[@"Message"]);
            [MBProgressHUD showError:error[@"Message"]];
        } else if(![dic[@"Data"] isKindOfClass:[NSNull class]]){ // 有数据返回
            [MBProgressHUD showSuccess:@"上传成功"];
        } else {
            [MBProgressHUD showError:@"上传失败,请联系服务商"];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        QMLog(@"%@",[error localizedDescription]);
        [MBProgressHUD showError:@"请求失败"];
    }];
}


@end
