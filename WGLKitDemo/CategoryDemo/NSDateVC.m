//
//  NSDateVC.m
//  WGLKitDemo
//
//  Created by wugl on 2019/3/18.
//  Copyright © 2019年 huya. All rights reserved.
//

#import "NSDateVC.h"

#import "NSDate+Format.h"

@interface NSDateVC ()

@end

@implementation NSDateVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
#pragma clang diagnostic push //收集当前的警告
#pragma clang diagnostic ignored "-Wunused-variable"

    NSDate *curDate = [NSDate date];
    NSInteger year = curDate.year;
    NSInteger month = curDate.month;
    NSInteger day = curDate.day;
    NSInteger hour = curDate.hour;
    NSInteger min = curDate.minute;
    NSInteger second = curDate.second;
    NSInteger nanosecond = curDate.nanosecond;
    NSInteger weakday = curDate.weekday;
    
    NSInteger isToday = curDate.isToday;
    NSInteger isYesterday = curDate.isYesterday;
    
#pragma clang diagnostic pop

    NSLog(@"");
    
}



@end
