
//
//  C139ActivityCtrl.m
//  Fragment
//
//  Created by zhang on 13-5-13.
//
//
#import "CRequestCtrl.h"
#import "CXmlCtrl.h"
#import "RFUtility.h"
#import "CUserInfo.h"
#import "CDBConfig.h"

#define LOGIN139MAIL_URL @"http://mail.10086.cn/Login/VirtualDiskLogin.ashx"
#define SendMesage_URL        @"http://smsrebuild1.mail.10086.cn/sms/sms?func=sms:sendSms&sid=%@&rnd=0.3204529338981956&cguid=2235028360583"
#define GetSmsSender_URL @"http://smsrebuild1.mail.10086.cn/sms/sms?func=sms:getSmsSender&sid=%@&rnd=0.5692538374569267&cguid=1648035472077"


                     //http://mail.10086.cn/s?func=login:sendSmsCode&cguid=1728444203331&randnum=0.6449299601372331
#define autoCode_URL @"http://mail.10086.cn/s?func=login:sendSmsCode&cguid=1728444203331&randnum=0.6449299601372331"

@implementation C139ActivityCtrl

@synthesize m_serverTime;

static NSMutableArray * m_array=nil;
static NSDate * m_getDate=nil;
static NSString * m_sessionId=nil;
static NSString * m_rmKey = nil;

+(C139ActivityCtrl *) GetC139ActivityCtrl
{
    if(m_array == nil)
    {
        m_array=[[NSMutableArray alloc] init];
    }
    
    C139ActivityCtrl * szCtrl=[[C139ActivityCtrl alloc] init];
    [m_array addObject:szCtrl];
    return szCtrl;
}

+(void) Remove139ActivityCtrl:(C139ActivityCtrl *)obj
{
    if(obj == nil) return;
    
    [m_array removeObject:obj];
}

+(void) CleanSaveData
{
//    SETDATA(m_getDate, nil);
//    SETSTRING(m_sessionId, nil);
//    SETSTRING(m_rmKey, nil);
    //清除cookie

}


-(void)dealloc
{
    m_delegate=nil;
    self.m_serverTime=nil;
    //    if (C_RequestQueue) {
    //        dispatch_release(C_RequestQueue);
    //       CRequestQueue = 0x00;
    //    }
}

-(id) init
{
    self=[super init];
    if(self)
    {
        m_delegate=nil;
        self.m_serverTime=nil;
        //       CRequestQueue = dispatch_queue_create("com.C.activityQueue", NULL);
        
    }
    return self;
}

-(void) StopRequire
{
    m_delegate=nil;
}

-(BOOL)LoginCalendarWithAccount:(NSString*)account andPassword:(NSString*)pswd  delegate:(id)delegate{
	m_delegate = delegate;
    NSString * strContactAcount =account;
    NSString * strContactPwd= pswd;
	
    if([RFUtility NSStringIsNULL:account]) return NO;
    NSURL *requestURL = [NSURL URLWithString:LOGIN139MAIL_URL];
	NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:requestURL];
	[urlRequest setTimeoutInterval:20.0f];
	[urlRequest setHTTPMethod:@"POST"];
    
	NSString * requestString=[CXmlCtrl GetLogin139MailXmlString:strContactAcount pwd:strContactPwd];
	[urlRequest setHTTPBody:[requestString dataUsingEncoding:NSUTF8StringEncoding]];
	
	NSHTTPURLResponse *response = nil;
	NSData *responseData = nil;
	NSError *error = nil;
	responseData = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&error];
	
	if (200 == [response statusCode]) {
		NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        for (NSHTTPCookie *cookie in [cookieJar cookies]) {
            NSString * name=[cookie name];
            NSString * val=[cookie value];
            if([@"RMKEY" compare:name options:NSCaseInsensitiveSearch] == NSOrderedSame)
            {
				m_rmKey =val;
                break;
            }
        }
		NSDictionary * dict=[CXmlCtrl ParseLogin139MailXmlFromData:responseData];

		NSString * description = [dict objectForKey:@"description"];
		NSLog(@"%@",description);
        NSString * result = [dict objectForKey:@"result"];
        if(result != nil && [@"0" compare:result options:NSCaseInsensitiveSearch] == NSOrderedSame)
        {
			//sid
            NSString * sid=[dict objectForKey:@"ssoid"];
			[CUserInfo sharedInstance].strSid = sid;
			[CUserInfo sharedInstance].strrmkey = m_rmKey;
			NSRange rang = [account rangeOfString:@"@139.com"];
			[CUserInfo sharedInstance].strAccount = [account substringToIndex:rang.location];
			[CUserInfo sharedInstance].strPswd = pswd;
			[CUserInfo sharedInstance].isSyningActivity = NO;
			[CUserInfo sharedInstance].isLogin = YES;
			
			NSUserDefaults *defaultCenter = [NSUserDefaults standardUserDefaults];
			[defaultCenter setObject:[NSString stringWithFormat:@"%@",[CUserInfo sharedInstance].strAccount] forKey:KAccountKey];
			[defaultCenter setObject:[CUserInfo sharedInstance].strPswd forKey:KPassworKey];
			[defaultCenter synchronize];
		}
        
		if (m_delegate && [m_delegate respondsToSelector:@selector(NoticeLoginFinish:desc:result:sender:)]) {
			[m_delegate NoticeLoginFinish:1 desc:@"" result:nil sender:nil];
		}
  	}
	else{
		if (m_delegate && [m_delegate respondsToSelector:@selector(NoticeLoginFinish:desc:result:sender:)]) {
			[m_delegate NoticeLoginFinish:0 desc:@"" result:nil sender:nil];
		}

	}

	return NO;
}


