//
//  TFPictureView.m
//  TFFinder
//
//  Created by apple on 16/12/23.
//  Copyright © 2016年 legentec. All rights reserved.
//

#import "TFPictureView.h"
#import "SDWebImageManager.h"
#import "UIImageView+WebCache.h"
#import "MBProgressHUD.h"

@interface TFPictureView () <UIScrollViewDelegate>

@property (weak, nonatomic) MBProgressHUD *progressView;

@end

@implementation TFPictureView

- (instancetype)initWithFrame:(CGRect)frame andImageUrl:(NSString *)imageUrl {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.contentSize = self.bounds.size;
        self.bounces = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.minimumZoomScale = 1.0;
        self.maximumZoomScale = 5.0;
        self.delegate = self;
        // 设置图片
        [self setPictureWithImageUrl:imageUrl];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame andImage:(UIImage *)image {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.contentSize = self.bounds.size;
        self.bounces = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.minimumZoomScale = 1.0;
        self.maximumZoomScale = 5.0;
        self.delegate = self;
        // 设置图片
        self.imgView.image = image;
    }
    return self;
}
- (void)setPictureWithImageUrl:(NSString *)imageUrl {
    BOOL isCached = [[SDWebImageManager sharedManager] cachedImageExistsForURL:[NSURL URLWithString:imageUrl]];
    if (isCached) {
        if (!self.progressView.hidden) self.progressView.hidden = YES;
        UIImage *cachedImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:imageUrl];
        self.imgView.image = cachedImage;
    }
    else {
        self.progressView.hidden = NO;
        [self.imgView sd_setImageWithURL:[NSURL URLWithString:imageUrl]
                        placeholderImage:nil
                                 options:0
                                progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                    self.progressView.progress = ((float)receivedSize)/expectedSize;
                                }
                               completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                   self.progressView.hidden = YES;
                               }];
    }
}

#pragma mark - UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imgView;
}
- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    // 缩放时让图片保持在屏幕中央
    CGFloat offsetX = (scrollView.bounds.size.width>scrollView.contentSize.width) ? (scrollView.bounds.size.width-scrollView.contentSize.width)*0.5 : 0.0;
    CGFloat offsetY = (scrollView.bounds.size.height>scrollView.contentSize.height) ? (scrollView.bounds.size.height-scrollView.contentSize.height)*0.5 : 0.0;
    self.imgView.center = CGPointMake(scrollView.contentSize.width*0.5 + offsetX, scrollView.contentSize.height*0.5 + offsetY);
}

#pragma mark - 懒加载
- (UIImageView *)imgView {
    if (_imgView == nil) {
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:self.bounds];
        imgView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:imgView];
        
        _imgView = imgView;
    }
    return _imgView;
}
- (MBProgressHUD *)progressView {
    if (_progressView == nil) {
        MBProgressHUD *progressView = [MBProgressHUD showHUDAddedTo:self animated:YES];
        progressView.mode = MBProgressHUDModeDeterminate;
        progressView.hidden = YES;
        _progressView = progressView;
    }
    return _progressView;
}

@end
