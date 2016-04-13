//
//  QMUserModel.h
//  Interview
//
//  Created by Mr.Right on 16/4/13.
//  Copyright © 2016年 yonganbo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SynthesizeSingleton.h"

@interface QMUserModel : NSObject
SYNTHESIZE_SINGLETON_FOR_CLASS_HEADER(QMUserModel);

@property(nonatomic,copy) NSString *pathToService;
@property(nonatomic,copy) NSString *userName;
@property(nonatomic,copy) NSString *password;
@property(nonatomic,copy) NSString *token;

@end
