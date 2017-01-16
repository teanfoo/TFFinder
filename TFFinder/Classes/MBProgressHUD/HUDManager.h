//
//  HUDManager.h
//  wbhelper
//
//  Created by apple on 16/10/12.
//  Copyright © 2016年 TeanFoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

#define BEZEL_VIEW_COLOR [UIColor colorWithWhite:0.0 alpha:0.5]
#define CONTENT_COLOR [UIColor colorWithWhite:1.0 alpha:1.0]

typedef NS_ENUM(NSInteger, OperatingResult) {
    // 操作成功
    OperatingSuccess = 10,
    // 操作失败
    OperatingFailed
};

@interface HUDManager : UIViewController

#pragma mark - 获取管理者对象
/*!
 * @abstract 获取（抬头显示器）管理者对象
 */
+ (HUDManager *)manager;

#pragma mark - 显示等待视图
/*!
 * @abstract 显示等待视图
 * @discussion 这个等待视图需要手动隐藏（调用：- hideWaitView）
 * @param text 需要显示的文本信息；nil 表示不需要显示文字。
 * @param view 目的视图（父视图）；nil 表示显示到当前窗口（window）。
 */
- (void)showWaitViewAndText:(NSString *)text inView:(UIView *)view;
#pragma mark - 隐藏等待视图
/*!
 * @abstract 隐藏等待视图
 */
- (void)hideWaitView;


#pragma mark - 显示操作提示
/*!
 * @abstract 显示操作成功的提示
 * @discussion 这个提示会自动隐藏
 * @param result OperatingSuccess表示操作成功的提示，OperatingFailed表示操作失败的提示；
 * @param title 需要显示的标题；nil 表示不需要显示文字；
 * @param message 需要显示的文本信息；nil 表示不需要显示文字；
 * @param view 目的视图（父视图）；nil 表示显示到当前窗口（window）。
 */
- (void)showTipViewWithOperatingResult:(OperatingResult)result title:(NSString *)title message:(NSString *)message inView:(UIView *)view;

#pragma mark - 显示消息提示（只有文本）
/*!
 * @abstract 显示消息提示（只有文本）
 * @discussion 这个提示会自动隐藏
 * @param title 需要显示的文本信息；不能为空；
 * @param view 目的视图（父视图）；nil 表示显示到当前窗口（window）。
 */
- (void)showTipViewWithTitle:(NSString *)title inView:(UIView *)view;


@end
