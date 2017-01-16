//
//  UIImageView+Utils.m
//  TFFinder
//
//  Created by apple on 16/12/26.
//  Copyright © 2016年 TeanFoo. All rights reserved.
//

#import "UIImageView+Utils.h"

@implementation UIImageView (Utils)

- (void)resizeWithImage:(UIImage *)image onSuperView:(UIView *)superView {
    if (image == nil) image = self.image;
    if (image == nil) return;
    if (superView == nil) superView = self.superview;
    if (superView == nil) return;
    self.image = image;
    [superView addSubview:self];
    
    CGFloat imageRatioOf_W4H = image.size.width / image.size.height;
    CGFloat superView_width = superView.bounds.size.width;
    CGFloat superView_height = superView.bounds.size.height;
    CGFloat superViewRatioOf_W4H = superView_width / superView_height;
    CGSize imageView_size = CGSizeZero;
    if (superViewRatioOf_W4H > imageRatioOf_W4H) {// 父视图的宽高比率大于图片的宽高比率
        // 以父视图的高度为基准重新设置imageView的尺寸
        imageView_size = CGSizeMake(superView_height*imageRatioOf_W4H, superView_height);
    }
    else {// 父视图的宽高比率小于或等于图片的宽高比率
        // 以父视图的宽度为基准重新设置imageView的尺寸
        imageView_size = CGSizeMake(superView_width, superView_width/imageRatioOf_W4H);
    }
    
    self.frame = CGRectMake(0, 0, imageView_size.width, imageView_size.height);
    self.center = CGPointMake(superView_width/2, superView_height/2);
}

@end
