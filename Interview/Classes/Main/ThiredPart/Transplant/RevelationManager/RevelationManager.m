//
//  RevelationManager.m
//  QingdaoBroadcast
//
//  Created by Alex Hepburn on 12-8-13.
//  Copyright (c) 2012年 iHope. All rights reserved.
//

#import "RevelationManager.h"
#import "ASIFormDataRequest.h"
#import "NSString+SBJSON.h"
//#import "Encryption.h"
//#import "GongYongData.h"
@interface RevelationManager ()
@property(nonatomic,assign) int StoryID;

@end

@implementation RevelationManager

@synthesize  OnLoadFinish, OnLoadFail;

+ (NSData*) base64Decode:(NSString *)string
{
    unsigned long ixtext, lentext;
    unsigned char ch, inbuf[4], outbuf[4];
    short i, ixinbuf;
    Boolean flignore, flendtext = false;
    const unsigned char *tempcstring;
    NSMutableData *theData;
    
    if (string == nil) {
        return [NSData data];
    }
    
    ixtext = 0;
    
    tempcstring = (const unsigned char *)[string UTF8String];
    
    lentext = [string length];
    
    theData = [NSMutableData dataWithCapacity: lentext];
    
    ixinbuf = 0;
    
    while (true) {
        if (ixtext >= lentext){
            break;
        }
        
        ch = tempcstring [ixtext++];
        
        flignore = false;
        
        if ((ch >= 'A') && (ch <= 'Z')) {
            ch = ch - 'A';
        } else if ((ch >= 'a') && (ch <= 'z')) {
            ch = ch - 'a' + 26;
        } else if ((ch >= '0') && (ch <= '9')) {
            ch = ch - '0' + 52;
        } else if (ch == '+') {
            ch = 62;
        } else if (ch == '=') {
            flendtext = true;
        } else if (ch == '/') {
            ch = 63;
        } else {
            flignore = true;
        }
        
        if (!flignore) {
            short ctcharsinbuf = 3;
            Boolean flbreak = false;
            
            if (flendtext) {
                if (ixinbuf == 0) {
                    break;
                }
                
                if ((ixinbuf == 1) || (ixinbuf == 2)) {
                    ctcharsinbuf = 1;
                } else {
                    ctcharsinbuf = 2;
                }
                
                ixinbuf = 3;
                
                flbreak = true;
            }
            
            inbuf [ixinbuf++] = ch;
            
            if (ixinbuf == 4) {
                ixinbuf = 0;
                
                outbuf[0] = (inbuf[0] << 2) | ((inbuf[1] & 0x30) >> 4);
                outbuf[1] = ((inbuf[1] & 0x0F) << 4) | ((inbuf[2] & 0x3C) >> 2);
                outbuf[2] = ((inbuf[2] & 0x03) << 6) | (inbuf[3] & 0x3F);
                
                for (i = 0; i < ctcharsinbuf; i++) {
                    [theData appendBytes: &outbuf[i] length: 1];
                }
            }
            
            if (flbreak) {
                break;
            }
        }
    }
    
    return theData;
}

+ (NSString*) base64Encode:(NSData *)data
{
    static char base64EncodingTable[64] = {
        'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P',
        'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', 'a', 'b', 'c', 'd', 'e', 'f',
        'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v',
        'w', 'x', 'y', 'z', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '+', '/'
    };
    int length = [data length];
    unsigned long ixtext, lentext;
    long ctremaining;
    unsigned char input[3], output[4];
    short i, charsonline = 0, ctcopy;
    const unsigned char *raw;
    NSMutableString *result;
    
    lentext = [data length];
    if (lentext < 1)
        return @"";
    result = [NSMutableString stringWithCapacity: lentext];
    raw = [data bytes];
    ixtext = 0;
    
    while (true) {
        ctremaining = lentext - ixtext;
        if (ctremaining <= 0)
            break;
        for (i = 0; i < 3; i++) {
            unsigned long ix = ixtext + i;
            if (ix < lentext)
                input[i] = raw[ix];
            else
                input[i] = 0;
        }
        output[0] = (input[0] & 0xFC) >> 2;
        output[1] = ((input[0] & 0x03) << 4) | ((input[1] & 0xF0) >> 4);
        output[2] = ((input[1] & 0x0F) << 2) | ((input[2] & 0xC0) >> 6);
        output[3] = input[2] & 0x3F;
        ctcopy = 4;
        switch (ctremaining) {
            case 1:
                ctcopy = 2;
                break;
            case 2:
                ctcopy = 3;
                break;
        }
        
        for (i = 0; i < ctcopy; i++)
            [result appendString: [NSString stringWithFormat: @"%c", base64EncodingTable[output[i]]]];
        
        for (i = ctcopy; i < 4; i++)
            [result appendString: @"="];
        
        ixtext += 3;
        charsonline += 4;
        
        if ((length > 0) && (charsonline >= length))
            charsonline = 0;
    }
    return result;
}

