//
//  CustomPickView.m
//  Interview
//
//  Created by ChengFei on 16/4/11.
//  Copyright © 2016年 yonganbo. All rights reserved.
//

#import "CustomPickView.h"
#define screenWidth [UIScreen mainScreen].bounds.size.width
#define screenHeight [UIScreen mainScreen].bounds.size.height



@interface CustomPickView()<UIPickerViewDelegate, UIPickerViewDataSource>
@property (nonatomic, strong) UIView *translucentView;
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIButton *cancleBtn;
@property (nonatomic, strong) UIButton *confirmBtn;
@property (nonatomic, strong) NSString *selectedString;
@property (nonatomic, strong) UIPickerView *pickerView;
@end

@implementation CustomPickView

- (instancetype)initWithFrame:(CGRect)frame WithData:(NSArray *)dataArray{
    self = [super initWithFrame:frame];
    if (self) {
        
        _dataArray = dataArray;
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
        
        
        _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 44, screenWidth, 216)];
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
        _pickerView.tintColor = [UIColor blackColor];
        [_backView addSubview:_pickerView];
        
        //初始化选中的
        _selectedString = _dataArray[0];
    }
    return self;
}

- (void)cancleBtnClicked {
    if ([self.delegate respondsToSelector:@selector(customPickViewCancle:)]) {
        [self.delegate customPickViewCancle:self];
    }
}

- (void)setConfirmBtnClicked {
    if ([self.delegate respondsToSelector:@selector(customPickViewConfirm:pickView:)]) {
        [self.delegate customPickViewConfirm:_selectedString pickView:self];
    }
}

#pragma mark PickViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return _dataArray.count;
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSString *str = _dataArray[row];
    return str;
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    _selectedString = _dataArray[row];
//    NSLog(@"selected string : %@",_selectedString);
}
// 每列宽度
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 40.0;
}


@end
