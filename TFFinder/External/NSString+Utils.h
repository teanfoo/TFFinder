//
//  NSString+Utils.h
//  TFFinder
//
//  Created by teanfoo on 16/12/19.
//  Copyright © 2016 TeanFoo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Utils)
// URL编码
- (NSString *)URLEncodedString;
// URL解码
- (NSString *)URLDecodingString;

/*!
 * @abstract 用户名是合法的？（数字字母和下划线以外）
 * @return 合法:YES, 非法:NO
 */
- (BOOL)isLegalUsername;
/*!
 * @abstract IP地址是合法的？
 * @return 合法:YES, 非法:NO
 */
- (BOOL)isLegalIP;
/*!
 * @abstract QQ号是合法的？
 * @return 合法:YES, 非法:NO
 */
- (BOOL)isLegalQQ;

@end
