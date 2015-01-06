//
//  CDatePickerView.h
//  CalendarSDK
//
//  Created by GaoAng on 14-2-26.
//  Copyright (c) 2014年C. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol CDatePickerViewDelegate <NSObject>

-(void)datePickerViewSeldate:(NSDate*)date;

@end
@interface CDatePickerView : UIView{
	UIDatePicker *mDatePikcer;
	UILabel *bgLabel;
}


@property (nonatomic, assign) BOOL isShow;
@property (nonatomic, retain) NSDate *mCurDate;
@property(nonatomic, assign) id<CDatePickerViewDelegate> m_delegate;
-(void)showDatePickerView:(BOOL)show;
-(void)showDatePickerView:(BOOL)show WithDate:(NSDate*)date;
@end


