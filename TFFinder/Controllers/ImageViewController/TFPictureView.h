//
//  TFPictureView.h
//  TFFinder
//
//  Created by teanfoo on 16/12/23.
//  Copyright © 2016 TeanFoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TFPictureView : UIScrollView
/** 图片视图 */
@property (weak, nonatomic) UIImageView *imgView;

- (instancetype)initWithFrame:(CGRect)frame andImageUrl:(NSString *)imageUrl;
- (void)setPictureWithImageUrl:(NSString *)imageUrl;

- (instancetype)initWithFrame:(CGRect)frame andImage:(UIImage *)image;

@end
