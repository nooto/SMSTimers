//
// CRequest.h
//  Fragment
//
//  Created by xiaogaochao on 13-5-14.
//
//

#import <Foundation/Foundation.h>
#import "CRequestCtrl.h"
#import "CUserInfo.h"

/**
 *  网络完成通知
 *
 *  @param requestType   0:查询。1新增，2修改，3取消活动，4接收，5拒绝，6删除
 *
 *  activityInfo :活动类型。
 */
typedef enum
{
	OPERATE_NO=-1,
    OPERATE_Login_Calendar,
    OPERATE_Login_AutoCode,

	//日历操作
	OPERATE_Send_Msg,
	OPERATE_QueryHistory,
	
}ERequestType;


@protocol CRequestCalendarDelegate<NSObject>
-(void)NotifyFreshUI:(ERequestType)requestType descp:(NSString *)item data:(NSArray*)arr isSynState:(BOOL)isSuccess;

@optional
-(void)NotifyFreshUI:(ERequestType)requestType WithImage:(UIImage *)image;

@end



@interface CRequest : NSObject<C139ActivityDelegate>{
	NSString *yqORrejectType;
}
/*
 //1新增，2修改，3取消活动，4接收，5拒绝，6删除
 */
@property(nonatomic,assign) id<CRequestCalendarDelegate> m_rquest_delegate;
-(CRequest*) initWithDelegate:(id)delegate;

//登录
-(void)LoginCCalendar:(NSString*)account :(NSString*)pswd;

//获取验证码
-(void)GetAutoCode:(NSString*)account;
-(void)requestImageCodeCCalendar;

//发送
-(void)sendMessageWith:(CSendMessageInfo*)msg;

-(void)GetMessageHistoryWith:(CGetSmsSender*)msg;

@end
