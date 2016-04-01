//
//  QMRecorderViewController.m
//  Interview
//
//  Created by Mr.Right on 16/3/30.
//  Copyright © 2016年 yonganbo. All rights reserved.
//

#import "QMRecorderViewController.h"

@interface QMRecorderViewController ()

@end

@implementation QMRecorderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(showList) normalImage:@"nav_list"];
}
/**
 *  显示已经录制的音频
 */
- (void)showList {
    UIViewController *vc = [[UIViewController alloc]init];
    
    [self.navigationController pushViewController:vc animated:YES];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
