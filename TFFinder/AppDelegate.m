//
//  AppDelegate.m
//  TFFinder
//
//  Created by teanfoo on 16/12/15.
//  Copyright © 2016 TeanFoo. All rights reserved.
//

#import "AppDelegate.h"
#import "GlobalData.h"
#import "SetIPViewController.h"
#import "FileListViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    // 设置路由
    [self setRootViewController];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - 自定义路由方法
- (void)setRootViewController {
//    NSLog(@"serverPath: %@", [GlobalData Data].serverPath);
    if ([[GlobalData Data].serverPath isEqualToString:@""]) {
        self.window.rootViewController = self.setIPNavigationController;
    }
    else {
        self.window.rootViewController = self.fileListNavigationController;
    }
    
}

#pragma mark - 懒加载
- (UIWindow *)window {
    if (_window == nil) {
        _window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        _window.backgroundColor = [UIColor whiteColor];
        [_window makeKeyAndVisible];
    }
    return _window;
}
- (UINavigationController *)setIPNavigationController {
    if (_setIPNavigationController == nil) {
        _setIPNavigationController = [[UINavigationController alloc] initWithRootViewController:[[SetIPViewController alloc] init]];
    }
    return _setIPNavigationController;
}
- (UINavigationController *)fileListNavigationController {
    if (_fileListNavigationController == nil) {
        FileListViewController *fileListVC = [[FileListViewController alloc] init];
        fileListVC.localPath = [GlobalData Data].serverPath;
        _fileListNavigationController = [[UINavigationController alloc] initWithRootViewController:fileListVC];
    }
    return _fileListNavigationController;
}

@end
