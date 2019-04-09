//
//  DownloadVC.m
//  WGLKitDemo
//
//  Created by wugl on 2019/2/15.
//  Copyright © 2019年 huya. All rights reserved.
//

#import "DownloadVC.h"
#import "DownloadCell.h"
#import "Toast.h"
#import "SVProgressHUD.h"
#import "UIView+Extensions.h"
#import "UIColor+Convertor.h"
#import "NSTimer+Block.h"

#import "WGLDownloadProvider.h"
#import "WGLFileCache.h"
#import "WGLNetworkMonitor.h"
#import "WGLTrafficMonitor.h"

@interface DownloadVC ()
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UILabel *speedLabel;
@property (nonatomic, strong) NSArray <NSDictionary *>* infos;
@property (nonatomic, strong) WGLDownloadProvider *downloadProvider;
@end

@implementation DownloadVC

- (void)dealloc {
    NSLog(@"");
    [[WGLNetworkMonitor sharedMonitor] stopMonitoring];
    [[WGLTrafficMonitor sharedMonitor] stopMonitoring];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.speedLabel];
    
    [self addNetworkMonitor];
    [self addTrafficMonitor];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 120, self.view.width, self.view.height - 120) style:UITableViewStylePlain];
        _tableView.delegate = (id<UITableViewDelegate>)self;
        _tableView.dataSource = (id<UITableViewDataSource>)self;
        [_tableView registerClass:[DownloadCell class] forCellReuseIdentifier:NSStringFromClass([DownloadCell class])];
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

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.infos.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DownloadCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([DownloadCell class])];
    if (!cell) {
        cell = [[DownloadCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([DownloadCell class])];
    }
    __weak typeof(self) weakSelf = self;
    cell.clickHandler = ^(DownloadCell *cell, NSString *urlString) {
        [weakSelf downloadURL:urlString forCell:cell];
    };
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell isKindOfClass:[DownloadCell class]]) {
        DownloadCell *dCell = (DownloadCell *)cell;
        NSDictionary *info = self.infos[indexPath.row];
        dCell.nameL.text = info[@"name"];
        NSString *url = info[@"url"];
        dCell.url = url;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    NSDictionary *info = self.infos[indexPath.row];
    NSString *url = info[@"url"];
    DownloadCell *cell = (DownloadCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    [self downloadURL:url forCell:cell];
}

#pragma mark - download

- (WGLDownloadProvider *)downloadProvider {
    if (!_downloadProvider) {
        _downloadProvider = [WGLDownloadProvider sharedProvider];
        _downloadProvider.delegate = (id<WGLDownloadProviderDelegate>)self;
        _downloadProvider.dataSource = (id<WGLDownloadProviderDataSource>)self;
    }
    return _downloadProvider;
}

- (void)downloadURL:(NSString *)url forCell:(DownloadCell *)cell {
    WGLDownloadState state = [self.downloadProvider downloadStateForURL:url];
    if (state == WGLDownloadStateDownloading) {
        //暂停下载
        
        //判断网络是否可用
        if (NO == [WGLNetworkMonitor sharedMonitor].isReachable) {
            cell.progressLabel.text = @"无网";
            return;
        }
        [self.downloadProvider cancelDownloadURL:url];
        
    }
    else {
        //开始下载
        BOOL exist = [[WGLFileCache sharedCache] cacheExistForURLString:url];
        if (exist) {
            //有缓存，则取缓存
            cell.progressView.progress = 1;
            cell.progressLabel.text = @"完成";
        }
        else {
            //判断网络是否可用
            if (NO == [WGLNetworkMonitor sharedMonitor].isReachable) {
                cell.progressLabel.text = @"无网";
                return;
            }
            cell.progressLabel.text = @"等待下载";
            
            /*
             [self.downloadProvider downloadWithURL:url];
             */
            
            [self.downloadProvider downloadWithURL:url startBlock:^(WGLDownloadProvider *dlProvider, NSString *_urlString) {
                
            } progressBlock:^(WGLDownloadProvider *dlProvider, NSString *_urlString, uint64_t receiveLength, uint64_t totalLength) {
                
                int proPercent = (int)(receiveLength * 100 / totalLength);
                float progress = (float)receiveLength / (float)totalLength;
                cell.progressView.progress = progress;
                cell.progressLabel.text = [NSString stringWithFormat:@"%d%%", proPercent];
            } successBlock:^(WGLDownloadProvider *dlProvider, NSString *_urlString, NSString *filePath) {
                
                cell.progressLabel.text = @"完成";
            } failBlock:^(WGLDownloadProvider *dlProvider, NSString *_urlString, WGLDownloadErrorType errorType) {
                
                NSString *errorMsg = [self errorMsg:errorType];
                NSLog(@"error msg : %@", errorMsg);
                cell.progressLabel.text = errorMsg;
            }];
            
        }
    }
}

#pragma mark - WGLDownloadProviderDataSource / delegate

//是否已缓存
- (BOOL)downloadProvider:(WGLDownloadProvider *)dlProvider existCache:(NSString *)urlString {
    BOOL exist = [[WGLFileCache sharedCache] cacheExistForURLString:urlString];
    return exist;
}

//文件下载的存放目录
- (NSString *)downloadProvider:(WGLDownloadProvider *)dlProvider getDirectory:(NSString *)urlString {
    NSString *dir = [[WGLFileCache sharedCache] getDefaultCacheDirectory];
    return dir;
}

//文件缓存的唯一key
- (NSString *)downloadProvider:(WGLDownloadProvider *)dlProvider cacheFileName:(NSString *)urlString {
    NSString *cacheName = [[WGLFileCache sharedCache] cacheFileNameForURLString:urlString];
    return cacheName;
}

//下载开始
- (void)downloadDidStart:(WGLDownloadProvider *)dlProvider urlString:(NSString *)urlString {
    
}

//下载中
- (void)downloader:(WGLDownloadProvider *)dlProvider urlString:(NSString *)urlString didReceiveLength:(uint64_t)receiveLength totalLength:(uint64_t)totalLength {
    DownloadCell *cell = [self cellForUrl:urlString];
    int progress = (int)(receiveLength * 100 / totalLength);
    cell.progressView.progress = progress;
    cell.progressLabel.text = [NSString stringWithFormat:@"%d%%", progress];
}

//下载成功
- (void)downloadDidFinish:(WGLDownloadProvider *)dlProvider urlString:(NSString *)urlString filePath:(NSString *)filePath {
    DownloadCell *cell = [self cellForUrl:urlString];
    cell.progressLabel.text = @"完成";
}

//下载失败
- (void)downloadDidFail:(WGLDownloadProvider *)dlProvider urlString:(NSString *)urlString errorType:(WGLDownloadErrorType)errorType {
    DownloadCell *cell = [self cellForUrl:urlString];
    NSString *errorMsg = [self errorMsg:errorType];
    NSLog(@"error msg : %@", errorMsg);
    cell.progressLabel.text = errorMsg;
}

- (NSString *)errorMsg:(WGLDownloadErrorType)errorType {
    NSString *errorMsg = @"";
    switch (errorType) {
            case WGLDownloadErrorTypeHTTPError:
            errorMsg = @"HTTP请求出错";
            break;
            case WGLDownloadErrorTypeInvalidURL:
            errorMsg = @"URL不合法";
            break;
            case WGLDownloadErrorTypeInvalidRequestRange:
            errorMsg = @"下载范围不对";
            break;
            case WGLDownloadErrorTypeInvalidDirectory:
            errorMsg = @"下载目录出错";
            break;
            case WGLDownloadErrorTypeNotEnoughFreeSpace:
            errorMsg = @"磁盘空间不足";
            break;
            case WGLDownloadErrorTypeCacheInDiskError:
            errorMsg = @"下载成功缓存失败";
            break;
        default:
            break;
    }
    return errorMsg;
}

//获取对应cell
- (DownloadCell *)cellForUrl:(NSString *)urlString {
    for (int i=0; i<self.infos.count; i++) {
        DownloadCell *cell = (DownloadCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        if ([cell.url isEqualToString:urlString]) {
            return cell;
        }
    }
    return nil;
}

#pragma mark - network monitor

- (void)addNetworkMonitor {
    /**
     TODO：
     这一块copy会强引用self，导致self没办法释放
     要对WGLNetworkMonitor的这个copy方法进行完善,
     建议改为通知的方式
     */
    [[WGLNetworkMonitor sharedMonitor] startMonitoring];
    [WGLNetworkMonitor sharedMonitor].networkStatusChangeBlock = ^(WGLNetworkReachabilityStatus status) {
        NSString *title = @"";
        switch (status) {
                case WGLNetworkReachabilityStatusUnknown:
                title = @"未知网络";
                break;
                case WGLNetworkReachabilityStatusNotReachable:
                title = @"断网";
                break;
                case WGLNetworkReachabilityStatusReachableViaWiFi:
                title = @"WiFi";
                break;
                case WGLNetworkReachabilityStatusReachableViaWWAN: {
                    WGLNetworkOperator operator = [WGLNetworkMonitor sharedMonitor].networkOperator;
                    NSString *desc = @"unknow";
                    switch (operator) {
                            case WGLNetworkOperatorUnknown:
                            desc = @"未知运营商";
                            break;
                            case WGLNetworkOperatorChinaMobile:
                            desc = @"中国移动";
                            break;
                            case WGLNetworkOperatorChinaUnicom:
                            desc = @"中国联通";
                            break;
                            case WGLNetworkOperatorChinaTelecon:
                            desc = @"中国电信";
                            break;
                            case WGLNetworkOperatorChinaTietong:
                            desc = @"中国铁通";
                            break;
                        default:
                            break;
                    }
                    WGLNetworkAccessTech accessTech = [WGLNetworkMonitor sharedMonitor].networkAccessTech;
                    NSString *desc2 = @"unknow";
                    switch (accessTech) {
                            case WGLNetworkAccessTechLTE:
                            desc2 = @"LTE";
                            break;
                            case WGLNetworkAccessTechGPRS:
                            desc2 = @"GPRS";
                            break;
                            case WGLNetworkAccessTechEdge:
                            desc2 = @"Edge";
                            break;
                            case WGLNetworkAccessTechHRPD:
                            desc2 = @"HRPD";
                            break;
                            case WGLNetworkAccessTechHSDPA:
                            desc2 = @"HSDPA";
                            break;
                            case WGLNetworkAccessTechHSUPA:
                            desc2 = @"HSUPA";
                            break;
                            case WGLNetworkAccessTechWCDMA:
                            desc2 = @"WCDMA";
                            break;
                            case WGLNetworkAccessTechCDMA1x:
                            desc2 = @"CDMA1x";
                            break;
                        default:
                            break;
                    }
                    
                    title = [NSString stringWithFormat:@"移动网络 : %@-%@", desc, desc2];
                }
                break;
            default:
                break;
        }
        self.title = title;
        
        
        //Toast使用
        CSToastStyle *style = [[CSToastStyle alloc] initWithDefaultStyle];
        style.verticalPadding = 30;
        style.horizontalPadding = 0;
        style.titleFont = [UIFont systemFontOfSize:16];
        style.messageFont = [UIFont systemFontOfSize:20];
        style.titleAlignment = NSTextAlignmentCenter;
        style.messageAlignment = NSTextAlignmentCenter;
        style.cornerRadius = 30;
        
        __weak typeof(self) weakSelf = self;
        [self.view makeToast:title duration:3 position:CSToastPositionCenter title:@"网络状态" image:[UIImage imageNamed:@"originImage.jpg"] style:style completion:^(BOOL didTap) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf.view makeToast:@"Toast完成block" duration:3 position:CSToastPositionCenter];
        }];
        
        //SVProgressHUD
//        [SVProgressHUD setSuccessImage:nil];
//        [SVProgressHUD showSuccessWithStatus:title];
        
    };
}

