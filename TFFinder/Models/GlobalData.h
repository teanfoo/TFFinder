//
//  GlobalData.h
//  TFFinder
//
//  Created by apple on 16/12/16.
//  Copyright © 2016年 TeanFoo. All rights reserved.
//

#import <Foundation/Foundation.h>

#define k_SERVER_IP_KEY @"serverIP_key"
#define k_SERVER_PATH_KEY @"serverPath_key"

static NSString * const kConfigFilePath = @"/.configFile.tfcf";// 配置文件相对路径

@interface GlobalData : NSObject

@property (strong, nonatomic) NSString *serverIP;// 服务器IP地址
@property (strong, nonatomic) NSString *serverPath;// 服务器主路径

// 获取单例
+ (instancetype)Data;

// 保存数据
- (void)saveData;

@end
