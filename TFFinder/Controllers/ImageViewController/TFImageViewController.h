//
//  TFImageViewController.h
//  TFFinder
//
//  Created by teanfoo on 16/12/22.
//  Copyright © 2016 TeanFoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TFImageViewController : UIViewController

// models
@property (strong, nonatomic) NSString *filePath;// 文件绝对路径
@property (strong, nonatomic) NSMutableArray *fileList;// 文件表

@end
