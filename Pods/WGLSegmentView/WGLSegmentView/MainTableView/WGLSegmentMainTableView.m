//
//  WGLSegmentMainTableView.m
//  WGLKit
//
//  Created by wugl on 2018/5/24.
//  Copyright © 2018年 WGLKit. All rights reserved.
//

#import "WGLSegmentMainTableView.h"

@interface WGLSegmentMainTableView ()
@property (nonatomic, assign) BOOL isBouncesEnable;
@end

@implementation WGLSegmentMainTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    if (self = [super initWithFrame:frame style:style]) {
        _isBouncesEnable = YES;//default YES;
        _isShouldRecognizeSimultaneously = YES;
    }
    return self;
}

//允许手势向下传递
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return self.isShouldRecognizeSimultaneously;
}

- (void)setBounces:(BOOL)bounces {
    super.bounces = bounces;
    _isBouncesEnable = bounces;
}

@end
