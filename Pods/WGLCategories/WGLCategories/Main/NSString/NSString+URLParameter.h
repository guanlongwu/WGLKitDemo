//
//  NSString+URLParameter.h
//  WGLUtils
//
//  Created by wugl on 2019/3/4.
//  Copyright © 2019年 WGLKit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (URLParameter)

/**
 *  截取URL中的参数
 *
 *  @return 以字典的形式返回
 */
- (NSMutableDictionary *)getURLParameters;

@end
