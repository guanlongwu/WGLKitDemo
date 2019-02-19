//
//  DownloadVC.m
//  WGLKitDemo
//
//  Created by wugl on 2019/2/15.
//  Copyright © 2019年 huya. All rights reserved.
//

#import "DownloadVC.h"
#import "DownloadCell.h"

@interface DownloadVC ()
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray <NSDictionary *>* infos;
@end

@implementation DownloadVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
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
              @"name" : @"SegmentView文件",
              @"url" : @"https://github.com/guanlongwu/WGLSegmentView",
              },
          @{
              @"name" : @"DownloadProvider文件",
              @"url" : @"https://github.com/guanlongwu/WGLDownloadProvider",
              },
          @{
              @"name" : @"CircleProgressView文件",
              @"url" : @"https://github.com/guanlongwu/WGLCircleProgressView",
              },
          @{
              @"name" : @"DesignPattern文件",
              @"url" : @"https://github.com/guanlongwu/Design-Pattern-For-iOS",
              }
          ];
    }
    return _infos;
}


@end
