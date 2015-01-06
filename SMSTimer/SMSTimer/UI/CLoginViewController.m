//
//  CLoginViewController.m
//  SMSTimer
//
//  Created by GaoAng on 14-3-31.
//  Copyright (c) 2014年 selfcom. All rights reserved.
//

#import "CLoginViewController.h"
#import "CRegisterViewController.h"
#import "../CMainViewController.h"
#import "../RFUtility.h"
#import "InputText.h"
#import "CAuthCodeLoginViewController.h"

@interface CLoginViewController ()<UITextFieldDelegate>

@property (nonatomic, weak)UITextField *accountTextField;
@property (nonatomic, weak)UILabel     *accountTextName;


@property (nonatomic, weak)UITextField  *pswdTextField;
@property (nonatomic, weak)UILabel      *pswdTextName;
@property (nonatomic, assign) BOOL chang;
@end

@implementation CLoginViewController
@synthesize  accountTextField, pswdTextField, m_delegate;
@synthesize loginBtn;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.title = @"登录";
	[[UIBarButtonItem appearance] setTintColor:[UIColor colorWithRed:242/255.0 green:248/255.0 blue:250/255.0 alpha:1.0]];
	[self.view setBackgroundColor:[UIColor colorWithRed:242/255.0 green:248/255.0 blue:250/255.0 alpha:1.0]];
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:self action:@selector(backAction:)];
    [left setTintColor:[UIColor blackColor]];
    self.navigationItem.leftBarButtonItem =left;

    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"注册" style:UIBarButtonItemStyleBordered target:self action:@selector(resigerButton:)];
    [rightButton setTintColor:[UIColor blackColor]];
    self.navigationItem.rightBarButtonItem =rightButton;

    
    CGFloat centerX = self.view.width * 0.5;
    InputText *inputText = [[InputText alloc] init];
    CGFloat userY = 150;
    UITextField *userText = [inputText setupWithIcon:nil textY:userY centerX:centerX point:nil];
    userText.delegate = self;
    self.accountTextField = userText;
    [userText setReturnKeyType:UIReturnKeyNext];
    userText.keyboardType = UIKeyboardTypePhonePad;
    [userText addTarget:self action:@selector(textFieldDidChange) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:userText];
    
    UILabel *userTextName = [self setupTextName:@"手机号" frame:userText.frame];
    self.accountTextName = userTextName;
    [self.view addSubview:userTextName];
    
    CGFloat passwordY = CGRectGetMaxY(userTextName.frame) + 20;
    UITextField *passwordText = [inputText setupWithIcon:nil textY:passwordY centerX:centerX point:nil];
    [passwordText setReturnKeyType:UIReturnKeyDone];
    [passwordText setSecureTextEntry:YES];
    passwordText.delegate = self;
    self.pswdTextField = passwordText;
    [passwordText addTarget:self action:@selector(textFieldDidChange) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:passwordText];
    UILabel *passwordTextName = [self setupTextName:@"密码" frame:passwordText.frame];
    self.pswdTextName = passwordTextName;
    [self.view addSubview:passwordTextName];
    
    
    [self.loginBtn setBackgroundColor:MainTitleBgColor];
    self.loginBtn.layer.cornerRadius = 4.0f;

   self.accountTextName.font = self.accountTextField.font= self.pswdTextName.font = self.pswdTextField.font = [UIFont systemFontOfSize:16];

}

-(void)viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
	if ([self checkAccountInfo]) {
		UIBarButtonItem *left =[[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(backBtn:)];
		[left setTintColor:[UIColor blackColor]];
		self.navigationItem.leftBarButtonItem =left;

	}
}



- (UILabel *)setupTextName:(NSString *)textName frame:(CGRect)frame
{
    UILabel *textNameLabel = [[UILabel alloc] init];
    textNameLabel.text = textName;
    textNameLabel.font = [UIFont systemFontOfSize:16];
    textNameLabel.textColor = [UIColor grayColor];
    textNameLabel.frame = frame;
    return textNameLabel;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)closeKeyboard{
	[accountTextField resignFirstResponder];
	[pswdTextField resignFirstResponder];
	
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
	[super touchesEnded:touches withEvent:event];
	UITouch *touch = [[event allTouches] anyObject];

    CGPoint point =	[touch locationInView:self.view];

	if (!CGRectContainsPoint(accountTextField.frame, point) && !CGRectContainsPoint(pswdTextField.frame, point)) {
		[self closeKeyboard];
	}
}
-(BOOL)resignFirstResponder{
	if (accountTextField.becomeFirstResponder || pswdTextField.becomeFirstResponder) {
		[self closeKeyboard];
	}
	
	return YES;
}

