//
//  NSDictionary+Sort.h
//  WGLUtils
//
//  Created by wugl on 2019/3/4.
//  Copyright © 2019年 WGLKit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Sort)

/**
 返回一个包含已排序的字典key的新数组，key应该是NSString，并且升序排序.
 */
- (NSArray *)allKeysSorted;

/**
 返回一个包含以key进行排序所对应的value的新数组，key应该是NSString，并且升序排序.
 */
- (NSArray *)allValuesSortedByKeys;

/**
 返回一个以key进行排序的新字典，key应该是NSString，并且升序排序.
 */
- (NSDictionary *)entriesForKeys:(NSArray *)keys;

@end
