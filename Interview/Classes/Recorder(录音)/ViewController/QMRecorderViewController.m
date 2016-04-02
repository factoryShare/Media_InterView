//
//  QMRecorderViewController.m
//  Interview
//
//  Created by Mr.Right on 16/3/30.
//  Copyright © 2016年 yonganbo. All rights reserved.
//

#import "QMRecorderViewController.h"
#import "LZRecorderTool.h"

@interface QMRecorderViewController () <LZRecorderDeleagte>
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIProgressView *powerIndicater;
@property (weak, nonatomic) IBOutlet UIButton *controlBtn;
@property (weak, nonatomic) IBOutlet UIButton *lockBtn;

@property(nonatomic,strong) NSTimer *timer;
@property(nonatomic,assign) int timerValue;
@property(nonatomic,strong) UIView *coverView;
@property(nonatomic,strong) LZRecorderTool *recorder;

@end

@implementation QMRecorderViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _timerValue = 0;
    
    
    self.view.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.7];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(showList) normalImage:@"nav_list"];
}
/**
 *  显示已经录制的音频
 */
- (void)showList {
    UIViewController *vc = [[UIViewController alloc]init];
    
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (IBAction)recorde:(UIButton *)sender {
    static BOOL isRecording = YES;
    sender.selected = isRecording;
    if (isRecording) {
        self.timer.fireDate = [NSDate distantPast];
        
        // 开始录制
        [self.recorder startRecorde];
        
        isRecording = NO;
    } else {
        _timerValue = 0;
        
        self.timer.fireDate = [NSDate distantFuture];
        if (self.timer.isValid) {
            [_timer invalidate];
        }
        _timer = nil;
        [self timeChanged];
        
        // 结束录制
        [self.recorder stopRecorde];
        
        isRecording = YES;
    }
}
/**
 *  锁定屏幕 */
- (IBAction)lockView:(UIButton *)sender {
    static BOOL isLocking = YES;
    sender.selected = isLocking;
    if (isLocking) {
//        _coverView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
//        _coverView.backgroundColor = [UIColor redColor];
//        [[UIApplication sharedApplication].keyWindow addSubview: _coverView];
//        
//        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
//        view.backgroundColor = [UIColor greenColor];
//        
//        [_coverView addSubview:self.lockBtn];
        isLocking = NO;
    } else {
        isLocking = YES;
    }

}

/**
 *  更新时间
 */
- (void)timeChanged {
    
    int minute = _timerValue / 60;
    int second = _timerValue % 60;
    switch (minute) {
        case 0:
            self.timeLabel.text = [NSString stringWithFormat:@"00:%02d",second];
            break;
            
        default:
            self.timeLabel.text = [NSString stringWithFormat:@"%02d:%02d",minute,second];
            break;
    }
    
    _timerValue++;

}

#pragma mark - LZRecorderDeleagte 
- (void)getaudioPower:(float)power {

    self.powerIndicater.progress = power;
}
#pragma mark - 初始化
- (NSTimer *)timer {
    if (_timer == nil) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1.f target:self selector:@selector(timeChanged) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
        _timer.fireDate = [NSDate distantFuture];
    }
    
    return _timer;
}

- (LZRecorderTool *)recorder {
    if (_recorder == nil) {
        _recorder = [[LZRecorderTool alloc]init];
        _recorder.delegate = self;
    }
    
    return _recorder;
}
@end
