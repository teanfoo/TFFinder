//
//  SetIPViewController.m
//  TFFinder
//
//  Created by teanfoo on 16/12/16.
//  Copyright © 2016 TeanFoo. All rights reserved.
//

#import "SetIPViewController.h"
#import "PrefixHeader.pch"
#import "TFDocumentViewController.h"

@interface SetIPViewController () <UITextFieldDelegate, UIActionSheetDelegate>

// views
@property (weak, nonatomic) UIView *panelView;// 操作面板视图
@property (weak, nonatomic) UITextField *IPTextField;// IP输入框
@property (weak, nonatomic) UITextField *portTextField;// 端口输入框
@property (weak, nonatomic) UIImageView *appIconView;// app图标视图
@property (weak, nonatomic) UIView *aboutView;// 关于视图

// datas
@property (assign, nonatomic) BOOL needLayoutUI;// 需要布局UI?

@end

@implementation SetIPViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = kColorWithHex(0xDDDDDD);
    self.navigationItem.title = @"设置IP";
    // 切换编码的按钮
    UIButton *encodeBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 44)];
    [encodeBtn setTitle:@"Encode" forState:UIControlStateNormal];
    [encodeBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [encodeBtn.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
    [encodeBtn addTarget:self action:@selector(onEncodeBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:encodeBtn];
    [self setupMainView];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.needLayoutUI = YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    // 屏幕旋转，重新布局子控件
    if (self.needLayoutUI) {
        if (SCREEN_H == 320) // iPhone 4s、iPhone 5/5c/5s、iPhone SE 且横屏
            self.appIconView.hidden = YES;
        else
            self.appIconView.hidden = NO;
        
        CGFloat width = self.panelView.bounds.size.width;
        self.panelView.frame = CGRectMake((SCREEN_W-width)/2, SCREEN_H*0.15, width, self.panelView.bounds.size.height);
        self.aboutView.frame = CGRectMake((SCREEN_W-width)/2, SCREEN_H-120, width, self.aboutView.bounds.size.height);
    }
}
#pragma mark - 屏幕将要旋转的回调
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    self.needLayoutUI = YES;
}

#pragma mark - 设置主界面
- (void)setupMainView {
    // 判断横竖屏
    CGFloat view_W = SCREEN_H > SCREEN_W ? SCREEN_W : SCREEN_H;
    
    // 创建面板
    UIView *panelView = [[UIView alloc] initWithFrame:CGRectMake((SCREEN_W-view_W)/2, SCREEN_H*0.15, view_W, 200)];
    panelView.backgroundColor = [UIColor clearColor];
    // IP输入框
    UITextField *ipTextField = [[UITextField alloc] initWithFrame:CGRectMake(15, 0, view_W-30, 44)];
    ipTextField.clearButtonMode = UITextFieldViewModeWhileEditing;// 删除按钮
    ipTextField.keyboardType = UIKeyboardTypeDecimalPad ;// 数字和点键盘
    ipTextField.placeholder = @"请填写服务器的IP地址";
    ipTextField.textAlignment = NSTextAlignmentCenter;
    ipTextField.delegate = self;
    [panelView addSubview:ipTextField];
    self.IPTextField = ipTextField;
    // IP输入框下划线
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(15, 44, view_W-30, 1)];
    line1.backgroundColor = [UIColor grayColor];
    [panelView addSubview:line1];
    // 端口输入框
    UITextField *portTextField = [[UITextField alloc] initWithFrame:CGRectMake(15, 45, view_W-30, 44)];
    portTextField.clearButtonMode = UITextFieldViewModeWhileEditing;// 删除按钮
    portTextField.keyboardType = UIKeyboardTypeDecimalPad ;// 数字和点键盘
    portTextField.placeholder = @"端口号";
    portTextField.textAlignment = NSTextAlignmentCenter;
    portTextField.delegate = self;
    [panelView addSubview:portTextField];
    self.portTextField = portTextField;
    // 端口输入框下划线
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(15, 89, view_W-30, 1)];
    line2.backgroundColor = [UIColor grayColor];
    [panelView addSubview:line2];
    // 连接 按钮
    UIButton *connectingButton = [[UIButton alloc] initWithFrame:CGRectMake(15, 115, view_W-30, 44)];
    connectingButton.titleLabel.font = [UIFont systemFontOfSize:20.0];
    connectingButton.backgroundColor = kRGBAColorMax_1(0.2, 0.55, 1.0, 1.0);
    connectingButton.layer.cornerRadius = 5.0;
    [connectingButton setTitle:@"连接" forState:UIControlStateNormal];
    [connectingButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [connectingButton addTarget:self action:@selector(onConnectingButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [panelView addSubview:connectingButton];
    // 帮助 按钮
    UIButton *helperButton = [[UIButton alloc] initWithFrame:CGRectMake(120, 170, view_W-240, 20)];
    helperButton.titleLabel.font = [UIFont systemFontOfSize:16.0];
    [helperButton setTitle:@"帮助" forState:UIControlStateNormal];
    [helperButton setTitleColor:kRGBAColorMax_1(0.2, 0.55, 1.0, 1.0) forState:UIControlStateNormal];
    [helperButton addTarget:self action:@selector(onHelperButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [panelView addSubview:helperButton];
    
    // 创建关于视图
    UIView *aboutView = [[UIView alloc] initWithFrame:CGRectMake((SCREEN_W-view_W)/2, SCREEN_H-120, view_W, 120)];
    aboutView.backgroundColor = [UIColor clearColor];
    // APP头像
    UIImageView *appIconView = [[UIImageView alloc] initWithFrame:CGRectMake((view_W-50)/2, 0, 50, 50)];
    appIconView.image = [UIImage imageNamed:@"appIconImage"];
    appIconView.layer.cornerRadius = 10.0;
    appIconView.clipsToBounds = YES;
    [aboutView addSubview:appIconView];
    if (SCREEN_H == 320) // iPhone 4s、iPhone 5/5c/5s、iPhone SE 且横屏
        appIconView.hidden = YES;
    else
        appIconView.hidden = NO;
    // APP名称
    UILabel *appNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, view_W, 30)];
    appNameLabel.textAlignment = NSTextAlignmentCenter;
    appNameLabel.font = [UIFont boldSystemFontOfSize:20.0];
    appNameLabel.text = @"TFFinder";
    [aboutView addSubview:appNameLabel];
    // 版本号
    UILabel *appVersionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 80, view_W, 15)];
    appVersionLabel.textAlignment = NSTextAlignmentCenter;
    appVersionLabel.font = [UIFont systemFontOfSize:12.0];
    appVersionLabel.text = @"v1.0.0";
    appVersionLabel.textColor = [UIColor grayColor];
    [aboutView addSubview:appVersionLabel];
    // Copyright
    UILabel *copyrightLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 95, view_W, 15)];
    copyrightLabel.textAlignment = NSTextAlignmentCenter;
    copyrightLabel.font = [UIFont systemFontOfSize:10.0];
    copyrightLabel.textColor = [UIColor darkGrayColor];
    copyrightLabel.text = @"Copyright© 2017 TeanFoo. All Rights Reserved";
    [aboutView addSubview:copyrightLabel];
    
    // 添加视图
    [self.view addSubview:aboutView];
    self.aboutView = aboutView;
    self.appIconView = appIconView;
    [self.view addSubview:panelView];
    self.panelView = panelView;
    
    // 初始值设置
    self.IPTextField.text = [GlobalData Data].serverIP;
    self.portTextField.text = [GlobalData Data].serverPort;
}
#pragma mark - 切换编码按钮的点击事件
- (void)onEncodeBtnClicked {
    TFAlertView *alertView = [[TFAlertView alloc] initWithTitle:@"设置编码" message:nil easyHide:NO cancelText:@"Mac(UTF-8)" confirmText:@"Win(936)" cancelAction:^{
        [GlobalData Data].encode = NSUTF8StringEncoding;
    } confirmAction:^{
        [GlobalData Data].encode = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingDOSChineseSimplif);
    }];
    [alertView show];
}
#pragma mark - 连接按钮的点击事件
- (void)onConnectingButtonClick {
    // 收起键盘
    if ([self.IPTextField isFirstResponder]) [self.IPTextField resignFirstResponder];
    // 检验非法性
    if (![self.IPTextField.text isLegalIP]) {
        DLog(@"【IP非法】");
        // 提示错误
        [[HUDManager manager] showTipViewWithOperatingResult:OperatingFailed
                                                       title:@"IP地址无效"
                                                     message:nil
                                                      inView:self.view];
        return;
    }
    if ([self.portTextField.text isEqualToString:@""]) {
        DLog(@"【未填写端口号】");
        // 提示错误
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请填写端口号"
                                                        message:@"提示：服务器默认的端口号为80"
                                                       delegate:nil
                                              cancelButtonTitle:@"我知道了"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    if (![self.portTextField.text isLegalPort]) {
        DLog(@"【端口号非法】");
        // 提示错误
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"端口号非法"
                                                        message:@"提示：取0到65535之间的整数"
                                                       delegate:nil
                                              cancelButtonTitle:@"我知道了"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    // 保存数据到RAM, 保证serverIP不为nil, 再赋值
    if ([GlobalData Data].serverIP) [GlobalData Data].serverIP = self.IPTextField.text;
    if ([GlobalData Data].serverPort) [GlobalData Data].serverPort = self.portTextField.text;
    if ([GlobalData Data].serverPath) [GlobalData Data].serverPath = [NSString stringWithFormat:@"http://%@:%@/TFFinder", self.IPTextField.text, self.portTextField.text];
    // 回收所有键盘
    [self.view endEditing:YES];
    // 连接服务器
    [self connectToServer];
}
#pragma mark - 连接服务器
- (void)connectToServer {
    [[HUDManager manager] showWaitViewAndText:@"连接中，请稍候..." inView:self.view];
    NSString *configFilePath = [[GlobalData Data].serverPath stringByAppendingPathComponent:kConfigFile];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:configFilePath]];
    request.HTTPMethod = @"GET";
    request.timeoutInterval = 10;
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
                               [[HUDManager manager] hideWaitView];
                               if (data == nil) {// 未获取到数据,退出
                                   UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"连接失败!"
                                                                                   message:@"1.请确认您的服务已开启;\n2.请确认IP和端口号填写正确;\n3.请确认设备在同一网络环境中。"
                                                                                  delegate:nil
                                                                         cancelButtonTitle:@"我知道了"
                                                                         otherButtonTitles:nil];
                                   [alert show];
                                   return;
                               }
                               
                               NSString *content = [[NSString alloc] initWithData:data encoding:[GlobalData Data].encode];