#pragma mark - Traffic Monitor

- (void)addTrafficMonitor {
    [[WGLTrafficMonitor sharedMonitor] startMonitoring];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getTrafficSpeed) name:WGLNetworkTrafficSpeedDidChangeNotification object:nil];
}

- (void)getTrafficSpeed {
    
    WGLNetworkReachabilityStatus status = [WGLNetworkMonitor sharedMonitor].networkReachabilityStatus;
    uint64_t wwanSpeed = 0;
    uint64_t wifiSpeed = 0;
    switch (status) {
        case WGLNetworkReachabilityStatusUnknown: {
            
        }
            break;
        case WGLNetworkReachabilityStatusNotReachable: {
            
        }
            break;
        case WGLNetworkReachabilityStatusReachableViaWWAN: {
            wwanSpeed = [[WGLTrafficMonitor sharedMonitor] getNetworkTrafficSpeed:WGLNetworkTrafficTypeWWAN];
        }
            break;
        case WGLNetworkReachabilityStatusReachableViaWiFi: {
            wifiSpeed = [[WGLTrafficMonitor sharedMonitor] getNetworkTrafficSpeed:WGLNetworkTrafficTypeWIFI];
        }
            break;
        default:
            break;
    }
//    uint64_t allSpeed = [[WGLTrafficMonitor sharedMonitor] getNetworkTrafficSpeed:WGLNetworkTrafficTypeALL];
    uint64_t allTrafficBytes = [[WGLTrafficMonitor sharedMonitor] getNetworkTrafficBytes:WGLNetworkTrafficTypeALL] / 1024;
    
    NSString *traffic = [NSString stringWithFormat:@"网速 wifi:%llu KB/s, wwan:%llu KB/s, 累积流量 %llu KB", wifiSpeed, wwanSpeed, allTrafficBytes];
    self.speedLabel.text = traffic;
    
}

