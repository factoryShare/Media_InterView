//
//  QMRecorderListViewController.m
//  Interview
//
//  Created by Mr.Right on 16/4/5.
//  Copyright © 2016年 yonganbo. All rights reserved.
//

#import "QMManuscriptAMRListViewController.h"
#import "QMRecorderDBManager.h"
#import "QMRecoderDBModel.h"
#import "QMRecorderListCell.h"
#import "LZFileHandle.h"
#import "AFNetworking.h"
#import "GTMBase64.h"

@interface QMManuscriptAMRListViewController () <UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) NSMutableArray *dataSource;
@property(nonatomic,strong) QMRecoderDBModel *recorderDBModel;
@property(nonatomic,strong) NSData *fileData;
@property(nonatomic,copy) NSString *fileName;
@property(nonatomic,copy) NSString *customName;

// 请求返回参数保存
@property(nonatomic,copy) NSString *fileID;

@end

@implementation QMManuscriptAMRListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"录音列表";
    self.recorderDBModel = nil;
    
    self.view.backgroundColor = QMColor(127, 127, 127);
    
    [self updateTableView];
    
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    QMRecorderListCell *cell = [QMRecorderListCell cellWithTableView:tableView];
    
    cell.model = self.dataSource[indexPath.row];
    
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    self.recorderDBModel = self.dataSource[indexPath.row];
//    NSString *tempDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
//    // wav 地址
//    NSString *path = [tempDir stringByAppendingPathComponent: self.recorderDBModel.recorderName];
//    // amr 地址
//    NSString *amrFileSavePath = [path stringByReplacingOccurrencesOfString:@".wav" withString:@".amr"];
//    // amr 文件名
//    _fileName = [self.recorderDBModel.recorderName stringByReplacingOccurrencesOfString:@".wav" withString:@""];
//    _customName = self.recorderDBModel.CustomName;
    // 开始上传 - 1.新建上传文件
//    [self newUpLoadFileWithFilePath:amrFileSavePath fileName:_fileName fileFormat:@"amr"];
    
  // 发通知
    NSDictionary *dict = @{@"recordName":_recorderDBModel.recorderName};
    NSNotification * notice = [NSNotification notificationWithName:@"SelectAMRFile" object:nil userInfo:dict];
    [[NSNotificationCenter defaultCenter] postNotification:notice];
    [self.navigationController popViewControllerAnimated:YES];
    
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
            [self upLoadFileWithFileID:dataDic[@"FileID"]];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        QMLog(@"%@",[error localizedDescription]);
        [MBProgressHUD showError:@"请求失败"];
    }];
}
/**
 *  上传文件
 */
- (void)upLoadFileWithFileID:(NSString *)fileID {
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
            [self upLoadFileDataWithFileID:_fileID blockIndex:dataDic[@"BlockIndex"] blockSize:dataDic[@"BlockSize"] Blockdata:[GTMBase64 encodeData:_fileData]];
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        QMLog(@"%@",[error localizedDescription]);
        [MBProgressHUD showError:@"请求失败"];
    }];

}

- (void)upLoadFileDataWithFileID:(NSString *)fileID blockIndex:(NSString *)blockIndex blockSize:(NSString *)blockSize Blockdata:(NSData *)Blockdata{
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
        QMLog(@"success,responseObject%@",dic);
        
        if (![dic[@"Error"] isKindOfClass:[NSNull class]]) {// 发生错误
            NSDictionary *error = dic[@"Error"];
            QMLog(@"%@",error[@"Message"]);
            [MBProgressHUD showError:error[@"Message"]];
        } else if(![dic[@"Data"] isKindOfClass:[NSNull class]]){ // 有数据返回
#warning 前三步 ok
            [self upLoadAudio];
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
    [parameters setObject:@"1" forKey:@"fileTypes"];
    [parameters setObject:_fileName forKey:@"title"];
    [parameters setObject:[[NSUserDefaults standardUserDefaults]objectForKey:kUserName] forKey:@"author"];
    [parameters setObject:_customName forKey:@"caption"];
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

#pragma mark - 初始化
- (void)updateTableView {
    self.automaticallyAdjustsScrollViewInsets = YES;
//    self.tableView.allowsMultipleSelection = YES;
    
    CGFloat tableViewH = 0;
    if (self.tableView == nil) {
        UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, tableViewH) style:(UITableViewStylePlain)];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.backgroundColor = [UIColor whiteColor];
        //    tableView.allowsMultipleSelection = YES;
        self.tableView = tableView;
        
        [self.tableView registerNib:[UINib nibWithNibName:@"QMRecorderListCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"QMRecorderListCell"];
        
        [self.view addSubview:self.tableView];

    }
    
    
    // 自动布局
    if ( self.dataSource.count * 60 > [UIScreen mainScreen].bounds.size.height -100) {
        tableViewH = [UIScreen mainScreen].bounds.size.height -100;
        self.tableView.height = tableViewH;
        [self.tableView setScrollEnabled:YES];
    } else {
        tableViewH = self.dataSource.count * 60;
        self.tableView.height = tableViewH;
        [self.tableView setScrollEnabled:NO];
    }
}

- (NSMutableArray *)dataSource {
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
        
        [[QMRecorderDBManager sharedQMRecorderDBManager] getAllModel:^(NSArray *array) {
            self.dataSource = [NSMutableArray arrayWithArray:array];
        }];
    }
    return _dataSource;
}
- (NSString*) base64Encode:(NSData *)data
{
    static char base64EncodingTable[64] = {
        'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P',
        'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', 'a', 'b', 'c', 'd', 'e', 'f',
        'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v',
        'w', 'x', 'y', 'z', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '+', '/'
    };
    NSUInteger length = [data length];
    unsigned long ixtext, lentext;
    long ctremaining;
    unsigned char input[3], output[4];
    short i, charsonline = 0, ctcopy;
    const unsigned char *raw;
    NSMutableString *result;
    
    lentext = [data length];
    if (lentext < 1)
        return @"";
    result = [NSMutableString stringWithCapacity: lentext];
    raw = [data bytes];
    ixtext = 0;
    
    while (true) {
        ctremaining = lentext - ixtext;
        if (ctremaining <= 0)
            break;
        for (i = 0; i < 3; i++) {
            unsigned long ix = ixtext + i;
            if (ix < lentext)
                input[i] = raw[ix];
            else
                input[i] = 0;
        }
        output[0] = (input[0] & 0xFC) >> 2;
        output[1] = ((input[0] & 0x03) << 4) | ((input[1] & 0xF0) >> 4);
        output[2] = ((input[1] & 0x0F) << 2) | ((input[2] & 0xC0) >> 6);
        output[3] = input[2] & 0x3F;
        ctcopy = 4;
        switch (ctremaining) {
            case 1:
                ctcopy = 2;
                break;
            case 2:
                ctcopy = 3;
                break;
        }
        
        for (i = 0; i < ctcopy; i++)
            [result appendString: [NSString stringWithFormat: @"%c", base64EncodingTable[output[i]]]];
        
        for (i = ctcopy; i < 4; i++)
            [result appendString: @"="];
        
        ixtext += 3;
        charsonline += 4;
        
        if ((length > 0) && (charsonline >= length))
            charsonline = 0;
    }
    return result;
}



@end
