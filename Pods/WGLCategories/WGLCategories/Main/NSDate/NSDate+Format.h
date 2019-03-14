//
//  NSDate+Format.h
//  WGLUtils
//
//  Created by wugl on 2019/3/4.
//  Copyright © 2019年 WGLKit. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDate (Format)

@property (nonatomic, readonly) NSInteger year; ///< Year component
@property (nonatomic, readonly) NSInteger month; ///< Month component (1~12)
@property (nonatomic, readonly) NSInteger day; ///< Day component (1~31)
@property (nonatomic, readonly) NSInteger hour; ///< Hour component (0~23)
@property (nonatomic, readonly) NSInteger minute; ///< Minute component (0~59)
@property (nonatomic, readonly) NSInteger second; ///< Second component (0~59)
@property (nonatomic, readonly) NSInteger nanosecond; ///< Nanosecond component
@property (nonatomic, readonly) NSInteger weekday; ///< Weekday component (1~7, first day is based on user setting)
@property (nonatomic, readonly) NSInteger weekdayOrdinal; ///< WeekdayOrdinal component
@property (nonatomic, readonly) NSInteger weekOfMonth; ///< WeekOfMonth component (1~5)
@property (nonatomic, readonly) NSInteger weekOfYear; ///< WeekOfYear component (1~53)
@property (nonatomic, readonly) NSInteger yearForWeekOfYear; ///< YearForWeekOfYear component
@property (nonatomic, readonly) NSInteger quarter; ///< Quarter component
@property (nonatomic, readonly) BOOL isLeapMonth; ///< Weather the month is leap month
@property (nonatomic, readonly) BOOL isLeapYear; ///< Weather the year is leap year
@property (nonatomic, readonly) BOOL isToday; ///< Weather date is today (based on current locale)
@property (nonatomic, readonly) BOOL isYesterday; ///< Weather date is yesterday (based on current locale)

/**
 返回由self 再往前移动 指定年份数 之后的日期.
 */
- (nullable NSDate *)dateByAddingYears:(NSInteger)years;

/**
 返回由self 再往前移动 指定月份数 生成的日期.
 */
- (nullable NSDate *)dateByAddingMonths:(NSInteger)months;

/**
 返回由self 再往前移动 指定星期数 生成的日期.
 */
- (nullable NSDate *)dateByAddingWeeks:(NSInteger)weeks;

/**
 返回由self 再往前移动 指定日份数 生成的日期.
 */
- (nullable NSDate *)dateByAddingDays:(NSInteger)days;

/**
 返回由self 再往前移动 指定小时数 生成的日期.
 */
- (nullable NSDate *)dateByAddingHours:(NSInteger)hours;

/**
 返回由self 再往前移动 指定分钟数 生成的日期.
 */
- (nullable NSDate *)dateByAddingMinutes:(NSInteger)minutes;

/**
 返回由self 再往前移动 指定秒钟数 生成的日期.
 */
- (nullable NSDate *)dateByAddingSeconds:(NSInteger)seconds;



/**
 根据格式返回self的时间
 e.g. @"yyyy-MM-dd HH:mm:ss"
 */
- (nullable NSString *)stringWithFormat:(NSString *)format;

/**
 根据格式返回self的时间
 e.g. @"yyyy-MM-dd HH:mm:ss"
 */
- (nullable NSString *)stringWithFormat:(NSString *)format
                               timeZone:(nullable NSTimeZone *)timeZone
                                 locale:(nullable NSLocale *)locale;

/**
 返回以ISO8601格式表示此日期的字符串
 e.g. "2010-07-09T16:13:30+12:00"
 */
- (nullable NSString *)stringWithISOFormat;

/**
 返回指定dateString的特定格式format的时间
 */
+ (nullable NSDate *)dateWithString:(NSString *)dateString format:(NSString *)format;

/**
 返回指定dateString的特定格式format的时间
 */
+ (nullable NSDate *)dateWithString:(NSString *)dateString
                             format:(NSString *)format
                           timeZone:(nullable NSTimeZone *)timeZone
                             locale:(nullable NSLocale *)locale;

/**
 返回以ISO8601格式表示此日期的字符串
 e.g. "2010-07-09T16:13:30+12:00"
 */
+ (nullable NSDate *)dateWithISOFormatString:(NSString *)dateString;


@end

NS_ASSUME_NONNULL_END

