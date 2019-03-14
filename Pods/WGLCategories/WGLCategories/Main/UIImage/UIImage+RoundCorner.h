//
//  UIImage+RoundCorner.h
//  WGLKitDemo
//
//  Created by wugl on 2019/3/13.
//  Copyright © 2019年 huya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (RoundCorner)

- (nullable UIImage *)imageByRoundCornerRadius:(CGFloat)radius;

- (nullable UIImage *)imageByRoundCornerRadius:(CGFloat)radius
                                   borderWidth:(CGFloat)borderWidth
                                   borderColor:(nullable UIColor *)borderColor;

- (nullable UIImage *)imageByRoundCornerRadius:(CGFloat)radius
                                       corners:(UIRectCorner)corners
                                   borderWidth:(CGFloat)borderWidth
                                   borderColor:(nullable UIColor *)borderColor
                                borderLineJoin:(CGLineJoin)borderLineJoin;

@end
