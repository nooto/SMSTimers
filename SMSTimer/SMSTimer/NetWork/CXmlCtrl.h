//
// CXmlCtrl.h
//  Fragment
//
//  Created by zhang on 13-5-13.
//
//

#import <Foundation/Foundation.h>
#import "RFUtility.h"
#import "CUserInfo.h"

@interface CXmlCtrl: NSObject
+(NSString *)GetSendMessageXmlString:(CSendMessageInfo *)msg;
+(NSString *)GetLogin139MailXmlString:(NSString *)name pwd:(NSString *)pwd;
+(NSString *)GetAutoCodeXmlString:(NSString *)name;
+(NSDictionary *) ParseLogin139MailXmlFromData:(NSData *)xmlData;

+(NSString *)GetSmsSenderXmlString:(CGetSmsSender *)msg;

@end
