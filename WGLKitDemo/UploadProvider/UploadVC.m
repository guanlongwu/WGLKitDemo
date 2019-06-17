//
//  UploadVC.m
//  WGLKitDemo
//
//  Created by wugl on 2019/4/24.
//  Copyright © 2019 huya. All rights reserved.
//

#import "UploadVC.h"
#import "UIView+Extensions.h"
#import "UIColor+Convertor.h"
#import "UIControl+Block.h"
#import "HYVideoSelector.h"
#import "SVProgressHUD.h"

#import "WGLUploadProvider.h"
#import "UploadCell.h"

@interface UploadVC ()
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UILabel *speedLabel;
@property (nonatomic, strong) NSMutableArray <NSString *>* filePaths;
@property (nonatomic, strong) WGLUploadProvider *uploadProvider;
@property (nonatomic, strong) UIButton *selectFileBtn;
@end

@implementation UploadVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.filePaths = [NSMutableArray array];
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.speedLabel];
    [self.view addSubview:self.selectFileBtn];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 120, self.view.width, self.view.height - 120) style:UITableViewStylePlain];
        _tableView.delegate = (id<UITableViewDelegate>)self;
        _tableView.dataSource = (id<UITableViewDataSource>)self;
        [_tableView registerClass:[UploadCell class] forCellReuseIdentifier:NSStringFromClass([UploadCell class])];
    }
    return _tableView;
}

- (UILabel *)speedLabel {
    if (!_speedLabel) {
        _speedLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 80, self.view.width, 40)];
        _speedLabel.textAlignment = NSTextAlignmentCenter;
        _speedLabel.font = [UIFont systemFontOfSize:14];
        _speedLabel.textColor = [UIColor blueColor];
        _speedLabel.backgroundColor = [UIColor colorWithHexString:@"0xf2f2f2"];
    }
    return _speedLabel;
}

