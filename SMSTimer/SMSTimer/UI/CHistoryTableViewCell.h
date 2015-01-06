//
//  CHistoryTableViewCell.h
//  SMSTimer
//
//  Created by GaoAng on 14-4-24.
//  Copyright (c) 2014年 selfcom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CUserInfo.h"
@interface CHistoryTableViewCell : UITableViewCell
@property(nonatomic, strong) UILabel* senderLabel;
@property(nonatomic, strong) UILabel* contentLabel;
@property(nonatomic, strong) UILabel* sendertime;

-(void)loardDataWith:(CSMSData*)data;
+(CGFloat)cellForData:(NSString*)content;
@end
