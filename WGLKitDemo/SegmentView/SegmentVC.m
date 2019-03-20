//
//  SegmentVC.m
//  WGLKitDemo
//
//  Created by wugl on 2019/2/15.
//  Copyright © 2019年 huya. All rights reserved.
//

#import "SegmentVC.h"
#import "UIControl+Block.h"

#import "WGLSegmentView.h"
#import "SubSegmentViewController.h"

@interface SegmentVC ()
@property (nonatomic, strong) WGLSegmentView *segmentView;
@property (nonatomic, strong) NSMutableArray <WGLSubSegmentBaseViewController *>* subSegmentVCs;
@property (nonatomic, weak) SubSegmentViewController *curSegmentVC;
@end

@implementation SegmentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.segmentView];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 80, 120, 50)];
    btn.backgroundColor = [UIColor grayColor];
    [btn setTintColor:[UIColor whiteColor]];
    btn.titleLabel.font = [UIFont systemFontOfSize:18];
    [btn setTitle:@"reloadData" forState:UIControlStateNormal];
    [self.view addSubview:btn];
    __weak typeof(self) weakSelf = self;
    [btn addBlockForControlEvents:UIControlEventTouchUpInside block:^(id sender) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf.curSegmentVC) {
            strongSelf.curSegmentVC.isDataEmpty = !(strongSelf.curSegmentVC.isDataEmpty);
            [strongSelf.curSegmentVC.tableView reloadData];
        }
    }];
}

#pragma mark - 分页

- (WGLSegmentView *)segmentView {
    if (!_segmentView) {
        _segmentView = [[WGLSegmentView alloc] initWithFrame:CGRectMake(0, AspectFakeNavBarHeight, HYScreenWidth, HYScreenHeight-AspectFakeNavBarHeight)];
        _segmentView.dataSource = (id<WGLSegmentViewDataSource>)self;
        _segmentView.delegate = (id<WGLSegmentViewDelegate>)self;
    }
    return _segmentView;
}

#pragma mark - HYSegmentViewDataSource

- (NSInteger)numberOfSectionsInSegmentView:(WGLSegmentView *)segmentView {
    return 1;
}

- (NSInteger)segmentView:(WGLSegmentView *)segmentView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (CGFloat)segmentView:(WGLSegmentView *)segmentView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 150;
}

- (UITableViewCell *)segmentView:(WGLSegmentView *)segmentView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    if (indexPath.section == 0) {
        cell = [segmentView.mainTableView dequeueReusableCellWithIdentifier:@"ide"];
    }
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ide"];
    }
    return cell;
}

- (void)segmentView:(WGLSegmentView *)segmentView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.backgroundColor = indexPath.row % 2 == 0 ? [UIColor yellowColor] : [UIColor grayColor];
}

- (BOOL)segmentView:(WGLSegmentView *)segmentView isShouldRecognizeSimultaneously:(NSIndexPath *)indexPath
{
    return (indexPath.row == 0 && indexPath.section == 0)? NO : YES;
}

//分页控件
- (NSInteger)numberOfTitlesInSegmentView:(WGLSegmentView *)segmentView {
    return self.segmentTitles.count;
}

- (NSString *)segmentView:(WGLSegmentView *)segmentView titleForIndex:(NSInteger)index {
    if (index >= 0 && index < self.segmentTitles.count) {
        return [NSString stringWithFormat:@"    %@    ", self.segmentTitles[index]];
    }
    return nil;
}

- (CGFloat)heightForTabBarViewInSegmentView:(WGLSegmentView *)segmentView {
    return 45;
}

- (WGLSubSegmentBaseViewController *)segmentView:(WGLSegmentView *)segmentView viewControllerForIndex:(NSInteger)index {
    if (index >= 0 && index < self.subSegmentVCs.count) {
        return self.subSegmentVCs[index];
    }
    return nil;
}

- (void)segmentView:(WGLSegmentView *)segmentView didDisplaySegmentVC:(WGLSubSegmentBaseViewController *)segmentVC forIndex:(NSInteger)index {
    segmentVC.view.backgroundColor = (index % 2 == 0) ? [UIColor redColor] : [UIColor blueColor];
    self.curSegmentVC = segmentVC;
}

- (NSMutableArray <WGLSubSegmentBaseViewController *>*)subSegmentVCs {
    if (!_subSegmentVCs) {
        NSMutableArray *list = [NSMutableArray array];
        for (int i=0; i<self.segmentTitles.count; i++) {
            SubSegmentViewController *subVC = [[SubSegmentViewController alloc] init];
            [list addObject:subVC];
        }
        _subSegmentVCs = [list mutableCopy];
    }
    return _subSegmentVCs;
}

- (NSMutableArray <NSString *>*)segmentTitles {
    return [@[
              @"YY", @"HUYA", @"BIGO"
              ] mutableCopy];
}

@end
