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

#pragma mark - download

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
    
}

#pragma mark - WGLUploadProviderDataSource

- (NSURLRequest *)uploaderGetUploadURLRequest:(WGLUploadProvider *)ulProvider {
    NSURL *url = [NSURL URLWithString:@"xxx/upload/file"];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    [request setValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@", @"1a2b3c"] forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"v1" forHTTPHeaderField:@"api_version"];
    return request;
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