#pragma mark - textField
#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == self.accountTextField) {
        [self diminishTextName:self.accountTextName];
        [self restoreTextName:self.pswdTextName textField:self.pswdTextField];
    }
    else if (textField == self.pswdTextField) {
        [self diminishTextName:self.pswdTextName];
        [self restoreTextName:self.accountTextName textField:self.accountTextField];
    }
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.accountTextField) {
        return [self.accountTextField becomeFirstResponder];
    } else if (textField == self.pswdTextField){
        return [self.pswdTextField becomeFirstResponder];
    }
    return NO;
}
- (void)diminishTextName:(UILabel *)label
{
    [UIView animateWithDuration:0.5 animations:^{
        label.transform = CGAffineTransformMakeTranslation(0, -20);
//        label.font = [UIFont systemFontOfSize:18];
    }];
}
- (void)restoreTextName:(UILabel *)label textField:(UITextField *)textFieled
{
    [self textFieldTextChange:textFieled];
    if (self.chang) {
        [UIView animateWithDuration:0.5 animations:^{
            label.transform = CGAffineTransformIdentity;
//            label.font = [UIFont systemFontOfSize:16];
        }];
    }
}
- (void)textFieldTextChange:(UITextField *)textField
{
    if (textField.text.length != 0) {
        self.chang = NO;
    } else {
        self.chang = YES;
    }
}

- (void)textFieldDidChange
{
    if (self.accountTextField.text.length != 0 && self.pswdTextField.text.length != 0 ) {
        self.loginBtn.enabled = YES;
    }
    else {
        self.loginBtn.enabled = NO;
    }
}

-(BOOL)checkAccountInfo{
	if ([CUserInfo sharedInstance].strAccount.length <= 0 || [CUserInfo sharedInstance].strPswd.length <= 0) {
		return NO;
	}
	
	//
	[accountTextField setText:[CUserInfo sharedInstance].strAccount];
    [self diminishTextName:self.accountTextName];

	[pswdTextField setText:[CUserInfo sharedInstance].strPswd];
    [self diminishTextName:self.pswdTextName];
//	[self loginAction:loginBtn];
	return YES;
}


-(IBAction)loginAction:(id)sender{
	if (accountTextField.text <= 0) {
		[RFUtility showMessage:@"请输入手机号码"];
		[accountTextField becomeFirstResponder];
		return;
	}
	if (pswdTextField.text.length <= 0) {
		[RFUtility showMessage:@"请输入密码"];
		[pswdTextField becomeFirstResponder];
		return;
	}
	
	[self closeKeyboard];

	
	CRequest *request = [[CRequest alloc] initWithDelegate:self];
	[request LoginCCalendar:[NSString stringWithFormat:@"%@@139.com",accountTextField.text] :pswdTextField.text];
}
-(void)backAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)resigerButton:(id)sender{
	[self closeKeyboard];
	
//    CAuthCodeLoginViewController *controller = [[CAuthCodeLoginViewController alloc] initWithNibName:@"CAuthCodeLoginViewController" bundle:nil];
//    [self.navigationController pushViewController:controller animated:YES];
//    
//    return;
    CRegisterViewController *contacterController = [[CRegisterViewController alloc] initWithNibName:@"CRegisterViewController" bundle:nil];
    [self.navigationController pushViewController:contacterController animated:YES];
}

-(void)backBtn:sender{
	CMainViewController *contacterController = [[CMainViewController alloc] initWithNibName:@"CMainViewController" bundle:nil];
	[self.navigationController pushViewController:contacterController animated:YES];
}

-(void)NotifyFreshUI:(ERequestType)requestType descp:(NSString *)item data:(NSArray *)arr isSynState:(BOOL)isSuccess{
    if (isSuccess) {
        CMainViewController *contacterController = [[CMainViewController alloc] initWithNibName:@"CMainViewController" bundle:nil];
        [self.navigationController pushViewController:contacterController animated:YES];
    }
    else{
        [RFUtility showMessage:@"登录失败，请稍后重试"];
    }
}

@end
