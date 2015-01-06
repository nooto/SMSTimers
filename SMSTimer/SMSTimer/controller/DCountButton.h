//
//  CXCountDownLabel.h
//  DCalendar
//
//  Created by GaoAng on 14-5-19s.
//  Copyright (c) 2014年 richinfo.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>


@interface DCountButton : UIButton

@property (nonatomic, strong, readonly) NSTimer *countTimer;
@property (nonatomic, assign) NSUInteger countInterval; // default is 0. when it is 0, use sqrtf(endNumber - startNumber) which is faster.
@property (nonatomic, assign) NSUInteger indexInterval; // default is 0. when it is 0, use sqrtf(endNumber - startNumber) which is faster.
@property (nonatomic, copy) NSString *strInitString;   //初始状态仙子
@property (nonatomic, copy) NSString *strDisableString;   //计时时显示
@property (nonatomic, copy) NSString *strEnabelString;    //计时后 显示



- (id)initWithFrame:(CGRect)frame count:(NSInteger)count;
-(void)setStringDisplayInit:(NSString*)strInit disable:(NSString*)strDistr enabel:(NSString*)strEnable;
- (void)restartCount;
- (void)stopCount;
@end
