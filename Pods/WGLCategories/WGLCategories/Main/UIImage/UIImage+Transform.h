//
//  UIImage+Transform.h
//  WGLKitDemo
//
//  Created by wugl on 2019/3/13.
//  Copyright © 2019年 huya. All rights reserved.
//

#import <UIKit/UIKit.h>

/// Convert degrees to radians.
static inline CGFloat DegreesToRadians(CGFloat degrees) {
    return degrees * M_PI / 180;
}

/// Convert radians to degrees.
static inline CGFloat RadiansToDegrees(CGFloat radians) {
    return radians * 180 / M_PI;
}

@interface UIImage (Transform)

/**
 获取旋转了指定弧度后的图像

 @param radians 指定旋转的弧度
 @param fitSize YES：新图像的大小会重新调整以适应原图像的所有内容；NO：新图像的大小不会改变，原图像的内容会被裁剪
 @return 旋转后的图像
 */
- (nullable UIImage *)imageByRotate:(CGFloat)radians fitSize:(BOOL)fitSize;

/**
 左转90度
 */
- (nullable UIImage *)imageByRotateLeft90;

/**
 右转90度
 */
- (nullable UIImage *)imageByRotateRight90;

/**
 旋转180度
 */
- (nullable UIImage *)imageByRotate180;

/**
 垂直翻转
 */
- (nullable UIImage *)imageByFlipVertical;

/**
 水平翻转
 */
- (nullable UIImage *)imageByFlipHorizontal;

@end
