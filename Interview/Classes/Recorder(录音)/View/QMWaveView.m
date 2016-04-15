//
//  QMWaveView.m
//  Interview
//
//  Created by Mr.Right on 16/4/15.
//  Copyright © 2016年 yonganbo. All rights reserved.
//

#import "QMWaveView.h"

@interface QMWaveView ()
@property(nonatomic,strong) NSMutableArray *movedPoint;
@end

@implementation QMWaveView

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    UIBezierPath *bottomPath = [UIBezierPath bezierPath];
    UIBezierPath *topPath = [UIBezierPath bezierPath];

    [[UIColor whiteColor] set];
    // 添加录音纹波
    CGFloat viewH = self.height / 2;
    
    for (int i = 0; i < self.movedPoint.count; i++) {
        if (i == 0) {
            CGPoint moveTemp = CGPointFromString(self.movedPoint[i]);
            [bottomPath moveToPoint:CGPointMake(i*3, (moveTemp.y/26 * viewH) + viewH)];
            [topPath moveToPoint:CGPointMake(i*3, (moveTemp.y/26 * viewH) + viewH)];

        } else {
            CGPoint moveTemp = CGPointFromString(self.movedPoint[i]);
            [bottomPath addLineToPoint:CGPointMake(i*3, (moveTemp.y/26 * viewH) + viewH)];
            [topPath addLineToPoint:CGPointMake(i*3, -(moveTemp.y/26 * viewH) + viewH)];
            if (i*3 > self.width) {
                [self.movedPoint removeObjectsInRange:(NSRange){0,3}];
            }

        }
    }
 
    // 绘图
    bottomPath.lineWidth = 3;
    bottomPath.lineJoinStyle = kCGLineJoinBevel;
    [bottomPath stroke];

    topPath.lineWidth = 3;
    topPath.lineJoinStyle = kCGLineJoinBevel;
    [topPath stroke];

    
}

#pragma -setter and getter
- (void)setPowerPotint:(CGPoint)powerPotint {
    [self.movedPoint addObject:NSStringFromCGPoint(powerPotint)];
    [self setNeedsDisplay];
}

- (void)setIsWaveShow:(BOOL)isWaveShow {
    if(!isWaveShow) {
        [self.movedPoint removeAllObjects];
        [self setNeedsDisplay];
    }
}

#pragma mark - 初始化
- (NSMutableArray *)movedPoint {
    if (!_movedPoint ) {
        _movedPoint = [NSMutableArray array];
        [_movedPoint addObject:NSStringFromCGPoint(CGPointZero)];
    }
    return _movedPoint;
}

@end
