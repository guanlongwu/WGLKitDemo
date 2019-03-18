//
//  UIDeviceVC.m
//  WGLKitDemo
//
//  Created by wugl on 2019/3/18.
//  Copyright © 2019年 huya. All rights reserved.
//

#import "UIDeviceVC.h"

#import "UIDevice+CPU.h"
#import "UIDevice+DeviceInfo.h"
#import "UIDevice+DiskMemory.h"
#import "UIDevice+NetworkInfo.h"

@interface UIDeviceVC ()

@end

@implementation UIDeviceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 测试机：iphone 6s 64G
    NSUInteger cpuCount = [UIDevice currentDevice].cpuCount;    //2
    float cpuUsage = [UIDevice currentDevice].cpuUsage; //0.52190727
    
    double systemVersion = [UIDevice systemVersion];    //12.1
    NSString *stringWithUUID = [UIDevice stringWithUUID];   //295B9BF0-9F02-4FCE-8489-1BF1D50E366F
    BOOL isSimulator = [UIDevice currentDevice].isSimulator;    //NO
    BOOL isJailbroken = [UIDevice currentDevice].isJailbroken;  //NO
    NSString *machineModel = [UIDevice currentDevice].machineModel; //iPhone8,1
    NSString *machineModelName = [UIDevice currentDevice].machineModelName; //iPhone 6s
    
    int64_t diskSpace = [UIDevice currentDevice].diskSpace; //63989493760
    int64_t spaceM = diskSpace / 1024 / 1024 / 1024;
    
    int64_t diskSpaceFree = [UIDevice currentDevice].diskSpaceFree; //4909666304
    int64_t freeM = diskSpaceFree / 1024 / 1024 / 1024;
    
    int64_t diskSpaceUsed = [UIDevice currentDevice].diskSpaceUsed; //59079827456
    int64_t usedM = diskSpaceUsed / 1024 / 1024 / 1024;
    
    int64_t memoryTotal = [UIDevice currentDevice].memoryTotal; //2105016320
    int64_t memoryUsed = [UIDevice currentDevice].memoryUsed;   //1285947392
    int64_t memoryFree = [UIDevice currentDevice].memoryFree;   //44990464
    int64_t memoryActive = [UIDevice currentDevice].memoryActive;
    int64_t memoryInactive = [UIDevice currentDevice].memoryInactive;
    
    NSString *ipAddressWIFI = [UIDevice currentDevice].ipAddressWIFI;   //fe80::39:87:4bd4:5ff0
    NSString *ipAddressCell = [UIDevice currentDevice].ipAddressCell;   //10.253.33.7
    uint64_t networkTrafficBytes = [[UIDevice currentDevice] getNetworkTrafficBytes:YYNetworkTrafficTypeWIFI];  //4373847040
    
    NSLog(@"");
    
}



@end
