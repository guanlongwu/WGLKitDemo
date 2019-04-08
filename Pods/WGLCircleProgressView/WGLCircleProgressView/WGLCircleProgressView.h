//
//  WGLCircleProgressView.h
//  WGLCircleProgressView
//
//  Created by wugl on 2019/2/18.
//  Copyright © 2019年 WGLKit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface WGLCircleProgressView : UIView

@property (nonatomic, assign) CGFloat progress;//进度值 0.0 ~ 1.0
@property (nonatomic, assign) CGFloat circleLineWidth;//进度线宽
@property (nonatomic, strong) UIColor *circleLineColor;//进度线颜色

@end
