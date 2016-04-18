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

@interface QMSettingViewController () <UITableViewDelegate,UITableViewDataSource>

@end

@implementation QMSettingViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"push" style:(UIBarButtonItemStyleDone) target:self action:@selector(push)];;
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

#pragma mark - 瞎搞
- (void)push {// 20165715055704.amr  /Users/admin/Desktop/Project/Interview/Interview/posttest.png
    QMPostFileTool *tool = [[QMPostFileTool alloc]init];
    
    NSString *tempDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    // amr 文件名
    NSString *audioTestPath = [tempDir stringByAppendingPathComponent:@"20165715055704.amr"];
    NSString *imageTestPath = @"/Users/admin/Desktop/Project/Interview/Interview/posttest.png";
    
    [tool newUpLoadFileWithFilePath:audioTestPath fileName:@"sadas"fileFormat:@"amr"];
}

@end
