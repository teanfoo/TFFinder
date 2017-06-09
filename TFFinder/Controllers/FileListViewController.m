//
//  FileListViewController.m
//  TFFinder
//
//  Created by teanfoo on 16/12/16.
//  Copyright © 2016 TeanFoo. All rights reserved.
//

#import "FileListViewController.h"
#import "PrefixHeader.pch"
#import "TFTextViewController.h"// 文本查看器
#import "TFImageViewController.h"// 图片查看器
#import "TFPlayerViewController.h"// 音/视频播放器
#import "TFBrowseViewController.h"// 网页查看器
#import "TFDocumentViewController.h"// 文档查看器

#define CELL_TAG_UNKNOW             10// 未知标签
#define CELL_TAG_FOLDER             20// 文件夹标签
#define CELL_TAG_TEXT_FILE          21// 文本文件标签
#define CELL_TAG_PHOTO_FILE         22// 图片文件标签
#define CELL_TAG_AUDIO_FILE         23// 音频文件标签
#define CELL_TAG_COMMON_VEDIO_FILE  24// 视频文件标签
#define CELL_TAG_OTHER_VEDIO_FILE   25// 视频文件标签
#define CELL_TAG_HTML_FILE          26// Web文件标签
#define CELL_TAG_DOCUMENT_FILE      27// 文档(PDF、Word、Excel、PowerPoint)文件标签

@interface FileListViewController () <UITableViewDelegate, UITableViewDataSource>

// models
@property (strong, nonatomic) NSURL *configFileURL;// 配置文件URL
@property (strong, nonatomic) NSMutableArray *fileList;// 文件表

// views
@property (weak, nonatomic) UITableView *tableView;// 列表视图
@property (weak, nonatomic) UIView *noDataPlaceholderView;// 没有数据的占位图片

// controller
@property (strong, nonatomic) UIDocumentInteractionController *documentController;// 第三方APP调用选项卡

@end

@implementation FileListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    // 隐藏tableview
    self.tableView.hidden = YES;
    // 隐藏空文件占位图
    self.noDataPlaceholderView.hidden = YES;
    // 设置标题
    NSString *folderName = self.localPath.lastPathComponent;
    self.navigationItem.title = [folderName URLDecodingString];
    // 设置导航栏左边的按钮
    if ([self.navigationItem.title isEqualToString:@"TFFinder"]) {// 根视图
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 42, 42)];
        [btn setImage:[UIImage imageNamed:@"switchIPImage"] forState:UIControlStateNormal];
        [btn setContentEdgeInsets:UIEdgeInsetsMake(0, -5, 0, 15)];// 向左偏移10
        [btn addTarget:self action:@selector(onSwitchIPButtonClick) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    }
    // 加载数据并配置视图
    [self loadDataAndConfigView];
}
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
//    DLog("LayoutSubviews---1");
    // 屏幕旋转，重新布局子控件
    if (!self.tableView.hidden)
        self.tableView.frame = self.view.bounds;
    if (!self.noDataPlaceholderView.hidden)
        self.noDataPlaceholderView.center = self.view.center;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}

#pragma mark - 加载数据，配置视图
- (void)loadDataAndConfigView {
    [[HUDManager manager] showWaitViewAndText:@"获取中，请稍候..." inView:self.view];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:self.configFileURL];
    request.HTTPMethod = @"GET";
    request.timeoutInterval = 10;
    request.cachePolicy = NSURLRequestReloadIgnoringLocalAndRemoteCacheData;// 忽略缓存
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
                               [[HUDManager manager] hideWaitView];
                               if (data == nil) {// 未获取到数据，显示空文件占位图，退出
                                   self.noDataPlaceholderView.hidden = NO;
                                   return;
                               }

                               NSString *content = [[NSString alloc] initWithData:data encoding:[GlobalData Data].encode];
                               if (content.length == 0) {// 数据错误，显示空文件占位图，退出
                                   self.noDataPlaceholderView.hidden = NO;
                                   return;
                               }
                               
                               NSArray *resultArray = [content componentsSeparatedByString:@","];
                               NSMutableArray *fileNameArray = [NSMutableArray array];
                               for (NSString *str in resultArray) {
                                   NSArray *tempArray = [str componentsSeparatedByString:@"/"];
                                   if (tempArray.count == 2) {
                                       [fileNameArray addObject:tempArray.lastObject];
                                   }
                               }
                               NSMutableArray *fileList = [NSMutableArray array];
                               for (NSString *fileName in fileNameArray) {
                                   // 过滤隐藏文件、配置文件和文件表生成工具（FileListMaker）
                                   if ([fileName hasPrefix:@"."] ||
                                       [fileName isEqualToString:kConfigFile] ||
                                       [fileName hasPrefix:@"FileListMaker"])
                                       continue;
                                   
                                   if ([fileName rangeOfString:@"."].length == 0) // 文件夹
                                       [self.fileList addObject:fileName];
                                   else// 文件
                                       [fileList addObject:fileName];
                               }
                               // 合并文件夹列表和文件列表
                               [self.fileList addObjectsFromArray:fileList];
                               // 显示对应的界面
                               if (self.fileList.count > 0) {
                                   // 刷新tableview
                                   self.tableView.hidden = NO;;
                                   [self.tableView reloadData];
                               }
                               else {
                                   // 显示空文件占位图
                                   self.noDataPlaceholderView.hidden = NO;
                               }
                           }];
}

