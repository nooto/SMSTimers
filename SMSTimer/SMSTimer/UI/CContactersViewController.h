//
//  CContactersViewController.h
//  SMSTimer
//
//  Created by GaoAng on 14-3-31.
//  Copyright (c) 2014年 selfcom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>

#import <AddressBookUI/AddressBookUI.h>


@interface CContactersViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>


@property (copy, nonatomic) void (^didSelectContacters)(NSMutableArray*);
@property(nonatomic, strong) IBOutlet UITableView *listTabelView;
@property (nonatomic, strong) NSMutableDictionary *contactDic;
@property (nonatomic, strong) NSMutableArray *selectContactDic;
@end


@interface RFContactCell : UITableViewCell

@property(nonatomic, strong) UIButton *checkButton;
@property(nonatomic, strong) UILabel *displayName;

@end