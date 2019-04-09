//
//  DownloadCell.h
//  WGLKitDemo
//
//  Created by wugl on 2019/2/18.
//  Copyright © 2019年 huya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WGLCircleProgressView.h"
@class DownloadCell;

typedef void(^DownloadCellClickHandler)(DownloadCell *cell, NSString *urlString);

@interface DownloadCell : UITableViewCell
@property (nonatomic, strong) UILabel *nameL;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, assign) CGFloat progress;//进度值
@property (nonatomic, copy) DownloadCellClickHandler clickHandler;

@property (nonatomic, strong) WGLCircleProgressView *progressView;
@property (nonatomic, strong) UILabel *progressLabel;

@end
