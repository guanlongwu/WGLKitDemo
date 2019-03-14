//
//  NSBundle+Extensions.m
//  WGLUtils
//
//  Created by wugl on 2019/3/13.
//  Copyright © 2019年 WGLKit. All rights reserved.
//

#import "NSBundle+Extensions.h"

@implementation NSBundle (Extensions)

- (NSString *)appBundleName {
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"];
}

- (NSString *)appBundleID {
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleIdentifier"];
}

- (NSString *)appVersion {
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
}

- (NSString *)appBuildVersion {
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
}

@end
