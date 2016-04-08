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

@interface QMRecorderListViewController () <UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) NSMutableArray *dataSource;
/** 播放器 */
@property(nonatomic,strong) LZPlayerForRecorder *player;
/** 底部视图 */
@property(nonatomic,strong) UIView *bottomView;
@property(nonatomic,strong) UIView *progressView;
@property(nonatomic,strong) UIButton *playBtn;

@end

@implementation QMRecorderListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = QMColor(127, 127, 127);

    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(rightItemClick:)image:@"nav_delete" selectedImage:@"nav_save"];
    
    [self updateTableView];
    
    [self createBottomView];
    
//    _playBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
//    [_playBtn setImage:[UIImage imageNamed:@"Playerplay"] forState:(UIControlStateNormal)];
//    [_playBtn setImage:[UIImage imageNamed:@"Playerpause"] forState:(UIControlStateSelected)];
//    _playBtn.frame = CGRectMake(100, 100, 0, 0);
//    _playBtn.size = _playBtn.currentImage.size;
//    
//    [self.view addSubview:_playBtn];


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
    if (!button.selected) {// 播放
        button.selected = YES;
    } else {// 暂停
        button.selected = NO;
    }
    _progressView.width += 10;
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
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    QMRecoderDBModel *model = self.dataSource[indexPath.row];
    
    self.player.filePath = model.recorderPath;
//    NSLog(@"%@",model.timeLong);
    [self.player startPlay];
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
    }}

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
    bottomView.backgroundColor = [UIColor redColor];
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
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(playBtn.width + 20, playBtn.centerY, 0, 3)];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.bottomView addSubview:bgView];
    
    // 播放进度条
    UIView *progressView = [[UIView alloc]initWithFrame:CGRectMake(playBtn.width + 20, playBtn.centerY, 0, 3)];
    progressView.backgroundColor = [UIColor blueColor];
    self.progressView = progressView;
    [self.bottomView addSubview:progressView];

}

- (LZPlayerForRecorder *)player {
    if (_player == nil) {
        _player = [[LZPlayerForRecorder alloc]init];
    }
    return _player;
}
//
//- (QMRecorderListBottomView *)bottomView {
//    if (_bottomView == nil) {
//        _bottomView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([QMRecorderListBottomView class]) owner:self options:nil] lastObject];
//        _bottomView.frame = CGRectMake(0, self.view.height - 90, self.view.width, 50);
//        _bottomView.progressView.width = 0;
//        [_bottomView layoutIfNeeded];
//    }
//    return _bottomView;
//}

@end
