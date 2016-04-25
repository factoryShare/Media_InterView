//
//  QMRecorderDBManager.m
//  Interview
//
//  Created by Mr.Right on 16/4/4.
//  Copyright © 2016年 yonganbo. All rights reserved.
//

#import "QMRecorderDBManager.h"
#import "FMDB.h"
#import "MBProgressHUD+MJ.h"
#import "QMRecoderDBModel.h"
@interface QMRecorderDBManager () {
    FMDatabaseQueue *_dataBaseQueue;
}
@end
@implementation QMRecorderDBManager
SYNTHESIZE_SINGLETON_FOR_CLASS(QMRecorderDBManager);

- (instancetype)init {
    if (self=  [super init]) {
        [self createDataBase];
    }
    return self;
}

/**
 *  创建数据库
 */
-(void)createDataBase{
    //CustomName:用户输入名,recorderName:默认名,recorderPath:存储地址
    NSString *sql = @"CREATE TABLE IF NOT EXISTS AMRSaveTable (CustomName text, RecorderName text, RecorderPath text, TimerLong text)";
    NSString *docPath  = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *dbPath = [docPath stringByAppendingPathComponent:@"RecorderList.db"];
    
    _dataBaseQueue = [FMDatabaseQueue databaseQueueWithPath:dbPath];
    [_dataBaseQueue inDatabase:^(FMDatabase *db) {
        
        BOOL isSueccess = [db executeUpdate:sql];
        if (isSueccess) {
            QMLog(@"%@",@"菜单创建表格成功");
        }else{
            QMLog(@"%@",@"菜单创建表格失败");
        }
    }];
}
#pragma mark 外部方法
/**
 *  更
 */
- (void)insertModel:(QMRecoderDBModel *)model{
    [_dataBaseQueue inDatabase:^(FMDatabase *db) {
        // 按默认名
        NSString *selectSql = @"select * from AMRSaveTable where RecorderName = ?";
        FMResultSet *rs = [db executeQuery:selectSql,model.recorderName];
        BOOL isEs  = NO;//判断当前插入的数据是否存在
        while ([rs next]) {
            isEs = YES;//如果进来，当前存在一条这样的语句
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUD];
            });
        }
        if (isEs == NO) {
            NSString *insertSQL =  @"INSERT INTO AMRSaveTable(CustomName, RecorderName, RecorderPath, TimerLong) VALUES(?, ?, ?, ?)";
            BOOL isSucess =  [db executeUpdate:insertSQL, model.CustomName,model.recorderName,model.recorderPath,model.timeLong];
            if (isSucess) {
                QMLog(@"AMRSaveTable插入数据%@",@"成功");
                [MBProgressHUD showSuccess:@"录音成功"];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [MBProgressHUD hideHUD];
                });
            } else {
                QMLog(@"%@",@"插入数据失败");
                [MBProgressHUD showError:@"保存失败,请联系开发者"];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [MBProgressHUD hideHUD];
                });
            }
        }
    }];
}
/**
 *  删
 */
- (void)deleteModel:(NSString *)title{
    
    [_dataBaseQueue inDatabase:^(FMDatabase *db) {
        
        NSString *sqlDelegate = @"delete from AMRSaveTable where RecorderName = ?";
        BOOL isSuccess = [db executeUpdate:sqlDelegate,title];
        if (isSuccess) {
            [MBProgressHUD showSuccess:@"删除成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUD];
            });
            QMLog(@"AMRSaveTable 数据删除成功");
        }
    }];
}

- (void)deleteAllData {
    [_dataBaseQueue inDatabase:^(FMDatabase *db) {
        
        NSString *sqlDelegate = @"delete from AMRSaveTable";
        BOOL isSuccess = [db executeUpdate:sqlDelegate];
        if (isSuccess) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUD];
            });
            QMLog(@"AMRSaveTable 数据删除所有数据成功");
        }
    }];

}

/**
 *  获取当前数据库所有数据
 */
- (void)getAllModel:(GetRecListBlocks)listModel{
    
    [_dataBaseQueue inDatabase:^(FMDatabase *db) {
        //创建可变数组存储modle
        NSMutableArray *modelArray = [[NSMutableArray alloc]init];
        // CustomName, RecorderName, RecorderPath
        NSString *sql = @"select * from AMRSaveTable";
        //执行查询sql语句
        FMResultSet *rs = [db executeQuery:sql];
        
        while ([rs next]) {
            QMRecoderDBModel  *model = [[QMRecoderDBModel alloc] init];
            
            model.CustomName = [rs stringForColumn:@"CustomName"];
            model.recorderName = [rs stringForColumn:@"RecorderName"];
            model.recorderPath = [rs stringForColumn:@"RecorderPath"];
            model.timeLong = [rs stringForColumn:@"TimerLong"];
            [modelArray addObject:model];
        }
        //获取model之后，传值回去
        listModel(modelArray);
    }];
}


@end
