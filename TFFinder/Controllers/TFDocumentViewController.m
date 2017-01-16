//
//  TFDocumentViewController.m
//  TFFinder
//
//  Created by teanfoo on 16/12/30.
//  Copyright © 2016 TeanFoo. All rights reserved.
//

#import "TFDocumentViewController.h"
#import "PrefixHeader.pch"

@interface TFDocumentViewController () <UIScrollViewDelegate, UIWebViewDelegate>

// views
@property (weak, nonatomic) UIWebView *webView;
// controller
@property (strong, nonatomic) UIDocumentInteractionController *documentController;

@end

@implementation TFDocumentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    // 设置导航栏右边的按钮
    if (self.showMoreButton) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 42, 42)];
        [btn setImage:[UIImage imageNamed:@"moreImage"] forState:UIControlStateNormal];
        [btn setContentEdgeInsets:UIEdgeInsetsMake(0, 10, 0, -10)];
        [btn addTarget:self action:@selector(onMoreButtonClick) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    }
    // 先隐藏子视图
    self.webView.hidden = YES;
    // 加载数据并配置视图
    [self loadDataAndConfigView];
}
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    // 屏幕旋转，重新布局子控件
    self.webView.frame = self.view.bounds;
}

#pragma mark - 按钮的点击事件
- (void)onMoreButtonClick {
    [self.documentController presentOpenInMenuFromRect:self.view.bounds inView:self.view animated:YES];
}

#pragma mark - 加载数据，配置视图
- (void)loadDataAndConfigView {
    [[HUDManager manager] showWaitViewAndText:@"正在加载..." inView:self.view];
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:self.filePath]];
    urlRequest.timeoutInterval = 6.0;
    [self.webView loadRequest:urlRequest];
}

#pragma mark - UIWebViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return nil;
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [[HUDManager manager] hideWaitView];
    
    self.webView.hidden = NO;// 加载完成，显示UI
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error {
    [[HUDManager manager] hideWaitView];
    
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
// controller
- (UIDocumentInteractionController *)documentController {
    if (_documentController == nil) {
        _documentController = [UIDocumentInteractionController interactionControllerWithURL:[NSURL fileURLWithPath:self.filePath]];
    }
    return _documentController;
}

@end
