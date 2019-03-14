//
//  UIDevice+DeviceInfo.h
//  WGLUtils
//
//  Created by wugl on 2019/3/14.
//  Copyright © 2019年 WGLKit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIDevice (DeviceInfo)

/**
 设备系统版本号
 e.g. 8.1
 */
+ (double)systemVersion;

/**
 返回一个新的 UUID NSString
 e.g. "D1178E50-2A4D-4F1F-9BD3-F6AAB00E06B1"
 */
+ (NSString *)stringWithUUID;

/**
 判断设备是否iPad/iPad mini.
 */
@property (nonatomic, readonly) BOOL isPad;

/**
 判断设备是否模拟器simulator.
 */
@property (nonatomic, readonly) BOOL isSimulator;

/**
 判断设备是否越狱jailbroken.
 */
@property (nonatomic, readonly) BOOL isJailbroken;

/**
 获取设备机器型号
 e.g. "iPhone6,1" "iPad4,6"
 @see http://theiphonewiki.com/wiki/Models
 */
@property (nullable, nonatomic, readonly) NSString *machineModel;

/**
 获取设备机器型号名称
 e.g. "iPhone 5s" "iPad mini 2"
 @see http://theiphonewiki.com/wiki/Models
 */
@property (nullable, nonatomic, readonly) NSString *machineModelName;

@end

#ifndef kSystemVersion
#define kSystemVersion [UIDevice systemVersion]
#endif

#ifndef kiOS6Later
#define kiOS6Later (kSystemVersion >= 6)
#endif

#ifndef kiOS7Later
#define kiOS7Later (kSystemVersion >= 7)
#endif

#ifndef kiOS8Later
#define kiOS8Later (kSystemVersion >= 8)
#endif

#ifndef kiOS9Later
#define kiOS9Later (kSystemVersion >= 9)
#endif

#ifndef kiOS10Later
#define kiOS10Later (kSystemVersion >= 10)
#endif

#ifndef kiOS11Later
#define kiOS11Later (kSystemVersion >= 11)
#endif

#ifndef kiOS12Later
#define kiOS12Later (kSystemVersion >= 12)
#endif
