//
//  ViewController.m
//  WGLKitDemo
//
//  Created by wugl on 2018/11/15.
//  Copyright © 2018年 huya. All rights reserved.
//

#import "ViewController.h"
#import "SegmentVC.h"
#import "DownloadVC.h"
#import "CategoryVC.h"

@interface ViewController ()
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(10, 100, 100, 50)];
    btn.backgroundColor = [UIColor grayColor];
    [btn setTitle:@"分页控件" forState:UIControlStateNormal];
    [btn setTintColor:[UIColor whiteColor]];
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(c_segment) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btn2 = [[UIButton alloc] initWithFrame:CGRectMake(120, 100, 100, 50)];
    btn2.backgroundColor = [UIColor grayColor];
    [btn2 setTitle:@"下载控件" forState:UIControlStateNormal];
    [btn2 setTintColor:[UIColor whiteColor]];
    [self.view addSubview:btn2];
    [btn2 addTarget:self action:@selector(c_download) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btn3 = [[UIButton alloc] initWithFrame:CGRectMake(240, 100, 100, 50)];
    btn3.backgroundColor = [UIColor grayColor];
    [btn3 setTitle:@"category控件" forState:UIControlStateNormal];
    [btn3 setTintColor:[UIColor whiteColor]];
    [self.view addSubview:btn3];
    [btn3 addTarget:self action:@selector(c_category) forControlEvents:UIControlEventTouchUpInside];
    
    NSString *str1 = @"仅展示本场直播最近300条的流水记录，\n更多记录请在直播结束后到个人中心查看";
    CGFloat width1 = [self mj_textWith:str1 font:[UIFont systemFontOfSize:10]];
    NSString *str2 = @"仅展示本场直播最近300条的流水记录，更多记录请在直播结束后到个人中心查看";
    CGFloat width2 = [self mj_textWith:str2 font:[UIFont systemFontOfSize:10]];
    NSLog(@"");
}

- (CGFloat)mj_textWith:(NSString *)txt font:(UIFont *)font {
    CGFloat stringWidth = 0;
    CGSize size = CGSizeMake(MAXFLOAT, MAXFLOAT);
    if (txt.length > 0) {
#if defined(__IPHONE_OS_VERSION_MAX_ALLOWED) && __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
        stringWidth =[txt
                      boundingRectWithSize:size
                      options:NSStringDrawingUsesLineFragmentOrigin
                      attributes:@{NSFontAttributeName:font}
                      context:nil].size.width;
#else
        
        stringWidth = [txt sizeWithFont:font
                            constrainedToSize:size
                                lineBreakMode:NSLineBreakByCharWrapping].width;
#endif
    }
    return stringWidth;
}

- (void)c_segment {
    SegmentVC *svc = [SegmentVC new];
    [self.navigationController pushViewController:svc animated:YES];
}

- (void)c_download {
    DownloadVC *dvc = [DownloadVC new];
    [self.navigationController pushViewController:dvc animated:YES];
}

- (void)c_category {
    CategoryVC *cvc = [CategoryVC new];
    [self.navigationController pushViewController:cvc animated:YES];
}


@end
