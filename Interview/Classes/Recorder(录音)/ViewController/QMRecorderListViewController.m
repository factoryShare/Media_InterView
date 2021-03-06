//
//  QMRecorderListViewController.m
//  Interview
//
//  Created by Mr.Right on 16/4/5.
//  Copyright © 2016年 yonganbo. All rights reserved.
//

#import "QMRecorderListViewController.h"
#import "QMRecorderDBManager.h"
#import "QMRecoderDBModel.h"
#import "QMRecorderListCell.h"
#import "LZFileHandle.h"
#import "LZPlayerForRecorder.h"
#import "QMRecorderListBottomView.h"

#import <AVFoundation/AVFoundation.h>

@interface QMRecorderListViewController () <UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) NSMutableArray *dataSource;
/** 播放器 */
@property(nonatomic,strong) LZPlayerForRecorder *player;
/** 底部视图 */
@property(nonatomic,strong) UIView *bottomView;
@property(nonatomic,strong) UIView *progressBgView;
@property(nonatomic,strong) UIView *progressView;
@property(nonatomic,strong) UIButton *playBtn;
@property(nonatomic,strong) UIButton *thumbBtn;

/** 音频总时长 */
@property(nonatomic,assign) NSTimeInterval timeLong;
/** 音频跟踪定时器 */
@property(nonatomic,strong) NSTimer *timer;
/** 没单位时间精度条自增长长度 */
@property(nonatomic,assign) double timerValue;
@property(nonatomic,strong) QMRecoderDBModel *recorderDBModel;

@end

@implementation QMRecorderListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];

    [self createBarItem];

    [[QMRecorderDBManager sharedQMRecorderDBManager] getAllModel:^(NSArray *array) {
        self.dataSource = [NSMutableArray arrayWithArray:array];
    }];
    // 进入后台停止播放
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopAudio) name:@"enterBackground" object:nil];

    // 初始播放设置
    [self getInitial];
    
    self.recorderDBModel = nil;
    
    self.view.backgroundColor = QMColor(127, 127, 127);

    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(rightItemClick:)image:@"nav_delete" selectedImage:@"nav_save"];
    
    [self updateTableView];
    
    [self createBottomView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (_player) {
        self.thumbBtn.centerX += self.player.currentTime / self.player.MusicDuring  * self.progressView.width;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_player stop];    
}


#pragma mark - 删除音频文件
- (void)rightItemClick:(UIButton *)buttonItem {
    
    if (!buttonItem.selected) {// 删除
        buttonItem.selected = YES;
    } else {// 保存
        buttonItem.selected = NO;
    }
    [self.tableView setEditing:!self.tableView.isEditing animated:YES];
    
}
/**
 *  控制音乐播放暂停
 */
- (void)playBtnOnClick:(UIButton *)button {
    self.recorderDBModel = self.dataSource[self.tableView.indexPathForSelectedRow.row];
    NSString *tempDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    // 初始化格式地址
    NSString *path = [tempDir stringByAppendingPathComponent: self.recorderDBModel.recorderName];
    // 音频播放
    LZFileHandle *handle = [[LZFileHandle alloc]init];
    self.player.filePath = path;
    if ([handle isFileExisting:path]) {
        self.timeLong = self.player.MusicDuring;
        if (self.timeLong == 0) {
            NSLog(@"00000");
            return;
        }
        _timerValue =  self.progressBgView.width / self.timeLong / 10.0;
    
    } else {
        return;
    }

    if (!button.selected) {// 播放
        [self.player startPlay];
        // 开始计时
        self.timer.fireDate = [NSDate distantPast];
        button.selected = YES;
    } else {// 暂停
        [self.player pause];
        // 暂停计时
        self.timer.fireDate = [NSDate  distantFuture];
        button.selected = NO;
    }
}

/**
 *  给视图添加移动手势
 *
 *  @param myView 要添加到得视图
 */