#pragma mark - tableView代理和数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.fileList.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellId"];
    if (cell == nil) cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cellId"];
    // 根据文件名的类型设置cell
    NSString *fileName = self.fileList[indexPath.row];
    cell.textLabel.text = fileName;// 设置cell的显示名称
    NSArray *name_type = [fileName componentsSeparatedByString:@"."];
    if (name_type.count == 1) {// 没有后缀名，则认为是文件夹
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;// 设置cell类型为右侧小箭头
        cell.tag = CELL_TAG_FOLDER;// 设置cell的标签为 文件夹标签
        cell.imageView.image = [UIImage imageNamed:@"folderIcon"];
    }
    else if (name_type.count >= 2) {// 有后缀名，则认为是文件
        cell.accessoryType = UITableViewCellAccessoryNone;// 设置cell类型为默认类型
        NSString *type = [name_type lastObject];
        if ([type caseInsensitiveCompare:@"h"]==NSOrderedSame ||
            [type caseInsensitiveCompare:@"pch"]==NSOrderedSame ||
            [type caseInsensitiveCompare:@"m"]==NSOrderedSame ||
            [type caseInsensitiveCompare:@"mm"]==NSOrderedSame ||
            [type caseInsensitiveCompare:@"c"]==NSOrderedSame ||
            [type caseInsensitiveCompare:@"cpp"]==NSOrderedSame ||
            [type caseInsensitiveCompare:@"txt"]==NSOrderedSame) {// 文本
            cell.imageView.image = [UIImage imageNamed:@"textIcon"];
            cell.tag = CELL_TAG_TEXT_FILE;
        }
        else if ([type caseInsensitiveCompare:@"png"]==NSOrderedSame ||
                 [type caseInsensitiveCompare:@"jpg"]==NSOrderedSame ||
                 [type caseInsensitiveCompare:@"gif"]==NSOrderedSame ||
                 [type caseInsensitiveCompare:@"jpeg"]==NSOrderedSame) {// 图片
            cell.imageView.image = [UIImage imageNamed:@"photoIcon"];
            cell.tag = CELL_TAG_PHOTO_FILE;
        }
        else if ([type caseInsensitiveCompare:@"mp3"]==NSOrderedSame ||
                 [type caseInsensitiveCompare:@"wav"]==NSOrderedSame) {// 音频
            cell.imageView.image = [UIImage imageNamed:@"audioIcon"];
            cell.tag = CELL_TAG_AUDIO_FILE;
        }
        else if ([type caseInsensitiveCompare:@"mp4"]==NSOrderedSame ||
                 [type caseInsensitiveCompare:@"mov"]==NSOrderedSame) {// TFFinder可播放视频
            cell.imageView.image = [UIImage imageNamed:@"vedioIcon"];
            cell.tag = CELL_TAG_COMMON_VEDIO_FILE;
        }
        else if ([type caseInsensitiveCompare:@"3gp"]==NSOrderedSame ||
                 [type caseInsensitiveCompare:@"avi"]==NSOrderedSame ||
                 [type caseInsensitiveCompare:@"flv"]==NSOrderedSame ||
                 [type caseInsensitiveCompare:@"rm"]==NSOrderedSame ||
                 [type caseInsensitiveCompare:@"rmvb"]==NSOrderedSame ||
                 [type caseInsensitiveCompare:@"wmv"]==NSOrderedSame) {// 其他视频
            cell.imageView.image = [UIImage imageNamed:@"vedioIcon"];
            cell.tag = CELL_TAG_OTHER_VEDIO_FILE;
        }
        else if ([type caseInsensitiveCompare:@"html"]==NSOrderedSame) {// HTML网页
            cell.imageView.image = [UIImage imageNamed:@"htmlIcon"];
            cell.tag = CELL_TAG_HTML_FILE;
        }
        else if ([type caseInsensitiveCompare:@"pdf"]==NSOrderedSame) {// PDF文档
            cell.imageView.image = [UIImage imageNamed:@"pdfIcon"];
            cell.tag = CELL_TAG_DOCUMENT_FILE;
        }
        else if ([type caseInsensitiveCompare:@"doc"]==NSOrderedSame ||
                 [type caseInsensitiveCompare:@"docx"]==NSOrderedSame) {// Word文档
            cell.imageView.image = [UIImage imageNamed:@"docIcon"];
            cell.tag = CELL_TAG_DOCUMENT_FILE;
        }
        else if ([type caseInsensitiveCompare:@"xls"]==NSOrderedSame ||
                 [type caseInsensitiveCompare:@"xlsx"]==NSOrderedSame) {// Excel文档
            cell.imageView.image = [UIImage imageNamed:@"xlsIcon"];
            cell.tag = CELL_TAG_DOCUMENT_FILE;
        }
        else if ([type caseInsensitiveCompare:@"ppt"]==NSOrderedSame ||
                 [type caseInsensitiveCompare:@"pptx"]==NSOrderedSame) {// PowerPoint文档
            cell.imageView.image = [UIImage imageNamed:@"pptIcon"];
            cell.tag = CELL_TAG_DOCUMENT_FILE;
        }
        else {// 未知类型
            cell.imageView.image = [UIImage imageNamed:@"unknowIcon"];
            cell.tag = CELL_TAG_UNKNOW;// 设置cell的标签为 未知标签
        }
    }
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    // 获取点击的cell
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    // 获取文件的真实路径
    NSString *fileName = self.fileList[indexPath.row];
    NSString *path = [self.localPath stringByAppendingPathComponent:[fileName URLEncodedString]];
