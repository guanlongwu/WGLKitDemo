//
//  HYVideoSelector.m
//  HYVideoEditSDK
//
//  Created by wugl on 2019/4/11.
//  Copyright © 2019 WGLKit. All rights reserved.
//

#import "HYVideoSelector.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "UIDevice+DeviceInfo.h"
#import "UIDevice+UserDefaults.h"
#import "PSTAlertController.h"
#import "SVProgressHUD.h"

@interface HYVideoSelector () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@end

@implementation HYVideoSelector

+ (HYVideoSelector *)sharedSelector {
    static HYVideoSelector *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[[self class] alloc] init];
    });
    return instance;
}

#pragma mark - 打开选择器

- (void)showWithSender:(id)sender inController:(UIViewController *)controller finish:(nonnull HYVideoSelectorDidFinish)finish cancel:(nonnull HYVideoSelectorDidCancel)cancel {
    NSParameterAssert(controller != nil && [controller isKindOfClass:[UIViewController class]]);
    self.controller = controller;
    self.sender = sender;
    self.finishHandler = finish;
    self.cancelHandler = cancel;
    
    [self showAlertView];
}

- (void)showAlertView {
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        PSTAlertController *vc = [PSTAlertController alertControllerWithTitle:nil message:nil preferredStyle:PSTAlertControllerStyleActionSheet];
        [vc addAction:[PSTAlertAction actionWithTitle:@"拍摄视频" style:PSTAlertActionStyleDefault handler:^(PSTAlertAction *action) {
            [self presentImagePickViewControllerWithSourceType:UIImagePickerControllerSourceTypeCamera];
        }]];
        [vc addAction:[PSTAlertAction actionWithTitle:@"从相册中选择" style:PSTAlertActionStyleDefault handler:^(PSTAlertAction *action) {
            [self presentImagePickViewControllerWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        }]];
        [vc addAction:[PSTAlertAction actionWithTitle:@"取消" style:PSTAlertActionStyleCancel handler:^(PSTAlertAction *action) {
        }]];
        
        [vc showWithSender:self.sender controller:self.controller animated:YES completion:nil];
    }
    else {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"选择视频来源" preferredStyle:UIAlertControllerStyleActionSheet];
        
        //创建UIAlertAction对象，设置标题并添加到UIAlertController上
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:cancelAction];
        UIAlertAction *photpAction = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self presentImagePickViewControllerWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        }];
        [alertController addAction:photpAction];
        UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"拍摄视频" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self presentImagePickViewControllerWithSourceType:UIImagePickerControllerSourceTypeCamera];
        }];
        [alertController addAction:cameraAction];
        UIPopoverPresentationController *popoverPresentCtr = alertController.popoverPresentationController;
        popoverPresentCtr.barButtonItem = self.controller.navigationItem.rightBarButtonItem;
        
        if([UIDevice currentDevice].isPad) {
            //在ipad UIAlertController UIAlertControllerStyleActionSheet 不设置以下置会崩
            alertController.popoverPresentationController.sourceView = self.controller.view;
            alertController.popoverPresentationController.sourceRect = CGRectMake(0,0,1.0,1.0);
        }
        
        [self.controller presentViewController:alertController animated:YES completion:nil];
    }
}

//show Image PickView
- (BOOL)presentImagePickViewControllerWithSourceType:(UIImagePickerControllerSourceType) sourceType {
    if (![UIImagePickerController isSourceTypeAvailable:sourceType]) {
        [SVProgressHUD showErrorWithStatus:@"抱歉，当前设备不支持此操作"];
        return NO;
    }
    
    if (sourceType == UIImagePickerControllerSourceTypeCamera) {
        if (NO == [UIDevice isCameraAvailable]) {
            [SVProgressHUD showErrorWithStatus:@"抱歉，无法使用相机"];
            return NO;
        }
    }
    else {
        if (NO == [UIDevice isAssetsLibraryAvailable]) {
            [SVProgressHUD showErrorWithStatus:@"抱歉，无法访问相册"];
            return NO;
        }
    }
    
    UIImagePickerController *photoPicker = [[UIImagePickerController alloc] init];
    photoPicker.allowsEditing = YES;
    photoPicker.delegate = self;
    photoPicker.sourceType = sourceType;
    photoPicker.videoQuality = UIImagePickerControllerQualityTypeHigh;
    photoPicker.videoMaximumDuration = 10 * 60;
    photoPicker.mediaTypes = [[NSArray alloc] initWithObjects:(NSString *) kUTTypeMovie, nil];
    [self.controller presentViewController:photoPicker animated:YES completion:nil];
    return YES;
}

#pragma mark - delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    if([type isEqualToString:(NSString *)kUTTypeMovie]) {
        NSURL *url = [info objectForKey:UIImagePickerControllerMediaURL];
        NSString *urlPath = [url path];
        HYVideoAlbumAsset *asset = [[HYVideoAlbumAsset alloc] init];
        asset.videoPath = urlPath;
        if (self.finishHandler) {
            self.finishHandler(asset);
        }
        _finishHandler = nil;
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
    if (self.cancelHandler) {
        self.cancelHandler();
    }
    _cancelHandler = nil;
}

@end
