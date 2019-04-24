//
//  UploadCell.h
//  WGLKitDemo
//
//  Created by wugl on 2019/4/24.
//  Copyright © 2019 huya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WGLCircleProgressView.h"
@class UploadCell;

NS_ASSUME_NONNULL_BEGIN

typedef void(^UploadCellClickHandler)(UploadCell *cell, NSString *filePath);

@interface UploadCell : UITableViewCell
@property (nonatomic, strong) UILabel *nameL;
@property (nonatomic, copy) NSString *filePath;
@property (nonatomic, assign) CGFloat progress;//进度值
@property (nonatomic, strong) WGLCircleProgressView *progressView;
@property (nonatomic, strong) UILabel *progressLabel;
@property (nonatomic, copy) UploadCellClickHandler clickHandler;
@end

NS_ASSUME_NONNULL_END
