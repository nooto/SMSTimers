//
// CXmlCtrl.m
//  Fragment
//
//  Created by zhang on 13-5-13.
//
//

#import "CXmlCtrl.h"
#import "CGDataXMLNode.h"
#import "RFUtility.h"
#import "CRequestCtrl.h"
#import "CUserInfo.h"

@implementation CXmlCtrl
+(CGDataXMLElement *) AddElementValAndAttri:(CGDataXMLElement *)element name:(NSString *)name val:(NSString *)value attriName:(NSString *)attName AttVal:(NSString *)attVal
{
    if([RFUtility NSStringIsNULL:name]) return nil;
    
    
   CGDataXMLElement * intElement=[CGDataXMLNode elementWithName:name stringValue:value];
    if(![RFUtility NSStringIsNULL:attName])
        [CXmlCtrl AddElementAttri:intElement name:attName val:attVal];
    [element addChild:intElement];
    return element;
}

+(CGDataXMLElement *) AddElementVal:(CGDataXMLElement *)element name:(NSString *)name val:(NSString *)value
{
   CGDataXMLElement * nameElement = [CGDataXMLNode elementWithName:name stringValue:name];
    
    [element addChild:nameElement];
    return element;
}

+(CGDataXMLElement *) AddElementAttri:(CGDataXMLElement *)element name:(NSString *)name val:(NSString *)value
{
    id attriElement = [CGDataXMLNode attributeWithName:name stringValue:value];
    
    [element addChild:attriElement];
    return element;
}

+(NSString *)GetSendMessageXmlString:(CSendMessageInfo *)msg
{
   CGDataXMLElement * partyElement = [CGDataXMLNode elementWithName:@"object"];
    	[CXmlCtrl AddElementValAndAttri:partyElement name:@"int" val:[NSString stringWithFormat:@"%ld",(long)msg.doubleMsg] attriName:@"name" AttVal:@"doubleMsg"];
	[CXmlCtrl AddElementValAndAttri:partyElement name:@"int" val:[NSString stringWithFormat:@"%ld",(long)msg.submitType] attriName:@"name" AttVal:@"submitType"];
	[CXmlCtrl AddElementValAndAttri:partyElement name:@"string" val:msg.smsContent attriName:@"name" AttVal:@"smsContent"];
	[CXmlCtrl AddElementValAndAttri:partyElement name:@"string" val:msg.receiverNumber attriName:@"name" AttVal:@"receiverNumber"];
	[CXmlCtrl AddElementValAndAttri:partyElement name:@"string" val:@"104" attriName:@"name" AttVal:@"comeFrom"];

	[CXmlCtrl AddElementValAndAttri:partyElement name:@"int" val:[NSString stringWithFormat:@"%ld",(long)msg.sendType] attriName:@"name" AttVal:@"sendType"];
	[CXmlCtrl AddElementValAndAttri:partyElement name:@"int" val:[NSString stringWithFormat:@"%ld",(long)msg.smsType] attriName:@"name" AttVal:@"smsType"];
	[CXmlCtrl AddElementValAndAttri:partyElement name:@"int" val:[NSString stringWithFormat:@"%ld",(long)msg.serialId] attriName:@"name" AttVal:@"serialId"];
	[CXmlCtrl AddElementValAndAttri:partyElement name:@"int" val:[NSString stringWithFormat:@"%ld",(long)msg.isShareSms] attriName:@"name" AttVal:@"isShareSms"];
    
    NSString *time = [RFUtility stringWithDate:[NSDate dateWithTimeIntervalSince1970:msg.mSendTime] withFormat:@"yyyy-MM-dd HH:mm:ss"];
	[CXmlCtrl AddElementValAndAttri:partyElement name:@"string" val:time attriName:@"name" AttVal:@"sendTime"];

	[CXmlCtrl AddElementValAndAttri:partyElement name:@"string" val:msg.validImg attriName:@"name" AttVal:@"validImg"];
	[CXmlCtrl AddElementValAndAttri:partyElement name:@"int" val:[NSString stringWithFormat:@"%ld",(long)msg.groupLength] attriName:@"name" AttVal:@"groupLength"];
	[CXmlCtrl AddElementValAndAttri:partyElement name:@"int" val:[NSString stringWithFormat:@"%ld",(long)msg.isSaveRecord] attriName:@"name" AttVal:@"isSaveRecord"];

   CGDataXMLDocument *document = [[CGDataXMLDocument alloc] initWithRootElement:partyElement];
    [document setCharacterEncoding:@"utf8"];
    NSData *xmlData = document.XMLData;
    
    NSString * tempText=[NSString stringWithUTF8String:[xmlData bytes]];
    NSLog(@"%@", tempText);
    return tempText;
}


#pragma mark -
+(NSString *)GetLogin139MailXmlString:(NSString *)name pwd:(NSString *)pwd
{
    CGDataXMLElement * partyElement = [CGDataXMLNode elementWithName:@"request"];
    
    [CXmlCtrl AddElementValAndAttri:partyElement name:@"cmd" val:@"login" attriName:nil AttVal:nil];
    [CXmlCtrl AddElementValAndAttri:partyElement name:@"clientType" val:@"login" attriName:nil AttVal:nil];
    [CXmlCtrl AddElementValAndAttri:partyElement name:@"userName" val:name attriName:nil AttVal:nil];
    [CXmlCtrl AddElementValAndAttri:partyElement name:@"password" val:pwd attriName:nil AttVal:nil];
    
    CGDataXMLDocument *document = [[CGDataXMLDocument alloc] initWithRootElement:partyElement];
    [document setCharacterEncoding:@"utf8"];
    NSData *xmlData = document.XMLData;
    
    NSString * tempText=[NSString stringWithUTF8String:[xmlData bytes]];
    NSLog(@"%@", tempText);
    return tempText;
}

