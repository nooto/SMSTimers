//
//  CAuthCodeLoginViewController.m
//  SMSTimer
//
//  Created by GaoAng on 15/1/5.
//  Copyright (c) 2015年 selfcom. All rights reserved.
//

#import "CAuthCodeLoginViewController.h"
#import "InputText.h"
#import "DCountButton.h"
#import "CRequest.h"
#import "CStatusBarWindow.h"

@interface CAuthCodeLoginViewController ()<UITextFieldDelegate, CRequestCalendarDelegate>
@property (nonatomic, strong) DCountButton *autoCodeButton;

@property (nonatomic, weak)UITextField *accountTextField;
@property (nonatomic, weak)UILabel     *accountTextName;


@property (nonatomic, weak)UITextField  *pswdTextField;
@property (nonatomic, weak)UILabel      *pswdTextName;
@property (nonatomic, assign) BOOL chang;

@end

@implementation CAuthCodeLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title =@"验证码登录";
    
    [self.view setBackgroundColor:[UIColor colorWithRed:242/255.0 green:248/255.0 blue:250/255.0 alpha:1.0]];
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:self action:@selector(backAction:)];
    [left setTintColor:[UIColor blackColor]];
    self.navigationItem.leftBarButtonItem =left;
    
    
    CGFloat centerX = self.view.width * 0.5;
    InputText *inputText = [[InputText alloc] init];
    CGFloat userY = 100;
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
    [passwordText setFrame:CGRectMake(CGRectGetMinX(passwordText.frame),
                                      CGRectGetMinY(passwordText.frame),
                                      120,
                                      CGRectGetHeight(passwordText.frame))];
    [passwordText setReturnKeyType:UIReturnKeyDone];
    [passwordText setSecureTextEntry:YES];
    passwordText.delegate = self;
    self.pswdTextField = passwordText;
    [passwordText addTarget:self action:@selector(textFieldDidChange) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:passwordText];
    UILabel *passwordTextName = [self setupTextName:@"验证码" frame:passwordText.frame];
    self.pswdTextName = passwordTextName;
    [self.view addSubview:passwordTextName];
    
    self.accountTextName.font = self.accountTextField.font= self.pswdTextName.font = self.pswdTextField.font = [UIFont systemFontOfSize:16];
    
    
    DCountButton* autoCodeButton = [[DCountButton alloc] initWithFrame:CGRectMake(self.pswdTextField.frame.origin.x + self.pswdTextField.frame.size.width +GAPX,
                                                                    self.pswdTextField.frame.origin.y - CGRectGetHeight(self.pswdTextField.frame) + 10,
                                                                    CGRectGetWidth(self.accountTextField.frame) - CGRectGetWidth(self.pswdTextField.frame),
                                                                    self.pswdTextField.frame.size.height *2 -10)
                                                   count:60];
    [autoCodeButton addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
    autoCodeButton.layer.cornerRadius = 4.0f;
    [self.view addSubview:autoCodeButton];
    [autoCodeButton.titleLabel setFont:self.loginBtn.titleLabel.font];
    [autoCodeButton setBackgroundColor:MainTitleBgColor];
    self.autoCodeButton = autoCodeButton;
    
    [self.loginBtn setBackgroundColor:MainTitleBgColor];
    self.loginBtn.layer.cornerRadius = 4.0f;

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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


-(void)backAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)buttonAction{
    if ([RFUtility GetMobileType:self.accountTextField.text] != MOBILE_CM) {
        [RFUtility showMessage:@"请输入移动手机号码"];
        return;
    }
    
    [self.autoCodeButton restartCount];
    CRequest *request = [[CRequest alloc] initWithDelegate:self];
    [request GetAutoCode:self.accountTextField.text];
}

-(void)NotifyFreshUI:(ERequestType)requestType descp:(NSString *)item data:(NSArray *)arr isSynState:(BOOL)isSuccess{
    if (requestType == OPERATE_Login_AutoCode) {
        if (isSuccess) {
            [g_pCStatusBar showMessage:@"验证码下发成功"];
        }
        else{
            [g_pCStatusBar showMessage:@"验证码下发失败"];
            [self.autoCodeButton stopCount];
        }
    }
}

-(IBAction)loginButtonAction:(id)sender{
    if ([RFUtility GetMobileType:self.accountTextField.text] != MOBILE_CM) {
        [RFUtility showMessage:@"请输入移动手机号码"];
        return;
    }
    if (self.pswdTextField.text.length <= 0) {
        [RFUtility showMessage:@"请输入验证码"];
        return ;
    }
    
    
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
//        self.loginBtn.enabled = YES;
    }
    else {
//        self.loginBtn.enabled = NO;
    }
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
