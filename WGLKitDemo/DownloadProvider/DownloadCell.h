//
//  DownloadCell.h
//  WGLKitDemo
//
//  Created by wugl on 2019/2/18.
//  Copyright © 2019年 huya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DownloadCell : UITableViewCell
@property (nonatomic, strong) UILabel *nameL;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, assign) CGFloat progress;//进度值
@end
