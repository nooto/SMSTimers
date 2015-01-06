//
//  InputText.h
//  动态输入框
//
//  Created by mxd on 14/12/4.
//  Copyright (c) 2014年 daizhe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface InputText : NSObject
/**
 *  输入框创建方法
 *
 *  @param icon  输入框图标
 *  @param centerX 输入框中点x值
 *  @param textY 输入框y值
 *  @param point 输入框提示文字
 */

- (UITextField *)setupWithIcon:(NSString *)icon textY:(CGFloat)textY centerX:(CGFloat)centerX point:(NSString *)point;
@end

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com 
