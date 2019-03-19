//
//  UIDevice+UserDefaults.h
//  WGLCategories
//
//  Created by wugl on 2019/3/18.
//  Copyright © 2019年 WGLKit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIDevice (UserDefaults)

//AppleLanguages
+ (NSString *)currentLanguage;

//相机是否可用
+ (BOOL)isCameraAvailable;

//相册是否可用
+ (BOOL)isAssetsLibraryAvailable;

//用户通知是否启用
+ (BOOL)isUserNotificationEnabled;

@end
