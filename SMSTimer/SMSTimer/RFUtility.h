//
//  RFRFUtility.h
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <CommonCrypto/CommonCryptor.h>

#ifdef DEBUG
 #define NSLog(...) NSLog(__VA_ARGS__)
#else
  #define NSLog(...)
#endif

#define RFUtility_LOG     [RFUtility getMillisecond:__FILE__  :__FUNCTION__ :__LINE__]

#define KAccountKey @"account"
#define KPassworKey @"password"

extern NSString * const kRFAccountKey;
extern NSString * const kRFToken;
extern NSString * const kRFSidKey;
extern NSString * const kRFRmkeyKey;

@interface RFUtility : NSObject
{
}


+ (BOOL)isSystemVersionSeven;

+ (NSString *)doCipher:(NSString *)sTextIn key:(NSString *)sKey context:(CCOperation)encryptOrDecrypt;

/**
 *	@brief	 字符串加密功能 传入 需要加密的字符串 str  返回base64后的数据 NSString*
 *
 *	Created by gao on 2014-04-30 13:39
 */
+ (NSString *)encryptStr:(NSString*)str;


/** 字符串解密功能
 传入 需要解的字符串 str
 返回解密后的数据 NSString*
 */
+ (NSString *)decryptStr:(NSString*)str;


/** MD5加密
 传入 需要加密的字符串 str
 返回加密后的数据 NSString*
 */
+ (NSString *)md5HexDigest:(NSString*)str;

#pragma mark Based64
/** Base64加密
 传入 需要加密的Nsdate
 返回加密后的数据 NSString*
 */
+ (NSString*)encodeBase64WithData:(NSData *)strData;

/** Base64解密
 传入 需要解密的NSString
 返回加密后的数据 NSData*
 */
+ (NSData *)decodeBase64WithString:(NSString *)strBase64;

+ (NSDate *) FormatDateFromNSString:(NSString *)aDate :(NSString *)aFormat;

+ (NSString *) FormatNSStringFromDate:(NSDate *)aDate :(NSString *)aFormat;

+(NSString*)getLocaleDataStringWithTimerInterval:(NSTimeInterval)val;
+ (NSString*)stringWithDate:(NSDate*)date withFormat:(NSString*)formatStr;

//font
/** 获取 STHeitiSC-Light  用于英文 数字 显示。
 参数：字体大小
 返回：STHeitiSC-Light 指定字体大小。
 */
+ (UIFont *)STHeitiSC:(CGFloat)fontSzie;

/** 获取 HelveticaNeue  用于中文显示。
 参数：字体大小
 返回：HelveticaNeue 指定字体大小。
 */
+ (UIFont*)HelveticaNeue:(CGFloat)fontSzie;


/** 获取 指定颜色  UIColor
 参数：R：红色  G：绿色 B：蓝色  A：透明度
 返回：指定的UIColor
 */
+ (UIColor*)ColorWithR:(CGFloat)red G:(CGFloat)green B:(CGFloat)blue A:(CGFloat)alp;


+ (UIColor *) colorFromColorString:(NSString *)colorString;
+ (UIColor *)colorFromColorString:(NSString *)colorString alpha:(CGFloat)alpha;

/** 自动打印 当前行的是简单。
 参数:__LINE__ 用来获取 在指定行的  时间点:精确到毫秒级别。
 返回：无
 备注：测试用自动打印当前行数 与 时间戳。
 */
+(void)getMillisecond:(const char*)fileName :(const char*)function :(NSInteger)line;

/** 指定格式16进制NSString转换成 uicolor
 参数: @"000000",@"OX000000",@"#000000"
 返回：UIColor
 */
+ (UIColor *)nsstringToColor:(NSString *)colorString;


/** 指定格式 nsstring  转换成 uicolor
 参数:@"248,250,251"
 返回：UIColor
 */
+(UIColor *)RGBnsstringToColor:(NSString *)rgb;

/** 判断日期是否同一天
 参数: NSDate
 返回：NSInteger 类型：  -1：前 ，0：同一天 ， 1：后
 */
+ (NSInteger)CompareToday:(NSDate *)date;

+ (NSInteger)isSameDayDesDate:(NSDate *)date srcDate:(NSDate *)srcDate;

