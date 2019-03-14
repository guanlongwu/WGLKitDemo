//
//  NSTimer+Block.h
//  WGLUtils
//
//  Created by wugl on 2019/3/4.
//  Copyright © 2019年 WGLKit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (Block)

/**
 创建并返回一个基于块的NSTimer对象，并将其安排在当前运行循环中。
 @param inTimeInterval 计时器触发之间的秒数。
 @param inBlock NSTimer触发的块。
 @param inRepeats YES-计时器将重复重新调度自己，直到失效；NO-计时器将在触发后失效。
 @return 一个新的NSTimer对象，该对象是根据指定的参数配置的.
 */
+ (NSTimer *)bk_scheduledTimerWithTimeInterval:(NSTimeInterval)inTimeInterval block:(void (^)(NSTimer *timer))inBlock repeats:(BOOL)inRepeats;

/**
 创建并返回一个基于块的NSTimer对象，必须使用“-addTimer:forMode:”将新计时器添加到运行循环中。
 @param inTimeInterval 计时器触发之间的秒数。
 @param inBlock NSTimer触发的块。
 @param inRepeats YES-计时器将重复重新调度自己，直到失效；NO-计时器将在触发后失效。
 @return 一个新的NSTimer对象，该对象是根据指定的参数配置的.
 */
+ (NSTimer *)bk_timerWithTimeInterval:(NSTimeInterval)inTimeInterval block:(void (^)(NSTimer *timer))inBlock repeats:(BOOL)inRepeats;

@end
