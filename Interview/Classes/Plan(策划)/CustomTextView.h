//
//  CustomTextView.h
//  Interview
//
//  Created by fei on 16/4/13.
//  Copyright © 2016年 yonganbo. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CustomTextView;

@protocol  CustomTextViewDelegate <NSObject>
- (void)customTextViewDelegateCancle;
- (void)customTextViewDelegateConfirm:(NSString *)text;
@end

@interface CustomTextView : UIView
- (instancetype)initWithFrame:(CGRect)frame andText:(NSString *)text;
@property (nonatomic, weak) id<CustomTextViewDelegate> delegate;
@end
