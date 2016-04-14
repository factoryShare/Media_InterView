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

//已经插入数据库
+(void)dbDidInserted:(NSObject *)entity result:(BOOL)result
{
    LKErrorLog(@"did insert : %@",NSStringFromClass(self));
}


@end
