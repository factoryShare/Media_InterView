//
//  QMRecorderViewController.m
//  Interview
//
//  Created by Mr.Right on 16/3/30.
//  Copyright © 2016年 yonganbo. All rights reserved.
//

#import "QMRecorderViewController.h"
#import "LZRecorderTool.h"
#import "QMRecoderDBModel.h"
#import "QMRecorderDBManager.h"
#import "QMRecorderListViewController.h"
#import "QMRecorderListBottomView.h"
#import "QMWaveView.h"

@interface QMRecorderViewController () <LZRecorderDeleagte,UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *controlBtn;
@property (weak, nonatomic) IBOutlet UIButton *lockBtn;
@property (weak, nonatomic) IBOutlet UIImageView *powerIndicaterIm;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet QMWaveView *waveView;

@property(nonatomic,strong) NSTimer *timer;
@property(nonatomic,assign) int timerValue;
@property(nonatomic,assign) int timerLong;
@property(nonatomic,strong) UIView *coverView;
@property(nonatomic,strong) LZRecorderTool *recorder;
@property(nonatomic,assign) long waveTime;
@property(nonatomic,assign) BOOL isWaveShow;
/** 录音默认文件名 */
@property(nonatomic,copy) NSString *fileName;
/** 录音存储地址(amr) */
@property(nonatomic,copy) NSString *amrFileSavePath;
@property(nonatomic,strong) QMRecorderDBManager *recorderDBManager;
@property(nonatomic,strong) UIWindow *keyWindow;

@end

@implementation QMRecorderViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _timerValue = 0;
    _timerLong = 0;
    
    _waveTime = 0;
    _isWaveShow = NO;
    
    
    self.view.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.7];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(showList) normalImage:@"nav_list"];
    
}
/**
 *  显示已经录制的音频
 */
- (void)showList {
    if (_isWaveShow) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"请录制完毕" message: nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        
        [alert setAlertViewStyle:(UIAlertViewStyleDefault)];
        
        [alert show];
        return;
    }
    
    QMRecorderListViewController *listVC = [[QMRecorderListViewController alloc]init];
    
    [self.navigationController pushViewController:listVC animated:YES];
    
}

- (IBAction)recorde:(UIButton *)sender {
    static BOOL isRecording = YES;
    if (isRecording) {// 开始录制
        sender.selected = isRecording;

        self.timer.fireDate = [NSDate distantPast];
        
        [self.recorder startRecorde];
        
        isRecording = NO;
        _isWaveShow = YES;
    } else {
        if (_timerValue <= 15) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"录音不足15秒请继续录制" message: nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            
            [alert setAlertViewStyle:(UIAlertViewStyleDefault)];
            
            [alert show];
            return;
        } else {
            sender.selected = isRecording;

            // 结束录制
            _timerLong = _timerValue;
            _timerValue = 0;
            _waveTime = 0;
            NSLog(@"1");
            self.timer.fireDate = [NSDate distantFuture];
            if (self.timer.isValid) {
                [_timer invalidate];
            }
            _timer = nil;
            [self timeChanged];
            
            // 存储文件名
            self.fileName = self.recorder.fileName;
            self.amrFileSavePath  =self.recorder.amrFileSavePath;
            
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"请输入录音名" message: nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            
            [alert setAlertViewStyle:(UIAlertViewStylePlainTextInput)];
            
            alert.delegate = self;
            
            UITextField *textField = [alert textFieldAtIndex:0];
            textField.text = [self getCurrentTime];
            textField.clearButtonMode = UITextFieldViewModeWhileEditing;

            [alert show];
            // 结束录制
            
            [self.recorder stopRecorde];

            self.recorder = nil;
            
            isRecording = YES;
            _isWaveShow = NO;
        }
    }
    

}
/**
 *  锁定屏幕 */
- (IBAction)lockView:(UIButton *)sender {
    _coverView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    _coverView.backgroundColor = [UIColor clearColor];
    self.keyWindow = [UIApplication sharedApplication].keyWindow;
    [self.keyWindow addSubview: _coverView];
    
    CGRect rect;
    
    rect = [self.bottomView convertRect:self.lockBtn.frame toView:_keyWindow];
    
    UIButton *lockBtnOnCover = [UIButton buttonWithType:(UIButtonTypeCustom)];
    lockBtnOnCover.frame = rect;
    [lockBtnOnCover setImage:[UIImage imageNamed:@"Recorder_lock_click"] forState:(UIControlStateNormal)];        [lockBtnOnCover addTarget:self action:@selector(lockBtnOnCoverClick:) forControlEvents:(UIControlEventTouchUpInside)];
    
    [_coverView addSubview:lockBtnOnCover];

}
/**
 *  解锁
 */
- (void)lockBtnOnCoverClick:(UIButton *)btn {
    [self.coverView removeFromSuperview];
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
    int character = power / 160 * 26;
    character -= 10;
    if (character > 26) {
        character = 26;
    } else if (character < 0) {
        character = 0;
    }
    NSString *imageName = [NSString stringWithFormat:@"vu%C",(unichar)(character + 97)];
    
    self.powerIndicaterIm.image = [UIImage imageNamed:imageName];
    
    if (_isWaveShow) {
        self.waveView.isWaveShow = _isWaveShow;
        static int i = 0;
        if (i >= 3) {
            self.waveView.powerPotint = CGPointMake(_waveTime++, character);
            i = 0;
        } else {
            i++;
        }
    } else {
        self.waveView.isWaveShow = _isWaveShow;
    }
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {

    if (buttonIndex == alertView.firstOtherButtonIndex) {
        UITextField *textField = [alertView textFieldAtIndex:0];
        NSDictionary *dic = @{@"CustomName":[NSString stringWithFormat:@"%@",textField.text],@"recorderName":self.fileName,@"recorderPath":self.amrFileSavePath,@"TimeLong":[NSString stringWithFormat:@"%d",_timerLong]};
        
        QMRecoderDBModel *model = [[QMRecoderDBModel alloc]init];
        [model setValuesForKeysWithDictionary:dic];
        
        // 建立本地数据库
        [self.recorderDBManager insertModel:model];
        
        self.powerIndicaterIm.image = [UIImage imageNamed:@"vu"];
        
        self.waveView.isWaveShow = NO;
    }
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

- (QMRecorderDBManager *)recorderDBManager {
    if (_recorderDBManager == nil) {
        _recorderDBManager = [QMRecorderDBManager sharedQMRecorderDBManager];
    }
    return  _recorderDBManager;
}

- (NSString *)getCurrentTime {
    
    NSDateFormatter *forma = [[NSDateFormatter alloc]init];
    forma.dateFormat = @"yyyymmddhhmmss";
    NSString *time = [forma stringFromDate:[NSDate date]];
    
    return time;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

@end
