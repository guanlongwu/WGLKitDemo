//
//  NSFileManagerVC.m
//  WGLKitDemo
//
//  Created by wugl on 2019/3/18.
//  Copyright © 2019年 huya. All rights reserved.
//

#import "NSFileManagerVC.h"
#import "UIView+Extensions.h"
#import "NSArray+Safe.h"

#import "NSFileManager+Extensions.h"

@interface NSFileManagerVC ()
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) NSArray <NSString *> *paths;
@end

@implementation NSFileManagerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    CGFloat width = self.view.width;
    CGFloat height = 80;
    for (int i = 0; i < 6; i++) {
        CGFloat originY = 80 + i * (height + 10);
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, originY, width, height)];
        label.font = [UIFont systemFontOfSize:12];
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentLeft;
        label.backgroundColor = [UIColor grayColor];
        [self.view addSubview:label];
        label.numberOfLines = 0;
        
        NSString *str = [self.paths safeObjectAtIndex:i];
        label.text = [NSString stringWithFormat:@"%d : %@", i, str];
    }
    
}

- (NSArray <NSString *> *)paths {
    return [@[
              [NSFileManager defaultManager].documentsURL,
              [NSFileManager defaultManager].documentsPath,
              [NSFileManager defaultManager].cachesURL,
              [NSFileManager defaultManager].cachesPath,
              [NSFileManager defaultManager].libraryURL,
              [NSFileManager defaultManager].libraryPath
              ] mutableCopy];
}


@end
