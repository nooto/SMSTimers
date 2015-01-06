//
// CUserInfo.h
//  iClearo
//
//  Created by  apple on 11-8-12.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface CUserInfo : NSObject {
    BOOL isSyningActivity;                 //表示正在同步服务器上活动数据
}

@property (nonatomic,assign) BOOL isSyningActivity;


@property (nonatomic,assign) BOOL isLogin;

@property (nonatomic,strong) NSString *strAccount;
@property (nonatomic,strong) NSString *strPswd;

@property (nonatomic,strong) NSString *strSid;
@property (nonatomic,strong) NSString *strrmkey;

@property (nonatomic,strong) NSString *activityHost;   /////活动请求host
@property (nonatomic,strong) NSString *activityDomain;   //活动域
@property (nonatomic,strong) NSString *addrapiUrl;   //活动域

@property (nonatomic,assign) BOOL isRequestLabelList;      //是否查询过 标签列表。

+ (CUserInfo *)sharedInstance;
-(void)resetLoginData;

@end


@interface CSendMessageInfo : NSObject

//<object><int name="doubleMsg">0</int><int name="submitType">1</int><string name="smsContent">元旦元旦，祝福不断；朋友关怀，依然不变；思念之心，依旧不减；朋友之情，更甚从前；深深祝福，轻轻来到；愿你元旦，快乐无限！</string><string name="receiverNumber">8613523056071</string><string name="comeFrom">3</string><int name="sendType">0</int><int name="smsType">1</int><int name="serialId">-1</int><int name="isShareSms">0</int><string name="sendTime">2015-12-11 14:07:00</string><string name="validImg"></string><int name="groupLength">50</int><int name="isSaveRecord">1</int></object>

@property (nonatomic,assign) NSInteger doubleMsg;   //活动域
@property (nonatomic,assign) NSInteger submitType;   //活动域
@property (nonatomic,strong) NSString *smsContent;   //短信内容。
@property (nonatomic,strong) NSString *receiverNumber;   //接受的手机号码
@property (nonatomic,strong) NSString *comeFrom;   //活动域

@property (nonatomic,assign) NSInteger sendType;   //活动域
@property (nonatomic,assign) NSInteger smsType;   //活动域
@property (nonatomic,assign) NSInteger serialId;   //活动域
@property (nonatomic,assign) NSInteger isShareSms;   //活动域
@property (nonatomic,assign) double   mSendTime;   //定时时间。。

@property (nonatomic,strong) NSString *validImg;   //活动域
@property (nonatomic,assign) NSInteger groupLength;   //活动域
@property (nonatomic,assign) NSInteger isSaveRecord;   //活动域
@end

@interface CGetSmsSender : NSObject
@property (nonatomic,assign) NSInteger actionId;   //活动域
@property (nonatomic,assign) NSInteger currentIndex;   //活动域
@property (nonatomic,assign) NSInteger phoneNum;   //活动域
@property (nonatomic,strong) NSString *deleSmsIds;   //活动域
@property (nonatomic,strong) NSString *keyWord;   //活动域
@property (nonatomic,strong) NSString *mobile;   //活动域
@property (nonatomic,assign) NSInteger pageSize;   //活动域
@property (nonatomic,assign) NSInteger pageIndex;   //活动域
@property (nonatomic,assign) NSInteger searchDateType;   //活动域

@end

@interface CSMSData : NSObject

@property (nonatomic, strong)  NSString* serialId;
@property (nonatomic, strong)  NSString* userNumber;
@property (nonatomic, strong)  NSString* sendMsg;
@property (nonatomic, strong)  NSString* createTime;
@property (nonatomic, strong)  NSString* sendTime;

@property (nonatomic, strong)  NSString* recUserNumber;
@property (nonatomic, assign)  NSInteger groupId;
@property (nonatomic, strong)  NSString* startSendTime;
@property (nonatomic, assign)  NSInteger sended;
@property (nonatomic, assign)  NSInteger sendStatus;

@property (nonatomic, assign)  NSInteger comeFrom;
@property (nonatomic, strong)  NSString* sendedTime;

@end


@interface CGetSmsSenderRespond : NSObject
@property (nonatomic, strong)  NSString* code;
@property (nonatomic, strong)   NSString* summary;
@property (nonatomic, assign)   NSInteger issSetPwsd;
@property (nonatomic, assign)   NSInteger isDecrypt;
@property (nonatomic, assign)   NSInteger pageCount;
@property (nonatomic, assign)   NSInteger records;
@property (nonatomic, strong)   NSMutableArray* arrSmesMesage;

@end

@interface NSMutableDictionary (CSMSData)
+(id) CreateDictionaryData:(CSMSData*)info;

@end