//
//  TFTextViewController.m
//  TFFinder
//
//  Created by teanfoo on 16/12/22.
//  Copyright © 2016 TeanFoo. All rights reserved.
//

#import "TFTextViewController.h"
#import "PrefixHeader.pch"

@interface TFTextViewController ()

// datas
@property (strong, nonatomic) NSURL *fileUrl;
// views
@property (weak, nonatomic) UITextView *textView;

@end

@implementation TFTextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    // 隐藏文本视图
    self.textView.hidden = YES;
    // 设置标题
    NSString *fileName = [[self.filePath componentsSeparatedByString:@"/"] lastObject];
    self.navigationItem.title = [fileName URLDecodingString];
    // 加载数据并配置视图
    [self loadDataAndConfigView];
}
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
//    DLog("LayoutSubviews---2");
    // 屏幕旋转，重新布局子控件
    self.textView.frame = self.view.bounds;
}

#pragma mark - 加载数据，配置视图
- (void)loadDataAndConfigView {
    unsigned long encode = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingDOSChineseSimplif);// DOS简体中文的txt编码
    NSString *contentText = [NSString stringWithContentsOfURL:self.fileUrl encoding:encode error:nil];
    if (contentText) {
        self.textView.hidden = NO;// 显示文本视图
        self.textView.text = contentText;
        self.textView.contentOffset = CGPointZero;
    }
    else {
        NSString *contentText = [NSString stringWithContentsOfURL:self.fileUrl encoding:NSUTF8StringEncoding error:nil];
        if (contentText) {
            self.textView.hidden = NO;// 显示文本视图
            self.textView.text = contentText;
            self.textView.contentOffset = CGPointZero;
        }
        else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"😂"
                                                            message:@"该文件可能已经被删除了，请更新服务器的文件列表。"
                                                           delegate:self
                                                  cancelButtonTitle:@"我知道了"
                                                  otherButtonTitles:nil];
            [alert show];
        }
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 懒加载
// datas
- (NSURL *)fileUrl {
    if (_fileUrl == nil) {
        NSURL *fileUrl = [NSURL URLWithString:self.filePath];
        _fileUrl = fileUrl;
    }
    return _fileUrl;
}
// views
- (UITextView *)textView {
    if (_textView == nil) {
        UITextView *textView = [[UITextView alloc] initWithFrame:self.view.bounds];
        textView.backgroundColor = kColorWithHex(0xeeeeee);
        textView.editable = NO;
        textView.font = [UIFont systemFontOfSize:15.0];
        [self.view addSubview:textView];
        _textView = textView;
    }
    return _textView;
}

@end
