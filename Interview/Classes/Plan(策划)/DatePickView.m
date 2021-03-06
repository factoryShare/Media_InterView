//
//  DatePickView.m
//  Interview
//
//  Created by fei on 16/4/11.
//  Copyright © 2016年 yonganbo. All rights reserved.
//

#import "DatePickView.h"

#define screenWidth [UIScreen mainScreen].bounds.size.width
#define screenHeight [UIScreen mainScreen].bounds.size.height

@interface DatePickView()
@property (nonatomic, strong) UIView *translucentView;
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIDatePicker *datePicker;
@property (nonatomic, strong) UIButton *cancleBtn;
@property (nonatomic, strong) UIButton *confirmBtn;
@property (nonatomic, strong) NSString *dateString;
@end

@implementation DatePickView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        //添加遮罩
        _translucentView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _translucentView.userInteractionEnabled = YES;
        _translucentView.backgroundColor = [UIColor blackColor];
        _translucentView.alpha = 0.4;
        [self addSubview:_translucentView];
        
        // 白色底层
        _backView = [[UIView alloc] initWithFrame:CGRectMake(0, screenHeight-216-44, screenWidth, 216+44)];
        _backView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_backView];
        
       // 时间选择
        _datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, 44, screenWidth, 216)];
        //    设置本地化
        _datePicker.locale = [NSLocale localeWithLocaleIdentifier:@"zh"];
        //    设置显示模式
        _datePicker.datePickerMode = UIDatePickerModeDate;
        [_backView addSubview:_datePicker];
        //    设置时区
        _datePicker.timeZone = [NSTimeZone localTimeZone];
        //    最小最大时间
        //    日期转换类
        NSDateFormatter *df = [[NSDateFormatter alloc]init];
        //    设置日期转换格式
        df.dateFormat = @"yyyy-MM-dd";
        //    dateFromString从字符串转日期
         // 设置选择器的初始值
        _dateString = [df stringFromDate:_datePicker.date];
        _datePicker.minimumDate = [NSDate date];
        [_datePicker addTarget:self action:@selector(datePickerViewChange:) forControlEvents:UIControlEventValueChanged];
        
        
        // 取消 按钮
        _cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancleBtn.frame = CGRectMake(0, 0, 60, 44);
        [_cancleBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [_cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancleBtn addTarget:self action:@selector(cancleBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [_backView addSubview:_cancleBtn];
        
        //确定按钮
        _confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_confirmBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [_confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
        _confirmBtn.frame = CGRectMake(screenWidth-60, 0, 60, 44);
        [_confirmBtn addTarget:self action:@selector(setConfirmBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [_backView addSubview:_confirmBtn];
    }
    return self;
}

#pragma mark datePicker值改变后执行的方法
-(void)datePickerViewChange:(UIDatePicker *)datePicker {
    NSLog(@"datePicker值改变");
    NSDateFormatter * df=[[NSDateFormatter alloc]init];
    //    日期转化为字符串
    //    设置转换格式
    df.dateFormat=@"yyyy-MM-dd";
    _dateString=[df stringFromDate:datePicker.date];
    NSLog(@"%@",_dateString);
}

- (void)cancleBtnClicked {
    if ([self.delegate respondsToSelector:@selector(datePickViewDelegateCancle)]) {
        [self.delegate datePickViewDelegateCancle];
    }
}

- (void)setConfirmBtnClicked {
    if ([self.delegate respondsToSelector:@selector(datePickViewDelegateConfirm:)]) {
        [self.delegate datePickViewDelegateConfirm:_dateString];
    }
}

@end
