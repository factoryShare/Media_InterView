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

@interface QMManuscriptAMRListViewController () <UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) NSMutableArray *dataSource;
@property(nonatomic,strong) QMRecoderDBModel *recorderDBModel;

@end

@implementation QMManuscriptAMRListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
    NSString *tempDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    // wav 地址
    NSString *path = [tempDir stringByAppendingPathComponent: self.recorderDBModel.recorderName];
    // amr 地址
    NSString *amrFileSavePath = [path stringByReplacingOccurrencesOfString:@".wav" withString:@".amr"];
    // amr 文件名
    NSString *fileName = [self.recorderDBModel.recorderName stringByReplacingOccurrencesOfString:@".wav" withString:@""];
    //
    [self newUpLoadFileWithFilePath:amrFileSavePath fileName:fileName fileFormat:@"amr"];
    
    
//    NSString *urlSting = [NSString stringWithFormat:@"http://%@/story/UploadMedias",[[NSUserDefaults standardUserDefaults]objectForKey:kPathToService]];
//    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
//    [parameters setObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"token"] forKey:@"token"];
//    [parameters setObject:fileName forKey:@"fileIDs"];
//    [parameters setObject:@"1" forKey:@"fileTypes"];
//    [parameters setObject:fileName forKey:@"title"];
//    [parameters setObject:[[NSUserDefaults standardUserDefaults]objectForKey:kUserName] forKey:@"author"];
//    [parameters setObject:fileName forKey:@"caption"];
//    [parameters setObject:@(1) forKey:@"channelID"];
//    
//    
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//    [manager POST:urlSting parameters: parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
//        NSError *error = nil;
//        
//       BOOL isSuccess = [formData appendPartWithFileURL:[NSURL fileURLWithPath:amrFileSavePath] name:fileName fileName:fileName mimeType:@"audio/AMR" error:&error];
//        if (isSuccess) {
//            QMLog(@"audio/ isSuccess");
//        } else if (error) {
//            QMLog(@"audio/AMR:error%@",[error localizedDescription]);
//        }
//    } progress:^(NSProgress * _Nonnull uploadProgress) {
//        
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:(NSJSONReadingMutableContainers) error:nil];
//        QMLog(@"success,responseObject%@",dic);
//        
//        
//        if (![dic[@"Error"] isKindOfClass:[NSNull class]]) {
//            NSDictionary *error = dic[@"Error"];
//            QMLog(@"%@",error[@"Message"]);
//        }
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        QMLog(@"error:%@",[error localizedDescription]);
//    }];
//    
}

#pragma mark - 上传文件
/**
 *  新建上传文件
 */
- (void)newUpLoadFileWithFilePath:(NSString *)filePath fileName:(NSString *)fileName fileFormat:(NSString *)fileFormat {
//    新建上传文件
//    地址: http://path-to-service/story/newUploadFile
//    方式: POST
//    参数: token, fileSize（文件大小）, fileName（文件名）, fileFormat（后缀比如amr）
//    返回: status, fileID(文件标识), blockCount(块数), blockSize(块大小)
    NSData *data = [NSData dataWithContentsOfFile:filePath];

    NSString *urlSting = [NSString stringWithFormat:@"http://%@/story/newUploadFile",[[NSUserDefaults standardUserDefaults]objectForKey:kPathToService]];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"token"] forKey:@"token"];
    [parameters setObject:[NSString stringWithFormat:@"%ld",data.length] forKey:@"fileSize"];
    [parameters setObject:fileName forKey:@"fileName"];
    [parameters setObject:fileFormat forKey:@"fileFormat"];

    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:urlSting parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:(NSJSONReadingMutableContainers) error:nil];
        QMLog(@"success,responseObject%@",dic);
        
        if (![dic[@"Error"] isKindOfClass:[NSNull class]]) {
            NSDictionary *error = dic[@"Error"];
            QMLog(@"%@",error[@"Message"]);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
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

@end
