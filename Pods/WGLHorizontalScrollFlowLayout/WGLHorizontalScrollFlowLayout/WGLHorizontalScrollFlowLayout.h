//
//  WGLHorizontalScrollFlowLayout.h
//  WGLHorizontalScrollFlowLayout
//
//  Created by wugl on 2019/4/22.
//  Copyright © 2019 WGLKit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

//计算页数
UIKIT_EXTERN NSUInteger wgl_numberOfPages(NSUInteger itemsInPage, NSUInteger totalCount);

@interface WGLHorizontalScrollFlowLayout : UICollectionViewFlowLayout

/**
 每页的缩进
 */
@property (nonatomic, assign) UIEdgeInsets pageInset;

/**
 每个页面所包含的数量
 */
@property (nonatomic, assign) NSUInteger numberOfItemsInPage;

/**
 每页分多少列
 */
@property (nonatomic, assign) NSUInteger columnsInPage;

@end