- (UIButton *)selectFileBtn {
    if (!_selectFileBtn) {
        _selectFileBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.width - 100, self.view.height / 2, 100, 100)];
        _selectFileBtn.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
        _selectFileBtn.clipsToBounds = YES;
        _selectFileBtn.layer.cornerRadius = 50;
        [_selectFileBtn setTitle:@"选视频上传" forState:UIControlStateNormal];
        [_selectFileBtn setTitleColor:[UIColor colorWithHexString:@"0xff0000"] forState:UIControlStateNormal];
        __weak typeof(self) weakSelf = self;
        [_selectFileBtn addBlockForControlEvents:UIControlEventTouchUpInside block:^(id sender) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf selectVideo];
        }];
    }
    return _selectFileBtn;
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.filePaths.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UploadCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UploadCell class])];
    if (!cell) {
        cell = [[UploadCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([UploadCell class])];
    }
    __weak typeof(self) weakSelf = self;
    cell.clickHandler = ^(UploadCell *cell, NSString *filePath) {
        [weakSelf uploadFilePath:filePath forCell:cell];
    };
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell isKindOfClass:[UploadCell class]]) {
        UploadCell *dCell = (UploadCell *)cell;
        NSString *filePath = self.filePaths[indexPath.row];
        dCell.filePath = filePath;
        dCell.nameL.text = filePath.lastPathComponent;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    NSString *filePath = self.filePaths[indexPath.row];
    UploadCell *cell = (UploadCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    [self uploadFilePath:filePath forCell:cell];
}

#pragma mark - upload

- (WGLUploadProvider *)uploadProvider {
    if (!_uploadProvider) {
        _uploadProvider = [WGLUploadProvider sharedProvider];
        _uploadProvider.delegate = (id<WGLUploadProviderDelegate>)self;
        _uploadProvider.dataSource = (id<WGLUploadProviderDataSource>)self;
        _uploadProvider.maxConcurrentUploadCount = 5;
    }
    return _uploadProvider;
}

- (void)uploadFilePath:(NSString *)filePath forCell:(UploadCell *)cell {
    [self.uploadProvider uploadWithFilePath:filePath start:^(WGLUploadProvider *ulProvider, WGLUploadFileInfo *fileInfo) {
        
    } progress:^(WGLUploadProvider *ulProvider, WGLUploadFileInfo *fileInfo) {
        
    } success:^(WGLUploadProvider *ulProvider, WGLUploadFileInfo *fileInfo) {
        
    } failure:^(WGLUploadProvider *ulProvider, WGLUploadFileInfo *fileInfo, NSError *error) {
        
    } cancel:^(WGLUploadProvider *ulProvider, WGLUploadFileInfo *fileInfo) {
        
    }];
}

#pragma mark - WGLUploadProviderDataSource

//上传urlrequest
- (NSURLRequest *)uploadProviderGetUploadURLRequest:(WGLUploadProvider *)ulProvider {
    NSURL *url = [NSURL URLWithString:@"xxx/upload/file"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    [request setValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@", @"1a2b3c"] forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"v1" forHTTPHeaderField:@"api_version"];
    return request;
}

//文件上传之前的所需参数
- (void)uploadProviderGetParamsBeforeUpload:(WGLUploadProvider *)ulProvider fileInfo:(WGLUploadFileInfo *)fileInfo completion:(WGLGetFileParamsBeforeUploadCompletion)completion {
    //异步获取到上传参数后，执行回调
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSDictionary *map
        = @{
            @"name":@"wugl",
            @"filePath" : fileInfo.filePath,
            @"fileName" : fileInfo.fileName,
            @"fileSize" : @(fileInfo.fileSize),
            @"fragmentCount" : @(fileInfo.fragmentCount),
            @"uploadProgress" : @(fileInfo.uploadProgress),
            };
        completion(map);
    });
}

//上传分片所需参数
- (NSDictionary *)uploadProviderGetChunkUploadParams:(WGLUploadProvider *)ulProvider params:(NSDictionary *)params chunkIndex:(NSInteger)chunkIndex {
    NSMutableDictionary *map = [NSMutableDictionary dictionaryWithDictionary:params];
    [map setObject:@(chunkIndex) forKey:@"chunkIndex"];
    return map;
}

//下载开始
- (void)uploadProviderDidStart:(WGLUploadProvider *)ulProvider fileInfo:(WGLUploadFileInfo *)fileInfo {
    NSLog(@"----上传开始：fileName:%@, totalCount:%ld, progress:%f, uploadedSize:%ld \n", fileInfo.fileName, (long)fileInfo.fragmentCount, fileInfo.uploadProgress, fileInfo.uploadedSize);
}

//上传中
- (void)uploadProviderUploading:(WGLUploadProvider *)ulProvider fileInfo:(WGLUploadFileInfo *)fileInfo {
    NSLog(@"----上传中：fileName:%@, totalCount:%ld, progress:%f, uploadedSize:%ld \n", fileInfo.fileName, (long)fileInfo.fragmentCount, fileInfo.uploadProgress, fileInfo.uploadedSize);
    [SVProgressHUD showProgress:fileInfo.uploadProgress];
}

//上传成功
- (void)uploadProviderDidFinish:(WGLUploadProvider *)ulProvider fileInfo:(WGLUploadFileInfo *)fileInfo {
    NSLog(@"----上传成功：fileName:%@, totalCount:%ld, progress:%f, uploadedSize:%ld", fileInfo.fileName, (long)fileInfo.fragmentCount, fileInfo.uploadProgress, fileInfo.uploadedSize);
    [SVProgressHUD showSuccessWithStatus:@"上传成功"];
}

//上传失败
- (void)uploadProviderDidFailure:(WGLUploadProvider *)ulProvider fileInfo:(WGLUploadFileInfo *)fileInfo error:(NSError *)error {
    NSLog(@"----上传失败：fileName:%@, totalCount:%ld, progress:%f, uploadedSize:%ld, erro:%@", fileInfo.fileName, (long)fileInfo.fragmentCount, fileInfo.uploadProgress, fileInfo.uploadedSize, error.description);
    [SVProgressHUD showErrorWithStatus:@"上传失败"];
}

//上传取消
- (void)uploadProviderDidCancel:(WGLUploadProvider *)ulProvider fileInfo:(WGLUploadFileInfo *)fileInfo {
    NSLog(@"----上传取消：fileName:%@, totalCount:%ld, progress:%f, uploadedSize:%ld", fileInfo.fileName, (long)fileInfo.fragmentCount, fileInfo.uploadProgress, fileInfo.uploadedSize);
    [SVProgressHUD showErrorWithStatus:@"取消上传"];
}

#pragma mark - 选相册

- (void)selectVideo {
    [[HYVideoSelector sharedSelector] showWithSender:self inController:self finish:^(HYVideoAlbumAsset * _Nonnull asset) {
        [self.filePaths addObject:asset.videoPath];
        [self.tableView reloadData];
    } cancel:^{
        
    }];
}

@end
