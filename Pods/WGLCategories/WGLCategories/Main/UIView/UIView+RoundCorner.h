//
//  UIView+RoundCorner.h
//  WGLCategories
//
//  Created by wugl on 2019/3/20.
//  Copyright © 2019年 WGLKit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (RoundCorner)

- (void)setRoundCornerRadius:(CGFloat)radius;

- (void)setRoundCornerRadius:(CGFloat)radius corners:(UIRectCorner)corners;

@end
