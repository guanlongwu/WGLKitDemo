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
#import "WGLNetworkMonitor.h"
#import "WGLTrafficMonitor.h"

@interface DownloadVC ()
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UILabel *speedLabel;
@property (nonatomic, strong) NSArray <NSDictionary *>* infos;
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
        _speedLabel.font = [UIFont systemFontOfSize:16];
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

- (void)addTrafficMonitor {
    [[WGLTrafficMonitor sharedMonitor] startMonitoring];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getTrafficSpeed) name:WGLNetworkTrafficSpeedDidChangeNotification object:nil];
}

- (void)getTrafficSpeed {
    
    WGLNetworkReachabilityStatus status = [WGLNetworkMonitor sharedMonitor].networkReachabilityStatus;
    uint64_t wwanSpeed = 0;
    uint64_t wifiSpeed = 0;
    uint64_t allSpeed = [[WGLTrafficMonitor sharedMonitor] getNetworkTrafficSpeed:WGLNetworkTrafficTypeALL];
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
    
    NSString *traffic = [NSString stringWithFormat:@"网速 wifi:%llu kb/s, wwan:%llu kb/s, all:%llu kb/s", wifiSpeed, wwanSpeed, allSpeed];
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