#pragma mark 获取验证码
-(BOOL)autoCode:(NSString*)account delegate:(id)delegate{
    m_delegate = delegate;
    if([RFUtility NSStringIsNULL:account]) return NO;
    NSURL *requestURL = [NSURL URLWithString:autoCode_URL];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:requestURL];
    [urlRequest setTimeoutInterval:20.0f];
    [urlRequest setHTTPMethod:@"POST"];
    
    NSString * requestString=[CXmlCtrl GetAutoCodeXmlString:account];
    [urlRequest setHTTPBody:[requestString dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSHTTPURLResponse *response = nil;
    NSData *responseData = nil;
    NSError *error = nil;
    responseData = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&error];

    BOOL success = NO;
    NSString * code = @"-1";
    if (200 == [response statusCode]) {

        NSString* responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:[responseString dataUsingEncoding:NSUTF8StringEncoding]
                                                         options:kNilOptions error:&error];
        code = [dict objectForKey:@"code"];
        if(code != nil && [@"S_OK" compare:code options:NSCaseInsensitiveSearch] == NSOrderedSame)
        {
            success =  YES;
        }
        
    }
    else{
        success = NO;
    }
    
    if (m_delegate && [m_delegate respondsToSelector:@selector(NoticeAutoCodeFinish:desc:result:sender:)]) {
        [m_delegate NoticeAutoCodeFinish:success desc:code result:nil sender:self];
    }
    
    return success;
}

#pragma mark - Activity
#pragma mark
-(BOOL)requestImageCodeWithDelegate:(id)delegate{
    
//    Request URL:http://imgcode.cmpassport.com:4100/getimage?clientid=9&rnd=0.9340480782557279
	m_delegate = delegate;
	NSString *URL = [NSString stringWithFormat:SendMesage_URL, [CUserInfo sharedInstance].strSid];
    URL = @"http://imgcode.cmpassport.com:4100/getimage?clientid=9&rnd=0.9340480782557279";
    
	NSURL *requestURL = [NSURL URLWithString:URL];
	NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:requestURL];
	[urlRequest setTimeoutInterval:20.0f];
	[urlRequest setHTTPMethod:@"GET"];
	[urlRequest addValue:@"image/jpeg" forHTTPHeaderField:@"Content-Type"];
//	NSString * requestString=[CXmlCtrl GetSendMessageXmlString:info];
//	[urlRequest setHTTPBody:[requestString dataUsingEncoding:NSUTF8StringEncoding]];
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:URL]];
    UIImage * result;

    result = [UIImage imageWithData:data];
    
	NSHTTPURLResponse *response = nil;
	NSData *responseData = nil;
	NSError *error = nil;
	responseData = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&error];
	
	if (200 == [response statusCode]) {
        UIImage *image= [UIImage imageWithData:responseData];
        
		NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:&error];
		
        NSString * code = [dict objectForKey:@"code"];
        NSString * summary = [dict objectForKey:@"summary"];
//		NSLog(@"%@",summary);
		BOOL success = NO;
        if(code != nil && [@"S_OK" compare:code options:NSCaseInsensitiveSearch] == NSOrderedSame)
        {
			success =  YES;
		}
		
		if (m_delegate && [m_delegate respondsToSelector:@selector(NoticeRequestCodeImageFinish:result:sender:)]) {
            [m_delegate NoticeRequestCodeImageFinish:1 result:result sender:nil];
//			[m_delegate NoticeSendFinish:success desc:summary result:nil sender:nil];
		}
  	}
	else{
		if (m_delegate && [m_delegate respondsToSelector:@selector(NoticeSendFinish:desc:result:sender:)]) {
			[m_delegate NoticeSendFinish:0 desc:@"" result:nil sender:nil];
		}
		
	}
    
    return NO;
}

