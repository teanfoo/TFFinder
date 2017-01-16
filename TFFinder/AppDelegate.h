//
//  AppDelegate.h
//  TFFinder
//
//  Created by apple on 16/12/15.
//  Copyright © 2016年 TeanFoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;// 主视窗
@property (strong, nonatomic) UINavigationController *setIPNavigationController;// 设置IP界面的导航控制器
@property (strong, nonatomic) UINavigationController *fileListNavigationController;// 文件列表界面的导航控制器

@end