- (void)PrintData:(NSString *)text {
    NSData *data = [RevelationManager base64Decode:text];
    //    NSLog(@"datalen:%d", data.length);
    NSString *tmp = @"";
    for (int i = 0; i < data.length; i ++) {
        const unsigned char *pBuf = [data bytes];
        tmp = [tmp stringByAppendingFormat:@"%02x ", pBuf[i]];
    }
    //    NSLog(@"%@", tmp);
}

- (id)init {
    self = [super init];
    if (self) {
        miSendCount = 0;
        miBlockSize = 0;
        miBlockIndex = 0;
        _StoryID = 0;
        mFileArray = [[NSMutableArray alloc] initWithCapacity:10];
    }
    return self;
}

- (void)dealloc {
    if (urlTempSString) {
        [urlTempSString release];
    }
    if (autherSString) {
        [autherSString release];
    }
    if (tokenSString) {
        [tokenSString release];
    }
    if (fileIDString) {
        [fileIDString release];
    }
    if (mData) {
        [mData release];
    }
    [mFileArray release];
    [super dealloc];
}

//发送按钮的请求
-(void)SendRequset:(NSMutableArray *)fileArray :(NSString *)caption :(NSString *)title{
    [mFileArray removeAllObjects];
    if (fileArray) {
        [mFileArray addObjectsFromArray:fileArray];
    }
    mCaption = [[NSString alloc] initWithString:caption];
    mTitle = [[NSString alloc] initWithString:title];
    
    [MBProgressHUD showMessage:@"上传中请稍后"];
    
    [self sendBaoliaoLoginRequset];
    
}

- (NSString *)mAppUUID {
    NSUserDefaults *UserDef = [NSUserDefaults standardUserDefaults];
    NSString *deviceIdStr = [UserDef valueForKey:@"deviceId"];
    if (!deviceIdStr) {
        CFUUIDRef deviceId = CFUUIDCreate (NULL);
        CFStringRef deviceIdStrRef = CFUUIDCreateString(NULL,deviceId);
        CFRelease(deviceId);
        deviceIdStr = [NSString stringWithString:(NSString *)deviceIdStrRef];
        [UserDef setValue:deviceIdStr forKey:@"deviceId"];
        [UserDef synchronize];
    }
    NSMutableString *str = [NSMutableString stringWithString:deviceIdStr];
    [str replaceOccurrencesOfString:@"-" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, str.length)];
    return str;
}

//爆料发送的第一步：登陆请求
-(void)sendBaoliaoLoginRequset {
    NSString *service = [[NSUserDefaults standardUserDefaults]objectForKey:kPathToService];
    if (service.length<=0) {
        [MBProgressHUD showError:@"请重新登陆"];
        return;
    }
    
    NSString *urlString = [NSString stringWithFormat:@"http://%@/Account/Login",service];
    
    NSURL *url = [NSURL URLWithString:urlString];
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:url];
    request.tag = 9998;
    [request setDelegate:self];
    [request setRequestMethod:@"POST"];
    [request setPostValue:[[NSUserDefaults standardUserDefaults]objectForKey:kUserName]forKey:@"userName"];
    [request setPostValue:[[NSUserDefaults standardUserDefaults]objectForKey:kPassword] forKey:@"password"];
    NSString *udid = [self mAppUUID];
    [request setPostValue:udid forKey:@"deviceID"];
    [request startAsynchronous];
    [request release];
}

//爆料发送的第二步：新建上传文件请求
-(void)sendBaoliaoUploadFileRequset:(NSString *)backSString :(int)iFileSize :(NSString *)fmt {
    NSString *filename = [self GetFileName:fmt];
    NSString *urlString = @"http://114.112.100.68:8020/story/newUploadFile";
    NSURL *url = [NSURL URLWithString:urlString];
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:url];
    request.tag = 9997;
    [request setDelegate:self];
    [request setRequestMethod:@"POST"];
    [request setPostValue:backSString forKey:@"token"];
    [request setPostValue:filename forKey:@"fileName"];
    [request setPostValue:[NSString stringWithFormat:@"%d", iFileSize] forKey:@"fileSize"];
    [request setPostValue:fmt forKey:@"fileFormat"];
    [request startAsynchronous];
    [request release];
    //    NSLog(@"newUploadFile:%@, %@", filename, fmt);
}

