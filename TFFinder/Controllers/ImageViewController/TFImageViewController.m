//
//  ImageViewController.m
//  TFFinder
//
//  Created by teanfoo on 16/12/22.
//  Copyright © 2016 TeanFoo. All rights reserved.
//

#import "TFImageViewController.h"
#import "PrefixHeader.pch"
#import "TFPictureView.h"
#import "UIImageView+WebCache.h"

@interface TFImageViewController () <UIScrollViewDelegate>

// models
@property (assign, nonatomic) NSInteger currentIndex;// 当前显示图片在图片列表中的索引
@property (strong, nonatomic) NSMutableArray *imageFilePaths;// 图片文件的全路径

// views
@property (weak, nonatomic) UIScrollView *scrollView;
@property (weak, nonatomic) TFPictureView *leftPictureView;
@property (weak, nonatomic) TFPictureView *centerPictureView;
@property (weak, nonatomic) TFPictureView *rightPictureView;

@end

@implementation TFImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    // 加载数据
    [self loadImageFilePaths];
    // 将索引显示到导航栏的标题
    self.navigationItem.title = [NSString stringWithFormat:@"%@ of %@", @(self.currentIndex+1), @(self.imageFilePaths.count)];
    // 显示滚动视图
    self.scrollView.hidden = NO;
    // 取消ScrollView的自动适配
    self.automaticallyAdjustsScrollViewInsets = NO;
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    // 开启 点击控制器时隐藏导航栏 的功能
    if (kiOSVersion >= 8.0)
        self.navigationController.hidesBarsOnTap = YES;
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    // 显示导航栏
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    // 关闭 点击控制器时隐藏导航栏 的功能
    if (kiOSVersion >= 8.0)
        self.navigationController.hidesBarsOnTap = NO;
}
- (void)viewDidDisappear:(BOOL)animated {
    // 清空图片缓存
    [[SDImageCache sharedImageCache] clearMemory];
    
    [super viewDidDisappear:animated];
}
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    // 重新布局界面
    self.scrollView.frame = self.view.bounds;
    self.scrollView.contentSize = CGSizeMake(self.view.bounds.size.width*3, 0);
    self.scrollView.contentOffset = CGPointMake(self.view.bounds.size.width, 0);
    
    self.leftPictureView.zoomScale = 1.0;
    self.leftPictureView.bounds = self.view.bounds;
    self.leftPictureView.center = CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height/2);
    self.leftPictureView.imgView.bounds = self.leftPictureView.bounds;
    self.leftPictureView.imgView.center = CGPointMake(self.leftPictureView.bounds.size.width/2, self.leftPictureView.bounds.size.height/2);

    self.centerPictureView.zoomScale = 1.0;
    self.centerPictureView.frame = self.view.bounds;
    self.centerPictureView.center = CGPointMake(self.view.bounds.size.width/2 + self.view.bounds.size.width, self.view.bounds.size.height/2);
    self.centerPictureView.imgView.bounds = self.centerPictureView.bounds;
    self.centerPictureView.imgView.center = CGPointMake(self.centerPictureView.bounds.size.width/2, self.centerPictureView.bounds.size.height/2);

    self.rightPictureView.zoomScale = 1.0;
    self.rightPictureView.bounds = self.view.bounds;
    self.rightPictureView.center = CGPointMake(self.view.bounds.size.width/2 + self.view.bounds.size.width*2, self.view.bounds.size.height/2);
    self.rightPictureView.imgView.bounds = self.rightPictureView.bounds;
    self.rightPictureView.imgView.center = CGPointMake(self.rightPictureView.bounds.size.width/2, self.rightPictureView.bounds.size.height/2);
}

#pragma mark - UIScrollViewDelegate method
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    // 左滑
    if (scrollView.contentOffset.x == 0) {
        // 交换图片
        self.rightPictureView.imgView.image = self.centerPictureView.imgView.image;
        self.centerPictureView.imgView.image = self.leftPictureView.imgView.image;
        // 显示中间的图片视图
        scrollView.contentOffset = CGPointMake(self.view.bounds.size.width, 0);
        // 加载新图片
        self.currentIndex -= 1;
        if (self.currentIndex < 0) // 从第一张图片滑到最后一张图片（左循环），则设置倒数第二张为前一张
            self.currentIndex = self.imageFilePaths.count-1;
        if (self.currentIndex == 0) // 从第二张图片滑到第一张图片，则设置最后一张为前一张
            [self.leftPictureView setPictureWithImageUrl:self.imageFilePaths.lastObject];
        else // 其他，从后一张图片滑到前一张图片
            [self.leftPictureView setPictureWithImageUrl:self.imageFilePaths[self.currentIndex-1]];
    }
    // 右滑
    if (scrollView.contentOffset.x == self.view.bounds.size.width*2) {
        // 交换图片
        self.leftPictureView.imgView.image = self.centerPictureView.imgView.image;
        self.centerPictureView.imgView.image = self.rightPictureView.imgView.image;
        // 显示中间的图片视图
        scrollView.contentOffset = CGPointMake(self.view.bounds.size.width, 0);
        // 加载新图片
        self.currentIndex += 1;
        if (self.currentIndex > self.imageFilePaths.count-1) // 从最后一张图片滑到第一张图片（右循环），则设置第二张为后一张
            self.currentIndex = 0;
        if (self.currentIndex == self.imageFilePaths.count-1) // 从倒数二张图片滑到倒数第一张图片，则设置第一张为后一张
            [self.rightPictureView setPictureWithImageUrl:self.imageFilePaths.firstObject];
        else // 其他，从前一张图片到后一张图片
            [self.rightPictureView setPictureWithImageUrl:self.imageFilePaths[self.currentIndex+1]];
    }
    
    // 从一张缩放(比例不为1.0)的图片滑到了另一张图片，则需要将比例恢复到1.0
    self.leftPictureView.zoomScale = 1.0;
    self.centerPictureView.zoomScale = 1.0;
    self.rightPictureView.zoomScale = 1.0;
    // 刷新索引
    self.navigationItem.title = [NSString stringWithFormat:@"%@ of %@", @(self.currentIndex+1), @(self.imageFilePaths.count)];
}