- (void)addPan:(UIView *)myView{
    //创建移动手势
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]init];
    //添加回调函数
    [pan addTarget:self action:@selector(pan:)];
    //视图添加手势
    [myView addGestureRecognizer:pan];
}
//移动手势的回调函数
- (void)pan:(UIPanGestureRecognizer *)pan{
    
    static CGPoint beganCenter;
    //获得偏移量
    CGPoint point = [pan translationInView:pan.view];
    //判断手势的状态
    switch (pan.state) {
        //开始
        case UIGestureRecognizerStateBegan:
        {
            beganCenter = pan.view.center;

        }break;
        // 移动
        case UIGestureRecognizerStateChanged:{
            // 按钮位置
            CGPoint center = CGPointMake(point.x+beganCenter.x, beganCenter.y);
            pan.view.center = (center.x >= self.progressBgView.x && center.x <= self.progressBgView.width + self.progressBgView.x) ? center : pan.view.center;
            // 进度条位置
            self.progressView.width = pan.view.center.x - self.progressBgView.x;
        }break;
        //结束
        case UIGestureRecognizerStateEnded:{
            // 播放音乐
            [self.player playAtTime:self.progressView.width / (1.0*self.progressBgView.width) * self.player.MusicDuring];

        }break;
        
        default:
            break;
    }
    
}

/**
 *  cell点击播放
 */
- (void)cellPlayOnClick:(UIButton *)button {
    if (!button.selected) {// 播放
        button.selected = YES;
    } else {// 暂停
        button.selected = NO;
    }

}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    QMRecorderListCell *cell = [QMRecorderListCell cellWithTableView:tableView];
    
    cell.model = self.dataSource[indexPath.row];
    
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        QMRecoderDBModel *delegateModel = self.dataSource[indexPath.row];
        [self.dataSource removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimationFade)];
        
        // 删除本地数据库
        [[QMRecorderDBManager sharedQMRecorderDBManager] deleteModel:delegateModel.recorderName];
        // 删除本地沙盒文件
        LZFileHandle *handle = [[LZFileHandle alloc]init];
        [handle removeFileAtPath:delegateModel.recorderPath];
        NSString *wavPath = [delegateModel.recorderPath stringByReplacingOccurrencesOfString:@"amr" withString:@"wav"];
        [handle removeFileAtPath:wavPath];
        // 跟新cell
        [self.tableView reloadData];
        // 更新表格
        [self updateTableView];
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self getInitial];
    
    self.recorderDBModel = self.dataSource[indexPath.row];
    NSString *tempDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    // 初始化格式地址
    NSString *path = [tempDir stringByAppendingPathComponent: self.recorderDBModel.recorderName];
    // amr 地址
//    NSString *amrFileSavePath = [path stringByReplacingOccurrencesOfString:@".wav" withString:@".amr"];
    // 音频播放
    LZFileHandle *handle = [[LZFileHandle alloc]init];
    self.player.filePath = path;
    QMLog(@"%@",self.player.filePath);

    if ([handle isFileExisting:path]) {
        self.timeLong = self.player.MusicDuring;
        if (self.timeLong == 0) {
            NSLog(@"00000");
            return;
        }
        // 设置精度条步进值/0.1s
        _timerValue =  self.progressBgView.width / self.timeLong / 10.0;
        // 点击播放按钮
        [self playBtnOnClick:self.playBtn];
    } else {
        return;
    }
}

#pragma mark - 初始化
- (void)updateTableView {
    self.automaticallyAdjustsScrollViewInsets = YES;
    CGFloat tableViewH = 0;
    if (self.tableView == nil) {
        UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, tableViewH) style:(UITableViewStylePlain)];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.backgroundColor = [UIColor whiteColor];
        //    tableView.allowsMultipleSelection = YES;
        self.tableView = tableView;
        
        [self.tableView registerNib:[UINib nibWithNibName:@"QMRecorderListCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"QMRecorderListCell"];
        
        [self.view addSubview:self.tableView];

    }
    
    if ( self.dataSource.count * 60 > [UIScreen mainScreen].bounds.size.height -100) {
        tableViewH = [UIScreen mainScreen].bounds.size.height -100;
        self.tableView.height = tableViewH;
        [self.tableView setScrollEnabled:YES];
    } else {
        tableViewH = self.dataSource.count * 60;
        self.tableView.height = tableViewH;
        [self.tableView setScrollEnabled:NO];
    }
}

