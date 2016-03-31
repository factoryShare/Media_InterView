//
//  QMTabBarController.m
//  QuanMeiTiCaiFang
//
//  Created by Mr.Right on 16/3/30.
//  Copyright © 2016年 Reborn. All rights reserved.
//

#import "QMTabBarController.h"
#import "QMNavigationController.h"

#import "QMRecorderViewController.h"
#import "QMManuscriptViewController.h"
#import "QMPlanViewController.h"
#import "QMPlanViewController.h"

@interface QMTabBarController ()

@end

@implementation QMTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // 添加子控制器
    [self setupChildVc: [[QMRecorderViewController alloc]init] title:@"录音" image:@"录音-未选中+透明底" selectedImage:@"录音-选中+透明底"];
    
    [self setupChildVc:[[QMManuscriptViewController alloc] init] title:@"稿件" image:@"稿件-未选中+透明底" selectedImage:@"稿件-选中+透明底"];
    
    [self setupChildVc:[[QMPlanViewController alloc] init] title:@"设置" image:@"设置-未选中+透明底" selectedImage:@"设置-选中+透明底"];
    
    [self setupChildVc:[[QMPlanViewController alloc] init] title:@"设置" image:@"设置-未选中+透明底" selectedImage:@"设置-选中+透明底"];
}

/**
 * 初始化子控制器
 */
- (void)setupChildVc:(UIViewController *)vc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage
{
    // 设置文字和图片
    vc.navigationItem.title = title;
    vc.tabBarItem.title = title;
    vc.tabBarItem.image = [UIImage imageNamed:image];
    vc.tabBarItem.selectedImage = [UIImage imageNamed:selectedImage];
    
    // 包装一个导航控制器, 添加导航控制器为tabbarcontroller的子控制器
    QMNavigationController *nav = [[QMNavigationController alloc] initWithRootViewController:vc];
    [self addChildViewController:nav];
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
