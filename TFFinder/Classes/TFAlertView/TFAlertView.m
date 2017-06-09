//
//  TFAlertView.m
//  iAppSinopecSSP
//
//  Created by apple on 2017/4/27.
//  Copyright © 2017年 Kinggrid. All rights reserved.
//

#import "TFAlertView.h"
#import "AppDelegate.h"

#pragma mark - 屏幕宽高
#define SCREEN_W [UIScreen mainScreen].bounds.size.width
#define SCREEN_H [UIScreen mainScreen].bounds.size.height
#define HALF_SCREEN_W ([UIScreen mainScreen].bounds.size.width/2)
#define HALF_SCREEN_H ([UIScreen mainScreen].bounds.size.height/2)

@interface TFAlertView ()

@property (copy, nonatomic) void(^cancelAction)();// 取消的操作
@property (copy, nonatomic) void(^confirmAction)();// 确定的操作

@property (weak, nonatomic) UIView *panel;// 弹窗面板
@property (assign, nonatomic) BOOL easyHide;// 是否开启简易退出模式(开启后点击弹窗以外的区域可隐藏弹窗)

@end

@implementation TFAlertView

- (instancetype)init {
    return [self initWithFrame:CGRectZero];
}
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    return self;
}

/** 初始弹窗输入框视图 */
- (instancetype)initWithTitle:(NSString *)title
                      message:(NSString *)message
                     easyHide:(BOOL)easyHide
                   cancelText:(NSString *)cancelText
                  confirmText:(NSString *)confirmText
                 cancelAction:(void(^)())cancelAction
                confirmAction:(void(^)())confirmAction {
    self = [self initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H)];
    if (self != nil) {
        self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.0];
        self.easyHide = easyHide;
        
        CGFloat panelWidth = 300;
        UIColor *subviewBgCollor = [UIColor clearColor];
        UIColor *gapViewCollor = [UIColor lightGrayColor];
        
        UIView *panel = [[UIView alloc] init];
        panel.clipsToBounds = YES;
        panel.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.9];
