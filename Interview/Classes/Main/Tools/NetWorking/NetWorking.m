//
//  NetWorking.m
//  QuanMeiTiCaiFang
//
//  Created by mac on 15-8-30.
//  Copyright (c) 2015年 Reborn. All rights reserved.
//

#import "NetWorking.h"


@interface NetWorking ()

@property(nonatomic,strong)NSMutableData *responseData;

@end

@implementation NetWorking

@synthesize responseData;

static NetWorking *_netWorking =nil;

+(NetWorking *)shareNetWork
{
    if (_netWorking==nil) {
        _netWorking=[[NetWorking alloc] init];
    }
    return _netWorking;
    
}




- (void)postURL:(NSURL *)url loginName:(NSString *)name loginPassWord:(NSString *)password
{
    NSMutableString  *body=[NSMutableString string];
    
    [body appendString:@"&"];
    [body appendString:@"username"];
    [body appendString:@"="];
    
    CFStringRef sRef = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                               (__bridge CFStringRef)name,
                                                               NULL,
                                                               (CFStringRef)@"!*'\"();:@&=+$,/?%#[]% ",
                                                               kCFStringEncodingUTF8);
    [body appendString:(__bridge NSString *)sRef];
    CFRelease(sRef);
    
    [body appendString:@"&"];
    [body appendString:@"password"];
    [body appendString:@"="];
    
    CFStringRef sRef2 = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                (__bridge CFStringRef)password,
                                                                NULL,
                                                                (CFStringRef)@"!*'\"();:@&=+$,/?%#[]% ",
                                                                kCFStringEncodingUTF8);
    [body appendString:(__bridge NSString *)sRef2];
    CFRelease(sRef2);
    
    
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url
                                                         cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:self.timeOut];
    [request setValue:@"application/x-www-form-urlencoded;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    
    NSData *data=[body dataUsingEncoding:NSUTF8StringEncoding];
    [request setValue:[NSString stringWithFormat:@"%d",[data length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:data];
    [request setHTTPMethod:@"POST"];
    NSURLConnection *conn=[[NSURLConnection alloc] initWithRequest:request delegate:self];
    if (conn) {
        self.responseData=[[NSMutableData alloc] init];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.responseData appendData:data];
    NSError *error;
    NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:self.responseData options:NSJSONReadingMutableContainers error:&error];
    QMLog(@"%@ ",[[dict objectForKey:@"Data"] objectForKey:@"UserName"]);
    QMLog(@"%@ ",[[dict objectForKey:@"Data"] objectForKey:@"Token"]);
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *userName = [[dict objectForKey:@"Data"] objectForKey:@"UserName"];
    NSString *token = [[dict objectForKey:@"Data"] objectForKey:@"Token"];
    [user setObject:userName forKey:@"UserName"];
    [user setObject:token forKey:@"Token"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"token" object:[[dict objectForKey:@"Data"] objectForKey:@"Token"]];
    
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    
    
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:@"token"];
}

@end