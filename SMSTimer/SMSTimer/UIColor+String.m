//
//  UIColor+String.m
//  SMSTimer
//
//  Created by GaoAng on 14/12/17.
//  Copyright (c) 2014年 selfcom. All rights reserved.
//

#import "UIColor+String.h"

@implementation UIColor(string)

+ (UIColor *) colorFromColorString:(NSString *)colorString{
    return [UIColor colorFromColorString:colorString alpha:1.0f];
}

+ (UIColor *)colorFromColorString:(NSString *)colorString alpha:(CGFloat)alpha{
    NSString *stringToConvert = @"";
    stringToConvert = [colorString stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    if ([cString rangeOfString:@","].location != NSNotFound) {
        NSArray *array = [colorString componentsSeparatedByString:@","];
        return [UIColor colorWithRed:([array[0] intValue]/255.0) green:([array[1] intValue]/255.0) blue:([array[2] intValue]/255.0) alpha:1.0];
    }
    
    if ([cString length] < 6)
        return [UIColor clearColor];
    
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    
    if ([cString length] > 6)
        cString = [cString substringToIndex:6];
    
    if ([cString length] != 6)
        return [UIColor clearColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:alpha];
}

+ (UIColor *)colorWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue
{
    return [UIColor colorWithRed:(red / 255.0f) green:(green / 255.0f) blue:(blue / 255.0f) alpha:1.0f];
}


@end
