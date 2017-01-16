//
//  HUDManager.m
//  wbhelper
//
//  Created by apple on 16/10/12.
//  Copyright © 2016年 legentec. All rights reserved.
//

#import "HUDManager.h"

static HUDManager *instance;

@interface HUDManager ()

@property (strong, nonatomic) MBProgressHUD *HUD;

@end

@implementation HUDManager

//获取单例
+ (HUDManager *)manager {
    if (instance == nil) {
        instance = [[self alloc] init];
    }
    return instance;
}
+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    if (instance == nil) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            instance = [super allocWithZone:zone];
        });
    }
    return instance;
}
- (instancetype)copyWithZone:(struct _NSZone *)zone {
    return self;
}

#if !__has_feature(objc_arc)// 非ARC环境 有效
- (id)retain {
    return self;
}
- (unsigned)retainCount {
    return 1;
}
- (void)release {
    
}
- (id)autorelease {
    return self;
}
- (void)dealloc {
    [super dealloc];
}
#endif

#pragma mark - 显示等待视图
- (void)showWaitViewAndText:(NSString *)text inView:(UIView *)view {
    if (view == nil) view = [UIApplication sharedApplication].keyWindow;
    self.HUD = [MBProgressHUD showHUDAddedTo:view animated:YES];
    // 设置提示框的底色
    self.HUD.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    self.HUD.bezelView.backgroundColor = BEZEL_VIEW_COLOR;
    // 设置内容的颜色
    self.HUD.contentColor = CONTENT_COLOR;
    // 设置文本内容
    if (text != nil) self.HUD.label.text = text;
}
#pragma mark - 隐藏等待视图
- (void)hideWaitView {
    if (self.HUD == nil) return;
    [self.HUD hideAnimated:YES];
}

#pragma mark - 显示操作成功的提示
- (void)showTipViewWithOperatingResult:(OperatingResult)result title:(NSString *)title message:(NSString *)message inView:(UIView *)view {
    if (view == nil) view = [UIApplication sharedApplication].keyWindow;
    // 创建一个提示视图对象
    self.HUD = [MBProgressHUD showHUDAddedTo:view animated:YES];
    // 设置提示框的底色
    self.HUD.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    self.HUD.bezelView.backgroundColor = BEZEL_VIEW_COLOR;
    // 设置内容的颜色
    self.HUD.contentColor = CONTENT_COLOR;
    // 设置提示标题
    if (title != nil) self.HUD.label.text = title;
    // 设置信息
    if (message != nil) self.HUD.detailsLabel.text = message;
    // 设置提示图片
    UIImage *image = nil;
    if (result == OperatingSuccess) image = [UIImage imageNamed:@"MBProgressHUD.bundle/success.png"];
    else image = [UIImage imageNamed:@"MBProgressHUD.bundle/error.png"];
    self.HUD.customView = [[UIImageView alloc] initWithImage:image];
    // 设置为自定义模式
    self.HUD.mode = MBProgressHUDModeCustomView;
    // 隐藏时候从父控件中移除
    self.HUD.removeFromSuperViewOnHide = YES;
    // 设置显示的时长（s）
    [self.HUD hideAnimated:YES afterDelay:2.0];
}

#pragma mark - 显示消息提示（只有文本）
- (void)showTipViewWithTitle:(NSString *)title inView:(UIView *)view {
    if (title == nil) return;
    if (view == nil) view = [UIApplication sharedApplication].keyWindow;
    // 创建一个提示视图对象
    self.HUD = [MBProgressHUD showHUDAddedTo:view animated:YES];
    // 设置提示框的底色
    self.HUD.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    self.HUD.bezelView.backgroundColor = BEZEL_VIEW_COLOR;
    // 设置内容的颜色
    self.HUD.contentColor = CONTENT_COLOR;
    // 设置提示标题
    self.HUD.label.text = title;
    // 设置为自定义模式
    self.HUD.mode = MBProgressHUDModeCustomView;
    // 隐藏时候从父控件中移除
    self.HUD.removeFromSuperViewOnHide = YES;
    // 设置显示的时长（s）
    [self.HUD hideAnimated:YES afterDelay:2.0];
}

@end
