//
//  CPersonViewController.m
//  SMSTimer
//
//  Created by GaoAng on 14/12/24.
//  Copyright (c) 2014年 selfcom. All rights reserved.
//

#import "CPersonViewController.h"
#import "CUserInfo.h"
@interface CPersonViewController ()

@property (nonatomic, strong) IBOutlet  UIImageView* mAvatroImage;
@property (nonatomic, strong) IBOutlet UILabel     *mNameLabel;
@property (nonatomic, strong) IBOutlet  UIButton *mLogoutBtn;
@end

@implementation CPersonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"个人资料";

    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:self action:@selector(backAction:)];
    [left setTintColor:[UIColor blackColor]];
    self.navigationItem.leftBarButtonItem =left;

    if ([CUserInfo sharedInstance].strAccount.length > 0) {
        [self.mNameLabel setText:[NSString stringWithFormat:@"当前帐号:%@",[CUserInfo sharedInstance].strAccount]];
    }
    else{
        [self.mNameLabel setText:@"未登录"];
    }
    [self.mLogoutBtn setBackgroundColor:MainTitleBgColor];
    self.mLogoutBtn.layer.cornerRadius = 4.0f;
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)backAction:(UIButton*)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)logoutButtonAction:(id)sender{
    if (![CUserInfo sharedInstance].isLogin) {
        return;
    }
    [[CUserInfo sharedInstance] resetLoginData];
    [self.navigationController popViewControllerAnimated:YES];
}
@end
