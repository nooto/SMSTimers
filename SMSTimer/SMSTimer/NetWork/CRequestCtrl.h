//
//  C139ActivityCtrl.h
//  Fragment
//
//  Created by zhang on 13-5-13.
//
//

//139活动处理类

#import <Foundation/Foundation.h>

@class CSendMessageInfo, CGetSmsSender;
@class CGetSmsSenderRespond;
@protocol C139ActivityDelegate <NSObject>
-(void)NoticeLoginFinish:(BOOL)state desc:(NSString *)desc result:(NSArray *)resultDict sender:(id)sender;
-(void)NoticeAutoCodeFinish:(BOOL)state desc:(NSString *)desc result:(NSArray *)resultDict sender:(id)sender;
-(void)NoticeSendFinish:(BOOL)state desc:(NSString *)desc result:(NSArray *)resultDict sender:(id)sender;
-(void)NoticeGetSmsHistoryFinish:(int)state result:(CGetSmsSenderRespond*)resultDict sender:(id)sender;

-(void)NoticeRequestCodeImageFinish:(int)state result:(UIImage*)image sender:(id)sender;

@end


@interface C139ActivityCtrl : NSObject
{
    id<C139ActivityDelegate> m_delegate;
}

@property(nonatomic, retain) NSString * m_serverTime;

+(C139ActivityCtrl *) GetC139ActivityCtrl;  //生成一个新的对象
+(void) Remove139ActivityCtrl:(C139ActivityCtrl *)obj;  //移除一个生成的对象

-(BOOL)LoginCalendarWithAccount:(NSString*)account andPassword:(NSString*)pswd  delegate:(id)delegate;
-(BOOL)requestImageCodeWithDelegate:(id)delegate;
-(BOOL)autoCode:(NSString*)account delegate:(id)delegate;

-(BOOL)sendMessageWithReq:(CSendMessageInfo*)info delegate:(id)delegate;
-(BOOL)queryHistoryWithReq:(CGetSmsSender*)info delegate:(id)delegate;

@end
