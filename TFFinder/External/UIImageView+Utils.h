//
//  UIImageView+Utils.h
//  TFFinder
//
//  Created by teanfoo on 16/12/26.
//  Copyright © 2016 TeanFoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (Utils)

// 根据SuperView和Image的宽高比例来重新设置ImageView的尺寸
// 如果image 为 nil, 则取imageView的image, 如果imageView的image也为nil, 则不执行任何操作
// 如果superView 为 nil, 则取imageView的superView, 如果imageView的superView也为nil, 则不执行任何操作
- (void)resizeWithImage:(UIImage *)image onSuperView:(UIView *)superView;

@end