//  DLog(@"----->path: %@", path);
    // 根据cell的类型执行相应的操作
    switch (cell.tag) {
        case CELL_TAG_FOLDER: {// 文件夹
            FileListViewController *fileListVC = [[FileListViewController alloc] init];
            fileListVC.localPath = path;
            [self.navigationController pushViewController:fileListVC animated:YES];
        } break;
        case CELL_TAG_TEXT_FILE: {// 文本文件
            TFTextViewController *textVC = [[TFTextViewController alloc] init];
            textVC.filePath = path;
            [self.navigationController pushViewController:textVC animated:YES];
        } break;
        case CELL_TAG_PHOTO_FILE: {// 图片类型
            TFImageViewController *imageVC = [[TFImageViewController alloc] init];
            imageVC.filePath = path;
            imageVC.fileList = self.fileList;
            [self.navigationController pushViewController:imageVC animated:YES];
        } break;
        case CELL_TAG_AUDIO_FILE: case CELL_TAG_COMMON_VEDIO_FILE: {// 音频/常见视频类型
            TFPlayerViewController *playerVC = [[TFPlayerViewController alloc] init];
            playerVC.filePath = path;
            [self.navigationController pushViewController:playerVC animated:YES];
        } break;
//        case CELL_TAG_OTHER_VEDIO_FILE: {// 其他视频类型
//            self.documentController = [UIDocumentInteractionController interactionControllerWithURL:[NSURL fileURLWithPath:path]];
//            [self.documentController presentOpenInMenuFromRect:self.view.bounds inView:self.view animated:YES];
//        } break;
        case CELL_TAG_HTML_FILE: {// 网页类型
            TFBrowseViewController *browseVC = [[TFBrowseViewController alloc] init];
            browseVC.filePath = path;
            [self.navigationController pushViewController:browseVC animated:YES];
        } break;
        case CELL_TAG_DOCUMENT_FILE: {// 文档(PDF、World、Excel、PPT)类型
            TFDocumentViewController *documentVC = [[TFDocumentViewController alloc] init];
            documentVC.navigationItem.title = fileName;
            documentVC.filePath = path;
            documentVC.showMoreButton = kIsiPhone;
            [self.navigationController pushViewController:documentVC animated:YES];
        } break;

        default:{// 未知类型
            [[HUDManager manager] showTipViewWithTitle:@"无法打开该类型的文件！" inView:self.view];
        } break;
    }
}

#pragma mark - 按钮的点击事件
- (void)onSwitchIPButtonClick {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"您确定要切换IP吗？"
                                                    message:nil
                                                   delegate:self
                                          cancelButtonTitle:@"取消"
                                          otherButtonTitles:@"确定",nil];
    [alert show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) return;
    // 跳转到设置IP界面
    AppDelegate *delegate = kAppDelegate;
    delegate.window.rootViewController = delegate.setIPNavigationController;
}

#pragma mark - 懒加载
// models
- (NSURL *)configFileURL {
    if (_configFileURL == nil) {
        _configFileURL = [NSURL URLWithString:[self.localPath stringByAppendingPathComponent:kConfigFile]];
    }
    return _configFileURL;
}
- (NSMutableArray *)fileList {
    if (_fileList == nil) {
        _fileList = [NSMutableArray array];
    }
    return _fileList;
}

// views
- (UITableView *)tableView {
    if (_tableView == nil) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        tableView.backgroundColor = [UIColor whiteColor];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.bounces = NO;
        [self.view addSubview:tableView];
        
        _tableView = tableView;
    }
    return _tableView;
}
- (UIView *)noDataPlaceholderView {
    if (_noDataPlaceholderView == nil) {
        UIView *noDataPlaceholderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
        noDataPlaceholderView.backgroundColor = [UIColor clearColor];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, 180, 180)];
        imageView.image = [UIImage imageNamed:@"noDataPlaceholderImage"];
        [noDataPlaceholderView addSubview:imageView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 180, 200, 20)];
        label.font = [UIFont systemFontOfSize:16.0];
        label.textColor = [UIColor darkGrayColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"这个文件夹是空的哦...";
        [noDataPlaceholderView addSubview:label];
        
        [self.view addSubview:noDataPlaceholderView];
        noDataPlaceholderView.center = self.view.center;
        _noDataPlaceholderView = noDataPlaceholderView;
    }
    return _noDataPlaceholderView;
}

@end
