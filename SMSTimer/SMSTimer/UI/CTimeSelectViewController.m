//
//  CTimeSelectViewController.m
//  SMSTimer
//
//  Created by GaoAng on 14/12/24.
//  Copyright (c) 2014年 selfcom. All rights reserved.
//

#import "CTimeSelectViewController.h"

#define KBOTTOMHEIGHT 40.0F
@interface CTimeSelectViewController ()
@property (nonatomic, strong) IBOutlet UIDatePicker *mDatePicker;
@property (nonatomic, strong) IBOutlet  UILabel  *mTimeLabel;

@property (nonatomic, assign) double  mCurDate;

@end

@implementation CTimeSelectViewController
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil curDate:(double)dateVal{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.mCurDate = dateVal;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"发送时间";
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:self action:@selector(bactAction:)];
    [left setTintColor:[UIColor blackColor]];
    self.navigationItem.leftBarButtonItem =left;
    NSString *dateStr = [RFUtility stringWithDate:[NSDate dateWithTimeIntervalSince1970:self.mCurDate] withFormat:@"YYYY年MM月dd日 HH:mm"];
    [self.mTimeLabel setText:dateStr];
    
    self.mDatePicker.layer.borderColor = [UIColor whiteColor].CGColor;
    self.mDatePicker.layer.borderWidth = 0.5F;
    [self.mDatePicker setBackgroundColor:[UIColor whiteColor]];
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.mDatePicker setFrame:CGRectMake(0,
                                          ScreenHeight - CGRectGetHeight(self.mDatePicker.frame)- KBOTTOMHEIGHT,
                                          CGRectGetWidth(self.mDatePicker.frame),
                                          CGRectGetHeight(self.mDatePicker.frame))];
    
}

-(void)bactAction:(UIButton*)sender{
    if (self.didSelectDate) {
        self.didSelectDate(self.mCurDate);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setMCurDate:(double)mCurDate{
    _mCurDate = mCurDate;
    if (mCurDate <= 0) {
        _mCurDate = [[NSDate date] timeIntervalSince1970];
    }
    NSString *dateStr = [RFUtility stringWithDate:[NSDate dateWithTimeIntervalSince1970:_mCurDate] withFormat:@"YYYY年MM月dd日 HH:mm"];
    [self.mTimeLabel setText:dateStr];

}

-(IBAction)dateChanged:(id)sender{
    self.mCurDate = [self.mDatePicker.date timeIntervalSince1970];
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
