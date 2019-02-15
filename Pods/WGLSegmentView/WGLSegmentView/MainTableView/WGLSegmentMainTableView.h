//
//  WGLSegmentMainTableView.h
//  WGLKit
//
//  Created by wugl on 2018/5/24.
//  Copyright © 2018年 WGLKit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WGLSegmentMainTableView : UITableView

@property (nonatomic, assign, readonly) BOOL isBouncesEnable;// default YES. if YES, bounces past edge of content and back again

@property (nonatomic, assign) BOOL isShouldRecognizeSimultaneously;

@end