+ (BOOL) isVailed139Mail:(NSString *)mail;

/** 判断日期是否同一月
 参数: NSDate
 返回：NSInteger 类型：  -1：前 ，0：同， 1：后
 */
+ (NSInteger)isSameMonthDestDate:(NSDate *)date srcDate:(NSDate *)srcDate;



+(NSString *) GetHMFromDate:(NSDate *)date;


/** 截取邮箱地址@前，字符串。
 参数: @"1234567890@139.com" 邮箱格式字符串
 返回： “@” 前字符串。
 备注：特定用于 139邮箱账户，截取手机号码。
 */
+ (NSString *) GetPhoneFromMail:(NSString *)mail;


/** 判断字符串是否为空
参数: NSString
返回：BOOL  YES:空，NO：不空
*/
+(BOOL) NSStringIsNULL:(id)id_;


/** 判断字符串是否为空
 参数: NSString
 返回：BOOL  YES:空，NO：不空
 */
+(BOOL)isBlankString:(NSString *)string;


/** 判断设备OS版本号。
 返回：当前设备系统版本号   例如：7.0.0
 */
+(float)currentDeviceVersion;

/** 判断设备OS版本是否为IOS6 （6.0。0 - 7.0。0）
 返回：yes or no
 */
+(BOOL)currentDeviceVersionSix;

/** 判断设备OS版本是否大于版本IOS6.0.0
 返回：yes or no
 */
+(BOOL)currentDeviceVersionAfterSix;

/** 判断设备OS版本是否为IOS7 之前
 返回：yes or no
 */
+(BOOL)currentDeviceVersionBeforeSeven;


/** 判断设备OS版本是否为IOS7.0.0 -IOS 7.9.9
 返回：yes or no
 */
+(BOOL)currentDeviceVersionSeven;

/** 判断设备OS版本是否大于版本IOS7.0.0
 返回：yes or no
 */
+(BOOL)currentDeviceVersionAfterSeven;

/** 汉字转换拼音自负
 参数： @“中文”
 返回： @“zhongwen”
 */
+(NSString *)GetThePinYinString:(NSString *)title;


/** 根据资源图片文件名 返回 图片格式类型。
 参数： @“mat_unknown.png”
 返回： @“png”
 */
+(NSString *) GetTheFileTypeImgNameByType:(NSString *)fileType;

/** 正则判断手机号码地址格式是否合法
 参数： @“13418682452”
 返回： yes or no
 */
+ (BOOL)isMobileNumber:(NSString *)mobileNum;

typedef enum MOBILETYPE
{
    MOBILE_CM,        //中国移动：China Mobile
    MOBILE_CU,        //中国联通：China Unicom
    MOBILE_CT,        //中国电信：China Telecom
    MOBILE_UNKNOWN    //未知。
}MOBILETYPE;

/** 正则判断手机号码运营商
 参数： @“13418682452”
 返回：
 */
+ (MOBILETYPE) GetMobileType:(NSString *)mobileNum;

/** 获取指定VIEW的截图
参数： UIView
返回： UIImageview
*/
+(UIImageView *) GetCurrentScreen:(UIView *)layView;


/** 正则判断 电子邮箱地址格式是否合法
 参数： @“13418682452@126.com”
 返回： yes or no
 */
+ (BOOL)isEmailValid:(NSString*)email;

/** 根据文件后缀 判断是否为 图片文件
 参数: @"faff.png"
 返回：yes or no
 */
+(BOOL) IsImageByExt:(NSString *)fileName;


+ (void)showMessage:(NSString*)msg;

///********************************************************************************
//邮箱功能专用。
+ (NSString *)getCurrentMailAccount;
+ (NSString *)getCurrentMailFolder;
+ (void)setCurrentMailAccount:(NSString *)mailAccount withFolderName:(NSString *)mailFolder;


//设置每次获取邮件的个数
+ (void)setMailPullNumber:(int)number;
+ (NSNumber*)getMailPullNumber;
//设置邮件列表正文摘要行数
+ (void)setMailShowLine:(int)number;
+ (NSNumber*)getMailShowLine;

//生成UUID
extern NSString *GetUUID();

@end
