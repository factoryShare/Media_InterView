//
//  CommonUI.m
//  Interview
//
//  Created by ChengFei on 16/4/12.
//  Copyright © 2016年 yonganbo. All rights reserved.
//

#import "CommonUI.h"

@implementation CommonUI
#pragma mark -提示视图
+ (void)showTextOnly:(NSString *)text{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    hud.userInteractionEnabled = NO;
    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeText;
    hud.labelText = text;
    hud.margin = 10.f;
    hud.removeFromSuperViewOnHide = YES;
    hud.userInteractionEnabled = NO;
    [hud hide:YES afterDelay:2];
}

@end
