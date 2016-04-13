//
//  QMUserModel.m
//  Interview
//
//  Created by Mr.Right on 16/4/13.
//  Copyright © 2016年 yonganbo. All rights reserved.
//

#import "QMUserModel.h"

@implementation QMUserModel
SYNTHESIZE_SINGLETON_FOR_CLASS(QMUserModel);

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    QMLog(@"QMUserModel没有 key:%@",key);
}
@end
