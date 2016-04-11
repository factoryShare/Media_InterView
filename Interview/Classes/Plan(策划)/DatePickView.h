//
//  DatePickView.h
//  Interview
//
//  Created by fei on 16/4/11.
//  Copyright © 2016年 yonganbo. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DatePickView;

@protocol DatePickViewDelegate <NSObject>
- (void)datePickViewDelegateCancle;
- (void)datePickViewDelegateConfirm:(NSString *)dateString;
@end


@interface DatePickView : UIView
@property (nonatomic, weak) id<DatePickViewDelegate>delegate;
@end
