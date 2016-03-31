//
//  UIBarButtonItem+Extension.h
//  LZChat
//
//  Created by Mr.Right on 16/3/17.
//  Copyright © 2016年 lizheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Extension)
+ (UIBarButtonItem *)itemWithTarget:(id)target action:(SEL)action image:(NSString *)image highImage:(NSString *)highImage;
@end
