//
//  CTimeSelectViewController.h
//  SMSTimer
//
//  Created by GaoAng on 14/12/24.
//  Copyright (c) 2014年 selfcom. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CTimeSelectViewController : UIViewController
@property (nonatomic, copy) void(^didSelectDate)(double);
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil curDate:(double)dateVal;
@end
