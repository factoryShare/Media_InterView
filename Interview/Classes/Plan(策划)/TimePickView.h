//
//  TimePickView.h
//  Interview
//
//  Created by ChengFei on 16/4/11.
//  Copyright © 2016年 yonganbo. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TimePickView;

@protocol TimePickViewDelegate <NSObject>
- (void)timePickViewDelegateCancle;
- (void)timePickViewDelegateConfirm:(NSString *)timeString;
@end


@interface TimePickView : UIView
@property (nonatomic, weak) id<TimePickViewDelegate>delegate;
@end
