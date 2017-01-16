//
//  TFWebProgress.m
//  TFFinder
//
//  Created by apple on 16/12/30.
//  Copyright © 2016年 legentec. All rights reserved.
//

#import "TFWebProgress.h"

@interface TFWebProgress ()

@property (strong, nonatomic) UIView *progressView;

@property (assign, nonatomic) CGFloat progress;
@property (assign, nonatomic) BOOL didFinish;

@end

@implementation TFWebProgress

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)start {
    // 没有设置宽度或高度，不能执行动画
    if (self.bounds.size.width==0 || self.bounds.size.height==0) return;
    
    self.progressView = nil;
    self.progress = 0.0;
    self.didFinish = NO;
    [self addSubview:self.progressView];
    [self doAnimation];
}
- (void)finish {
    self.didFinish = YES;
}

- (void)doAnimation {
    if (self.progress >= 1.0) {
        self.progress = 1.0;
        self.didFinish = YES;
    }
    self.progress += self.bounds.size.width/100000.0;
    [UIView animateWithDuration:0.05 animations:^{
        self.progressView.frame = CGRectMake(0, 0, self.bounds.size.width*self.progress, self.bounds.size.height);
    } completion:^(BOOL finished) {
        if (!self.didFinish) [self doAnimation];// 没有结束，继续加载动画
        else {// 结束了
            [UIView animateWithDuration:0.3 animations:^{
                self.progressView.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
            } completion:^(BOOL finished) {
                self.hidden = YES;
            }];
        }
    }];
}

#pragma mark - 懒加载
- (UIView *)progressView {
    if (_progressView == nil) {
        _progressView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, self.bounds.size.height)];
        if (self.progressColor == nil) self.progressColor = [UIColor greenColor];
        _progressView.backgroundColor = self.progressColor;
    }
    return _progressView;
}

@end
