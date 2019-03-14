//
//  UIColor+Convertor.h
//  WGLUtils
//
//  Created by wugl on 2019/3/13.
//  Copyright © 2019年 WGLKit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Convertor)

/**
 将16进制的颜色值，转化成UIColor对象

 @param rgbValue The rgb value such as 0x66ccff.
 @return UIColor对象
 */
+ (UIColor *)colorWithRGB:(uint32_t)rgbValue;

/**
 将16进制uint32_t型的颜色值，转化成UIColor对象

 @param rgbaValue  The rgb value such as 0x66ccffff.
 @return UIColor对象
 */
+ (UIColor *)colorWithRGBA:(uint32_t)rgbaValue;

/**
 将16进制uint32_t型的颜色值，转化成UIColor对象

 @param rgbValue  The rgb value such as 0x66CCFF.
 @param alpha     The opacity value of the color object,specified as a value from 0.0 to 1.0.
 @return UIColor对象
 */
+ (UIColor *)colorWithRGB:(uint32_t)rgbValue alpha:(CGFloat)alpha;

/**
 将16进制NSString类型的颜色值，转化成UIColor对象
 
 @param hexStr  The hex string value for the new color.
                Example: @"0xF0F", @"66ccff", @"#66CCFF88"
 @return UIColor对象
 @discussion: Valid format: #RGB #RGBA #RRGGBB #RRGGBBAA 0xRGB ...
 The `#` or "0x" sign is not required.
 The alpha will be set to 1.0 if there is no alpha component.
 It will return nil when an error occurs in parsing.
 */
+ (nullable UIColor *)colorWithHexString:(NSString *)hexStr;

/**
 将UIColor对象，转化成16进制uint32_t型的颜色值
 @return hex value of RGB,such as 0x66ccff.
 */
- (uint32_t)rgbValue;

/**
 将UIColor对象，转化成16进制uint32_t型的颜色值
 @return hex value of RGBA,such as 0x66ccffff.
 */
- (uint32_t)rgbaValue;

/**
 将UIColor对象，转化成16进制NSString型的颜色值 (lowercase).Such as @"0066cc".
 @return The color's value as a hex string.
 */
- (nullable NSString *)hexString;

/**
 将UIColor对象，转化成16进制NSString型的颜色值 (lowercase). Such as @"0066ccff".
 @return The color's value as a hex string.
 */
- (nullable NSString *)hexStringWithAlpha;

/**
 The color's red component value in RGB color space.
 The value of this property is a float in the range `0.0` to `1.0`.
 */
@property (nonatomic, readonly) CGFloat red;

/**
 The color's green component value in RGB color space.
 The value of this property is a float in the range `0.0` to `1.0`.
 */
@property (nonatomic, readonly) CGFloat green;

/**
 The color's blue component value in RGB color space.
 The value of this property is a float in the range `0.0` to `1.0`.
 */
@property (nonatomic, readonly) CGFloat blue;

/**
 The color's alpha component value.
 The value of this property is a float in the range `0.0` to `1.0`.
 */
@property (nonatomic, readonly) CGFloat alpha;

@end
