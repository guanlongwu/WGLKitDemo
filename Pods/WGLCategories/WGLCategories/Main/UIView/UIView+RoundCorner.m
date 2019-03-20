//
//  UIView+RoundCorner.m
//  WGLCategories
//
//  Created by wugl on 2019/3/20.
//  Copyright © 2019年 WGLKit. All rights reserved.
//

#import "UIView+RoundCorner.h"

@implementation UIView (RoundCorner)

- (void)setRoundCornerRadius:(CGFloat)radius {
    return [self setRoundCornerRadius:radius corners:UIRectCornerAllCorners];
}

- (void)setRoundCornerRadius:(CGFloat)radius corners:(UIRectCorner)corners {
    CGRect rect = self.bounds;
    CGFloat minx = CGRectGetMinX(rect);
    CGFloat midx = CGRectGetMidX(rect);
    CGFloat maxx = CGRectGetMaxX(rect);
    CGFloat miny = CGRectGetMinY(rect);
    CGFloat midy = CGRectGetMidY(rect);
    CGFloat maxy = CGRectGetMaxY(rect);
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, nil, minx, midy);
    CGPathAddArcToPoint(path, nil, minx, miny, midx, miny, (corners & UIRectCornerTopLeft) ? radius : 0);
    CGPathAddArcToPoint(path, nil, maxx, miny, maxx, midy, (corners & UIRectCornerTopRight) ? radius : 0);
    CGPathAddArcToPoint(path, nil, maxx, maxy, midx, maxy, (corners & UIRectCornerBottomRight) ? radius : 0);
    CGPathAddArcToPoint(path, nil, minx, maxy, minx, midy, (corners & UIRectCornerBottomLeft) ? radius : 0);
    CGPathCloseSubpath(path);
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    [maskLayer setPath:path];
    [self.layer setMask:nil];
    [self.layer setMask:maskLayer];
    CFRelease(path);
}


@end
