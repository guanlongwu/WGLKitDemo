//
//  UIScreen+Extensions.h
//  WGLUtils
//
//  Created by wugl on 2019/3/14.
//  Copyright © 2019年 WGLKit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScreen (Extensions)

/**
 主屏幕的比例
 */
+ (CGFloat)screenScale;

/**
 返回当前设备方向的屏幕bounds
 注意：`UIScreen`的`bounds`方法总是返回它的纵向屏幕的边界.
 */
- (CGRect)currentBounds NS_EXTENSION_UNAVAILABLE_IOS("");

/**
 返回给定设备方向的屏幕边界。
 注意：`UIScreen`的`bounds`方法总是返回它的纵向屏幕的边界.
 */
- (CGRect)boundsForOrientation:(UIInterfaceOrientation)orientation;

/**
 屏幕的实际大小（以像素为单位）（宽度始终小于高度）。
 在未知设备或模拟器中，该值可能不是非常准确.
 e.g. (768,1024)
 */
@property (nonatomic, readonly) CGSize sizeInPixel;

/**
 屏幕的PPI。
 在未知设备或模拟器中，该值可能不是非常准确.
 Default value is 96.
 */
@property (nonatomic, readonly) CGFloat pixelsPerInch;

@end
