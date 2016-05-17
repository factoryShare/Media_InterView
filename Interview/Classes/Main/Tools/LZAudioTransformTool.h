//
//  LZAudioTransformTool.h
//  Interview
//
//  Created by Mr.Right on 16/5/16.
//  Copyright © 2016年 yonganbo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SynthesizeSingleton.h"

@interface LZAudioTransformTool : NSObject
SYNTHESIZE_SINGLETON_FOR_CLASS_HEADER(LZAudioTransformTool);
- (void)audio_PCMtoMP3WithResourcePath:(NSString *)rPath;
@end
