//
//  NSArray+Safe.m
//  WGLUtils
//
//  Created by wugl on 2019/3/4.
//  Copyright © 2019年 WGLKit. All rights reserved.
//

#import "NSArray+Safe.h"

@implementation NSArray (Safe)

- (id)safeObjectAtIndex:(NSUInteger)index {
    if(index<[self count]) {
        return [self objectAtIndex:index];
    }
    return nil;
}

@end