#pragma mark -
+(NSString *)GetAutoCodeXmlString:(NSString *)name
{
    CGDataXMLElement * partyElement = [CGDataXMLNode elementWithName:@"object"];
    [CXmlCtrl AddElementValAndAttri:partyElement name:@"loginName" val:name attriName:nil AttVal:nil];
    [CXmlCtrl AddElementValAndAttri:partyElement name:@"fv" val:@"4" attriName:nil AttVal:nil];
    [CXmlCtrl AddElementValAndAttri:partyElement name:@"clientId" val:@"1003" attriName:nil AttVal:nil];
    [CXmlCtrl AddElementValAndAttri:partyElement name:@"version" val:@"1.0" attriName:nil AttVal:nil];
    
    CGDataXMLDocument *document = [[CGDataXMLDocument alloc] initWithRootElement:partyElement];
    [document setCharacterEncoding:@"utf8"];
    NSData *xmlData = document.XMLData;
    
    NSString * tempText=[NSString stringWithUTF8String:[xmlData bytes]];
    NSLog(@"%@", tempText);
    return tempText;
}


+(NSDictionary *) ParseLogin139MailXmlFromData:(NSData *)xmlData
{
    NSMutableDictionary * dict=[NSMutableDictionary dictionary];
    NSError *error;
    CGDataXMLDocument *doc = [[CGDataXMLDocument alloc] initWithData:xmlData options:0 error:&error];
    if (doc == nil) { return nil; }
    
    NSArray *partyMembers = [doc nodesForXPath:@"return" error:&error];
    for (CGDataXMLElement *partyMember in partyMembers) {
        // result
        [CXmlCtrl GetElementNameAndValToDictionary:dict :partyMember key:@"result"];
        
        // description
        [CXmlCtrl GetElementNameAndValToDictionary:dict :partyMember key:@"description"];
        
        // description
        [CXmlCtrl GetElementNameAndValToDictionary:dict :partyMember key:@"ssoid"];
        
        // description
        [CXmlCtrl GetElementNameAndValToDictionary:dict :partyMember key:@"svrInfoURL"];
        
        // description
        [CXmlCtrl GetElementNameAndValToDictionary:dict :partyMember key:@"logoutURL"];
    }
    
    return dict;
}



+(NSString *)GetSmsSenderXmlString:(CGetSmsSender *)msg{

	CGDataXMLElement * partyElement = [CGDataXMLNode elementWithName:@"request"];
    
	[CXmlCtrl AddElementValAndAttri:partyElement name:@"int" val:[NSString stringWithFormat:@"%ld",(long)msg.actionId] attriName:@"name" AttVal:@"actionId"];
	[CXmlCtrl AddElementValAndAttri:partyElement name:@"int" val:[NSString stringWithFormat:@"%ld",(long)msg.currentIndex] attriName:@"name" AttVal:@"currentIndex"];
	[CXmlCtrl AddElementValAndAttri:partyElement name:@"int" val:[NSString stringWithFormat:@"%ld",(long)msg.phoneNum] attriName:@"name" AttVal:@"phoneNum"];
	
	[CXmlCtrl AddElementValAndAttri:partyElement name:@"string" val:msg.deleSmsIds attriName:@"name" AttVal:@"deleSmsIds"];
	[CXmlCtrl AddElementValAndAttri:partyElement name:@"string" val:msg.keyWord attriName:@"name" AttVal:@"keyWord"];
	[CXmlCtrl AddElementValAndAttri:partyElement name:@"string" val:msg.mobile attriName:@"name" AttVal:@"mobile"];
	
	[CXmlCtrl AddElementValAndAttri:partyElement name:@"int" val:[NSString stringWithFormat:@"%ld",(long)msg.pageSize] attriName:@"name" AttVal:@"pageSize"];
	[CXmlCtrl AddElementValAndAttri:partyElement name:@"int" val:[NSString stringWithFormat:@"%ld",(long)msg.pageIndex] attriName:@"name" AttVal:@"pageIndex"];
	[CXmlCtrl AddElementValAndAttri:partyElement name:@"int" val:[NSString stringWithFormat:@"%ld",(long)msg.searchDateType] attriName:@"name" AttVal:@"searchDateType"];
	
   CGDataXMLDocument *document = [[CGDataXMLDocument alloc] initWithRootElement:partyElement];
    [document setCharacterEncoding:@"utf8"];
    NSData *xmlData = document.XMLData;
    
    NSString * tempText=[NSString stringWithUTF8String:[xmlData bytes]];
    NSLog(@"%@", tempText);
    return tempText;
}



+(void) GetElementNameAndValToDictionary:(NSMutableDictionary *)dict :(CGDataXMLElement *)element key:(NSString *)key
{
    NSArray *names = [element elementsForName:key];
    if (names.count > 0) {
        NSString * tempText=nil;
		
       CGDataXMLElement *firstName = (CGDataXMLElement *) [names objectAtIndex:0];
        tempText = firstName.stringValue;
        [dict setObject:tempText forKey:key];
    }
}


@end
