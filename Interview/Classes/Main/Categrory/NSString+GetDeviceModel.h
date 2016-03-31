//
//  NSString+GetDeviceModel.h
//  prepay365
//
//  Created by ccq on 15/12/16.
//  Copyright © 2015年 ccq. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (GetDeviceModel)
+ (NSString *)getDeviceModel;

-(BOOL) isValidateMobile;

-(BOOL) isValidateEmail;
@end
