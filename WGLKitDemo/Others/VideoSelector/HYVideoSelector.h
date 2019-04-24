//
//  HYVideoSelector.h
//  HYVideoEditSDK
//
//  Created by wugl on 2019/4/11.
//  Copyright © 2019 WGLKit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "HYVideoAlbumAsset.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^HYVideoSelectorDidFinish)(HYVideoAlbumAsset *asset);
typedef void(^HYVideoSelectorDidCancel)(void);

@interface HYVideoSelector : NSObject

@property (nonatomic, strong) UIViewController *controller;
@property (nonatomic, strong) id sender;
@property (nonatomic, copy) HYVideoSelectorDidFinish finishHandler;
@property (nonatomic, copy) HYVideoSelectorDidCancel cancelHandler;

+ (HYVideoSelector *)sharedSelector;

//打开选择器
- (void)showWithSender:(id)sender inController:(UIViewController *)controller finish:(HYVideoSelectorDidFinish)finish cancel:(HYVideoSelectorDidCancel)cancel;

@end

NS_ASSUME_NONNULL_END
