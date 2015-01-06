//
//  CRegisterViewController.m
//  SMSTimer
//
//  Created by GaoAng on 14-4-4.
//  Copyright (c) 2014年 selfcom. All rights reserved.
//

#import "CRegisterViewController.h"

@interface CRegisterViewController ()

@property (nonatomic, strong)IBOutlet UIWebView *webViw;
//@property (nonatomic, strong)IBOutlet UIImageView *codeImage;
@end

@implementation CRegisterViewController
//@synthesize webViw;
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
	self.title = @"注册";
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:self action:@selector(backAction:)];
    [left setTintColor:[UIColor blackColor]];
    self.navigationItem.leftBarButtonItem =left;

//    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:self action:@selector(backAction:)];
//    [left setTintColor:[UIColor blackColor]];
//    self.navigationItem.leftBarButtonItem =left;

	
	[self.webViw loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.cmpassport.com/umc/reg/phone/?from=3&_fv=5"]]];
//	[self.webViw loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://sz.focus.cn/news/2014-03-21/4980249.html"]]];
    // Do any additional setup after loading the view from its nib.
}
-(void)backAction:(UIButton*)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)codeButton:(id)sender{
//    CRequest *request = [[CRequest alloc] initWithDelegate:self];
//    [request requestImageCodeCCalendar];

}
-(void)NotifyFreshUI:(ERequestType)requestType WithImage:(UIImage *)image{
//    [self.codeImage setBackgroundColor:[UIColor redColor]];
//    [self.codeImage setImage:image];
//    [self.codeImage setFrame:CGRectMake(CGRectGetMinX(self.codeImage.frame), CGRectGetMinY(self.codeImage.frame), image.size.width, image.size.height)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
