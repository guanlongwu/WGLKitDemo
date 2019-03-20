//
//  SubSegmentViewController.m
//  WGLKitDemo
//
//  Created by wugl on 2019/2/14.
//  Copyright © 2019年 huya. All rights reserved.
//

#import "SubSegmentViewController.h"
#import "UIColor+Convertor.h"
#import "NSArray+Safe.h"
#import "Toast.h"
#import "UIScrollView+EmptyDataSet.h"

@interface SubSegmentViewController () <DZNEmptyDataSetDelegate, DZNEmptyDataSetSource>
@property (nonatomic, strong) NSArray <NSString *> *titles;
@end

@implementation SubSegmentViewController
@synthesize tableView = _tableView;

- (void)dealloc {
    [self.tableView setEmptyDataSetSource:nil];
    [self.tableView setEmptyDataSetDelegate:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isDataEmpty = YES;
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = (id<UITableViewDelegate>)self;
        _tableView.dataSource = (id<UITableViewDataSource>)self;
        [_tableView setEmptyDataSetDelegate:(id<DZNEmptyDataSetDelegate>)self];
        [_tableView setEmptyDataSetSource:(id<DZNEmptyDataSetSource>)self];
        [self.view addSubview:_tableView];
        
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
    }
    return _tableView;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.isDataEmpty ? 0 : 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titles.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"iddd"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:@"iddd"];
        UILabel *label = [[UILabel alloc] initWithFrame:cell.contentView.bounds];
        label.textColor = [UIColor blackColor];
        label.tag = 1001;
        [cell.contentView addSubview:label];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.backgroundColor = indexPath.row % 2 == 0 ? [UIColor grayColor] : [UIColor whiteColor];
    UILabel *label = [cell.contentView viewWithTag:1001];
    label.frame = cell.contentView.bounds;
    if (label) {
        label.text = [self.titles safeObjectAtIndex:indexPath.row];// [NSString stringWithFormat:@"cell index is %ld", (long)indexPath.row];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
}

#pragma mark - DZNEmptyDataSource

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    return YES;
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    UIColor *forColor = [UIColor colorWithRGB:0xff0000];//[UIColor colorWithHexString:@"0xff0000"];
    NSDictionary *attributesDefault =
  @{
    NSFontAttributeName: [UIFont systemFontOfSize:15.0f],
    NSForegroundColorAttributeName:forColor
    };
    
    UIColor *forColor2 = [UIColor colorWithRGB:0xbd9b6f];
    //[UIColor colorWithHexString:@"0xbd9b6f"]
    NSDictionary *attributesHighlight =
  @{
    NSFontAttributeName: [UIFont systemFontOfSize:20.0f],
    NSForegroundColorAttributeName: forColor2,
    NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle)
    };
    
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] init];
    NSAttributedString *appendStr = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"没找到与之相关的歌曲\n可到"] attributes:attributesDefault];
    [title appendAttributedString:appendStr];
    
    appendStr = [[NSAttributedString alloc] initWithString:@"maimai.huya.com" attributes:attributesHighlight];
    [title appendAttributedString:appendStr];
    
    appendStr = [[NSAttributedString alloc] initWithString:@"进行上传" attributes:attributesDefault];
    [title appendAttributedString:appendStr];
    
    return title;
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    NSAttributedString *desc = [[NSAttributedString alloc] initWithString:@"~描述~"];
    return desc;
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"DataEmpty_WUGU"];
}

- (UIColor *)imageTintColorForEmptyDataSet:(UIScrollView *)scrollView {
    return nil;
}

- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state {
    NSAttributedString *btnTitle = [[NSAttributedString alloc] initWithString:@"~btn文案~"];
    return btnTitle;
}

- (UIImage *)buttonImageForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state {
    return nil;
}

- (void)emptyDataSet:(UIScrollView *)scrollView didTapButton:(UIButton *)button {
    [self.view makeToast:@"点击了空占位图button" duration:2 position:CSToastPositionCenter];
}


#pragma mark - data

- (NSArray <NSString *> *)titles {
    if (!_titles) {
        _titles =
        [@[
           @"UIImage", @"NSString", @"NSTimer", @"NSData",
           @"NSFileManager", @"NSDate", @"UIDevice", @"UIScreen",
           @"NSArray", @"NSDictionary", @"UIControl", @"UIGestureRecognizer",
           @"UIView", @"NSBundle", @"UIScrollView", @"UIColor",
           ] mutableCopy];
    }
    return _titles;
}

/**
 DZNEmptyDataSet使用总结：
 必须在@interface xx:xx_super <DZNEmptyDataSetDelegate, DZNEmptyDataSetSource>
 否则不会显示空数据占位图
 如果没有上面的写法，尽管
 [_tableView setEmptyDataSetSource:(id<DZNEmptyDataSetSource>)self];
 也是不会显示。
 */



@end
