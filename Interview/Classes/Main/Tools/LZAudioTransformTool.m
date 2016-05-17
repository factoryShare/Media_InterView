//
//  LZAudioTransformTool.m
//  Interview
//
//  Created by Mr.Right on 16/5/16.
//  Copyright © 2016年 yonganbo. All rights reserved.
//

#import "LZAudioTransformTool.h"
#import "lame.h"
#import <AVFoundation/AVFoundation.h>

@implementation LZAudioTransformTool
SYNTHESIZE_SINGLETON_FOR_CLASS(LZAudioTransformTool);

- (instancetype)init {
    if (self = [super init]) {
        
    }
    return self;
}


#pragma mark - 音频转化
- (void)audio_PCMtoMP3WithResourcePath:(NSString *)rPath
{
    NSString *fPath = [rPath stringByReplacingOccurrencesOfString:@".caf" withString:@"exported.mp3"];
    
    @try {
        int read, write;
        
        FILE *pcm = fopen([rPath cStringUsingEncoding:1], "rb");  //source 被转换的音频文件位置
        fseek(pcm, 4*1024, SEEK_CUR);                                   //skip file header
        FILE *mp3 = fopen([fPath cStringUsingEncoding:1], "wb");  //output 输出生成的Mp3文件位置
        
        const int PCM_SIZE = 8192;
        const int MP3_SIZE = 8192;
        short int pcm_buffer[PCM_SIZE*2];
        unsigned char mp3_buffer[MP3_SIZE];
        
        lame_t lame = lame_init();
        lame_set_in_samplerate(lame, 11025.0);
        lame_set_VBR(lame, vbr_default);
        lame_init_params(lame);
        
        do {
            read = fread(pcm_buffer, 2*sizeof(short int), PCM_SIZE, pcm);
            if (read == 0)
                write = lame_encode_flush(lame, mp3_buffer, MP3_SIZE);
            else
                write = lame_encode_buffer_interleaved(lame, pcm_buffer, read, mp3_buffer, MP3_SIZE);
            
            fwrite(mp3_buffer, write, 1, mp3);
            
        } while (read != 0);
        
        lame_close(lame);
        fclose(mp3);
        fclose(pcm);
    }
    @catch (NSException *exception) {
        NSLog(@"%@",[exception description]);
    }
    @finally {
        
        [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategorySoloAmbient error: nil];
        NSLog(@"MP3生成成功: %@",fPath);
        
    }
    
}

@end
