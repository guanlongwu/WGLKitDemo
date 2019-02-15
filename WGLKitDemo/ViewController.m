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

@interface ViewController ()
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 100, 50)];
    btn.backgroundColor = [UIColor grayColor];
    [btn setTitle:@"分页控件" forState:UIControlStateNormal];
    [btn setTintColor:[UIColor whiteColor]];
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(c_segment) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btn2 = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 100, 50)];
    btn2.backgroundColor = [UIColor grayColor];
    [btn2 setTitle:@"下载控件" forState:UIControlStateNormal];
    [btn2 setTintColor:[UIColor whiteColor]];
    [self.view addSubview:btn2];
    [btn2 addTarget:self action:@selector(c_download) forControlEvents:UIControlEventTouchUpInside];
}

- (void)c_segment {
    SegmentVC *svc = [SegmentVC new];
    [self.navigationController pushViewController:svc animated:YES];
}

- (void)c_download {
    DownloadVC *dvc = [DownloadVC new];
    [self.navigationController pushViewController:dvc animated:YES];
}


@end
