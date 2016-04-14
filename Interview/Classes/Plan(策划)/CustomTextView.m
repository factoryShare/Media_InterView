//
//  CustomTextView.m
//  Interview
//
//  Created by fei on 16/4/13.
//  Copyright © 2016年 yonganbo. All rights reserved.
//

#import "CustomTextView.h"
#define screenWidth [UIScreen mainScreen].bounds.size.width
#define screenHeight [UIScreen mainScreen].bounds.size.height

@interface CustomTextView()
@property (nonatomic, strong) UIView *translucentView;
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIButton *cancleBtn;
@property (nonatomic, strong) UIButton *confirmBtn;
@property (nonatomic, strong) UITextView *textView;
@end

@implementation CustomTextView

- (instancetype)initWithFrame:(CGRect)frame andText:(NSString *)text{
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
        
        _textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 44, screenWidth, 216)];
        _textView.text = text;
        [_backView addSubview:_textView];
    }
    return self;
}


- (void)cancleBtnClicked {
    if ([self.delegate respondsToSelector:@selector(customTextViewDelegateCancle)]) {
        [self.delegate customTextViewDelegateCancle];
    }
}

- (void)setConfirmBtnClicked {
    if ([self.delegate respondsToSelector:@selector(customTextViewDelegateConfirm:)]) {
        [self.delegate customTextViewDelegateConfirm:self.textView.text];
    }
}


@end
