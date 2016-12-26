//
//  VTMViewController.h
//  lametext
//
//  Created by Mr.Right on 16/5/13.
//  Copyright © 2016年 lizheng. All rights reserved.
//

#import <UIKit/UIKit.h>
//基库，一系列的Class(类)来建立和管理iPhone OS应用程序的用户界面接口、应用程序对象、事件控制、绘图模型、窗口、视图和用于控制触摸屏等的接口
#import <AVFoundation/AVFoundation.h> //音频处理
#import <MediaPlayer/MediaPlayer.h> //媒体库
@interface VTMViewController : UIViewController {
    //媒体选择控制器的委托
    MPMediaItem *song; //歌曲 媒体类型
    UILabel *songLabel; //歌曲 文本类型
    UILabel *artistLabel; //艺术家 文本类型
    UILabel *sizeLabel; //大小  文本类型
    UIImageView *coverArtView; //转化艺术家 图片类型
    UIProgressView *conversionProgress; //进度指示器类型
    
}
@end
