//
//  SetIPViewController.m
//  TFFinder
//
//  Created by apple on 16/12/16.
//  Copyright © 2016年 legentec. All rights reserved.
//

#import "SetIPViewController.h"
#import "PrefixHeader.pch"
#import "TFDocumentViewController.h"

@interface SetIPViewController () <UITextFieldDelegate>

// views
@property (weak, nonatomic) UIView *panelView;// 操作面板视图
@property (weak, nonatomic) UITextField *IPTextField;// IP输入框
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
    [self setupMainView];
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
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(15, 0, view_W-30, 44)];
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;// 删除按钮
    textField.keyboardType = UIKeyboardTypeDecimalPad ;// 数字和点键盘
    textField.placeholder = @"请填写服务器的IP地址";
    textField.textAlignment = NSTextAlignmentCenter;
    textField.delegate = self;
    [panelView addSubview:textField];
    self.IPTextField = textField;
    // IP输入框下划线
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(15, 44, view_W-30, 1)];
    line1.backgroundColor = [UIColor grayColor];
    [panelView addSubview:line1];
    // 连接 按钮
    UIButton *connectingButton = [[UIButton alloc] initWithFrame:CGRectMake(15, 75, view_W-30, 44)];
    connectingButton.titleLabel.font = [UIFont systemFontOfSize:20.0];
    connectingButton.backgroundColor = kRGBAColorMax_1(0.2, 0.5, 1.0, 1.0);
    connectingButton.layer.cornerRadius = 5.0;
    [connectingButton setTitle:@"连接" forState:UIControlStateNormal];
    [connectingButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [connectingButton addTarget:self action:@selector(onConnectingButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [panelView addSubview:connectingButton];
    // 帮助 按钮
    UIButton *helperButton = [[UIButton alloc] initWithFrame:CGRectMake(15, 140, view_W-30, 44)];
    helperButton.titleLabel.font = [UIFont systemFontOfSize:20.0];
    helperButton.backgroundColor = kRGBAColorMax_1(0.2, 0.8, 0.2, 1.0);
    helperButton.layer.cornerRadius = 5.0;
    [helperButton setTitle:@"帮助" forState:UIControlStateNormal];
    [helperButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
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
}
#pragma mark - 按钮的点击事件
- (void)onConnectingButtonClick {
    // 收起键盘
    if ([self.IPTextField isFirstResponder]) [self.IPTextField resignFirstResponder];
    // 检验非法性
    if ([self.IPTextField.text isLegalIP]) {
        // 保存数据到RAM, 保证serverIP不为nil, 再赋值
        if ([GlobalData Data].serverIP) [GlobalData Data].serverIP = self.IPTextField.text;
        if ([GlobalData Data].serverPath) [GlobalData Data].serverPath = [NSString stringWithFormat:@"http://%@/TFFinder", self.IPTextField.text];
        // 连接服务器
        [self connectToServer];
    }
    else {
        DLog(@"【IP非法】");
        // 提示错误
        [[HUDManager manager] showTipViewWithOperatingResult:OperatingFailed
                                                       title:@"IP地址无效"
                                                     message:nil
                                                      inView:self.view];
    }
}
#pragma mark - 连接服务器
- (void)connectToServer {
    [[HUDManager manager] showWaitViewAndText:@"连接中，请稍候..." inView:self.view];
    NSString *configFilePath = [NSString stringWithFormat:@"%@%@",[GlobalData Data].serverPath, kConfigFilePath];
    BACK_DOING(^{
        NSURL *serverUrl = [NSURL URLWithString:configFilePath];
        NSArray *configFileContent = [[NSArray alloc] initWithContentsOfURL:serverUrl];
//        DLog(@"【configFileContent: %@】", configFileContent);
        MAIN_DOING(^{
            [[HUDManager manager] hideWaitView];
            if (configFileContent == nil) {// 连接失败
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"连接失败!"
                                                                message:@"1.请确认您的服务已开启;\n2.请确认您的IP地址填写正确。"
                                                               delegate:nil
                                                      cancelButtonTitle:@"我知道了"
                                                      otherButtonTitles:nil];
                [alert show];
            }
            else {// 连接成功
                // 保存数据到ROM
                [[GlobalData Data] saveData];
                // 跳转到文件列表界面
                AppDelegate *delegate = kAppDelegate;
                delegate.fileListNavigationController = nil;
                delegate.window.rootViewController = delegate.fileListNavigationController;
            }
        });
    });
}
#pragma mark - 获取帮助
- (void)onHelperButtonClick {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"TFFinderHelper" ofType:@".webarchive"];
    TFDocumentViewController *documentVC = [[TFDocumentViewController alloc] init];
    documentVC.navigationItem.title = @"帮助";
    documentVC.filePath = path;
    documentVC.showMoreButton = NO;
    [self.navigationController pushViewController:documentVC animated:YES];
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
