//
//  UIGestureRecognizer+Block.h
//  WGLUtils
//
//  Created by wugl on 2019/3/14.
//  Copyright © 2019年 WGLKit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIGestureRecognizer (Block)

/**
 初始化一个带Block的手势识别器.
 */
- (instancetype)initWithActionBlock:(void (^)(id sender))block;

/**
 为手势识别器添加一个block.
 */
- (void)addActionBlock:(void (^)(id sender))block;

/**
 删除这个手势识别器的所有Block.
 */
- (void)removeAllActionBlocks;

@end
