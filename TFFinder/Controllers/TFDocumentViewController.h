//
//  TFDocumentViewController.h
//  TFFinder
//
//  Created by teanfoo on 16/12/30.
//  Copyright © 2016 TeanFoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TFDocumentViewController : UIViewController

@property (strong, nonatomic) NSString *filePath;// 文件绝对路径
@property (assign, nonatomic) BOOL showMoreButton;// 显示“更多”按钮？

@end
