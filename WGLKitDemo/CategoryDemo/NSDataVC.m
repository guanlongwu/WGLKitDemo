//
//  NSDataVC.m
//  WGLKitDemo
//
//  Created by wugl on 2019/3/15.
//  Copyright © 2019年 huya. All rights reserved.
//

#import "NSDataVC.h"
#import "NSArray+Safe.h"

#import "NSData+Hash.h"
#import "NSData+Encrypt.h"
#import "NSData+Compress.h"
#import "NSData+Encode.h"

@interface NSDataVC ()
@property (nonatomic, strong) NSArray <NSString *> *titles;
@property (nonatomic, strong) NSData *originData;
@end

@implementation NSDataVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    CGFloat width = 80;
    CGFloat height = 50;
    for (int row = 0; row < 1; row++) {
        for (int column = 0; column < 4; column++) {
            CGFloat originX = 10 + column * (width + 10);
            CGFloat originY = 100 + row * (height + 30);
            
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(originX, originY, width, height)];
            btn.backgroundColor = [UIColor grayColor];
            [btn setTintColor:[UIColor whiteColor]];
            btn.titleLabel.font = [UIFont systemFontOfSize:10];
            [self.view addSubview:btn];
            [btn addTarget:self action:@selector(c_string:) forControlEvents:UIControlEventTouchUpInside];
            
            NSInteger idx = 4 * row + column;
            btn.tag = idx;
            NSString *title = [self.titles safeObjectAtIndex:idx];
            [btn setTitle:title ?: @"..." forState:UIControlStateNormal];
        }
    }
}

- (void)c_string:(UIButton *)sender {
    NSInteger idx = sender.tag;
    switch (idx) {
        case 0: {
            //Hash
            NSData *data = self.originData;
            NSData *md5 = [data md5Data];
            //<8b7e28e1 12a557b2 66bba644 e4fb0b57>
            NSString *md5String = [data md5String];
            //8b7e28e112a557b266bba644e4fb0b57
            NSString *md5Str = [[NSString alloc] initWithData:md5 encoding:NSUTF8StringEncoding];   //nil
            
            NSString *sha1Str = [data sha1String];
            //5a67e40ea7991c937537139f902e3148983ff727
            NSData *sha1Data = [data sha1Data];
            //<5a67e40e a7991c93 7537139f 902e3148 983ff727>
            
            NSString *sha256Str = [data sha256String];
            //38e47374aaf8556ffd84ccd451adc001ef6d94b32cf2b782090f628b0cea42a3
            
            NSString *crc32Str = [data crc32String];
            //9e46ef15
            
            NSLog(@"%@,%@,%@,%@,%@,%@,%@", md5, md5String, md5Str, sha1Str, sha1Data, sha256Str, crc32Str);
        }
            break;
        case 1: {
            //Encrypt
            NSData *data = self.originData;
            //<e6b58be8 af954e53 44617461 e79a84e5 8886e7b1 bbe696b9 e6b395>
            NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSData *key = [@"wuguanlongWUGUAN" dataUsingEncoding:NSUTF8StringEncoding];
            NSData *encrypt = [data aes256EncryptWithKey:key iv:nil];
            //<3a28994f 1631cc60 dd967b52 9aaae0ad 68c1e58e ca6b5d0d 843e7823 85230ec1>
            NSData *decrypt = [encrypt aes256DecryptWithkey:key iv:nil];
            //<e6b58be8 af954e53 44617461 e79a84e5 8886e7b1 bbe696b9 e6b395>
            
            NSLog(@"");
        }
            break;
        case 2: {
            //Compress
            
            NSLog(@"");
        }
            break;
        case 3: {
            //Encode
            
            NSLog(@"");
        }
            break;
        case 4: {
            //Trim
            
            NSLog(@"");
        }
            break;
        default:
            break;
    }
}

- (NSArray <NSString *> *)titles {
    if (!_titles) {
        _titles =
        [@[
           @"Hash", @"Encrypt", @"Compress", @"Encode",
           ] mutableCopy];
    }
    return _titles;
}

- (NSData *)originData {
    if (!_originData) {
        NSString *string = @"测试NSData的分类方法";
        _originData = [string dataUsingEncoding:NSUTF8StringEncoding];
    }
    return _originData;
}


@end
