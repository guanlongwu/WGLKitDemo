//
//  WGLCircleProgressView.m
//  WGLCircleProgressView
//
//  Created by wugl on 2019/2/18.
//  Copyright © 2019年 WGLKit. All rights reserved.
//

#import "WGLCircleProgressView.h"

#define WGLCircleLineDefaultWidth  3.0f
#define WGLCircleDefaultColor      [UIColor colorWithRed:0/255.0 green:191/255.0 blue:255/255.0 alpha:1]

@interface WGLCircleProgressView ()
@property (nonatomic, weak) UILabel *cLabel;
@end

@implementation WGLCircleProgressView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)setProgress:(CGFloat)progress {
    _progress = progress;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    //路径
    UIBezierPath *path = [[UIBezierPath alloc] init];
    //线宽
    path.lineWidth = self.circleLineWidth;
    //颜色
    [self.circleLineColor set];
    //拐角
    path.lineCapStyle = kCGLineCapRound;
    path.lineJoinStyle = kCGLineJoinRound;
    //半径
    CGFloat radius = (MIN(rect.size.width, rect.size.height) - self.circleLineWidth * 2) * 0.5;
    //画弧（参数：中心、半径、起始角度(3点钟方向为0)、结束角度、是否顺时针）
    [path addArcWithCenter:(CGPoint){rect.size.width * 0.5, rect.size.height * 0.5} radius:radius startAngle:M_PI * 1.5 endAngle:M_PI * 1.5 + M_PI * 2 * _progress clockwise:YES];
    //连线
    [path stroke];
}

#pragma mark - 参数

- (CGFloat)circleLineWidth {
    if (_circleLineWidth < 0.05f) {
        _circleLineWidth = WGLCircleLineDefaultWidth;
    }
    return _circleLineWidth;
}

- (UIColor *)circleLineColor {
    if (!_circleLineColor) {
        _circleLineColor = WGLCircleDefaultColor;
    }
    return _circleLineColor;
}

@end
