//
// CUserInfo.m
//  iClearo
//
//  Created by  apple on 11-8-12.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "CUserInfo.h"
#import "RFUtility.h"

@implementation CUserInfo
@synthesize  isSyningActivity,isLogin,isRequestLabelList;
@synthesize strAccount, strPswd, strrmkey, strSid;
@synthesize activityHost,activityDomain;
@synthesize addrapiUrl;

+ (CUserInfo *)sharedInstance
{
    // the instance of this class is stored here
     static CUserInfo *myInstance = nil;
    
    // check to see if an instance already exists
    if (nil == myInstance) 
    {
        myInstance  = [[[self class] alloc] init];
        myInstance.isLogin = NO;
        myInstance.isSyningActivity=NO;
		
		myInstance.isRequestLabelList = NO;
		[myInstance resetLoginData];
		NSUserDefaults *defaultCenter = [NSUserDefaults standardUserDefaults];
		NSString *account = [defaultCenter objectForKey:KAccountKey];
		NSString *password = [defaultCenter objectForKey:KPassworKey];
		myInstance.strAccount = account;
		myInstance.strPswd = password;
		
    }
    return myInstance;
}

-(void)resetLoginData{
	self.isRequestLabelList = NO;
//	self.isRequestMsgBox = NO;
	self.strAccount = @"";
	self.strPswd = @"";
	self.addrapiUrl = @"http://addrapi.mail.10086.cn/GetUserAddrJsonData";
	self.isSyningActivity = NO;
	self.isLogin = NO;
}

@end

@implementation CSendMessageInfo
@synthesize doubleMsg, sendType, receiverNumber, comeFrom;
@synthesize serialId, smsContent, smsType, submitType, isShareSms;
@synthesize validImg, groupLength, isSaveRecord;

-(CSendMessageInfo*)init{
	if (self = [super init]) {
		self.doubleMsg = 0;
		submitType = 1;
		smsContent = nil;
		receiverNumber = nil;
		comeFrom = @"104";
		
		sendType = 0;
		smsType = 1;
		serialId = -1;
		isShareSms = 0;
        self.mSendTime = [[NSDate date] timeIntervalSince1970] + 60 * 60 * 24;
		
		validImg = nil;
		groupLength = 50;
		isSaveRecord = 1;
		
		
	}
	return self;
}

@end

@implementation CGetSmsSender

@synthesize actionId, currentIndex, pageSize, deleSmsIds, keyWord;
@synthesize mobile, phoneNum, pageIndex, searchDateType;
-(CGetSmsSender*)init{
	if (self = [super init]) {
		
	}
	return self;
}
@end

@implementation CSMSData

@synthesize sendStatus, userNumber, sended, comeFrom ,sendMsg;
@synthesize recUserNumber, groupId, sendTime, serialId, sendedTime;
@synthesize createTime, startSendTime;
-(CSMSData*)init{
	if (self = [super init]) {
		
	}
	return self;
}
@end

@implementation CGetSmsSenderRespond

@synthesize code, summary, isDecrypt, issSetPwsd, arrSmesMesage,pageCount, records;
-(CGetSmsSenderRespond*)init{
	if (self = [super init]) {
		
	}
	return self;
}
-(NSMutableArray*)arrSmesMesage{
	if (arrSmesMesage == nil) {
		arrSmesMesage = [[NSMutableArray alloc] init];
	}
	return arrSmesMesage;
}

@end

@implementation NSMutableDictionary (CSMSData)

+(id) CreateDictionaryData:(CSMSData*)item
{
    NSMutableDictionary *dicData = [NSMutableDictionary dictionary];
	
    [dicData setValue:[NSString stringWithFormat:@"%ld",(long)item.sendStatus] forKey:@"sendStatus"];
    [dicData setValue:item.userNumber forKey:@"userNumber"];
	[dicData setValue:[NSString stringWithFormat:@"%ld",(long)item.sended] forKey:@"sended"];
	[dicData setValue:[NSString stringWithFormat:@"%ld",(long)item.comeFrom] forKey:@"comeFrom"];
    [dicData setValue:item.sendMsg forKey:@"sendMsg"];
	
    [dicData setValue:item.recUserNumber forKey:@"recUserNumber"];
	[dicData setValue:[NSString stringWithFormat:@"%ld",(long)item.groupId] forKey:@"groupId"];
	[dicData setValue:item.sendTime forKey:@"sendTime"];
    [dicData setValue:item.serialId forKey:@"serialId"];
    [dicData setValue:item.sendedTime forKey:@"sendedTime"];
	
    [dicData setValue:item.createTime forKey:@"createTime"];
    [dicData setValue:item.startSendTime forKey:@"startSendTime"];

    return dicData;
}
@end
