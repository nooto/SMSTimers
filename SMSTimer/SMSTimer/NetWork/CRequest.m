//
// CRequest.m
//  Fragment
//
//  Created by xiaogaochao on 13-5-14.
//
//
#import "CRequest.h"
#import "CDictionary.h"

static NSRecursiveLock *secureLock = nil;

NSString *modifing139ActivityID=@"";

@interface CRequest (){
	dispatch_queue_t   CRequestQueue;

}
@end

@implementation CRequest
@synthesize m_rquest_delegate;

-(CRequest*) initWithDelegate:(id)delegate
{
	if ((self = [super init]))
    {
		m_rquest_delegate =delegate;
       CRequestQueue = dispatch_queue_create("com.C.activityQueue", NULL);
		
    }
	return self;
}

#pragma mark - 登录
-(void)LoginCCalendar:(NSString*)account :(NSString*)pswd{
    dispatch_async(CRequestQueue, ^(){
		C139ActivityCtrl *c139ActivityCtrl=[C139ActivityCtrl GetC139ActivityCtrl];
		[c139ActivityCtrl LoginCalendarWithAccount:account andPassword:pswd delegate:self];
	});
	
}

-(void)NoticeLoginFinish:(BOOL)state desc:(NSString *)desc result:(NSArray *)resultDict sender:(id)sender{
	dispatch_async(dispatch_get_main_queue(), ^(){
		if( [m_rquest_delegate respondsToSelector:@selector(NotifyFreshUI:descp:data:isSynState:)])
		{
			[m_rquest_delegate NotifyFreshUI:OPERATE_Login_Calendar descp:@"" data:nil isSynState:state];
		}
	});
}

#pragma makr - 下发验证码
-(void)GetAutoCode:(NSString*)account{
    dispatch_async(CRequestQueue, ^(){
        C139ActivityCtrl *c139ActivityCtrl=[C139ActivityCtrl GetC139ActivityCtrl];
        [c139ActivityCtrl autoCode:account delegate:self];
    });
    
}
-(void)NoticeAutoCodeFinish:(BOOL)state desc:(NSString *)desc result:(NSArray *)resultDict sender:(id)sender{
    dispatch_async(dispatch_get_main_queue(), ^(){
        if( [m_rquest_delegate respondsToSelector:@selector(NotifyFreshUI:descp:data:isSynState:)])
        {
            [m_rquest_delegate NotifyFreshUI:OPERATE_Login_AutoCode descp:@"" data:nil isSynState:state];
        }
    });
}

#pragma mark - 获取图片验证码
-(void)requestImageCodeCCalendar{
//    Request URL:http://imgcode.cmpassport.com:4100/getimage?clientid=9&rnd=0.9340480782557279
    dispatch_async(CRequestQueue, ^(){
		C139ActivityCtrl *c139ActivityCtrl=[C139ActivityCtrl GetC139ActivityCtrl];
        [c139ActivityCtrl requestImageCodeWithDelegate:self];
    });
}


-(void)NoticeRequestCodeImageFinish:(int)state result:(UIImage*)image sender:(id)sender{
 
    dispatch_async(dispatch_get_main_queue(), ^(){
		if( [m_rquest_delegate respondsToSelector:@selector(NotifyFreshUI:WithImage:)])
		{
            [m_rquest_delegate NotifyFreshUI:OPERATE_Send_Msg WithImage:image];
//			[m_rquest_delegate NotifyFreshUI:OPERATE_Send_Msg descp:@"" data:nil isSynState:state];
		}
	});
}



#pragma mark - 发送短信
-(void)sendMessageWith:(CSendMessageInfo*)msg;
{
	if ([CUserInfo sharedInstance].isLogin == NO)  return;

	dispatch_async(CRequestQueue, ^(){

		C139ActivityCtrl *c139ActivityCtrl=[C139ActivityCtrl GetC139ActivityCtrl];
		[c139ActivityCtrl sendMessageWithReq:msg delegate:self];
	});
	
}

-(void)NoticeSendFinish:(BOOL)state desc:(NSString *)desc result:(NSArray *)resultDict sender:(id)sender{
	dispatch_async(dispatch_get_main_queue(), ^(){
		if( [m_rquest_delegate respondsToSelector:@selector(NotifyFreshUI:descp:data:isSynState:)])
		{
			[m_rquest_delegate NotifyFreshUI:OPERATE_Send_Msg descp:@"" data:nil isSynState:state];
		}
	});
}


#pragma mark - 查询短信。
-(void)GetMessageHistoryWith:(CGetSmsSender*)msg{
	dispatch_async(CRequestQueue, ^(){
		
		C139ActivityCtrl *c139ActivityCtrl=[C139ActivityCtrl GetC139ActivityCtrl];
		[c139ActivityCtrl queryHistoryWithReq:msg delegate:self];
	});

}
-(void)NoticeGetSmsHistoryFinish:(int)state result:(CGetSmsSenderRespond *)resultDict sender:(id)sender{
	dispatch_async(dispatch_get_main_queue(), ^(){
		if( [m_rquest_delegate respondsToSelector:@selector(NotifyFreshUI:descp:data:isSynState:)])
		{
			BOOL success = YES;
			if (state == 1) {
				success = YES;
			}
			else{
				success = NO;
			}
			[m_rquest_delegate NotifyFreshUI:OPERATE_QueryHistory descp:@"" data:resultDict.arrSmesMesage isSynState:YES];
		}
	});
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////



@end
