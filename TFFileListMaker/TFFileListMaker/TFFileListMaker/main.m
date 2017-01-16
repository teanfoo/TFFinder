//
//  main.m
//  TFFileListMaker
//
//  Created by apple on 16/12/15.
//  Copyright © 2016年 legentec. All rights reserved.
//

#import <Foundation/Foundation.h>

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        NSLog(@"|*-----   Updating...    -----*|");
        // 获取当前目录下的所有文件夹名及文件名
        //===============================================================================================
        // 1. 获取主路径（当前路径）
        NSString *mainPath = [[NSBundle mainBundle] bundlePath];
        // 2. 获取绝对路径（当前路径下的子路径）
        NSArray *subPaths = [[NSBundle mainBundle] pathsForResourcesOfType:@"" inDirectory:nil];
        // 3. 获取文件或文件夹的名称列表
        NSMutableArray *relativeSubPaths = [NSMutableArray array];
        for (NSString *subPath in subPaths) {
            [relativeSubPaths addObject:[subPath substringFromIndex:mainPath.length]];
        }
        // 4. 将文件名列表格式化为字符串
        NSString *resultStr = [NSString stringWithFormat:@"%@", relativeSubPaths];
        // 5. 获取配置文件路径
        NSString *configFilePath = [NSString stringWithFormat:@"%@/.configFile.tfcf", mainPath];
        // 6. 将文件名列表的字符串写入配置文件“.configFile.tfcf”
        [resultStr writeToFile:configFilePath atomically:NO encoding:NSUTF8StringEncoding error:nil];
        
        [NSFileManager defaultManager];
        
        // Log
        NSLog(@"mainPath: %@", mainPath);
        NSLog(@"subPaths: %@", subPaths);
        NSLog(@"%@", resultStr);
        NSLog(@"configFilePath: %@", configFilePath);
        //===============================================================================================
        NSLog(@"|*----- Update Succesed! -----*|");
    }
    return 0;
}
