//
//  Reachability+LZ.m
//  text
//
//  Created by Mr.Right on 16/2/25.
//  Copyright © 2016年 lizheng. All rights reserved.
//

#import "Reachability+LZ.h"

@implementation Reachability (LZ)
+ (void)addObserver:(id)target selector:(SEL)aSelector object:(id)object{
    Reachability *reach = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    [[NSNotificationCenter defaultCenter] addObserver:target selector: aSelector name: @"kNetWorkchanged" object:object];
    [reach startNotifier];
}

@end