#pragma mark - 加载数据
- (void)loadImageFilePaths {
    self.imageFilePaths = [NSMutableArray array];
    // 根据点击文件的全路径获取 所在文件夹的路径 和 点击的文件名
    NSArray *tempArr = [self.filePath componentsSeparatedByString:@"/"];
    NSString *localPath = tempArr.firstObject;
    for (int i=1; i<tempArr.count-1; i++)
        localPath = [NSString stringWithFormat:@"%@/%@", localPath, tempArr[i]];
    NSString *selectedImageName = tempArr.lastObject;
    
    for (NSInteger i=0; i<self.fileList.count; i++) {
        NSArray *name_type = [self.fileList[i] componentsSeparatedByString:@"."];
        if ([name_type.lastObject caseInsensitiveCompare:@"png"]==NSOrderedSame ||
            [name_type.lastObject caseInsensitiveCompare:@"jpg"]==NSOrderedSame ||
            [name_type.lastObject caseInsensitiveCompare:@"gif"]==NSOrderedSame) {
            // 添加图片的路径到 数组
            NSString *imageFilePath = [NSString stringWithFormat:@"%@%@", localPath, [self.fileList[i] URLEncodedString]];
            [self.imageFilePaths addObject:imageFilePath];
            // 记录点击的索引
            if ([self.fileList[i] hasSuffix:selectedImageName])
                self.currentIndex = self.imageFilePaths.count - 1;
        }
    }
    
//        DLog(@"currentIndex: %@", @(self.currentIndex));
//        DLog(@"\nimageFilePaths: %@", _imageFilePaths);
}

#pragma mark - 懒加载
// views
- (UIScrollView *)scrollView {
    if (_scrollView == nil) {
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        scrollView.backgroundColor = kColorWithHex(0xDDDDDD);
        scrollView.contentSize = CGSizeMake(self.view.bounds.size.width*3, 0);
        scrollView.contentOffset = CGPointMake(self.view.bounds.size.width, 0);
        scrollView.pagingEnabled = YES;
        scrollView.bounces = NO;
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.delegate = self;
        
        {// 设置 左边的图像视图 （用来显示上一张图片）
            NSString *imageUrl = nil;
            if (self.currentIndex-1 < 0)// 前面没有图片了，则设置最后一张图片到前一页
                imageUrl = self.imageFilePaths.lastObject;
            else// 有前一页则设置前一页的图片
                imageUrl = self.imageFilePaths[self.currentIndex-1];
            TFPictureView *leftPictureView = [[TFPictureView alloc] initWithFrame:self.view.bounds andImageUrl:imageUrl];
            leftPictureView.center = CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height/2);
            [scrollView addSubview:leftPictureView];
            self.leftPictureView = leftPictureView;
        }

        {// 设置 中间的图像视图 （用来显示当前图片）
            TFPictureView *centerPictureView = [[TFPictureView alloc] initWithFrame:self.view.bounds andImageUrl:self.imageFilePaths[self.currentIndex]];
            centerPictureView.center = CGPointMake(self.view.bounds.size.width/2 + self.view.bounds.size.width, self.view.bounds.size.height/2);
            [scrollView addSubview:centerPictureView];
            self.centerPictureView = centerPictureView;
        }
        
        {// 设置 右边的图像视图 （用来显示下一张图片）
            NSString *imageUrl = nil;
            if (self.currentIndex+1 == self.imageFilePaths.count)// 后面没有图片了，则设置第一张图片到后一页
                imageUrl = self.imageFilePaths.firstObject;
            else// 有后一页则设置后一页的图片
                imageUrl = self.imageFilePaths[self.currentIndex+1];
            TFPictureView *rightPictureView = [[TFPictureView alloc] initWithFrame:self.view.bounds andImageUrl:imageUrl];
            rightPictureView.center = CGPointMake(self.view.bounds.size.width/2 + self.view.bounds.size.width*2, self.view.bounds.size.height/2);
            [scrollView addSubview:rightPictureView];
            self.rightPictureView = rightPictureView;
        }
        
        [self.view addSubview:scrollView];
        _scrollView = scrollView;
    }
    return _scrollView;
}

@end
