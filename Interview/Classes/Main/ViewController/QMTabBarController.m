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
#import "QMSettingViewController.h"

@interface QMTabBarController ()

@end

@implementation QMTabBarController
+ (void)initialize
{
    UITabBar *bar = [UITabBar appearance];
    [bar setBackgroundImage:[UIImage imageNamed:@"tabbar_bg"]];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // 添加子控制器
    UIStoryboard *recorderSB = [UIStoryboard storyboardWithName:@"QMRecorderViewController" bundle:nil];
    QMSettingViewController *recorderVC = [recorderSB instantiateViewControllerWithIdentifier:@"QMRecorderViewController"];
    [self setupChildVc: recorderVC title:@"录音" image:@"tabbar_recorder" selectedImage:@"tabbar_recorder_click"];
    
    [self setupChildVc:[[QMManuscriptViewController alloc] init] title:@"稿件" image:@"tabbar_Manuscript" selectedImage:@"tabbar_Manuscript_click"];
    
    [self setupChildVc:[[QMPlanViewController alloc] init] title:@"策划" image:@"tabbar_plan" selectedImage:@"tabbar_plan_click"];
    
    
    UIStoryboard *settingSB = [UIStoryboard storyboardWithName:@"QMSettingViewController" bundle:nil];
    QMSettingViewController *settingVC = [settingSB instantiateViewControllerWithIdentifier:@"QMSettingViewController"];
    [self setupChildVc:settingVC title:@"设置" image:@"tabbar_Setting" selectedImage:@"tabbar_Setting_click"];
}

/**
 * 初始化子控制器
 */
- (void)setupChildVc:(UIViewController *)vc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage
{
    // 设置文字和图片
    vc.navigationItem.title = @"全媒体采访系统";
    vc.tabBarItem.title = title;
    vc.tabBarItem.image = [[UIImage imageNamed:image] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    vc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    // 设置文字的样式
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = [UIColor whiteColor];;
    [vc.tabBarItem setTitleTextAttributes:textAttrs forState:UIControlStateNormal];

    NSMutableDictionary *selectTextAttrs = [NSMutableDictionary dictionary];
    selectTextAttrs[NSForegroundColorAttributeName] = [UIColor whiteColor];
    [vc.tabBarItem setTitleTextAttributes:selectTextAttrs forState:UIControlStateSelected];

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