//爆料发送的第三步：上传文件请求
-(void)sendBaoliaoFileuploadRequset:(NSString *)backSString {
    //    NSLog(@"sendBaoliaoFileuploadRequset");
    NSString *urlString = @"http://114.112.100.68:8020/story/uploadFile";
    NSURL *url = [NSURL URLWithString:urlString];
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:url];
    request.tag = 9996;
    [request setDelegate:self];
    [request setRequestMethod:@"POST"];
    [request setPostValue:tokenSString forKey:@"token"];
    [request setPostValue:fileIDString forKey:@"fileID"];
    [request startAsynchronous];
    [request release];
}


//爆料发送的第四步：上传文件数据请求
-(void)sendBaoliaoFileDataRequset:(NSData *)data {
    //    NSLog(@"sendBaoliaoFileDataRequset");
    NSString *urlString = @"http://114.112.100.68:8020/story/uploadData";
    NSURL *url = [NSURL URLWithString:urlString];
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:url];
    request.tag = 9995;
    [request setDelegate:self];
    [request setRequestMethod:@"POST"];
    [request setTimeOutSeconds:40];
    [request setPostValue:tokenSString forKey:@"token"];
    [request setPostValue:fileIDString forKey:@"fileID"];
    [request setPostValue:[NSString stringWithFormat:@"%d", miBlockIndex] forKey:@"blockIndex"];
    [request setPostValue:[NSString stringWithFormat:@"%d", data.length] forKey:@"blockSize"];
    NSString *datastr = [RevelationManager base64Encode:data];
    [request setPostValue:datastr forKey:@"blockdata"];
    //NSLog(@"datalen2:%d, %@", data.length, datastr);
    [request startAsynchronous];
    [request release];
}

//爆料发送的最后一步
-(void)sendBaoliaoLastRequset {
    //    NSLog(@"sendBaoliaoLastRequset");
    NSString *filetypes = @"";
    NSString *fileIDs = @"";
    for (int i = 0; i < mFileArray.count; i ++) {
        NSDictionary *dict = [mFileArray objectAtIndex:i];
        NSString *filetype = [dict objectForKey:@"filetype"];
        NSString *fileID = [dict objectForKey:@"fileID"];
        if (i == 0) {
            filetypes = [NSString stringWithFormat:@"%@", filetype];
            fileIDs = [NSString stringWithFormat:@"%@", fileID];
        }
        else {
            filetypes = [filetypes stringByAppendingFormat:@",%@", filetype];
            fileIDs = [fileIDs stringByAppendingFormat:@",%@", fileID];
        }
    }
    NSString *urlString = @"http://114.112.100.68:8020/story/UploadMedias";
    NSURL *url = [NSURL URLWithString:urlString];
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:url];
    request.tag = 9994;
    [request setDelegate:self];
    [request setRequestMethod:@"POST"];
    [request setPostValue:tokenSString forKey:@"token"];
    [request setPostValue:fileIDs forKey:@"fileIDs"];
    [request setPostValue:filetypes forKey:@"fileTypes"];
    [request setPostValue:mTitle forKey:@"title"];
    [request setPostValue:autherSString forKey:@"author"];
    [request setPostValue:mCaption forKey:@"caption"];
    
    NSMutableArray *tempArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"OnlineChannelArray"];
    NSString *tempTagString = [[NSUserDefaults standardUserDefaults] objectForKey:@"SelectCellIndex"];
    NSDictionary *tempDddIC = [tempArray objectAtIndex:[tempTagString intValue]];
    [request setPostValue:@"1"forKey:@"channelID"];
    [request startAsynchronous];
    [request release];
}