//        panel.layer.borderWidth = 1.0;
//        panel.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        panel.layer.cornerRadius = 10.0;
        [self addSubview:panel];
        self.panel = panel;
        
        UITextView *titleView = nil;
        CGFloat titleViewHeight = 0.0;
        if (title.length != 0) {
            titleView = [[UITextView alloc] init];
            titleView.backgroundColor = subviewBgCollor;
            titleView.font = [UIFont boldSystemFontOfSize:16.0];
            titleView.textColor = [UIColor darkTextColor];
            titleView.textAlignment = NSTextAlignmentCenter;
            titleView.editable = NO;
            titleView.selectable = NO;
            titleView.showsVerticalScrollIndicator = NO;
            titleView.showsHorizontalScrollIndicator = NO;
            titleView.text = title;
            titleViewHeight = [titleView sizeThatFits:CGSizeMake(panelWidth, CGFLOAT_MAX)].height;
            [panel addSubview:titleView];
        }
        
        UITextView *messageView = nil;
        CGFloat messageViewHeight = 0.0;
        if (message.length != 0) {
            messageView = [[UITextView alloc] init];
            messageView.backgroundColor = subviewBgCollor;
            messageView.font = [UIFont systemFontOfSize:14.0];
            messageView.textColor = [UIColor darkTextColor];
            messageView.textAlignment = NSTextAlignmentCenter;
            messageView.editable = NO;
            messageView.selectable = NO;
            messageView.showsVerticalScrollIndicator = NO;
            messageView.showsHorizontalScrollIndicator = NO;
            messageView.text = message;
            messageViewHeight = [messageView sizeThatFits:CGSizeMake(panelWidth, CGFLOAT_MAX)].height;
            [panel addSubview:messageView];
        }
        
        // 适配各个View的高度
        CGFloat btnHeight = 45.0;// 底部按钮的高度 + 分割线
        if (cancelText.length == 0 && confirmText.length == 0) btnHeight = 0.0;
        CGFloat panelHeight = titleViewHeight + messageViewHeight + btnHeight;// 整个弹窗的高度
        CGFloat restrictedHeight = (SCREEN_H - btnHeight) / 2;
        if (panelHeight > SCREEN_H) {
            panelHeight = SCREEN_H;
            if (titleViewHeight > restrictedHeight) {
                if (messageViewHeight > restrictedHeight) {
                    titleViewHeight = restrictedHeight;
                    messageViewHeight = restrictedHeight;
                }
                else {
                    titleViewHeight = restrictedHeight * 2 - messageViewHeight;
                }
            }
            else {
                if (messageViewHeight > restrictedHeight) {
                    messageViewHeight = restrictedHeight * 2 - titleViewHeight;
                }
            }
        }

        // 设置panel、titleView、messageView的尺寸
        panel.frame = CGRectMake(0, 0, panelWidth, panelHeight);
        titleView.frame = CGRectMake(0, 0, panelWidth, titleViewHeight);
        messageView.frame = CGRectMake(0, titleViewHeight, panelWidth, messageViewHeight);
        // 先放到底部(不显示)
        panel.center = CGPointMake(HALF_SCREEN_W, SCREEN_H * 1.5);
        
        // 判断按钮的设置状态
        CGFloat gapViewWidth = 0.5;// 分割线的宽度
        CGFloat absoluteBtnHeight = btnHeight - gapViewWidth;
        if (cancelText.length == 0) {
            if (confirmText.length != 0) {// 只有确定按钮
                // 添加分割线
                UIView *gapView = [[UIView alloc] initWithFrame:CGRectMake(0, panelHeight - btnHeight, panelWidth, gapViewWidth)];
                gapView.backgroundColor = gapViewCollor;
                [panel addSubview:gapView];
                // 添加按钮
                UIButton *confirmBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, panelHeight - absoluteBtnHeight, panelWidth, absoluteBtnHeight)];
                confirmBtn.backgroundColor = subviewBgCollor;
                confirmBtn.titleLabel.font = [UIFont systemFontOfSize:16.0];
                [confirmBtn setTitle:confirmText forState:UIControlStateNormal];
                [confirmBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
                [confirmBtn addTarget:self action:@selector(onConfirmClicked) forControlEvents:UIControlEventTouchUpInside];
                [panel addSubview:confirmBtn];
                // 设置回调操作
                self.confirmAction = confirmAction;
            }
        }
        else {
            if (confirmText.length != 0) {// 取消和确定按钮都有
                CGFloat btnWidth = (panel.bounds.size.width / 2) - (gapViewWidth / 2);// 按钮的宽度
                // 添加分割线
                UIView *gapView = [[UIView alloc] initWithFrame:CGRectMake(0, panelHeight - btnHeight, panelWidth, gapViewWidth)];
                gapView.backgroundColor = gapViewCollor;
                [panel addSubview:gapView];
                
                UIView *gapView1 = [[UIView alloc] initWithFrame:CGRectMake(btnWidth, panelHeight - btnHeight, gapViewWidth, btnHeight)];
                gapView1.backgroundColor = gapViewCollor;
                [panel addSubview:gapView1];
                
                // 添加按钮
                UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, panelHeight - absoluteBtnHeight, btnWidth, absoluteBtnHeight)];
                cancelBtn.backgroundColor = subviewBgCollor;
                cancelBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16.0];
                [cancelBtn setTitle:cancelText forState:UIControlStateNormal];
                [cancelBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
                [cancelBtn addTarget:self action:@selector(onCancelClicked) forControlEvents:UIControlEventTouchUpInside];
                [panel addSubview:cancelBtn];
                
                UIButton *confirmBtn = [[UIButton alloc] initWithFrame:CGRectMake(btnWidth + gapViewWidth, panelHeight - absoluteBtnHeight, btnWidth, absoluteBtnHeight)];
                confirmBtn.backgroundColor = subviewBgCollor;
                confirmBtn.titleLabel.font = [UIFont systemFontOfSize:16.0];
                [confirmBtn setTitle:confirmText forState:UIControlStateNormal];
                [confirmBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
                [confirmBtn addTarget:self action:@selector(onConfirmClicked) forControlEvents:UIControlEventTouchUpInside];
                [panel addSubview:confirmBtn];
                // 设置回调操作
                self.cancelAction = cancelAction;
                self.confirmAction = confirmAction;
            }
            else {// 只有取消按钮
                // 添加分割线
                UIView *gapView = [[UIView alloc] initWithFrame:CGRectMake(0, panelHeight - btnHeight, panelWidth, gapViewWidth)];
                gapView.backgroundColor = gapViewCollor;
                [panel addSubview:gapView];
                // 添加按钮
                UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, panelHeight - absoluteBtnHeight, panelWidth, absoluteBtnHeight)];
                cancelBtn.backgroundColor = subviewBgCollor;
                cancelBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16.0];
                [cancelBtn setTitle:cancelText forState:UIControlStateNormal];
                [cancelBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
                [cancelBtn addTarget:self action:@selector(onCancelClicked) forControlEvents:UIControlEventTouchUpInside];
                [panel addSubview:cancelBtn];
                // 设置回调操作
                self.cancelAction = cancelAction;
            }
        }
    }
    return self;
}

/** 显示 */
- (void)show {
    // 添加视图
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [delegate.window addSubview:self];
    // 声明self的弱引用
    __weak typeof(self) weakSelf = self;
    // 动画显示
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];
        weakSelf.panel.center = CGPointMake(HALF_SCREEN_W, SCREEN_H * 0.5);
    }];
}

#pragma mark - 退出
- (void)dismiss {
    // 声明self的弱引用
    __weak typeof(self) weakSelf = self;
    // 动画隐藏Alert
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.0];
        weakSelf.panel.center = CGPointMake(HALF_SCREEN_W, SCREEN_H * 1.5);
    } completion:^(BOOL finished) {
        // 移除子视图
        for (UIView *subView in weakSelf.subviews) {
            [subView removeFromSuperview];
        }
        // 移除自己
        [weakSelf removeFromSuperview];
    }];
}

#pragma mark - 按钮的点击事件
- (void)onCancelClicked {
    // 退出弹窗
    [self dismiss];
    // 取消操作的回调
    if (self.cancelAction != nil) {
        self.cancelAction();
    }
}
- (void)onConfirmClicked {
    // 退出弹窗
    [self dismiss];
    // 确定操作的回调
    if (self.confirmAction != nil) {
        self.confirmAction();
    }
}

#pragma mark - 屏幕的点击事件
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.easyHide) {
        [self dismiss];
    }
}

@end
