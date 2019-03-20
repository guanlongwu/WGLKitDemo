//
//  UIImageVC.m
//  WGLKitDemo
//
//  Created by wugl on 2019/3/14.
//  Copyright © 2019年 huya. All rights reserved.
//

#import "UIImageVC.h"
#import "NSArray+Safe.h"

#import "UIImage+Blur.h"
#import "UIImage+Modify.h"
#import "UIImage+Resize.h"
#import "UIImage+FixOrientation.h"
#import "UIImage+Transform.h"
#import "UIImage+RoundCorner.h"

#import "UIView+RoundCorner.h"

@interface UIImageVC ()
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImage *image;

@property (nonatomic, strong) NSArray <NSString *> *titles;
@end

@implementation UIImageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    CGFloat width = 80;
    CGFloat height = 50;
    for (int row = 0; row < 3; row++) {
        for (int column = 0; column < 4; column++) {
            CGFloat originX = 10 + column * (width + 10);
            CGFloat originY = 400 + row * (height + 30);
            
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(originX, originY, width, height)];
            btn.backgroundColor = [UIColor grayColor];
            [btn setTintColor:[UIColor whiteColor]];
            btn.titleLabel.font = [UIFont systemFontOfSize:10];
            [self.view addSubview:btn];
            [btn addTarget:self action:@selector(c_image:) forControlEvents:UIControlEventTouchUpInside];
            
            NSInteger idx = 4 * row + column;
            btn.tag = idx;
            NSString *title = [self.titles safeObjectAtIndex:idx];
            [btn setTitle:title ?: @"..." forState:UIControlStateNormal];
        }
    }
    
    self.image = [UIImage imageNamed:@"originImage.jpg"];
    
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 100, 330, 200)];
    self.imageView.backgroundColor = [UIColor grayColor];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.imageView.image = self.image;
    [self.view addSubview:self.imageView];
    
}

- (NSArray <NSString *> *)titles {
    if (!_titles) {
        _titles =
        [@[
           @"Origin", @"Crop", @"Resize", @"AspectFit",
           @"AspectFill", @"Transform", @"Transform2", @"RoundCorner", @"RoundCorner2",
           ] mutableCopy];
    }
    return _titles;
}

- (void)c_image:(UIButton *)sender {
    NSInteger idx = sender.tag;
    switch (idx) {
        case 0: {
            //原图
            self.imageView.image = self.image;
        }
            break;
        case 1: {
            //裁剪
            CGRect cropFrame = CGRectMake(-200, -300, CGImageGetWidth(self.image.CGImage), CGImageGetHeight(self.image.CGImage));
            UIImage *cropImg = [self.image croppedImage:cropFrame];
            self.imageView.image = cropImg;
        }
            break;
        case 2: {
            //大小调整
            CGSize reSize = CGSizeMake(CGImageGetWidth(self.image.CGImage) / 3, CGImageGetHeight(self.image.CGImage));
            UIImage *resizeImg = [self.image resizedImage:reSize interpolationQuality:0];
            self.imageView.image = resizeImg;
        }
            break;
        case 3: {
            //AspectFit
            CGFloat imgW = CGImageGetWidth(self.image.CGImage);
            CGFloat imgH = CGImageGetHeight(self.image.CGImage);
            CGSize imgViewSize = self.imageView.frame.size;
            CGSize fitSize = CGSizeMake(imgW, imgH);
            UIImage *fitImg = [self.image imageByResizeToSize:fitSize contentMode:UIViewContentModeScaleAspectFit];
            self.imageView.image = fitImg;
        }
            break;
        case 4: {
            //AspectFill
            CGSize fillSize = self.imageView.frame.size;
            UIImage *fillImg = [self.image imageByResizeToSize:fillSize contentMode:UIViewContentModeScaleAspectFill];
            self.imageView.image = fillImg;
        }
            break;
        case 5: {
            //Transform
            CGFloat radius = DegreesToRadians(45);
            UIImage *resultImg = [self.image imageByRotate:radius fitSize:YES];
            self.imageView.image = resultImg;
        }
            break;
        case 6: {
            //Transform2
            CGFloat radius = DegreesToRadians(45);
            UIImage *resultImg = [self.image imageByRotate:radius fitSize:NO];
            self.imageView.image = resultImg;
        }
            break;
        case 7: {
            //RoundCorner
            CGFloat radius = MIN(CGImageGetWidth(self.image.CGImage), CGImageGetHeight(self.image.CGImage)) / 2;
            UIImage *resultImg = [self.image imageByRoundCornerRadius:radius corners:UIRectCornerTopRight | UIRectCornerBottomRight borderWidth:3 borderColor:nil];
            self.imageView.image = resultImg;
        }
            break;
        case 8: {
            //RoundCorner2
            CGFloat radius = MIN(CGRectGetWidth(self.imageView.frame), CGRectGetHeight(self.imageView.frame)) / 3;
            self.imageView.image = self.image;
            [self.imageView setRoundCornerRadius:radius corners:UIRectCornerTopLeft];
        }
            break;
        default:
            break;
    }
}

@end
