//
//  Common_Common.h
//  DCalendar
//
//  Created by GaoAng on 14-5-6.
//  Copyright (c) 2014年 richinfo.cn. All rights reserved.

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#if DEBUG
    #if 0
        //生产线
        #define Servers_URl              @"http://apps.richinfo.cn/"
        #define IMAGESERVERURL           @"http://images.139cm.com/jpdy/jpdymobile/cal/img/%@"

        #define EaseMobAppKey            @"richinfo-app#xiaod"
        /////////推送地址-生产
        #define DEVICEUSER_BIND_URL          @"http://pnsmsg-svr.mail.10086.cn:7700/rsv/deviceBind"
        #define DEVICEUSER_UNBIND_URL        @"http://pnsmsg-svr.mail.10086.cn:7700/rsv/unDeviceBind"
    #else
        //研发线
        #define Servers_URl                  @"http://192.168.40.200/"
        #define IMAGESERVERURL               @"http://192.168.40.200/jpdy/jpdymobile/cal/img/%@"

        #define DEVICEUSER_BIND_URL          @"http://192.168.9.91:7701/rsv/deviceBind"
        #define DEVICEUSER_UNBIND_URL        @"http://192.168.9.91:7701/rsv/unDeviceBind"

        #define EaseMobAppKey                @"richinfo-app#xiaod"
    #endif
#else

    //生产线
    #define Servers_URl              @"http://apps.richinfo.cn/"
    #define IMAGESERVERURL           @"http://images.139cm.com/jpdy/jpdymobile/cal/img/%@"

    #define EaseMobAppKey            @"richinfo-app#xiaod"
    /////////推送地址-生产
    #define DEVICEUSER_BIND_URL          @"http://pnsmsg-svr.mail.10086.cn:7700/rsv/deviceBind"
    #define DEVICEUSER_UNBIND_URL        @"http://pnsmsg-svr.mail.10086.cn:7700/rsv/unDeviceBind"

#endif
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//支撑邮箱。
#define KDCalenderSupportMail            @"xiaod@richinfo.cn"

//上传图片时 的数据分割符。
#define TWITTERFON_FORM_BOUNDARY         @"WebKitFormBoundaryRKDtL43cySz3F6Lu"

#define   KLOCATIONFAIL                  @"定位失败"
#define   KLOCATIONFAILRETRY             @"定位失败,请点击重试"

#define   DDeviceToken                   @"deviceToken"
#define   AppVersion                     @"XD_App_Version"
//用户审核默认的数据 判断字段是否需要审核。
#define kJOINADUTNAME                    @"姓名ySz3F6L"
#define kJOINADUTUSERNUMBER              @"手机号ySz3F6L"
#define kJOINADUTCERO                    @"身份证ySz3F6L"
#define kJOINADUTCREMARK                 @"备注ySz3F6L"

#define MainScreenBbounds                [[UIScreen mainScreen] bounds]
#define ScreenWidth                      [[UIScreen mainScreen] bounds].size.width
#define ScreenHeight                     [[UIScreen mainScreen] bounds].size.height
#define KEY_WINDOW                       [[UIApplication sharedApplication] keyWindow]

#define KMAXIMAGEHIGHT                   MAXFLOAT

typedef enum{
	TYPE_OTHER                           = 0,       //其他
	TYPE_HIKING                          = 1,       //徒步
	TYPE_MOUNTAIN                        = 2,       //登山
	TYPE_RIDING                          = 3,       //骑行
	TYPE_RUNNING                         = 4,       //跑步
	
	TYPE_MEETING                         = 5,       //会议
	TYPE_BALL                            = 6,       //球类
	TYPE_TRAVEL                          = 7,       //旅行
	TYPE_DRIVERING                       = 8,       //自驾
	TYPE_GONGYI                          = 9,       //公益
	TYPE_SWIMMING                        = 10,      //游泳
    
}EEventType;

//
#define DESKEY                           @"ky@93ma#_ep$byd"
#define UPLOADIMGNOTIFY                  @"DUploadImageRecordData"
#define UPLOADIMGNOTIFY_Begin            @"BeginUploadImageRecordData"

#define DIDRECIEVE_MSG                   @"DidReciveNmewMessage"
#define Exit_chatView                   @"exit_chatview"
#define KDRAFTEVETN                      @"draft_gid"
#define KNOTIFY_LOGINSUCCESS             @"loginsuccess"
#define KNOTIFY_FORCELOGOUT              @"ForceLogout"
#define KNOTIFY_RefreshMainView          @"RelordMainViewFromDB"

#define KNOTIFY_UPDATEPARSONINFO         @"DUpdateMainViewPersonInfo"


#define KNOTIFY_SID_Vaild          @"Sid_Vaild" //sid过期 重新登录


#define NotAllow_Album  @"您需要在“设置-隐私-照片”中允许小D活动访问您的照片"
#define NotAllow_Camera @"您需要在“设置-隐私-相机”中允许小D活动使用相机"


//配置信息
#define KCONFIG_Industry                 @"102" //行业
#define NOT_TEXT                         @"未填写"

#define KEVENTSIGNLENGTH                 6   //分享链接，或者二维码扫描获取的链接  eventsign固定长度为6位
#define KPAGESIZE                        20
#define KJAmaxInputLength                100    //报名审核备注信息 最大输入的长度限制。
#define KMAXPERSONNUM                    999     //活动报名默认最大的限制人数。
#define KMAXIMAGESIZE                    (1 * 1024)
#define KErrorCode_TimeOut               -1001    //网络超时。
#define KErrorCode_NONETWORK             -10001    //不可用。
#define KDotMaxInterge                 10000000    //不可用。

#define KOneDaySecond  (60 * 60  * 24)

//横向默认间隔
#define GAPX                             10.0f


#define KBOTTOMHIGHT                     49

#define ANIMATIONDURATION                (0.4)
#define IMAGEHIGHT                       220
#define IMAGEWIDTH                       300
#define CONTENT_FONT                     [UIFont fontWithName:@"Helvetica-Bold" size:14]

#define MAXHIGHT                         200.0f


#define MAXPASSWORDLENGTH                16
#define MINPASSWORDLENGTH                6
#define AUTHCODELENGTH                   6
#define KOccupationLENGTH                   12 //个人资料--职业输入长度限制。

#define  KNickNameMaxLenght               16 //16 八个汉字  汉字：两个  英文：1个

//主页标题背景色
#define MainTitleBgColor                 [UIColor colorWithRed:22/255.0f green:203/255.0f blue:150/255.0f alpha:1.0f]
#define MainViewBgColor                  [Utility colorFromColorString:@"#f0efed"]
//[UIColor colorWithRed:237/255.0f green:241/255.0f blue:248/255.0f alpha:1.0f]

#define kBottomBarHeight                 46
#define kHeight_TITLE                    44


#define  UIFont17  [UIFont systemFontOfSize:17.0f]
#define  UIFont16  [UIFont systemFontOfSize:16.0f]
#define  UIFont15  [UIFont systemFontOfSize:15.0f]
#define  UIFont14  [UIFont systemFontOfSize:14.0f]
#define  UIFont13  [UIFont systemFontOfSize:13.0f]
#define  UIFont12  [UIFont systemFontOfSize:12.0f]
#define  UIFont11  [UIFont systemFontOfSize:11.0f]
#define  UIFont10  [UIFont systemFontOfSize:10.0f]



#define UIColor7e7e7e [Utility colorFromColorString:@"7e7e7e"]
#define UIColor333333 [Utility colorFromColorString:@"333333"]
#define UIColora1a1a1 [Utility colorFromColorString:@"a1a1a1"]


