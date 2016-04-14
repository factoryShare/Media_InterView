//
//  CustomPickView.h
//  Interview
//
//  Created by ChengFei on 16/4/11.
//  Copyright © 2016年 yonganbo. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CustomPickView;

@protocol  CustomPickViewDelegate <NSObject>
- (void)customPickViewCancle:(CustomPickView *)pickView;
- (void)customPickViewConfirm:(NSString *)selectedString pickView:(CustomPickView *)pickView;

@end

@interface CustomPickView : UIView
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, weak) id<CustomPickViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame WithData:(NSArray *)dataArray;


@end
