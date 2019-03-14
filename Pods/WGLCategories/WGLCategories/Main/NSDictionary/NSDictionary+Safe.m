//
//  NSDictionary+Safe.m
//  WGLUtils
//
//  Created by wugl on 2019/3/4.
//  Copyright © 2019年 WGLKit. All rights reserved.
//

#import "NSDictionary+Safe.h"

@implementation NSDictionary (Safe)

- (NSNumber *)safeNumberForKey:(NSString *)key {
    id object = [self objectForKey:key];
    if (![object isKindOfClass:[NSNumber class]] || [object isKindOfClass:[NSNull class]]) {
        return @(0);
    }
    return object;
}

- (NSNumber *)safeNumberOrNilForKey:(NSString *)key {
    id object = [self objectForKey:key];
    
    if (![object isKindOfClass:[NSNumber class]] || [object isKindOfClass:[NSNull class]]) {
        return nil;
    }
    return object;
}

- (NSString *)safeStringForKey:(NSString *)key {
    id object = [self objectForKey:key];
    if (![object isKindOfClass:[NSString class]] || [object isKindOfClass:[NSNull class]]) {
        return @"";
    }
    return object;
}

- (NSString *)safeStringOrNilForKey:(NSString *)key {
    id object = [self objectForKey:key];
    if (![object isKindOfClass:[NSString class]] || [object isKindOfClass:[NSNull class]]) {
        return nil;
    }
    return object;
}

- (NSArray *)safeArrayForKey:(NSString *)key {
    id object = [self objectForKey:key];
    if (![object isKindOfClass:[NSArray class]] || [object isKindOfClass:[NSNull class]]) {
        return nil;
    }
    return object;
}

- (NSDictionary *)safeDictionaryForKey:(NSString *)key {
    id object = [self objectForKey:key];
    if (![object isKindOfClass:[NSDictionary class]] || [object isKindOfClass:[NSNull class]]) {
        return nil;
    }
    return object;
}

@end
