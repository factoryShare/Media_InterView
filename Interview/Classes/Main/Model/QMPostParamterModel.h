//
//  QMPostParamterModel.h
//  Interview
//
//  Created by Mr.Right on 16/4/17.
//  Copyright © 2016年 yonganbo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SynthesizeSingleton.h"

@interface QMPostParamterModel : NSObject
SYNTHESIZE_SINGLETON_FOR_CLASS_HEADER(QMPostParamterModel);
@property(nonatomic,copy) NSString *BlockCount;
@property(nonatomic,copy) NSString *BlockSize;
@property(nonatomic,copy) NSString *FileID;

@end
