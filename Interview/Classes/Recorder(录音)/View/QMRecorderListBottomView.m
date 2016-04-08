//
//  QMRecorderListBottomView.m
//  Interview
//
//  Created by Mr.Right on 16/4/8.
//  Copyright © 2016年 yonganbo. All rights reserved.
//

#import "QMRecorderListBottomView.h"

@implementation QMRecorderListBottomView

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if ([super initWithCoder:aDecoder]) {
        self.backgroundColor = [UIColor blueColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    self.backgroundColor = [UIColor blueColor];
}

- (void)layoutSubviews {
    self.backgroundColor = [UIColor blueColor];
}



@end
