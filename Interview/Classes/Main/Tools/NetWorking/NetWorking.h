//
//  NetWorking.h
//  QuanMeiTiCaiFang
//
//  Created by mac on 15-8-30.
//  Copyright (c) 2015年 Reborn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NetWorking : NSObject<NSURLConnectionDelegate,NSURLConnectionDataDelegate>

@property(nonatomic,assign)CGFloat timeOut;//!<超时时间
+(NetWorking *)shareNetWork;

- (void)postURL:(NSURL *)url loginName:(NSString *)name loginPassWord:(NSString *)password;
@end
