//
//  RevelationManager.h
//  QingdaoBroadcast
//
//  Created by Alex Hepburn on 12-8-13.
//  Copyright (c) 2012年 iHope. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, RevelationManagerResult) {

    RevelationManagerResultSuccess = 0,
    RevelationManagerResultError = 1,
    RevelationManagerResultCancle = 2
};

@protocol RevelationManagerDelegate <NSObject>
- (void)uploadFileResult:(RevelationManagerResult)result;

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
