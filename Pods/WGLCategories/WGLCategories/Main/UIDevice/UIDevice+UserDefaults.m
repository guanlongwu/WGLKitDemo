//
//  UIDevice+UserDefaults.m
//  WGLCategories
//
//  Created by wugl on 2019/3/18.
//  Copyright © 2019年 WGLKit. All rights reserved.
//

#import "UIDevice+UserDefaults.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import "UIDevice+DeviceInfo.h"

@implementation UIDevice (UserDefaults)

+ (NSString *)currentLanguage {
    NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];
    NSArray *languages = [defs objectForKey:@"AppleLanguages"];
    NSString *curLang = [languages objectAtIndex:0];
    return curLang;
}

+ (BOOL)isCameraAvailable {
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if(authStatus == AVAuthorizationStatusAuthorized || authStatus == AVAuthorizationStatusNotDetermined) {
        return YES;
    }
    else {
        return NO;
    }
}

+ (BOOL)isAssetsLibraryAvailable {
    if (floor(NSFoundationVersionNumber) < NSFoundationVersionNumber_iOS_9_0) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        ALAuthorizationStatus authStatus = [ALAssetsLibrary authorizationStatus];
        if(authStatus == ALAuthorizationStatusAuthorized
           || authStatus == ALAuthorizationStatusNotDetermined) {
            return YES;
        }
        else {
            return NO;
        }
#pragma clang diagnostic pop
    }
    else {
        PHAuthorizationStatus authStatus = [PHPhotoLibrary authorizationStatus];
        if(authStatus == PHAuthorizationStatusAuthorized
           || authStatus == PHAuthorizationStatusNotDetermined) {
            return YES;
        }
        else {
            return NO;
        }
    }
}

+ (BOOL)isUserNotificationEnabled {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    if ([UIDevice systemVersion] >= 8.0) {
        // iOS8 +
        UIUserNotificationSettings *setting = [[UIApplication sharedApplication] currentUserNotificationSettings];
        if (UIUserNotificationTypeNone != setting.types) {
            return YES;
        }
    } else {
        // iOS7
        UIRemoteNotificationType type = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
        if(UIRemoteNotificationTypeNone != type) {
            return YES;
        }
    }
#pragma clang diagnostic pop
    return NO;
}

@end
