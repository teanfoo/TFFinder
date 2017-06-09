//
//  TFAlertView.h
//  iAppSinopecSSP
//
//  Created by apple on 2017/4/27.
//  Copyright © 2017年 Kinggrid. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TFAlertView : UIView

/** 初始弹窗输入框视图
 *
 *  @param title            标题
 *  @param message          信息
 *  @param easyHide         是否开启简易退出模式(开启后点击弹窗以外的区域可隐藏弹窗)
 *  @param cancelText       取消按钮的文字
 *  @param confirmText      确定按钮的文字
 *  @param cancelAction     点击取消按钮的动作
 *  @param confirmAction    点击确认按钮的动作
 *
 *  @return TFAlertView对象
 */
- (instancetype)initWithTitle:(NSString *)title
                      message:(NSString *)message
                     easyHide:(BOOL)easyHide
                   cancelText:(NSString *)cancelText
                  confirmText:(NSString *)confirmText
                 cancelAction:(void(^)())cancelAction
                confirmAction:(void(^)())confirmAction;

/** 显示 */
- (void)show;

@end
