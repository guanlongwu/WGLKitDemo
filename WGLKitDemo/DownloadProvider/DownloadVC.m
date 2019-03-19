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
    
    [[WGLNetworkMonitor sharedMonitor] startMonitoring];
    [WGLNetworkMonitor sharedMonitor].networkStatusChangeBlock = ^(WGLNetworkReachabilityStatus status) {
        switch (status) {
            case WGLNetworkReachabilityStatusUnknown:
                self.title = @"未知网络";
                break;
            case WGLNetworkReachabilityStatusNotReachable:
                self.title = @"断网";
                break;
            case WGLNetworkReachabilityStatusReachableViaWiFi:
                self.title = @"WiFi";
                break;
            case WGLNetworkReachabilityStatusReachableViaWWAN: {
                WGLNetworkOperator operator = [WGLNetworkMonitor sharedMonitor].networkOperator;
                NSString *desc = @"";
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
                self.title = [NSString stringWithFormat:@"移动网络 : %@", desc];
            }
                break;
            default:
                break;
        }
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