//                               DLog(@"content: %@", content);
                               if (content == nil) {// 数据错误,退出
                                   UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"连接失败!"
                                                                                   message:@"1.请确认您的服务已开启;\n2.请确认IP和端口号填写正确;\n3.请确认设备在同一网络环境中。"
                                                                                  delegate:nil
                                                                         cancelButtonTitle:@"我知道了"
                                                                         otherButtonTitles:nil];
                                   [alert show];
                                   return;
                               }
                               
                               // 连接成功
                               // 保存数据到ROM
                               [[GlobalData Data] saveData];
                               // 跳转到文件列表界面
                               AppDelegate *delegate = kAppDelegate;
                               delegate.fileListNavigationController = nil;
                               delegate.window.rootViewController = delegate.fileListNavigationController;
                           }];
}
#pragma mark - 获取帮助
- (void)onHelperButtonClick {
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"选择帮助文档"
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                         destructiveButtonTitle:nil
                                              otherButtonTitles:@"Mac OS X平台帮助文档", @"Windows平台帮助文档", nil];
    [sheet showInView:self.view];
}
#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"Helper4Mac" ofType:@".webarchive"];
        TFDocumentViewController *documentVC = [[TFDocumentViewController alloc] init];
        documentVC.navigationItem.title = @"帮助";
        documentVC.filePath = path;
        documentVC.showMoreButton = NO;
        [self.navigationController pushViewController:documentVC animated:YES];
    }
    if (buttonIndex == 1) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"Helper4Windows" ofType:@".webarchive"];
        TFDocumentViewController *documentVC = [[TFDocumentViewController alloc] init];
        documentVC.navigationItem.title = @"帮助";
        documentVC.filePath = path;
        documentVC.showMoreButton = NO;
        [self.navigationController pushViewController:documentVC animated:YES];
    }
}
#pragma mark - 点击view回收键盘
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];// 回收所有键盘
    [super touchesBegan:touches withEvent:event];
}// 隐藏键盘
#pragma mark - UITextFieldDelegate方法，点击键盘的回车按键是会调用
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.view endEditing:YES];// 回收所有键盘
    return YES;
}

@end
