//
//  UIImage+Scale.m
//  QuanMeiTiCaiFang
//
//  Created by Mr.Right on 16/3/31.
//  Copyright © 2016年 lizheng. All rights reserved.
//

#import "UIImage+Scale.h"

@implementation UIImage (Scale)

-(UIImage*)scaleToSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);

    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];

    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();

    return scaledImage;
}

@end
