//
//  TFWebProgress.h
//  TFFinder
//
//  Created by teanfoo on 16/12/30.
//  Copyright © 2016 TeanFoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TFWebProgress : UIView

// default: green
@property (strong, nonatomic) UIColor *progressColor;

- (void)start;
- (void)finish;

@end
