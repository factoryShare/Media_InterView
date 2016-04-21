//
//  RevelationManager.h
//  QingdaoBroadcast
//
//  Created by Alex Hepburn on 12-8-13.
//  Copyright (c) 2012年 iHope. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RevelationManagerDelegate <NSObject>

- (void)uploadFileResult:(int)result;

//- (void)uploadFileResult2:(NSString *)result;

@end

@interface RevelationManager : NSObject {
    int miSendCount;
    NSString *urlTempSString;
    NSString *autherSString;
    NSString *tokenSString;
    NSString *fileIDString;
    NSData *mData;
    NSString *mCaption;
    NSString *mTitle;
    int miBlockSize;
    int miBlockIndex;
    int miBlockCount;
    int miIndex;
    NSMutableArray *mFileArray;
}

@property (nonatomic, assign) SEL OnLoadFinish;
@property (nonatomic, assign) SEL OnLoadFail;

@property(nonatomic,assign) id<RevelationManagerDelegate>delegate;

-(void)SendRequset:(NSMutableArray *)fileArray :(NSString *)caption :(NSString*)title;

@end
