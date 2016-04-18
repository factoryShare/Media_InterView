//
//  ManuscriptModel.h
//  Interview
//
//  Created by ChengFei on 16/4/15.
//  Copyright © 2016年 yonganbo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LKDBHelper.h"
@interface ManuscriptModel : NSObject
@property (nonatomic, copy) NSString *scriptTitle;
@property (nonatomic, copy) NSString *scriptContent;
@property (nonatomic, strong) NSArray *attachmentArray;
@property (nonatomic,copy) NSString *isSendToServer;
@property (nonatomic, copy) NSString *scriptId;
@end