#pragma mark - model

- (NSArray <NSDictionary *> *)infos {
    if (!_infos) {
        _infos =
        @[
          @{
              @"name" : @"火影忍者.jpg",
              @"url" : @"http://img.netbian.com/file/20120330/e15fca8315ae95771d1fd044ac69c467.jpg",
              },
          @{
              @"name" : @"佐佐.jpg",
              @"url" : @"http://gss0.baidu.com/-Po3dSag_xI4khGko9WTAnF6hhy/zhidao/pic/item/4e4a20a4462309f71b4d36a8710e0cf3d7cad66e.jpg",
              },
          @{
              @"name" : @"女孩讲述被鬼附身（上）.mp3",
              @"url" : @"https://mms.msstatic.com/music/wZkE7ERBKH.mp3",
              },
          @{
              @"name" : @"女孩讲述被鬼附身（下）.mp3",
              @"url" : @"https://mms.msstatic.com/music/4ZQwAazJQK.mp3",
              },
          @{
              @"name" : @"骨折女孩讲述离奇经历（上）.mp3",
              @"url" : @"https://mms.msstatic.com/music/35aCMANk7E.mp3",
              },
          @{
              @"name" : @"骨折女孩讲述离奇经历（下）.mp3",
              @"url" : @"https://mms.msstatic.com/music/6mdms8y7aM.mp3",
              },
          @{
              @"name" : @"碟仙的亲身体验.mp3",
              @"url" : @"https://mms.msstatic.com/music/AkMiN4nAPh.mp3",
              },
          @{
              @"name" : @"成都.mp3",
              @"url" : @"https://mms.msstatic.com/music/p8k66cBkCW.mp3",
              },
          @{
              @"name" : @"失落沙洲.mp3",
              @"url" : @"https://mms.msstatic.com/music/WyhNR2QsFX.mp3",
              },
          @{
              @"name" : @"匆匆那年.mp3",
              @"url" : @"https://mms.msstatic.com/music/xZ4N3wcG5K.mp3",
              },
          ];
    }
    return _infos;
}


@end