#pragma mark - Activity
#pragma mark
-(BOOL)sendMessageWithReq:(CSendMessageInfo*)info delegate:(id)delegate{
	m_delegate = delegate;
	NSString *URL = [NSString stringWithFormat:SendMesage_URL, [CUserInfo sharedInstance].strSid];
	NSURL *requestURL = [NSURL URLWithString:URL];
	NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:requestURL];
	[urlRequest setTimeoutInterval:20.0f];
	[urlRequest setHTTPMethod:@"POST"];
	[urlRequest addValue:@"application/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
	NSString * requestString=[CXmlCtrl GetSendMessageXmlString:info];
	[urlRequest setHTTPBody:[requestString dataUsingEncoding:NSUTF8StringEncoding]];
	
	NSHTTPURLResponse *response = nil;
	NSData *responseData = nil;
	NSError *error = nil;
	responseData = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&error];
	
	if (200 == [response statusCode]) {
		NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:&error];
		
        NSString * code = [dict objectForKey:@"code"];
        NSString * summary = [dict objectForKey:@"summary"];
		NSLog(@"%@",summary);
		BOOL success = NO;
        if(code != nil && [@"S_OK" compare:code options:NSCaseInsensitiveSearch] == NSOrderedSame)
        {
			success =  YES;
		}
		
		if (m_delegate && [m_delegate respondsToSelector:@selector(NoticeSendFinish:desc:result:sender:)]) {
			[m_delegate NoticeSendFinish:success desc:summary result:nil sender:nil];
		}
  	}
	else{
		if (m_delegate && [m_delegate respondsToSelector:@selector(NoticeSendFinish:desc:result:sender:)]) {
			[m_delegate NoticeSendFinish:0 desc:@"" result:nil sender:nil];
		}
	}
	return NO;
}


-(BOOL)queryHistoryWithReq:(CGetSmsSender*)info delegate:(id)delegate{
	m_delegate = delegate;
	NSString *URL = [NSString stringWithFormat:GetSmsSender_URL, [CUserInfo sharedInstance].strSid];
	NSURL *requestURL = [NSURL URLWithString:URL];
	NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:requestURL];
	[urlRequest setTimeoutInterval:20.0f];
	[urlRequest setHTTPMethod:@"POST"];
	[urlRequest addValue:@"application/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
	NSString * requestString=[CXmlCtrl GetSmsSenderXmlString:info];
	[urlRequest setHTTPBody:[requestString dataUsingEncoding:NSUTF8StringEncoding]];
	
	NSHTTPURLResponse *response = nil;
	NSData *responseData = nil;
	NSError *error = nil;
	responseData = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&error];
	
	if (200 == [response statusCode]) {
		NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:&error];
			CGetSmsSenderRespond *respond = [self parseDictToArray:dict];
		if (m_delegate && [m_delegate respondsToSelector:@selector(NoticeGetSmsHistoryFinish:result:sender:)]) {
			[m_delegate NoticeGetSmsHistoryFinish:1 result:respond sender:self];;
		}
  	}
	else{
		if (m_delegate && [m_delegate respondsToSelector:@selector(NoticeGetSmsHistoryFinish:result:sender:)]) {
			[m_delegate NoticeGetSmsHistoryFinish:1 result:nil sender:self];;
		}
		
	}
	return NO;
	
	return YES;
}
-(CGetSmsSenderRespond*)parseDictToArray:(NSDictionary*)srcDict{
	CGetSmsSenderRespond* responder = [[CGetSmsSenderRespond alloc] init];
	responder.code = [srcDict objectForKey:@"code"];
	responder.summary = [srcDict objectForKey:@"summary"];
	NSDictionary* varDict = [srcDict objectForKey:@"var"];
	
	responder.issSetPwsd = [[varDict objectForKey:@"issSetPwsd"] intValue];
	responder.isDecrypt = [[varDict objectForKey:@"isDecrypt"] intValue];
	responder.pageCount = [[varDict objectForKey:@"pageCount"] intValue];
	responder.records = [[varDict objectForKey:@"records"] intValue];
	
	NSArray *arr = [varDict objectForKey:@"table"];
	for (id data  in arr) {
		if ([data isKindOfClass:[NSDictionary class]]) {
			NSDictionary* tempDict = (NSDictionary*)data;
			CSMSData* data = [[CSMSData alloc] init];
			data.sendStatus = [[tempDict objectForKey:@"sendStatus"] intValue];
			data.userNumber = [tempDict objectForKey:@"userNumber"];
			data.sended = [[tempDict objectForKey:@"sended"] intValue];
			data.comeFrom = [[tempDict objectForKey:@"comeFrom"] intValue];
			data.sendMsg = [tempDict objectForKey:@"sendMsg"];

			data.recUserNumber = [tempDict objectForKey:@"recUserNumber"];
			data.groupId = [[tempDict objectForKey:@"groupId"] intValue];
			data.sendTime = [tempDict objectForKey:@"sendTime"];
			data.serialId = [tempDict objectForKey:@"serialId"];
			data.sendedTime = [tempDict objectForKey:@"sendedTime"];

			data.createTime = [tempDict objectForKey:@"createTime"];
			data.startSendTime = [tempDict objectForKey:@"startSendTime"];
			[responder.arrSmesMesage addObject:data];
			[[CCDBConfig shareInstace] insertMessage:data];
		}
	}
	
	return  responder;
	
}
	
@end
