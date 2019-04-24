//
//  UploadCell.m
//  WGLKitDemo
//
//  Created by wugl on 2019/4/24.
//  Copyright © 2019 huya. All rights reserved.
//

#import "UploadCell.h"
#import "UIView+Extensions.h"
#import "UIControl+Block.h"

@interface UploadCell ()
@property (nonatomic, strong) UIButton *startBtn;
@end

@implementation UploadCell

- (void)dealloc {
    NSLog(@"");
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.nameL];
        [self.contentView addSubview:self.progressView];
        [self.progressView addSubview:self.progressLabel];
        [self.contentView addSubview:self.startBtn];
    }
    return self;
}

- (UILabel *)nameL {
    if (!_nameL) {
        _nameL = [[UILabel alloc] init];
        _nameL.textAlignment = NSTextAlignmentLeft;
        _nameL.font = [UIFont systemFontOfSize:16];
        _nameL.textColor = [UIColor redColor];
    }
    return _nameL;
}

- (UIButton *)startBtn {
    if (!_startBtn) {
        _startBtn = [[UIButton alloc] init];
        [_startBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        _startBtn.backgroundColor = [UIColor grayColor];
        [_startBtn setTitle:@"上传" forState:UIControlStateNormal];
        __weak typeof(self) weakSelf = self;
        [_startBtn addBlockForControlEvents:UIControlEventTouchUpInside block:^(id sender) {
            if (weakSelf.clickHandler) {
                weakSelf.clickHandler(weakSelf, weakSelf.filePath);
            }
        }];
    }
    return _startBtn;
}

- (WGLCircleProgressView *)progressView {
    if (!_progressView) {
        _progressView = [[WGLCircleProgressView alloc] initWithFrame:self.bounds];
        _progressView.circleLineColor = [UIColor grayColor];
        _progressView.circleLineWidth = 1.5;
        _progressView.userInteractionEnabled = NO;
    }
    return _progressView;
}

- (UILabel *)progressLabel {
    if (!_progressLabel) {
        _progressLabel = [[UILabel alloc] init];
        _progressLabel.textAlignment = NSTextAlignmentCenter;
        _progressLabel.font = [UIFont systemFontOfSize:13];
        _progressLabel.textColor = [UIColor redColor];
    }
    return _progressLabel;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.progressView.frame = CGRectMake([UIScreen mainScreen].bounds.size.width-100, 0, 50, 50);
    self.progressLabel.frame = self.progressView.bounds;
    self.startBtn.frame = CGRectMake(self.progressView.left-50, 0, 50, 50);
    self.nameL.frame = CGRectMake(20, 0, self.startBtn.left-20, self.contentView.frame.size.height);
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
}

@end
