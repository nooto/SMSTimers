//
//  CMainViewController.h
//  SMSTimer
//
//  Created by GaoAng on 14-3-31.
//  Copyright (c) 2014年 selfcom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CDatePickerView.h"
#import "CRequest.h"
#import "JSTokenField.h"

@interface CAttenderInfo : NSObject

@property (nonatomic, copy) NSString* name;
@property (nonatomic, copy) NSString *phoneNumber;
@end

@interface CMainViewController : UIViewController<CRequestCalendarDelegate,JSTokenFieldDelegate, UITabBarDelegate, UITabBarControllerDelegate, UITextViewDelegate, CDatePickerViewDelegate,UIScrollViewDelegate>

@property (nonatomic, strong) IBOutlet UIView *mView;
@property (nonatomic, strong) IBOutlet UIButton *keyBoradBtn;
@property (nonatomic, strong) IBOutlet UIButton *senderButton;

@property(nonatomic, strong) IBOutlet UIButton *timeBtn;
@property (nonatomic, strong) IBOutlet UILabel *timeLabel;

@property (nonatomic, strong) IBOutlet UITextView* msgTextView;
@property(nonatomic, strong) CDatePickerView*datePickerView;
@property (nonatomic, strong) UITabBarController *tabbarControl;

@property (nonatomic, strong) IBOutlet JSTokenField *attenderField;
@property (nonatomic, strong)  NSMutableArray *arrAttenders;

@end
