//
//  CMainViewController.m
//  SMSTimer
//
//  Created by GaoAng on 14-3-31.
//  Copyright (c) 2014年 selfcom. All rights reserved.
//

#import "CMainViewController.h"
#import "CLoginViewController.h"
#import "CContactersViewController.h"
#import "CStatusBarWindow.h"
#import "CHistoryViewController.h"
#import "RFUtility.h"
#import "CPersonViewController.h"
#import "CTimeSelectViewController.h"
#import "RFContact.h"
#import "CRegisterViewController.h"

@implementation CAttenderInfo
@end


@interface CMainViewController ()

@property (nonatomic, strong) CSendMessageInfo *mSendMsgInfo;
@end

@implementation CMainViewController
@synthesize datePickerView, msgTextView;
@synthesize keyBoradBtn, tabbarControl;
@synthesize timeBtn;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(CSendMessageInfo*)mSendMsgInfo{
    if (!_mSendMsgInfo) {
        _mSendMsgInfo = [[CSendMessageInfo alloc] init];
    }
    return _mSendMsgInfo;
}
-(NSMutableArray*)arrAttenders{
    if (!_arrAttenders) {
        _arrAttenders = [[NSMutableArray alloc] initWithCapacity:1];
    }
    return _arrAttenders;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	self.title = @"发送短信";
//	[self.view setBackgroundColor:[UIColor colorWithRed:242/255.0 green:248/255.0 blue:250/255.0 alpha:1.0]];

    [self.mView setFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
	//登录按钮
    UIButton  *returnBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 35, 35)];
    [returnBtn setBackgroundColor:[UIColor clearColor]];
    [returnBtn setBackgroundImage:[UIImage imageNamed:@"默认头像-大"] forState:UIControlStateNormal];
    [returnBtn setBackgroundImage:[UIImage imageNamed:@"默认头像-大"] forState:UIControlStateHighlighted];
    [returnBtn addTarget:self action:@selector(loginItemAction) forControlEvents:UIControlEventTouchUpInside];
    returnBtn.layer.borderColor = [UIColor redColor].CGColor;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:returnBtn];

	//历史记录
	UIBarButtonItem *right =[[UIBarButtonItem alloc] initWithTitle:@"发送记录" style:UIBarButtonItemStylePlain target:self action:@selector(rightItemAction)];
	[right setTintColor:[UIColor blackColor]];
	self.navigationItem.rightBarButtonItem =right;
    self.view.userInteractionEnabled = YES;
    
    [self.attenderField setBackgroundColor:[UIColor whiteColor]];
    self.attenderField.layer.cornerRadius = 5.0f;
    self.attenderField.delegate = self;
    self.attenderField.layer.borderWidth = .5f;
    self.attenderField.layer.borderColor = [UIColor grayColor].CGColor;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleTokenFieldFrameDidChange:) name:JSTokenFieldFrameDidChangeNotification object:nil];

	self.msgTextView.delegate = self;
    self.msgTextView.layer.cornerRadius = 10.0f;
    self.msgTextView.layer.borderWidth = .5f;
    self.msgTextView.layer.borderColor = [UIColor grayColor].CGColor;
    [self.msgTextView setBackgroundColor:[UIColor whiteColor]];
    self.senderButton.layer.cornerRadius = 4.0f;
    [self loardTimeLabel];
    
    if (![self checkAccountInfo]) {
        CLoginViewController *contacterController = [[CLoginViewController alloc] initWithNibName:@"CLoginViewController" bundle:nil];
        [self.navigationController pushViewController:contacterController animated:NO];
    }
}

-(void)viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
	self.title = @"发送短信";

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loginFinished{
	self.title = @"发送短信";
}


-(void)textViewDidBeginEditing:(UITextView *)textView{
	[self.keyBoradBtn setHidden:NO];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if (range.location>=70)
    {
        return  NO;
    }
    else
    {
        return YES;
    }
}


-(IBAction)hiddenKeyBoard:(id)sender{
	[keyBoradBtn setHidden:YES];
	[msgTextView resignFirstResponder];
}


-(BOOL)checkAccountInfo{
    if ([CUserInfo sharedInstance].strAccount.length <= 0 || [CUserInfo sharedInstance].strPswd.length <= 0) {
        return NO;
    }
    if (![CUserInfo sharedInstance].isLogin) {
        CRequest *request = [[CRequest alloc] initWithDelegate:self];
        [request LoginCCalendar:[NSString stringWithFormat:@"%@@139.com",[CUserInfo sharedInstance].strAccount] :[CUserInfo sharedInstance].strPswd];
        return YES;
    }
    return YES;
}