- (void)requestFinished:(ASIHTTPRequest *)_request {
    NSData *data = [_request responseData];
    NSString *responseContent = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]autorelease];
    //    NSLog(@"responseContent baoliao %d is %@", _request.tag, responseContent);
    if (_request.tag == 9999) {
        [self sendBaoliaoLoginRequset:responseContent];
    }
    else if(_request.tag == 9998) {// 登陆返回 token
        NSMutableDictionary *tempDic = [responseContent JSONValue];
        NSMutableDictionary *dict = [tempDic objectForKey:@"Data"];
        if (dict && ![dict isKindOfClass:[NSNull class]]) {
            NSString *tokenstr = [dict objectForKey:@"Token"];
            tokenSString = [[NSString alloc] initWithString:tokenstr];
            miIndex = 0;
            if (![self NewFileUpload]) {
                [self sendBaoliaoLastRequset];
            }
        }
        else {
            //            NSLog(@"%@", tempDic);
            NSString *msg = @"上传文件失败";
            NSDictionary *errordict = [tempDic objectForKey:@"Error"];
            if (errordict && ![errordict isKindOfClass:[NSNull class]]) {
                msg = [errordict objectForKey:@"Message"];
            }
            //            if (delegate && OnLoadFail) {
            //                [delegate performSelector:OnLoadFail withObject:msg];
            //            }
            [MBProgressHUD showError:msg];
            
        }
    }
    else if(_request.tag == 9997) {//爆料发送的第二步：新建上传文件请求;
        NSMutableDictionary *tempDic = [responseContent JSONValue];
        NSString *fileID = [[tempDic objectForKey:@"Data"] objectForKey:@"FileID"];
        if (fileIDString) {
            [fileIDString release];
            fileIDString = nil;
        }
        fileIDString = [[NSString alloc] initWithString:fileID];
        
        NSMutableDictionary *dict1 = [mFileArray objectAtIndex:miIndex];
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setObject:dict1[@"filename"] forKey:@"filename"];
        [dict setObject:dict1[@"filetype"] forKey:@"filetype"];
        [dict setObject:fileID forKey:@"fileID"];
        [mFileArray replaceObjectAtIndex:miIndex withObject:dict];
        [self sendBaoliaoFileuploadRequset:fileID];
    }
    else if(_request.tag == 9996) {
        NSMutableDictionary *tempDic = [responseContent JSONValue];
        NSString *blockSize = [[tempDic objectForKey:@"Data"] objectForKey:@"BlockSize"];
        miBlockSize = [blockSize intValue];
        miBlockCount = mData.length/miBlockSize;
        miBlockIndex = 0;
        if (mData.length%miBlockSize>0) {
            miBlockCount++;
        }
        [self SendFileData];
    }
    else if(_request.tag == 9995) {
        miBlockIndex ++;
        if (miBlockIndex < miBlockCount) {
            [self SendFileData];
        }
        else {
            miIndex ++;
            if (![self NewFileUpload]) {
                [self sendBaoliaoLastRequset];
            }
        }
    }
    else if(_request.tag == 9994) {
        QMLog(@"responseContent baoliao %ld is %@", (long)_request.tag, responseContent);
        [MBProgressHUD hideHUD];
        
        NSMutableDictionary *tempDic = [responseContent JSONValue];
        if (![tempDic[@"Error"] isKindOfClass:[NSNull class]]) {// 发生错误
            NSDictionary *error = tempDic[@"Error"];
            QMLog(@"%@",error[@"Message"]);
            [MBProgressHUD showError:error[@"Message"]];
            if (_delegate && [self.delegate performSelector:@selector(uploadFileResult)]) {
                [self.delegate uploadFileResult:1];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"wosai_success" object:nil userInfo:@{@"status":@"1"}];

            }
        } else if(![tempDic[@"Data"] isKindOfClass:[NSNull class]]){ // 有数据返回
            [MBProgressHUD showSuccess:@"上传成功"];
            
            if (_delegate && [self.delegate performSelector:@selector(uploadFileResult:)]) {
                [self.delegate uploadFileResult:0];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"wosai_success" object:nil userInfo:@{@"status":@"0"}];
            }
            
        } else {
            if (_delegate && [self.delegate performSelector:@selector(uploadFileResult:)]) {
                [self.delegate uploadFileResult:1];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"wosai_success" object:nil userInfo:@{@"status":@"1"}];
            }
            [MBProgressHUD showError:@"请重新登陆"];
        }
    }
}

- (NSString *)GetFileName:(NSString *)ext {
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYYMMddHHmmss"];//hh与HH的区别:分别表示12小时制,24小时制
    NSString *dateString = [formatter stringFromDate:[NSDate date]];
    [formatter release];
    return [NSString stringWithFormat:@"Upload%@.%@", dateString, ext];
}

- (BOOL)NewFileUpload {
    if (miIndex >= mFileArray.count) {
        return NO;
    }
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    if (mData) {
        [mData release];
        mData = nil;
    }
    
    NSDictionary *dict = [mFileArray objectAtIndex:miIndex];
    NSString *filename = [dict objectForKey:@"filename"];
    NSRange range = [filename rangeOfString:@"." options:NSBackwardsSearch];
    NSString *filefmt = [filename substringFromIndex:range.location+range.length];
    mData = [[NSData alloc] initWithContentsOfFile:filename];
    [self sendBaoliaoUploadFileRequset:tokenSString :mData.length :filefmt];
    [pool release];
    return YES;
}

- (void)SendFileData {
    int iStart = miBlockIndex*miBlockSize;
    int iLength = miBlockSize;
    if (iStart + iLength > mData.length) {
        iLength = mData.length-iStart;
    }
    NSData *sudata = [mData subdataWithRange:NSMakeRange(iStart, iLength)];
    [self sendBaoliaoFileDataRequset :sudata];
}

- (void)requestFailed:(ASIHTTPRequest *)_request {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    [MBProgressHUD hideHUD];
    
    if (_delegate && [self.delegate performSelector:@selector(uploadFileResult:)]) {
        [self.delegate uploadFileResult:1];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"wosai_success" object:nil userInfo:@{@"status":@"1"}];
    }
    
    [MBProgressHUD showError:@"上传超时"];
    
}

@end