- (NSMutableArray *)dataSource {
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
        
        [[QMRecorderDBManager sharedQMRecorderDBManager] getAllModel:^(NSArray *array) {
            self.dataSource = [NSMutableArray arrayWithArray:array];
        }];
    }
    return _dataSource;
}
/**
 *  底部播放模块
 */
- (void)createBottomView {
    
    // 创建底部视图
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, _kScreenHeight - 100, _kScreenWidth, 100)];
    bottomView.backgroundColor = [UIColor blackColor];
    self.bottomView = bottomView;
    [self.view addSubview: self.bottomView];
    
    // 播放按钮
    UIButton *playBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [playBtn setImage:[UIImage imageNamed:@"Playerplay"] forState:(UIControlStateNormal)];
    [playBtn setImage:[UIImage imageNamed:@"Playerpause"] forState:(UIControlStateSelected)];
    playBtn.frame = CGRectMake(5, 5, 0, 0);
    playBtn.size = playBtn.currentImage.size;
    [playBtn addTarget:self action:@selector(playBtnOnClick:) forControlEvents:(UIControlEventTouchUpInside)];
    self.playBtn = playBtn;
    
    [self.bottomView addSubview: self.playBtn];
    
    // 播放进度条背景
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(playBtn.width + 20, playBtn.centerY, _kScreenWidth - playBtn.width - 20 * 2, 3)];
    bgView.backgroundColor = [UIColor whiteColor];
    self.progressBgView = bgView;
    [self.bottomView addSubview:self.progressBgView];
    
    // 播放进度条
    UIView *progressView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 3)];
    progressView.backgroundColor = [UIColor blueColor];
    self.progressView = progressView;
    [self.progressBgView addSubview:progressView];
    
    // 拖动按钮
    UIButton *thumbBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [thumbBtn setImage:[UIImage imageNamed:@"process_thumb"] forState:(UIControlStateNormal)];
    thumbBtn.size = thumbBtn.currentImage.size;
    thumbBtn.centerX = bgView.x;
    thumbBtn.centerY = bgView.y + bgView.height / 2;
    self.thumbBtn = thumbBtn;
    [self.bottomView addSubview:self.thumbBtn];
    
    [self addPan:thumbBtn];
}

- (LZPlayerForRecorder *)player {
    if (_player == nil) {
        _player = [[LZPlayerForRecorder alloc]init];
        _player.isPlaying = NO;
        QMLog(@"新建 player");
    }
    return _player;
}

- (NSTimer *)timer {
    if (_timer == nil) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(timeChanged) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
        _timer.fireDate = [NSDate distantFuture];
    }
    
    return _timer;
}

/**
 *  更新时间
 */
- (void)timeChanged {
    _progressView.width += _timerValue;
    self.thumbBtn.centerX += _timerValue;
    if (_progressBgView.width <= _progressView.width) {
        [self getInitial];
    }

}
/**
 *  初始化播放设置
 */
- (void)getInitial {
    _progressView.width = 0;
    self.playBtn.selected = NO;

    self.thumbBtn.centerX = self.progressBgView.x;
    self.thumbBtn.centerY = self.progressBgView.y + self.progressBgView.height / 2;

    self.timer.fireDate = [NSDate distantFuture];
    if (self.timer.isValid) {
        [_timer invalidate];
    }
    _timer = nil;
    
}

//if (self.player.isPlaying) {
//    [self.player stop];
//}

- (void)createBarItem {
    
    UIButton *button = [[UIButton alloc]init];

    [button setBackgroundImage:[UIImage imageNamed:@"nav_back"] forState:(UIControlStateNormal)];
    button.size = button.currentBackgroundImage.size;
    // 让按钮内部的所有内容左对齐
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    //        [button sizeToFit];
    // 让按钮的内容往左边偏移10
    button.contentEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    // 修改导航栏左边的item
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];

}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)stopAudio{

    [_player stop];
    
    [self getInitial];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
