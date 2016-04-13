//
//  PlanModel.m
//  Interview
//
//  Created by fei on 16/4/4.
//  Copyright © 2016年 yonganbo. All rights reserved.
//

#import "PlanModel.h"

@implementation PlanModel
// 表名
+ (NSString *)getTableName {
    return @"PlanTable";
}

// 数据库路径
+ (LKDBHelper *)getUsingLKDBHelper {
    static LKDBHelper *db;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *dbPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/db/PlanTable.db"];
        db = [[LKDBHelper alloc] initWithDBPath:dbPath];
        NSLog(@"PlanTable.db ok");
    });
    return db;
}

// 主键
+ (NSString *)getPrimaryKey {
    return @"code";
}


//已经插入数据库
+(void)dbDidInserted:(NSObject *)entity result:(BOOL)result
{
    LKErrorLog(@"did insert : %@",NSStringFromClass(self));
}


@end
