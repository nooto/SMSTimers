//
//  RFContact.h
//  CalendarSDK
//
//  Created by chengenlin on 1/6/14.
//  Copyright (c) 2014 richinfo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RFUtility.h"

@interface RFContact : NSObject{
    NSString *sortLetter;           //通过姓或名或公司
    NSString *nameFirst;            //姓
    NSString *nameLast;             //名
    NSString *company;              //公司
    NSString *displayName;          //显示的名字
    
    NSMutableArray *phoneArray;     //电话列表
    NSMutableArray *emailArray;     //邮件列表
}

@property(nonatomic,retain) NSString *sortLetter;
@property(nonatomic,retain) NSString *nameFirst;
@property(nonatomic,retain) NSString *nameLast;
@property(nonatomic,retain) NSString *company;
@property(nonatomic,retain) NSString *displayName;
@property(nonatomic,retain) NSMutableArray *phoneArray;
@property(nonatomic,retain) NSMutableArray *emailArray;

-(void)setSortLetter;
-(void)setDisplayName;

@end
