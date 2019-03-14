//
//  NSDictionary+Safe.h
//  WGLUtils
//
//  Created by wugl on 2019/3/4.
//  Copyright © 2019年 WGLKit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Safe)

- (NSNumber *)safeNumberForKey:(NSString *)key;
- (NSNumber *)safeNumberOrNilForKey:(NSString *)key;

- (NSString *)safeStringForKey:(NSString *)key;
- (NSString *)safeStringOrNilForKey:(NSString *)key;

- (NSArray *)safeArrayForKey:(NSString *)key;
- (NSDictionary *)safeDictionaryForKey:(NSString *)key;

@end
