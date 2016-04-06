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

typedef void (^GetRecListBlocks)(NSArray *array);

@interface QMRecorderDBManager : NSObject

SYNTHESIZE_SINGLETON_FOR_CLASS_HEADER(QMRecorderDBManager);
/** 更 */
- (void)insertModel:(QMRecoderDBModel *)model;
/** 删 */
- (void)deleteModel:(NSString *)title;

- (void)getAllModel:(GetRecListBlocks)listModel;
@end
