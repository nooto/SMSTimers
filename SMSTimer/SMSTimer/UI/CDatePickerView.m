//
//  CDatePickerView.m
//  CalendarSDK
//
//  Created by GaoAng on 14-2-26.
//  Copyright (c) 2014年C. All rights reserved.
//

#import "CDatePickerView.h"

@implementation CDatePickerView
@synthesize isShow, mCurDate;
@synthesize m_delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
		[self setBackgroundColor:[UIColor whiteColor]];
		isShow = NO;
		UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
		[titleLabel setBackgroundColor:[UIColor whiteColor]];
		[titleLabel setTextAlignment:NSTextAlignmentCenter];
		[titleLabel setText:@"选择日期"];;
		[titleLabel setFont:[UIFont systemFontOfSize:16]];
		[self addSubview:titleLabel];
		
		//
		UIButton *leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
		[leftBtn setBackgroundColor:[UIColor clearColor]];
		[leftBtn setImage:[UIImage imageNamed:@"rf_cancel_nor"] forState:UIControlStateNormal];
		[leftBtn setImage:[UIImage imageNamed:@"rf_cancel_sel"] forState:UIControlStateHighlighted];
		[leftBtn setImage:[UIImage imageNamed:@"rf_cancel_sel"] forState:UIControlStateSelected];
		[leftBtn addTarget:self action:@selector(leftButtonAction) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:leftBtn];
		
		UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(320-44, 0,30, 30)];
		[rightBtn setBackgroundColor:[UIColor clearColor]];
		[rightBtn setImage:[UIImage imageNamed:@"rf_sure_nor"] forState:UIControlStateNormal];
		[rightBtn setImage:[UIImage imageNamed:@"rf_sure_sel"] forState:UIControlStateHighlighted];
		[rightBtn setImage:[UIImage imageNamed:@"rf_sure_sel"] forState:UIControlStateSelected];
		[rightBtn addTarget:self action:@selector(rightButtonAction) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:rightBtn];
		
		mCurDate = [NSDate date];
		mDatePikcer = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 30, 320, frame.size.height - 44)];
		mDatePikcer.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
			mDatePikcer.datePickerMode = UIDatePickerModeDate;
		[mDatePikcer setDate:[NSDate date]];
		[self addSubview:mDatePikcer];
    }
    return self;
}


-(void)leftButtonAction{
	if (m_delegate && [m_delegate respondsToSelector:@selector(datePickerViewSeldate:)]) {
		[m_delegate datePickerViewSeldate:nil];
	}
	[self showDatePickerView:NO];
}

-(void)rightButtonAction{
	[self showDatePickerView:NO];
	
//	if ( [RFUtility isSameDayDesDate:mDatePikcer.date srcDate:mCurDate] != 0) {
//		mCurDate = mDatePikcer.date;
//	}
//	else{
//		mCurDate = nil;
//	}
	
	if (m_delegate && [m_delegate respondsToSelector:@selector(datePickerViewSeldate:)]) {
		[m_delegate datePickerViewSeldate:mCurDate];
	}

}


-(void)showDatePickerView:(BOOL)show WithDate:(NSDate*)date{
	if (date) {
		mCurDate = date;
		[mDatePikcer setDate:mCurDate];
	}
	[self showDatePickerView:show];
}

-(void)showDatePickerView:(BOOL)show{
	isShow = show;
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.3];
	if (show) {
		[self setFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 246, 320, 246)];
	}
	else{
		[self setFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height, 320, 246)];
	}
	
	[UIView commitAnimations];
}

@end
