//
//  QMRecorderDBManager.m
//  Interview
//
//  Created by Mr.Right on 16/4/4.
//  Copyright © 2016年 yonganbo. All rights reserved.
//

#import "QMManuscriptDBManager.h"
#import "FMDB.h"
#import "MBProgressHUD+MJ.h"

@interface QMManuscriptDBManager () {
    FMDatabaseQueue *_dataBaseQueue;
}
@end
@implementation QMManuscriptDBManager
SYNTHESIZE_SINGLETON_FOR_CLASS(QMManuscriptDBManager);

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
    NSString *sql = @"CREATE TABLE IF NOT EXISTS ManuscriptModel (scriptTitle text, scriptContent text, attachmentArray text, isSendToServer text, scriptId text, rowid integer)";
    NSString *docPath  = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *bdpath2 = [docPath stringByAppendingPathComponent:@"db"];
    NSString *dbPath = [bdpath2 stringByAppendingPathComponent:@"LKDB.db"];
    
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

- (void)deleteAllData {
    [_dataBaseQueue inDatabase:^(FMDatabase *db) {
        
        NSString *sqlDelegate = @"delete from ManuscriptModel";
        BOOL isSuccess = [db executeUpdate:sqlDelegate];
        if (isSuccess) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUD];
            });
            QMLog(@"ManuscriptModel 数据删除所有数据成功");
        }
    }];

}

@end
