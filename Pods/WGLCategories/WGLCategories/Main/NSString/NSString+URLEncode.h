//
//  NSString+URLEncode.h
//  WGLUtils
//
//  Created by wugl on 2019/3/4.
//  Copyright © 2019年 WGLKit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (URLEncode)

- (NSString *)URLDecode;

- (NSString *)URLDecodedUsingEncoding:(NSStringEncoding)encoding;

- (NSString *)URLEncode;

- (NSString *)urlEncodeUsingEncoding:(NSStringEncoding)encoding;

@end
