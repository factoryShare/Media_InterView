//
//  QMSettingViewController.m
//  Interview
//
//  Created by Mr.Right on 16/4/1.
//  Copyright © 2016年 yonganbo. All rights reserved.
//

#import "QMSettingViewController.h"
#import "QMSettingTableViewCell.h"
#import "QMUserInfoViewController.h"
#import "QMCacheViewController.h"
#import "QMPostFileTool.h"
#import "AFNetworking.h"
#import "RevelationManager.h"

#import "LZAudioTransformTool.h"

@interface QMSettingViewController () <UITableViewDelegate,UITableViewDataSource>

@end

@implementation QMSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"push" style:(UIBarButtonItemStyleDone) target:self action:@selector(push)];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(uploadFile:) name:@"postFileByArray" object:nil];

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static  NSString  *cellIDE = nil;
    if (indexPath.row == 0) {
        cellIDE = @"settingcell1";
    } else if (indexPath.row == 1) {
        cellIDE = @"settingcell2";
    } else if (indexPath.row == 2) {
        cellIDE = @"settingcell3";
    }
    
    QMSettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIDE];
    
    
    return cell;
}

#pragma mark - TableView delegate
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        QMUserInfoViewController *userInfoVC = [[QMUserInfoViewController alloc]init];
        [self.navigationController pushViewController:userInfoVC animated:YES];
    } else if(indexPath.row == 1){
        UIViewController *bannerVC = [[UIViewController alloc]init];
        UIImageView *im = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, _kScreenWidth, _kScreenHeight - 64)];
        im.contentMode = UIViewContentModeScaleToFill;
        im.image = [UIImage imageNamed:@"Banner_bg"];
        [bannerVC.view addSubview:im];

        // 版权信息
        UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(0, _kScreenHeight - 64 - 60, _kScreenWidth-2, 30)];
        label1.text = @"版本 : 1.3";
        label1.textColor = [UIColor whiteColor];
        label1.textAlignment = NSTextAlignmentRight;
        label1.font = [UIFont boldSystemFontOfSize:15];
        [bannerVC.view addSubview:label1];
        
        UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(0, _kScreenHeight - 64 - 30, _kScreenWidth-2, 30)];
        label2.text = @"© 版权所有，北京永安博技术有限公司";
        label2.textColor = [UIColor whiteColor];
        label2.textAlignment = NSTextAlignmentRight;
        label2.font = [UIFont boldSystemFontOfSize:15];
        [bannerVC.view addSubview:label2];
        
        bannerVC.title  = @"关于";
        
        [self.navigationController pushViewController:bannerVC animated:YES
         ];
    } else if(indexPath.row == 2) {
        QMCacheViewController *cacheVC = [[QMCacheViewController alloc]init];
        [self.navigationController pushViewController:cacheVC animated:YES
         ];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}

- (void)uploadFile:(NSNotification *)no {
    QMLog(@"%@",no.userInfo);
    
    NSMutableArray *fileArr = [no.userInfo objectForKey:@"fileDic"];
    
    NSString *scriptTitle = [no.userInfo objectForKey:@"title"];
    NSString *scriptContent = [no.userInfo objectForKey:@"content"];
    
    RevelationManager *manager = [[RevelationManager alloc]init];
//    __block  QMSettingViewController *vc = self;
//    manager.delegate  = vc;
    [manager SendRequset:fileArr :scriptTitle :scriptContent];

}


#pragma mark - 瞎搞
- (void)push {
    NSString *audioPath =@"/Users/admin/Desktop/exported.caf";
    
    LZAudioTransformTool *tool = [LZAudioTransformTool sharedLZAudioTransformTool];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [tool audio_PCMtoMP3WithResourcePath:audioPath];
    });
    
//    NSMutableArray *imageArr = [NSMutableArray array];
//    
//    [imageArr addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:audioPath,@"filename",@"1",@"filetype", nil]];
//    
//    RevelationManager *manager = [[RevelationManager alloc]init];
////    __block  QMSettingViewController *vc = self;
////    manager.delegate  = self;
//    [manager SendRequset:imageArr :@"test" :@"gg"];
    
}

//#pragma mark -RevelationManagerDelegate
//- (void)uploadFileResult:(int)result{
////    [[NSNotificationCenter defaultCenter] postNotificationName:@"wosai_success" object:nil userInfo:@{@"status":[NSString stringWithFormat:@"%d",result]}];
//}

@end
