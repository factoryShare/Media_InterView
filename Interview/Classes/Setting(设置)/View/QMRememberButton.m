//
//  QMRememberButton.m
//  Interview
//
//  Created by Mr.Right on 16/4/13.
//  Copyright © 2016年 yonganbo. All rights reserved.
//

#import "QMRememberButton.h"

@implementation QMRememberButton


- (void)setSelected:(BOOL)selected {
    
    if (selected) {
        [self setImage:[UIImage imageNamed:@"UserInfo_Remember_click"] forState:(UIControlStateNormal)];
    } else {
        [self setImage:[UIImage imageNamed:@"UserInfo_Remember"] forState:(UIControlStateNormal)];
    }

}

@end
