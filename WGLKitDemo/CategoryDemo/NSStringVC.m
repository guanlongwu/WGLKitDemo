//
//  NSStringVC.m
//  WGLKitDemo
//
//  Created by wugl on 2019/3/15.
//  Copyright © 2019年 huya. All rights reserved.
//

#import "NSStringVC.h"
#import "NSArray+Safe.h"
#import "UIView+Extensions.h"

#import "NSString+URLParameter.h"
#import "NSString+URLEncode.h"
#import "NSString+Size.h"
#import "NSString+Dictionary.h"
#import "NSString+Number.h"
#import "NSString+Base64.h"
#import "NSString+Hash.h"
#import "NSString+Trim.h"

@interface NSStringVC ()
@property (nonatomic, strong) NSArray <NSString *> *titles;
@end

@implementation NSStringVC

- (void)dealloc {
    NSLog(@"");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    CGFloat width = 80;
    CGFloat height = 50;
    for (int row = 0; row < 2; row++) {
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

- (NSArray <NSString *> *)titles {
    if (!_titles) {
        _titles =
        [@[
           @"URLParameter", @"URLEncode", @"Base64", @"Hash",
           @"Trim", @"Size", @"Dictionary", @"Number",
           ] mutableCopy];
    }
    return _titles;
}

- (void)c_string:(UIButton *)sender {
    NSInteger idx = sender.tag;
    switch (idx) {
        case 0: {
            //urlPrameter
            NSString *url = self.originString;
            NSDictionary *urlParams = [url getURLParameters];
            for (NSString *key in urlParams.allKeys) {
                id value = urlParams[key];
                NSLog(@"\n key = %@, value = %@\n", key, value);
            }
            NSLog(@"");
        }
            break;
        case 1: {
            //URLEncode
            NSString *url = self.originString;
            NSString *encodeURL = [url urlEncodeUsingEncoding:NSUTF8StringEncoding];
            NSString *decodeURL = [encodeURL URLDecodedUsingEncoding:NSUTF8StringEncoding];
            NSLog(@"");
        }
            break;
        case 2: {
            //Base64
            NSString *url = self.originString;
            NSString *base64URL = [url base64EncodedString];
            NSString *base64Decode = [NSString stringWithBase64EncodedString:base64URL];
            NSLog(@"");
        }
            break;
        case 3: {
            //Hash
            NSString *url = self.originString;
            NSString *md5URL = [url md5String];
            NSLog(@"");
        }
            break;
        case 4: {
            //Trim
            NSString *url = @"  wugl\n\tCATEGORY demo ";
            NSString *trimURL = [url stringByTrim];
            NSLog(@"");
        }
            break;
        case 5: {
            //Size
            NSString *str1 = @"  仅展示本场直播最近300条的流水记录，\n更多记录请在直播结束后到个人中心查看";
            NSString *str2 = @"仅展示本场直播最近300条的流水记录，更多记录请在直播结束后到个人中心查看";
            UIFont *font = [UIFont systemFontOfSize:10];
            CGSize limitSize = CGSizeMake(self.view.width, 300);
            CGSize size1 = [str1 safeSizeWithFont:font constrainedToSize:limitSize lineBreakMode:NSLineBreakByCharWrapping];
            CGSize size2 = [str2 safeSizeWithFont:font constrainedToSize:limitSize lineBreakMode:NSLineBreakByCharWrapping];
            NSLog(@"");
        }
            break;
        case 6: {
            //Dictionary
            
            /**
             注意：json对象和json字符串是不一样的。
             字符串，我们常说的JavaScript中的字符串是单引号或者双引号引起来的。
             json字符串，之所以叫json字符串，因为字符串的格式符合json的格式
             */
            
        }
            break;
        case 7: {
            //Number
            NSString *str = @"123";
            NSNumber *number = [str toNumber];      //123
            NSString *str1 = @"abc";
            NSNumber *number1 = [str1 toNumber];    //nil
            NSString *str2 = @"代码";
            NSNumber *number2 = [str2 toNumber];    //nil
            NSString *str3 = @"123a";
            NSNumber *number3 = [str3 toNumber];    //nil
            NSString *str4 = @"0x000022";
            NSNumber *number4 = [str4 toNumber];    //34
            NSLog(@"");
        }
            break;
        default:
            break;
    }
}

- (NSString *)originString {
    return @"https://lf.snssdk.com/api/ad/union/redirect/?req_id=f192430ccc1d4e0a929701735930c3d3u9222&use_pb=1&rit=904160020&call_back=OZxXi2zCyGSJWVnec94oVTpJL4CvJEM3ScGKuS8nhXmzQ8FQdgE%2FSIohjqLTLuPQBipGC6ARrNp6X%2B1Q3u5pUw%3D%3D&extra=hoeYDQYCAygEEXuEj0b29VtKZd9XnHd2fwm5hbdrqjMaTQqAgo6IUU7AaBv3mQjTYvElxQfo7YH9GfkMyl7tv%2FOScAPc3Hv4u5%2FDbEoOgNFGL1Zp6cb9GtQGOdVcF3r0C7IFW3X92VW6eG5MB9%2Bvac9NqjpGxafOI4%2Bt7RrxT22%2Fx%2F94DDjbsBa7wGHVij3BT0d%2BZRpnaHJLAFMW3WhmBG1bWABKfPzYqVAiScigyL4cBPEPURrNoJqH77CEdkmSVfqjP0TaCkoE5tt%2FOLVP2fDFNncxluJlfATUA6XECHJE2OS7vYgxuIAYo1rM4rPv85NSWQ%2B8cV8ewK4XJ0RZTDxCtuXnXqT2t2zfCjLyby7SaWnEFwGDH5s5buHi5kirCLBdRwEYsv0Q0PCRGVPN9TdfNi1m%2F%2F0BbOVeOAhmyfEI58VBhCbWqnb1Hbch8jS2SR%2F3OrA44KBr%2F6RDz3VCGokonq6oiiI5YtPVYl%2FSYT6Fabloa87wBad3OotgE9ZfVCQPfkI5l5Yj9%2BJ2NpX0GO9VjlhZPOfywFcyu75sBIZjYjIIDr9zpPoLj0tCqWezS73%2Ba5gA%2FuTwBEgOo%2B0jn17vwFVNHiZaunvnVg1LbuJWUADAyYGGbx3CC%2BBclHBxhDBSvFx%2BHNzq%2BC1GtcRczUM6zt3n3uOlF6AJda5xX%2FY4GE3ovwdUQ04nUeEdWnqXZp9X%2BNwb8gPYCBIXAyRzow%3D%3D&source_type=1&pack_time=1552619694.46&active_extra=FHtDrXBYIEXKi8l%2BGw6CRVHt7luwmcIB9Wzy%2Brr9%2BcnR65Czv61mCT83X6a4RM8zO9gMrZ7HNLo4eXX53aR1eg%3D%3D";
}


@end