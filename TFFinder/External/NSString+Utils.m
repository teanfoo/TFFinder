//
//  NSString+Utils.m
//  TFFinder
//
//  Created by teanfoo on 16/12/19.
//  Copyright © 2016 TeanFoo. All rights reserved.
//

#import "NSString+Utils.h"

@implementation NSString (Utils)

#pragma mark - URL编码/解码
- (NSString *)URLEncodedString {
    NSString *encodedString = [self stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return encodedString;
}
- (NSString *)URLDecodingString {
    NSString *decodingString = [self stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return decodingString;
}

#pragma mark - 合法性校验
- (BOOL)isLegalUsername {
    NSString *str = @"^[A-Za-z0-9_]+$";
    NSPredicate* emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", str];
    return [emailTest evaluateWithObject:self];
}
- (BOOL)isLegalIP {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"^[0-9.]+$"];
    if (![predicate evaluateWithObject:self]) return NO;
    
    NSArray *array = [self componentsSeparatedByString:@"."];
    if (array.count != 4) return NO;
    
    for (NSString *str in array) {
        NSPredicate *predicate1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"^[0-9]+$"];
        if (![predicate1 evaluateWithObject:str]) return NO;
        if ([str intValue]<0 || [str intValue]>255) return NO;
    }
    
    return YES;
}
- (BOOL)isLegalPort {
    if (self.length>5) return NO;// 多余五位
    NSString *str = @"^[0-9]+$";
    NSPredicate* emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", str];
    if (![emailTest evaluateWithObject:self]) return NO;// 含有非数字字符
    if (self.integerValue >= 65535) return NO;// 超过65535
    
    return YES;
}
- (BOOL)isLegalQQ {
    if ([self hasPrefix:@"0"]) return NO;
    if (self.length<8 || self.length>10) return NO;
    NSString *str = @"^[0-9]+$";
    NSPredicate* emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", str];
    return [emailTest evaluateWithObject:self];
}

@end
