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

@interface QMRecorderListViewController () <UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) NSMutableArray *dataSource;
@end

@implementation QMRecorderListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = QMColor(127, 127, 127);
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(rightItemClick:)image:@"nav_delete" selectedImage:@"nav_save"];
    
    [[QMRecorderDBManager sharedQMRecorderDBManager] getAllModel:^(NSArray *array) {
        self.dataSource = [NSMutableArray arrayWithArray:array];
    }];
    
    [self createTableView];
    
    [self createBottomView];
}

#pragma mark - 删除音频文件
- (void)rightItemClick:(UIButton *)buttonItem {
    if (!buttonItem.selected) {// 删除
        buttonItem.selected = YES;
    } else {// 保存
        buttonItem.selected = NO;
    }
}
/**
 *  控制音乐播放暂停
 */
- (void)play:(UIButton *)button {
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
    
    QMRecorderListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QMRecorderListCell" forIndexPath:indexPath];
    
    QMRecoderDBModel *model = self.dataSource[indexPath.row];
    
    cell.musicName.text  = model.CustomName;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

#pragma mark - 初始化
- (void)createTableView {
    self.automaticallyAdjustsScrollViewInsets = YES;
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.height, self.dataSource.count * 60) style:(UITableViewStylePlain)];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = [UIColor whiteColor];
    self.tableView = tableView;

    
    [self.tableView registerNib:[UINib nibWithNibName:@"QMRecorderListCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"QMRecorderListCell"];
    
    
    [self.view addSubview:self.tableView];
}

- (void)createBottomView {
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.height - 100, self.view.frame.size.width, 100)];
    bottomView.backgroundColor = [UIColor clearColor];
    
    UIButton *contollBtn = [[UIButton alloc]init];
    contollBtn.size = contollBtn.currentImage.size;
    contollBtn.centerY = bottomView.height / 2;
    contollBtn.x  = 150;
    [contollBtn setTitle:@"asda" forState:(UIControlStateNormal)];

    [contollBtn setImage:[UIImage imageNamed:@"Playerplay"] forState:(UIControlStateNormal)];
    [contollBtn setImage:[UIImage imageNamed:@"Playerpause"] forState:(UIControlStateSelected)];
    contollBtn.backgroundColor = [UIColor whiteColor];
    [contollBtn addTarget:self action:@selector(play:) forControlEvents:(UIControlEventTouchUpInside)];
    [bottomView addSubview:contollBtn];
    
    [self.view addSubview:bottomView];
}

- (NSMutableArray *)dataSource {
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}
@end
