//
//  AppDelegate.m
//  Interview
//
//  Created by Mr.Right on 16/3/30.
//  Copyright © 2016年 lizheng. All rights reserved.
//

#import "AppDelegate.h"
#import "AFNetworkReachabilityManager.h"
#import "QMTabBarController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    UIWindow *window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    window.backgroundColor = [UIColor grayColor];
    self.window = window;
    [self.window makeKeyAndVisible];
    
    QMTabBarController *tabC = [[QMTabBarController alloc]init];
    self.window.rootViewController = tabC;
    
    [self startMonitoringNetWorking];
    
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
//    [[NSNotificationCenter defaultCenter]postNotificationName:@"enterBackground" object:nil];

}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - 私人方法
/**
 *  全局监测网络状态
 */
- (void)startMonitoringNetWorking {
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusReachableViaWiFi:
                break;
                
            case AFNetworkReachabilityStatusReachableViaWWAN:
                break;
                
            case AFNetworkReachabilityStatusNotReachable:
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [MBProgressHUD showError:@"请检测网络状态"];
                });
                
                break;
                
            case AFNetworkReachabilityStatusUnknown:
                
                break;
            default:
                break;
        }
        
    }];
    
    [manager startMonitoring];
}

@end
