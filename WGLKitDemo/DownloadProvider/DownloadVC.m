//
//  DownloadVC.m
//  WGLKitDemo
//
//  Created by wugl on 2019/2/15.
//  Copyright © 2019年 huya. All rights reserved.
//

#import "DownloadVC.h"
#import "DownloadCell.h"
#import "WGLNetworkMonitor.h"
#import "Toast.h"
#import "SVProgressHUD.h"

@interface DownloadVC ()
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray <NSDictionary *>* infos;
@end

@implementation DownloadVC

- (void)dealloc {
    NSLog(@"");
    [[WGLNetworkMonitor sharedMonitor] stopMonitoring];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    
    /**
     TODO：
     这一块copy会强引用self，导致self没办法释放
     要对WGLNetworkMonitor的这个copy方法进行完善
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

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = (id<UITableViewDelegate>)self;
        _tableView.dataSource = (id<UITableViewDataSource>)self;
        [_tableView registerClass:[DownloadCell class] forCellReuseIdentifier:NSStringFromClass([DownloadCell class])];
    }
    return _tableView;
}

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

- (NSArray <NSDictionary *> *)infos {
    if (!_infos) {
        _infos =
        @[
          @{
              @"name" : @"火影忍者",
              @"url" : @"http://img.netbian.com/file/20120330/e15fca8315ae95771d1fd044ac69c467.jpg",
              },
          @{
              @"name" : @"鸣人",
              @"url" : @"http://gss0.baidu.com/7Po3dSag_xI4khGko9WTAnF6hhy/zhidao/pic/item/eac4b74543a98226a0e691358b82b9014a90ebf9.jpg",
              },
          @{
              @"name" : @"佐佐",
              @"url" : @"http://gss0.baidu.com/-Po3dSag_xI4khGko9WTAnF6hhy/zhidao/pic/item/4e4a20a4462309f71b4d36a8710e0cf3d7cad66e.jpg",
              },
          @{
              @"name" : @"广东雨神",
              @"url" : @"https://mms.msstatic.com/music/TjNwW2n5KJ.mp3",
              },
          @{
              @"name" : @"失落沙洲",
              @"url" : @"https://mms.msstatic.com/music/WyhNR2QsFX.mp3",
              }
          ];
    }
    return _infos;
}


@end
