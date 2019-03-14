//
//  UIImage+Resize.h
//  WGLUtils
//
//  Created by wugl on 2019/3/4.
//  Copyright © 2019年 WGLKit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Resize)

/**
 对原图进行指定区域的裁剪

 @param bounds 以原图左上角像素点为（0，0）坐标原点进行裁剪
 @return 裁剪后的图像
 @discussion 不考虑原图的方向，裁剪后的图片不会变形
 */
- (UIImage *)croppedImage:(CGRect)bounds;

/**
 将图片大小进行调整

 @param newSize 调整后的最终大小
 @param quality CGInterpolationQuality
 @return 调整后的图片
 @discussion 考虑原图的方向，图片调整后不会被裁剪，但是调整后图片有可能会变形
 */
- (UIImage *)resizedImage:(CGSize)newSize interpolationQuality:(CGInterpolationQuality)quality;

/**
 将图片大小进行调整

 @param size 调整后的最终大小
 @return 调整后的图片
 @discussion 不考虑原图的方向，图片不会被裁剪，但是有可能会变形
 */
- (UIImage *)imageByResizeToSize:(CGSize)size;

/**
 将图片大小进行调整
 
 @param size 调整后的最终大小
 @param contentMode 调整方式
 @return 调整后的图片
 @discussion 不考虑原图的方向
 */
- (UIImage *)imageByResizeToSize:(CGSize)size contentMode:(UIViewContentMode)contentMode;


- (UIImage *)imageByApplyingAlpha:(CGFloat) alpha;

@end
