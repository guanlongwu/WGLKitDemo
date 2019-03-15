//
//  NSDictionary+JSON.h
//  WGLUtils
//
//  Created by wugl on 2019/3/4.
//  Copyright © 2019年 WGLKit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (JSON)

/**
 字典转json字符串方法
 */
- (NSString *)toJson;

/**
 字典转json字符串方法
 会将空格和换行符去掉（" ","\n"）
 */
- (NSString *)toJsonByTrim;

@end