-(void)NotifyFreshUI:(ERequestType)requestType descp:(NSString *)item data:(NSArray *)arr isSynState:(BOOL)isSuccess{
	if (requestType== OPERATE_Login_Calendar) {
        if (isSuccess) {
//            [self sendMsgToServer];
        }
        else{
            [RFUtility showMessage:@"登录失败，请稍后重试"];
            CLoginViewController *contacterController = [[CLoginViewController alloc] initWithNibName:@"CLoginViewController" bundle:nil];
            [self.navigationController pushViewController:contacterController animated:YES];
        }
	}
	else if (requestType == OPERATE_Send_Msg){
		if (isSuccess) {
			[g_pCStatusBar showMessage:@"发送成功"];
		}
		else{
			[g_pCStatusBar showMessage:@"发送失败"];
		}
	}
	else{
	}
}


-(IBAction)sendButton:(id)sender{
	if (![CUserInfo sharedInstance].isLogin) {
		CRequest *request = [[CRequest alloc] initWithDelegate:self];
		[request LoginCCalendar:[NSString stringWithFormat:@"%@@139.com",[CUserInfo sharedInstance].strAccount] :[CUserInfo sharedInstance].strPswd];
	}
	else{
		[self sendMsgToServer];
	}

	[keyBoradBtn setHidden:YES];
	[msgTextView resignFirstResponder];

}


-(void)sendMsgToServer{
    if (self.arrAttenders.count <= 0) {
        [RFUtility showMessage:@"前输入短信接受人"];
        return;
    }
    if (self.msgTextView.text.length <= 0 || self.msgTextView.text.length>= 140) {
        [RFUtility showMessage:@"请输入140字以内的短信内容"];
        return;
    }
    NSMutableString *string = [NSMutableString string];
    [string  appendString:@""];
    for (CAttenderInfo *info in self.arrAttenders) {
        [string appendString:info.phoneNumber];
        [string appendString:@","];
    }
	CRequest *req = [[CRequest alloc] initWithDelegate:self];
	self.mSendMsgInfo.smsContent = self.msgTextView.text;
	self.mSendMsgInfo.receiverNumber = string;
	[req sendMessageWith:self.mSendMsgInfo];
}

-(void)loardTimeLabel{
    NSString *dateStr = [RFUtility stringWithDate:[NSDate dateWithTimeIntervalSince1970:self.mSendMsgInfo.mSendTime] withFormat:@"YYYY年MM月dd日 HH:mm"];
    [self.timeLabel setText:dateStr];
}

-(BOOL) checkAttenderInfo:(NSString*)phoneNumber{
    if (self.arrAttenders.count <= 0) {
        return YES;
    }
    for (CAttenderInfo *temp in self.arrAttenders) {
        if ([temp.phoneNumber isEqualToString:phoneNumber]) {
            return NO;
        }
    }
    
    return YES;
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesEnded:touches withEvent:event];
    UITouch *touch = [touches anyObject];
    CGPoint postion = [touch locationInView:self.view];
    if (CGRectContainsPoint(self.msgTextView.frame, postion)) {
        [self hiddenKeyBoard:nil];
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    [self hiddenKeyBoard:nil];
}

#pragma mark -

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    return YES;
}
#pragma mark JSTokenFieldDelegate

- (void)tokenField:(JSTokenField *)tokenField didAddToken:(NSString *)title representedObject:(id)obj
{
//    NSDictionary *recipient = [NSDictionary dictionaryWithObject:obj forKey:title];
    if(![RFUtility isMobileNumber:obj])
    {
        [self.attenderField removeTokenForString:obj];
        [RFUtility showMessage:@"非法的手机号！"];
        return;
    }

    if ([self checkAttenderInfo:obj]) {
        
        CAttenderInfo *info = [[CAttenderInfo alloc] init];
        [info setName:title];
        [info setPhoneNumber:obj];
        [_arrAttenders addObject:info];
    }
    
//    [_arrAttenders addObject:recipient];
    NSLog(@"Added token for < %@ : %@ >\n%@", title, obj, _arrAttenders);
}

- (void)tokenField:(JSTokenField *)tokenField didRemoveTokenAtIndex:(NSUInteger)index
{
    if ( index < _arrAttenders.count) {
        [_arrAttenders removeObjectAtIndex:index];
    }
}

