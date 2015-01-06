//
//  UIColor+String.h
//  SMSTimer
//
//  Created by GaoAng on 14/12/17.
//  Copyright (c) 2014年 selfcom. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIColor (string)
/**
 *  根据字符 OX000000 & #000000 生成对应的UIColor
 *
 *  @param colorString: OX000000 & #000000
 *
 *  @return UIColor
 */
+ (UIColor *)colorFromColorString:(NSString *)colorString;

/**
 *  根据指定的颜色字符串和透明度 生成对应UIColor
 *
 *  @param colorString colorstring  OX000000 & #000000
 *  @param alpha       透明度
 *
 *  @return UIColor
 */
+ (UIColor *)colorFromColorString:(NSString *)colorString alpha:(CGFloat)alpha;




/**
 *  根据指定的颜色字符串和透明度 生成对应UIColor
 *
 *  @param colorString colorstring  OX000000 & #000000
 *  @param alpha       透明度
 *
 *  @return UIColor
 */
+ (UIColor *)colorWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue;
@end
