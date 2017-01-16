//
//  TFPlayerViewController.m
//  TFFinder
//
//  Created by apple on 16/12/28.
//  Copyright © 2016年 TeanFoo. All rights reserved.
//

#import "TFPlayerViewController.h"
#import "PrefixHeader.pch"
#import <AVKit/AVKit.h>

@interface TFPlayerViewController ()

@property (weak, nonatomic) AVPlayerViewController *playerViewController;

@end

@implementation TFPlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = YES;
    // 显示播放器及返回按钮
    self.playerViewController.view.hidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    // 显示导航栏
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 返回按钮的点击事件
- (void)onBackBtnClicked {
    [self.playerViewController.player pause];// 停止播放
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 懒加载
- (AVPlayerViewController *)playerViewController {
    if (_playerViewController == nil) {
        AVAudioSession *session = [AVAudioSession sharedInstance];
        [session setCategory:AVAudioSessionCategoryPlayback error:nil];
        
        AVPlayer *player = [AVPlayer playerWithURL:[NSURL URLWithString:self.filePath]];
        AVPlayerViewController *playerViewController = [[AVPlayerViewController alloc] init];
        playerViewController.view.frame = self.view.bounds;
        playerViewController.player = player;
        playerViewController.videoGravity = AVLayerVideoGravityResizeAspect;
        if (kiOSVersion >= 9.0)
            playerViewController.allowsPictureInPicturePlayback = YES;//画中画，iPad可用
        playerViewController.showsPlaybackControls = YES;
        
        // 添加返回按钮
        UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 20, 60, 30)];
//        backBtn.backgroundColor = [UIColor greenColor];
        backBtn.titleLabel.font = [UIFont systemFontOfSize:25.0];
        [backBtn setTitle:@"<" forState:UIControlStateNormal];
        [backBtn setContentEdgeInsets:UIEdgeInsetsMake(0, 0, 5, 30)];
        [backBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [backBtn addTarget:self action:@selector(onBackBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [playerViewController.view addSubview:backBtn];
        
        [self addChildViewController:playerViewController];
        [self.view addSubview:playerViewController.view];
        _playerViewController = playerViewController;
    }
    return _playerViewController;
}

@end
