//
//  AttachMentModel.h
//  Interview
//
//  Created by ChengFei on 16/4/16.
//  Copyright © 2016年 yonganbo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QMRecoderDBModel.h"

@interface AttachmentModel : NSObject
@property (nonatomic, assign) NSInteger index;
@property (nonatomic,assign) BOOL isEdit;
@property (nonatomic,copy) NSString *attachmentType;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic,copy) QMRecoderDBModel *recordModel;
@end
