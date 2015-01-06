//
//  CLoginViewController.h
//  SMSTimer
//
//  Created by GaoAng on 14-3-31.
//  Copyright (c) 2014年 selfcom. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CRequest.h"

@interface CLoginViewController : UIViewController <CRequestCalendarDelegate>

@property (nonatomic, assign) id m_delegate;
//@property (nonatomic, strong) IBOutlet UITextField *accountTextField;
//@property (nonatomic, strong) IBOutlet UITextField *pswdTextField;


@property (nonatomic, strong) IBOutlet UIButton* loginBtn;
@end