- (BOOL)tokenFieldShouldReturn:(JSTokenField *)tokenField {
    NSMutableString *recipient = [NSMutableString string];
    
    NSMutableCharacterSet *charSet = [[NSCharacterSet whitespaceCharacterSet] mutableCopy];
    [charSet formUnionWithCharacterSet:[NSCharacterSet punctuationCharacterSet]];
    
    NSString *rawStr = [[tokenField textField] text];
    for (int i = 0; i < [rawStr length]; i++)
    {
        if (![charSet characterIsMember:[rawStr characterAtIndex:i]])
        {
            [recipient appendFormat:@"%@",[NSString stringWithFormat:@"%c", [rawStr characterAtIndex:i]]];
        }
    }
    
    if ([rawStr length])
    {
        [tokenField addTokenWithTitle:rawStr representedObject:recipient];
    }
    
    return NO;
}

- (void)handleTokenFieldFrameDidChange:(NSNotification *)note
{
    if ([[note object] isEqual:_attenderField])
    {
//        [UIView animateWithDuration:0.0
//                         animations:^{
                             [_mView setFrame:CGRectMake(CGRectGetMinX(_mView.frame),
                                                              CGRectGetMaxY(_attenderField.frame)+  10,
                                                              CGRectGetWidth(_mView.frame),
                                                              CGRectGetHeight(_mView.frame))];
        UIScrollView *scrollView = (UIScrollView*)self.view;
        [scrollView setContentSize:CGSizeMake(CGRectGetWidth(scrollView.frame), CGRectGetHeight(_mView.frame) + CGRectGetHeight(_attenderField.frame) + 100)];
                             
//                         }
//                         completion:nil];
    }
}


//时间选择
-(IBAction)datePickerButton:(id)sender{
    [self hiddenKeyBoard:nil];

    CTimeSelectViewController *contacterController = [[CTimeSelectViewController alloc] initWithNibName:@"CTimeSelectViewController" bundle:nil curDate:0];
    
    __weak typeof(CMainViewController*) _weakSelf= self;
    [contacterController setDidSelectDate:^(double time){
        [_weakSelf.mSendMsgInfo setMSendTime:time];
        NSString *dateStr = [RFUtility stringWithDate:[NSDate dateWithTimeIntervalSince1970:time] withFormat:@"YYYY年MM月dd日 HH:mm"];
        [_weakSelf.timeLabel setText:dateStr];
    }];
    
    [self.navigationController pushViewController:contacterController animated:YES];
}

-(void)datePickerViewSeldate:(NSDate *)date{
	NSString* temp = [RFUtility FormatNSStringFromDate:date :@"yyyy-MM-dd HH:mm:ss"];
	[timeBtn setTitle:[NSString stringWithFormat:@"时间设定：%@",temp] forState:UIControlStateNormal];
}

//添加联系人
-(IBAction)addContarorView:(id)sender{
    [self hiddenKeyBoard:nil];
    __weak typeof(CMainViewController*) weakSelf = self;
	CContactersViewController *contacterController = [[CContactersViewController alloc] initWithNibName:@"CContactersViewController" bundle:nil];
	[contacterController setDidSelectContacters:^(NSMutableArray *arr){
        for (RFContact *contact in arr) {
            if (contact.phoneArray.count > 0) {
                NSString *phone = [contact.phoneArray objectAtIndex:0];
                if ([weakSelf checkAttenderInfo:phone]) {
                    NSString *name = [NSString stringWithFormat:@"%@%@",contact.nameFirst, contact.nameLast];
                    if (name.length <= 0) {
                        name = phone;
                    }
                    [weakSelf.attenderField addTokenWithTitle:name representedObject:phone];
                }
            }
        }
	}];
	[self.navigationController pushViewController:contacterController animated:YES];
}

//历史记录
-(void)rightItemAction{
    [self hiddenKeyBoard:nil];
	CHistoryViewController *contacterController = [[CHistoryViewController alloc] initWithNibName:@"CHistoryViewController" bundle:nil];
	[self.navigationController pushViewController:contacterController animated:YES];
}


//登录
-(void)loginItemAction{
    [self hiddenKeyBoard:nil];
    
    if (![CUserInfo sharedInstance].isLogin) {
        CLoginViewController *contacterController = [[CLoginViewController alloc] initWithNibName:@"CLoginViewController" bundle:nil];
        [self.navigationController pushViewController:contacterController animated:YES];
    }
    else{
        CPersonViewController *contacterController = [[CPersonViewController alloc] initWithNibName:@"CPersonViewController" bundle:nil];
        [self.navigationController pushViewController:contacterController animated:YES];
    }
}

#pragma mark - 

@end
