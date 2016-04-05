//
//  QMRecorderDBManager.h
//  Interview
//
//  Created by Mr.Right on 16/4/4.
//  Copyright © 2016年 yonganbo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SynthesizeSingleton.h"
#import "QMRecoderDBModel.h"

@interface QMRecorderDBManager : NSObject

SYNTHESIZE_SINGLETON_FOR_CLASS_HEADER(QMRecorderDBManager);
- (void)insertModel:(QMRecoderDBModel *)model;
@end
