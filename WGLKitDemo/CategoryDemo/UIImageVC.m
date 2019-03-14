//
//  UIImageVC.m
//  WGLKitDemo
//
//  Created by wugl on 2019/3/14.
//  Copyright © 2019年 huya. All rights reserved.
//

#import "UIImageVC.h"
#import "WGLCategories.h"

@interface UIImageVC ()
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImage *image;
@end

@implementation UIImageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.image = [UIImage imageNamed:@"originImage.jpg"];
    
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 100, 330, 200)];
    self.imageView.backgroundColor = [UIColor grayColor];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.imageView.image = self.image;
    [self.view addSubview:self.imageView];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(120, 320, 100, 50)];
    btn.backgroundColor = [UIColor grayColor];
    [btn setTitle:@"原图" forState:UIControlStateNormal];
    [btn setTintColor:[UIColor whiteColor]];
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(c_origin) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btn1 = [[UIButton alloc] initWithFrame:CGRectMake(10, 400, 100, 50)];
    btn1.backgroundColor = [UIColor grayColor];
    [btn1 setTitle:@"裁剪" forState:UIControlStateNormal];
    [btn1 setTintColor:[UIColor whiteColor]];
    [self.view addSubview:btn1];
    [btn1 addTarget:self action:@selector(c_crop) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btn2 = [[UIButton alloc] initWithFrame:CGRectMake(120, 400, 100, 50)];
    btn2.backgroundColor = [UIColor grayColor];
    [btn2 setTitle:@"调整大小" forState:UIControlStateNormal];
    [btn2 setTintColor:[UIColor whiteColor]];
    [self.view addSubview:btn2];
    [btn2 addTarget:self action:@selector(c_resize) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btn3 = [[UIButton alloc] initWithFrame:CGRectMake(240, 400, 100, 50)];
    btn3.backgroundColor = [UIColor grayColor];
    [btn3 setTitle:@"AspectFit" forState:UIControlStateNormal];
    [btn3 setTintColor:[UIColor whiteColor]];
    [self.view addSubview:btn3];
    [btn3 addTarget:self action:@selector(c_aspectFit) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btn4 = [[UIButton alloc] initWithFrame:CGRectMake(10, 500, 100, 50)];
    btn4.backgroundColor = [UIColor grayColor];
    [btn4 setTitle:@"AspectFill" forState:UIControlStateNormal];
    [btn4 setTintColor:[UIColor whiteColor]];
    [self.view addSubview:btn4];
    [btn4 addTarget:self action:@selector(c_aspectFill) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btn5 = [[UIButton alloc] initWithFrame:CGRectMake(120, 500, 100, 50)];
    btn5.backgroundColor = [UIColor grayColor];
    [btn5 setTitle:@"Transform" forState:UIControlStateNormal];
    [btn5 setTintColor:[UIColor whiteColor]];
    [self.view addSubview:btn5];
    [btn5 addTarget:self action:@selector(c_transform) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btn6 = [[UIButton alloc] initWithFrame:CGRectMake(240, 500, 100, 50)];
    btn6.backgroundColor = [UIColor grayColor];
    [btn6 setTitle:@"Transform2" forState:UIControlStateNormal];
    [btn6 setTintColor:[UIColor whiteColor]];
    [self.view addSubview:btn6];
    [btn6 addTarget:self action:@selector(c_transform2) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)c_origin {
    self.imageView.image = self.image;
}

- (void)c_crop {
    CGRect cropFrame = CGRectMake(-200, -300, CGImageGetWidth(self.image.CGImage), CGImageGetHeight(self.image.CGImage));
    UIImage *cropImg = [self.image croppedImage:cropFrame];
    self.imageView.image = cropImg;
}

- (void)c_resize {
    CGSize cropSize = CGSizeMake(CGImageGetWidth(self.image.CGImage) / 3, CGImageGetHeight(self.image.CGImage));
    UIImage *cropImg2 = [self.image resizedImage:cropSize interpolationQuality:0];
    self.imageView.image = cropImg2;
}

- (void)c_aspectFit {
    CGFloat imgW = CGImageGetWidth(self.image.CGImage);
    CGFloat imgH = CGImageGetHeight(self.image.CGImage);
    CGSize imgViewSize = self.imageView.frame.size;
    CGSize cropSize = CGSizeMake(imgW, imgH);
    UIImage *cropImg = [self.image imageByResizeToSize:cropSize contentMode:UIViewContentModeScaleAspectFit];
    self.imageView.image = cropImg;
}

- (void)c_aspectFill {
    CGSize cropSize = self.imageView.frame.size;
    UIImage *cropImg = [self.image imageByResizeToSize:cropSize contentMode:UIViewContentModeScaleAspectFill];
    self.imageView.image = cropImg;
}

- (void)c_transform {
    CGFloat radius = DegreesToRadians(45);
    UIImage *cropImg = [self.image imageByRotate:radius fitSize:YES];
    self.imageView.image = cropImg;
}

- (void)c_transform2 {
    CGFloat radius = DegreesToRadians(45);
    UIImage *cropImg = [self.image imageByRotate:radius fitSize:NO];
    self.imageView.image = cropImg;
}

@end
