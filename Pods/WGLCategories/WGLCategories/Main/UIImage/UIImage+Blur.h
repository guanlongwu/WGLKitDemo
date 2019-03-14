//
//  UIImage+Blur.h
//  WGLUtils
//
//  Created by wugl on 2019/3/5.
//  Copyright © 2019年 WGLKit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Blur)

/**
 *  毛玻璃效果
 *
 *  @param blurRadius            滤镜大小
 *  @param tintColor             色调
 *  @param saturationDeltaFactor 饱和三角因子,1为正常值
 *  @param maskImage             遮罩图
 *
 *  @return 图
 */
- (UIImage *)blurWithRadius:(CGFloat)blurRadius tintColor:(UIColor *)tintColor saturationDeltaFactor:(CGFloat)saturationDeltaFactor maskImage:(UIImage *)maskImage;

@end
