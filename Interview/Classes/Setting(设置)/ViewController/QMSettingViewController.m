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

#import "QMPostFileTool.h"
#import "QMPostSingle.h"
#import "AFNetworking.h"

#import "RevelationManager.h"

@interface QMSettingViewController () <UITableViewDelegate,UITableViewDataSource,RevelationManagerDelegate>

@end

@implementation QMSettingViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"push" style:(UIBarButtonItemStyleDone) target:self action:@selector(push)];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(uploadFile:) name:@"postFileByArray" object:nil];

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static  NSString  *cellIDE = nil;
    if (indexPath.row == 0) {
        cellIDE = @"settingcell1";
    } else {
        cellIDE = @"settingcell2";
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
    } else {
        UIViewController *bannerVC = [[UIViewController alloc]init];
        UIImageView *im = [[UIImageView alloc]initWithFrame:bannerVC.view.bounds];
        im.image = [UIImage imageNamed:@"Banner_bg"];
        [bannerVC.view addSubview:im];
        
        [self.navigationController pushViewController:bannerVC animated:YES
         ];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}

- (void)uploadFile:(NSNotification *)no {
    QMLog(@"%@",no.userInfo);
    
    NSMutableArray *fileArr = [no.userInfo objectForKey:@"fileDic"];
    
    NSString *scriptTitle = [no.userInfo objectForKey:@"title"];
    NSString *scriptContent = [no.userInfo objectForKey:@"content"];
//    NSString *audioPath = @"/Users/admin/Desktop/外包项目/Interview/Interview/20164220024258.amr";
//    NSMutableArray *imageArr = [NSMutableArray array];
//    
//    [imageArr addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:audioPath,@"filename",@"1",@"filetype", nil]];

    

    RevelationManager *manager = [[RevelationManager alloc]init];
    __block  QMSettingViewController *vc = self;
    manager.delegate  = vc;
    [manager SendRequset:fileArr :scriptTitle :scriptContent];

}

#pragma mark - 瞎搞
- (void)push {
    NSString *audioPath = @"/Users/admin/Desktop/外包项目/Interview/Interview/20164220024258.amr";
    NSMutableArray *imageArr = [NSMutableArray array];
    
    [imageArr addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:audioPath,@"filename",@"1",@"filetype", nil]];
    
    RevelationManager *manager = [[RevelationManager alloc]init];
    __block  QMSettingViewController *vc = self;
    manager.delegate  = vc;
    [manager SendRequset:imageArr :@"test" :@"gg"];
    
}

#pragma mark -RevelationManagerDelegate
- (void)uploadFileResult:(RevelationManagerResult)result {
    QMLog(@"%ld",(long)result);
}

@end
