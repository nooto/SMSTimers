//
//  CHistoryViewController.h
//  SMSTimer
//
//  Created by GaoAng on 14-4-8.
//  Copyright (c) 2014年 selfcom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "../MJRefresh/RFRefreshFooterView.h"
#import "../NetWork/CRequest.h"

@interface CHistoryViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, RFRefreshBaseViewDelegate,CRequestCalendarDelegate>{
	RFRefreshFooterView *_footer;
}
@property(nonatomic, assign) NSInteger  indexOfPage;
@property(nonatomic, strong) IBOutlet UITableView *listView;
@property(nonatomic, strong) NSMutableArray *arrListData;
@end
