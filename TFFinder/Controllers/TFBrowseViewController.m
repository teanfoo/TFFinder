//
//  TFBrowseViewController.m
//  TFFinder
//
//  Created by teanfoo on 16/12/19.
//  Copyright © 2016 TeanFoo. All rights reserved.
//

#import "TFBrowseViewController.h"
#import "PrefixHeader.pch"
#import "TFWebProgress.h"

@interface TFBrowseViewController () <UIWebViewDelegate, UIScrollViewDelegate>

// models
@property (strong, nonatomic) NSURL *fileUrl;
// views
@property (weak, nonatomic) UIWebView *webView;
@property (weak, nonatomic) TFWebProgress *webProgress;
// datas
@property (assign, nonatomic) BOOL needLayoutUI;// 需要布局UI?

@end

@implementation TFBrowseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    // 设置标题
    NSString *fileName = self.filePath.lastPathComponent;
    self.navigationItem.title = [fileName URLDecodingString];
    // 设置导航栏右边的按钮
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 42, 42)];
    btn.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [btn setTitle:@"Safari" forState:UIControlStateNormal];
    [btn setTitleColor:kColorWithHex(0x4E90FF) forState:UIControlStateNormal];
    [btn setContentEdgeInsets:UIEdgeInsetsMake(0, 10, 0, -10)];
    [btn addTarget:self action:@selector(onMoreButtonClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    // 显示WebView
    self.webView.hidden = NO;
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    // 加载数据并配置视图
    [self loadDataAndConfigView];
}
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    // 屏幕旋转，重新布局子控件
    if (self.needLayoutUI) {
        self.webView.frame = self.view.bounds;
        
        CGFloat webProgress_y;
        if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait)// 竖屏
            webProgress_y = self.navigationController.navigationBar.bounds.size.height + 20;
        else// 横屏
            webProgress_y = self.navigationController.navigationBar.bounds.size.height;
        self.webProgress.frame = CGRectMake(0, webProgress_y, self.view.bounds.size.width, 2);
    }
}

#pragma mark - 屏幕将要旋转的回调
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    self.needLayoutUI = YES;
}

#pragma mark - 按钮的点击事件
- (void)onMoreButtonClick {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.filePath]];
}

#pragma mark - 加载数据，配置视图
- (void)loadDataAndConfigView {
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:self.fileUrl];
    urlRequest.timeoutInterval = 6.0;
    [self.webView loadRequest:urlRequest];
}

#pragma mark - UIWebViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return nil;
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView {
    [self.webProgress start];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self.webProgress finish];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [self.webProgress finish];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"😂"
                                                    message:@"该文件可能已经被删除了，请更新服务器的文件列表。"
                                                   delegate:self
                                          cancelButtonTitle:@"我知道了"
                                          otherButtonTitles:nil];
    [alert show];
}

#pragma mark - alertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 懒加载
// models
- (NSURL *)fileUrl {
    if (_fileUrl == nil) {
        NSURL *fileUrl = [NSURL URLWithString:self.filePath];
        _fileUrl = fileUrl;
    }
    return _fileUrl;
}
// views
- (UIWebView *)webView {
    if (_webView == nil) {
        UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
        webView.backgroundColor = kColorWithHex(0xDDDDDD);
        webView.scalesPageToFit = YES;
        webView.delegate = self;
        webView.scrollView.delegate = self;
        [self.view addSubview:webView];
        _webView = webView;
    }
    return _webView;
}
- (TFWebProgress *)webProgress {
    if (_webProgress == nil) {
        CGFloat webProgress_y;
        if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait)// 竖屏
            webProgress_y = self.navigationController.navigationBar.bounds.size.height + 20;
        else// 横屏
            webProgress_y = self.navigationController.navigationBar.bounds.size.height;
        TFWebProgress *webProgress = [[TFWebProgress alloc] initWithFrame:CGRectMake(0, webProgress_y, self.view.bounds.size.width, 2)];
        webProgress.backgroundColor = [UIColor whiteColor];
        
        [self.view addSubview:webProgress];
        _webProgress = webProgress;
    }
    return _webProgress;
}

@end
