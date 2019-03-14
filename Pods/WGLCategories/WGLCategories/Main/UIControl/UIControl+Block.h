//
//  UIControl+Block.h
//  WGLUtils
//
//  Created by wugl on 2019/3/14.
//  Copyright © 2019年 WGLKit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIControl (Block)

/**
 为UIControl控件添加一个Block事件，内部将产生一个对block的强引用
 */
- (void)addBlockForControlEvents:(UIControlEvents)controlEvents block:(void (^)(id sender))block;

/**
 为UIControl控件添加一个Block事件，内部将产生一个对block的强引用
 区别于addBlockForControlEvents方法，set方法会将UIControl的UIControlEventAllEvents事件移除，再重新添加
 */
- (void)setBlockForControlEvents:(UIControlEvents)controlEvents block:(void (^)(id sender))block;

/**
 移除特定事件对应的所有Block
 */
- (void)removeAllBlocksForControlEvents:(UIControlEvents)controlEvents;

@end
