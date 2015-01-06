//
//  CHistoryViewController.m
//  SMSTimer
//
//  Created by GaoAng on 14-4-8.
//  Copyright (c) 2014年 selfcom. All rights reserved.
//

#import "CHistoryViewController.h"
#import "CHistoryTableViewCell.h"
#import "../NetWork/CRequest.h"
#import "../DateBase/CDBConfig.h"
#import "../CStatusBarWindow.h"

@interface CHistoryViewController ()

@end

@implementation CHistoryViewController
@synthesize listView, arrListData;
@synthesize indexOfPage;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
		indexOfPage = 1;
    }
    return self;
}
-(NSMutableArray*)arrListData{
	if (arrListData == nil) {
		arrListData = [[NSMutableArray alloc] initWithCapacity:1];
	}
	return arrListData;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	self.title = @"历史记录";
	
	UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:self action:@selector(backAction:)];
	[left setTintColor:[UIColor blackColor]];
	self.navigationItem.leftBarButtonItem =left;
	
	[self addFooter];
	UILongPressGestureRecognizer *longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
	[listView addGestureRecognizer:longPressRecognizer];

//	[self loadDataFromDB];
	if (![CUserInfo sharedInstance].isLogin) {
		CRequest *request = [[CRequest alloc] initWithDelegate:self];
		[request LoginCCalendar:[NSString stringWithFormat:@"%@@139.com",[CUserInfo sharedInstance].strAccount] :[CUserInfo sharedInstance].strPswd];
	}
	else{
		[self sendRequest];
	}
    
    
    if ([self.listView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.listView setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([self.listView respondsToSelector:@selector(setSeparatorStyle:)]) {
        [self.listView setSeparatorInset:UIEdgeInsetsZero];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
}


-(void)sendRequest{
	CRequest *req = [[CRequest alloc] initWithDelegate:self];
	
	CGetSmsSender *info = [[CGetSmsSender alloc] init];
	info.actionId = 0;
	info.currentIndex = 1;
	info.phoneNum = 10;
	info.deleSmsIds = @"";
	info.keyWord = @"";
	info.mobile= @"";
	info.pageIndex = indexOfPage;
	info.pageSize = 20;
	info.searchDateType = 0;
	
	[req GetMessageHistoryWith:info];
}
-(void)NotifyFreshUI:(ERequestType)requestType descp:(NSString *)item data:(NSArray *)arr isSynState:(BOOL)isSuccess{

	if (requestType == OPERATE_Login_Calendar) {
		[self sendRequest];
	}
	else if (requestType == OPERATE_QueryHistory ){
		if ([arr count] <= 0) {
			[g_pCStatusBar showMessage:@"取完所有记录"];
			[self.listView reloadData];
		}
		else{
			[self loadDataFromDB];
		}
		[self doneWithView:_footer];
	}
	else{
		
	}
}

- (void)addFooter
{
    RFRefreshFooterView *footer = [RFRefreshFooterView footer];
    footer.scrollView =self.listView;
    footer.beginRefreshingBlock = ^(RFRefreshBaseView *refreshView) {
		indexOfPage = indexOfPage +1;
		[self sendRequest];
    };
    _footer = footer;
}

-(void)loadDataFromDB{

	[self.arrListData removeAllObjects];
	self.arrListData = [[CCDBConfig shareInstace] qureyMailMessage];
	[listView reloadData];
	
}

- (void)doneWithView:(RFRefreshBaseView *)refreshView
{
    // 刷新表格
    [refreshView endRefreshing];
}

-(void)handleLongPress:(UILongPressGestureRecognizer *)recognizer{
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell  setLayoutMargins:UIEdgeInsetsZero];
    }
    
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	static NSString *cellid = @"CHistoryTableViewCell";
	CHistoryTableViewCell *cell = (CHistoryTableViewCell*) [tableView dequeueReusableCellWithIdentifier:cellid];
	if (cell == nil) {
        cell = [[CHistoryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
		[cell.textLabel setBackgroundColor:[UIColor clearColor]];
		[cell.textLabel setFont:[UIFont systemFontOfSize:16.0f]];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
	}
	
	if (indexPath.row >= 0 && indexPath.row < [arrListData count]) {
		CSMSData* data = [arrListData objectAtIndex:indexPath.row];
        [cell loardDataWith:data];
		
	}
	return cell;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
	return  1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	return [arrListData count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row >= 0 && indexPath.row < [arrListData count]) {
        CSMSData* data = [arrListData objectAtIndex:indexPath.row];
        return  [CHistoryTableViewCell cellForData:data.sendMsg];
    }
	return  120;
}
-(void)backAction:(id)sender{
	[self.navigationController popViewControllerAnimated:YES];
}
@end
