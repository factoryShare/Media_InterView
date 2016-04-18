//
//  QMPostParamterModel.m
//  Interview
//
//  Created by Mr.Right on 16/4/17.
//  Copyright © 2016年 yonganbo. All rights reserved.
//

#import "QMPostParamterModel.h"

@implementation QMPostParamterModel

SYNTHESIZE_SINGLETON_FOR_CLASS(QMPostParamterModel);

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    QMLog(@"QMUserModel没有 key:%@",key);
}
@end
