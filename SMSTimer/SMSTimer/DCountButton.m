//
//  DTextField.m
//  DCalendar
//
//  Created by GaoAng on 14-5-19.
//  Copyright (c) 2014年 richinfo.cn. All rights reserved.
//
#import "DCountButton.h"

@interface DCountButton ()
@end

@implementation DCountButton
@synthesize countInterval, countTimer, indexInterval;
@synthesize strDisableString, strEnabelString, strInitString;

- (id)initWithFrame:(CGRect)frame count:(NSInteger)count
{
    self = [super initWithFrame:frame];
    if (self) {
		countInterval = count <= 0 ? 10: count;
		strInitString = @"获取验证码";
		strDisableString = @"%d秒后重新获取";
		strEnabelString = @"重新获取验证码";
		[self.titleLabel setFont:[UIFont systemFontOfSize:12.0f]];
		[self setTitle:strInitString forState:UIControlStateNormal];
		[self setBackgroundImage:[UIImage imageNamed:@"button_Sure"] forState:UIControlStateNormal];
		indexInterval = countInterval;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
    }
    return self;
}

-(void)setStringDisplayInit:(NSString*)strInit disable:(NSString*)strDistr enabel:(NSString*)strEnable{
	strInitString = strInit.length > 0 ? strInit :@"获取验证码";
	strDisableString = strDistr.length > 0 ? strDistr :@"%d秒后重新获取";
	strEnabelString = strEnable.length > 0 ? strEnable :@"重新获取验证码";
	
	[self setTitle:strInitString forState:UIControlStateNormal];
	[self setTitle:strInitString forState:UIControlStateDisabled];
	[self setTitle:strInitString forState:UIControlStateHighlighted];
}

-(void)timerFired:(id)sender{
	[self setTitle:[NSString stringWithFormat:strDisableString, indexInterval] forState:UIControlStateNormal];
	[self setTitle:[NSString stringWithFormat:strDisableString, indexInterval] forState:UIControlStateDisabled];

	if (indexInterval <=0 ) {
		[countTimer invalidate];
		countTimer = nil;
		self.enabled = YES;
		[self setTitle:strEnabelString forState:UIControlStateNormal];
		[self setTitle:strEnabelString forState:UIControlStateDisabled];
		return;
	}
	self .enabled = NO;
	indexInterval -- ;
}

-(void)restartCount{
	indexInterval = countInterval;
	[self setEnabled:NO];
	if (countTimer == nil) {
		countTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerFired:) userInfo:nil repeats:YES];
		[countTimer fire];
	}
}

-(void)stopCount{
	if (countTimer) {
		[countTimer invalidate];
		countTimer = nil;
	}
	indexInterval = countInterval;
	[self setEnabled:YES];
	[self setTitle:strEnabelString forState:UIControlStateNormal];
	[self setTitle:strEnabelString forState:UIControlStateDisabled];

}

@end
