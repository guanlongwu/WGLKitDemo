//
//  UIDevice+CPU.h
//  WGLUtils
//
//  Created by wugl on 2019/3/14.
//  Copyright © 2019年 WGLKit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIDevice (CPU)

/**
 可用的CPU处理器的数量
 */
@property (nonatomic, readonly) NSUInteger cpuCount;

/**
 当前CPU使用率，1.0表示100％
 (-1 when error occurs)
 */
@property (nonatomic, readonly) float cpuUsage;

/**
 每个处理器的当前CPU使用率（NSNumber数组），1.0表示100％。
 (nil when error occurs)
 */
@property (nullable, nonatomic, readonly) NSArray<NSNumber *> *cpuUsagePerProcessor;

@end
