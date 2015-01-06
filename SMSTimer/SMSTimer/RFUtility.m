//
//  RFRFUtility.m
//  iClearmagazine
//
//  Created by 肖 高超 on 12-4-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RFUtility.h"
#import "CommonCrypto/CommonDigest.h"
#import "RFPOAPinyin.h"

NSString * const kRFAccountKey              = @"kRFAccountKey";
NSString * const kRFToken             = @"kRFToken";


static NSString *hardKey = @"vrMQNdaRkFqJgSK0rl4M";    //加密解密密钥

static const char _base64EncodingTable[64] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

static const short _base64DecodingTable[256] = {
	-2, -2, -2, -2, -2, -2, -2, -2, -2, -1, -1, -2, -1, -1, -2, -2,
	-2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
	-1, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, 62, -2, -2, -2, 63,
	52, 53, 54, 55, 56, 57, 58, 59, 60, 61, -2, -2, -2, -2, -2, -2,
	-2,  0,  1,  2,  3,  4,  5,  6,  7,  8,  9, 10, 11, 12, 13, 14,
	15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, -2, -2, -2, -2, -2,
	-2, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40,
	41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, -2, -2, -2, -2, -2,
	-2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
	-2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
	-2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
	-2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
	-2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
	-2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
	-2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
	-2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2
};

@implementation RFUtility

+ (NSString *) encryptStr:(NSString *) str    //加密
{
    NSString *encryptStr = [RFUtility doCipher:str key:hardKey context:kCCEncrypt];
    return encryptStr;
}

+ (NSString *) decryptStr:(NSString	*) str   //解密
{
    NSString *encryptStr = [RFUtility doCipher:str key:hardKey context:kCCDecrypt];
    return encryptStr;    
}

+ (NSString *)doCipher:(NSString *)sTextIn key:(NSString *)sKey
			   context:(CCOperation)encryptOrDecrypt 
{
	NSStringEncoding EnC = NSUTF8StringEncoding;
    NSMutableData * dTextIn;
    if (encryptOrDecrypt == kCCDecrypt) 
    {    
        dTextIn = [[RFUtility decodeBase64WithString:sTextIn] mutableCopy];
    }
    else
    {    
        dTextIn = [[sTextIn dataUsingEncoding:EnC] mutableCopy];    
    }
    NSMutableData * dKey = [[sKey dataUsingEncoding:EnC] mutableCopy];
    [dKey setLength:kCCBlockSizeDES];        
    uint8_t *bufferPtr1 = NULL;    
    size_t bufferPtrSize1 = 0;
    size_t movedBytes1 = 0;
    
	Byte iv[] = {0x12, 0x34, 0x56, 0x78, 0x90, 0xAB, 0xCD, 0xEF};
    bufferPtrSize1 = ([sTextIn length] + kCCKeySizeDES) & ~(kCCKeySizeDES -1);    
    bufferPtr1 = malloc(bufferPtrSize1 * sizeof(uint8_t));    
    memset((void *)bufferPtr1, 0x00, bufferPtrSize1);    
	CCCrypt(encryptOrDecrypt, // CCOperation op    
			kCCAlgorithmDES, // CCAlgorithm alg    
			kCCOptionPKCS7Padding|kCCOptionECBMode, // CCOptions options    
			[dKey bytes], // const void *key    
			[dKey length], // size_t keyLength    
			iv, // const void *iv    
			[dTextIn bytes], // const void *dataIn
			[dTextIn length],  // size_t dataInLength    
			(void *)bufferPtr1, // void *dataOut    
			bufferPtrSize1,     // size_t dataOutAvailable 
			&movedBytes1);      // size_t *dataOutMoved    
    
    NSString * sResult;    
    if (encryptOrDecrypt == kCCDecrypt)
    {    
        sResult = [[NSString alloc] initWithData:[NSData dataWithBytes:bufferPtr1
																  length:movedBytes1] encoding:EnC];
    }    
    else 
    {    
        NSData *dResult = [NSData dataWithBytes:bufferPtr1 length:movedBytes1]; 
        sResult = [RFUtility encodeBase64WithData:dResult];
    }           
    free(bufferPtr1);
    return sResult;
}

+ (NSString *)md5HexDigest:(NSString*)str{
    const char *original_str = [str UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(original_str, strlen(original_str), result);
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < 16; i++)
        {
            [hash appendFormat:@"%02X", result[i]];
        }
    NSString *mdfiveString = [hash lowercaseString];
    return mdfiveString;
}

+(NSString*)encodeBase64WithData:(NSData *)strData
{
    if (strData.length == 0)
        return @"";
    
    char *characters = malloc(strData.length*3/2);
    if (characters == NULL)
        return @"";
    NSInteger end = strData.length - 3;
    int index = 0;
    int charCount = 0;
    int n = 0;
    
    while (index <= end) 
    {
        int d = (((int)(((char *)[strData bytes])[index]) & 0x0ff) << 16) 
        | (((int)(((char *)[strData bytes])[index + 1]) & 0x0ff) << 8)
        | ((int)(((char *)[strData bytes])[index + 2]) & 0x0ff);
        
        characters[charCount++] = _base64EncodingTable[(d >> 18) & 63];
        characters[charCount++] = _base64EncodingTable[(d >> 12) & 63];
        characters[charCount++] = _base64EncodingTable[(d >> 6) & 63];
        characters[charCount++] = _base64EncodingTable[d & 63];
        
        index += 3;
        
        if(n++ >= 14)
        {
            n = 0;
            characters[charCount++] = ' ';
        }
    }
    
    if(index == strData.length - 2)
    {
        int d = (((int)(((char *)[strData bytes])[index]) & 0x0ff) << 16) 
        | (((int)(((char *)[strData bytes])[index + 1]) & 255) << 8);
        characters[charCount++] = _base64EncodingTable[(d >> 18) & 63];
        characters[charCount++] = _base64EncodingTable[(d >> 12) & 63];
        characters[charCount++] = _base64EncodingTable[(d >> 6) & 63];
        characters[charCount++] = '=';
    }
    else if(index == strData.length - 1)
    {
        int d = ((int)(((char *)[strData bytes])[index]) & 0x0ff) << 16;
        characters[charCount++] = _base64EncodingTable[(d >> 18) & 63];
        characters[charCount++] = _base64EncodingTable[(d >> 12) & 63];
        characters[charCount++] = '=';
        characters[charCount++] = '=';
    }
    NSString * rtnStr = [[NSString alloc] initWithBytesNoCopy:characters length:charCount encoding:NSUTF8StringEncoding freeWhenDone:YES];
    //free(characters);
    return rtnStr;
}

+ (NSData *)decodeBase64WithString:(NSString *)strBase64 {
	const char * objPointer = [strBase64 cStringUsingEncoding:NSASCIIStringEncoding];
	NSInteger intLength = strlen(objPointer);
	int intCurrent;
	int i = 0, j = 0, k;
	
	unsigned char * objResult;
	objResult = calloc(intLength, sizeof(char));
	
	// Run through the whole string, converting as we go
	while ( ((intCurrent = *objPointer++) != '\0') && (intLength-- > 0) ) {
		if (intCurrent == '=') {
			if (*objPointer != '=' && ((i % 4) == 1)) {// || (intLength > 0)) {
				// the padding character is invalid at this point -- so this entire string is invalid
				free(objResult);
				return nil;
			}
			continue;
		}
		
		intCurrent = _base64DecodingTable[intCurrent];
		if (intCurrent == -1) {
			// we're at a whitespace -- simply skip over
			continue;
		} else if (intCurrent == -2) {
			// we're at an invalid character
			free(objResult);
			return nil;
		}
		
		switch (i % 4) {
			case 0:
				objResult[j] = intCurrent << 2;
				break;
				
			case 1:
				objResult[j++] |= intCurrent >> 4;
				objResult[j] = (intCurrent & 0x0f) << 4;
				break;
				
			case 2:
				objResult[j++] |= intCurrent >>2;
				objResult[j] = (intCurrent & 0x03) << 6;
				break;
				
			case 3:
				objResult[j++] |= intCurrent;
				break;
		}
		i++;
	}
	
	// mop things up if we ended on a boundary
	k = j;
	if (intCurrent == '=') {
		switch (i % 4) {
			case 1:
				// Invalid state
				free(objResult);
				return nil;
				
			case 2:
				k++;
				// flow through
			case 3:
				objResult[k] = 0;
		}
	}
	
	// Cleanup and setup the return NSData
	NSData * objData = [[NSData alloc] initWithBytes:objResult length:j];
	free(objResult);
	return objData;
}

//苹果黑体字体。
+(UIFont*)STHeitiSC:(CGFloat)fontSzie{
    if (fontSzie <= 0) {
        fontSzie = 10;
    }
    
    return  [UIFont fontWithName:@"STHeitiSC-Light" size:fontSzie];
}

//苹果黑体字体。
+(UIFont*)HelveticaNeue:(CGFloat)fontSzie{
    if (fontSzie <= 0) {
        fontSzie = 10;
    }
    
    return   [UIFont fontWithName:@"HelveticaNeue" size:fontSzie];
}


+ (UIColor *) colorFromColorString:(NSString *)colorString{
    return [RFUtility colorFromColorString:colorString alpha:1.0f];
}

+ (UIColor *)colorFromColorString:(NSString *)colorString alpha:(CGFloat)alpha{
    NSString *stringToConvert = @"";
    stringToConvert = [colorString stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    if ([cString rangeOfString:@","].location != NSNotFound) {
        NSArray *array = [colorString componentsSeparatedByString:@","];
        return [UIColor colorWithRed:([array[0] intValue]/255.0) green:([array[1] intValue]/255.0) blue:([array[2] intValue]/255.0) alpha:1.0];
    }
    
    if ([cString length] < 6)
        return [UIColor clearColor];
    
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    
    if ([cString length] > 6)
        cString = [cString substringToIndex:6];
    
    if ([cString length] != 6)
        return [UIColor clearColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:alpha];
}


+(UIColor*)ColorWithR:(CGFloat)red G:(CGFloat)green B:(CGFloat)blue A:(CGFloat)alp{
   
    if (green <= 0.0f || green >= 255.0f) {
        green = 255.0f;
    }
    if (red <= 0.0f || red >= 255.0f) {
        red = 255.0f;
    }
    if (blue <= 0.0f || blue >= 255.0f) {
        blue = 255.0f;
    }
    
    if (alp <= 0.0f || alp >= 1.0f) {
        alp = 1.0f;
    }
    
    return [UIColor colorWithRed:red/255.0f green:green/255.0f blue:blue/255.0f alpha:alp];
}


+ (BOOL)isSystemVersionSeven{
    if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 7.0)
    {
        return YES;
    }
    return NO;
    
}


//获取当前操作的邮件账户，eg.  15507586421@139.com
+ (NSString *)getCurrentMailAccount{
    NSUserDefaults *CUserInfo = [NSUserDefaults standardUserDefaults];
    NSString *account = [CUserInfo valueForKey:@"currentMailAccount"];
    if (account == nil) {
        account = @"";
    }
    return account;
}
//获取当前操作的邮件账户文件夹，文件夹名称与服务器中的文件夹名称一样
+ (NSString *)getCurrentMailFolder{
    NSUserDefaults *CUserInfo = [NSUserDefaults standardUserDefaults];
    NSString *folder = [CUserInfo valueForKey:@"currentMailFolder"];
    if (folder == nil) {
        folder = @"";
    }
    return folder;
}
//设置当前操作的邮件账户与文件夹
+ (void)setCurrentMailAccount:(NSString *)mailAccount withFolderName:(NSString *)mailFolder{
    NSUserDefaults *CUserInfo = [NSUserDefaults standardUserDefaults];
    [CUserInfo setObject:mailAccount forKey:@"currentMailAccount"];
    [CUserInfo setObject:mailFolder forKey:@"currentMailFolder"];
    [CUserInfo setObject:@"0" forKey:@"selectedIndex"];
    [CUserInfo synchronize];
}

+ (void)setMailPullNumber:(int)number{
    NSUserDefaults *CUserInfo = [NSUserDefaults standardUserDefaults];
    [CUserInfo setValue:[NSNumber numberWithInt:number] forKey:@"mailPullNumber"];
    [CUserInfo synchronize];
}
+ (NSNumber*)getMailPullNumber{
    NSUserDefaults *CUserInfo = [NSUserDefaults standardUserDefaults];
    NSNumber *number = [CUserInfo objectForKey:@"mailPullNumber"];
    
    if (0 == [number integerValue]) {
        return [NSNumber numberWithInteger:50];
    }
    
    return number;
}
+ (void)setMailShowLine:(int)number{
    NSUserDefaults *CUserInfo = [NSUserDefaults standardUserDefaults];
    [CUserInfo setValue:[NSNumber numberWithInt:number] forKey:@"mailShowLine"];
    [CUserInfo synchronize];
}
+ (NSNumber*)getMailShowLine{
    NSUserDefaults *CUserInfo = [NSUserDefaults standardUserDefaults];
    NSNumber *number = [CUserInfo objectForKey:@"mailShowLine"];
    
    if (0 == [number integerValue]) {
        return [NSNumber numberWithInteger:2];
    }
    
    return number;
}
//获取当前时间 毫秒级别。
+(void)getMillisecond:(const char*)fileName :(const char*)function :(NSInteger)line{
    NSDateFormatter *formatter= [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSSSSS"];
	NSLog(@"%s: %ld: %@", function, (long)line, [formatter stringFromDate:[NSDate date]]);
    return;
}


+ (UIColor *) nsstringToColor:(NSString *)colorString
{
    NSString *stringToConvert = @"";
    stringToConvert = [colorString stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    if ([cString length] < 6)
        return [UIColor clearColor];
    
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    
    if ([cString length] != 6)
        return [UIColor clearColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}

+(UIColor *)RGBnsstringToColor:(NSString *)rgb{//23,23,343
    NSArray *array = [rgb componentsSeparatedByString:@","];
    return [UIColor colorWithRed:(float)(([array[0] intValue])/255.0f)green:(float)(([array[1] intValue])/255.0f)blue:(float)(([array[2] intValue])/255.0f)alpha:1.0f];
}

+(NSString *) GetHMFromDate:(NSDate *)date{
    if(date == nil) return nil;
    
//    NSDateComponents *todayComponents = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:date];
//    
//    NSString * tempText=[NSString stringWithFormat:@"%02d%02d", todayComponents.hour, todayComponents.minute];
//    return tempText;
	return nil;
}



+ (NSInteger)CompareToday:(NSDate *)date{
    
    return 0;
}

+(NSInteger)isSameDayDesDate:(NSDate *)date srcDate:(NSDate *)srcDate{
//	if (date == Nil || srcDate == Nil) {
//        return -1;
//    }
//    NSDateComponents *todayComponents = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:date];
//    NSDateComponents *dateComponents = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:srcDate];
//    
//    if (dateComponents.year < todayComponents.year) {
//        return -1;
//    }
//    else if (dateComponents.year == todayComponents.year){
//    	if (dateComponents.month < todayComponents.month) {
//            return -1;
//        }
//        else if (dateComponents.month == todayComponents.month){
//            if (dateComponents.day < todayComponents.day) {
//                return -1;
//            }
//            else if (dateComponents.day == todayComponents.day){
//                return 0;
//            }
//            else if (dateComponents.day > todayComponents.day){
//                return 1;
//            }
//        }
//        else if (dateComponents.month > todayComponents.month){
//            return 1;
//        }
//    }
//    else if (dateComponents.year > todayComponents.year){
//        return 1;
//    }
//    
    
    return 0;
}


+ (NSInteger)isSameMonthDestDate:(NSDate *)date srcDate:(NSDate *)srcDate{
    if (date == Nil) {
        return -1;
    }
    return 0;
	
}
+ (NSDate *) FormatDateFromNSString:(NSString *)aDate :(NSString *)aFormat{
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSTimeZone *timeZone = [NSTimeZone localTimeZone];
    [formatter setTimeZone:timeZone];
    [formatter setDateFormat:aFormat];
	NSDate *firstDaydate =[formatter dateFromString:aDate] ;//date这个日期所在月份的第一天的日期

	return firstDaydate;
}

+ (NSString *) FormatNSStringFromDate:(NSDate *)aDate :(NSString *)aFormat{

	
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    NSTimeZone *timeZone = [NSTimeZone localTimeZone];
//    [formatter setTimeZone:timeZone];
    [formatter setDateFormat:aFormat];
	NSString *dateStiring =[formatter stringFromDate:aDate] ;
	
	return dateStiring;
}


+ (BOOL)isBlankString:(NSString *)string
{
    if (string == nil)
    {
        return YES;
    }
    if (string == NULL)
    {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]])
    {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}


+ (NSString *) GetPhoneFromMail:(NSString *)mail
{
    NSString * phone=mail;
    NSInteger pos=[mail rangeOfString:@"@"].location;
    if(pos != NSNotFound)
    {
        phone = [mail substringToIndex:pos];
    }
    return phone;
}

+ (BOOL) isVailed139Mail:(NSString *)mail
{
    NSInteger pos=[mail rangeOfString:@"@139.com"].location;
    if(pos != NSNotFound)
    {
		return YES;
    }
    return NO;
}


+(BOOL) NSStringIsNULL:(id)id_
{
    if([id_ isKindOfClass:[NSNull class]]) return YES;
    if(![id_ isKindOfClass:[NSString class]]) return YES;
    
	if(id_ == nil) return YES;
    
    NSInteger len=[(NSString *)id_ length];
    if (len <= 0) return YES;

	return NO;
}

+(float)currentDeviceVersion{
    NSString *version = [UIDevice currentDevice].systemVersion;
    return [version floatValue];
}

+(BOOL)currentDeviceVersionSix{
    NSString *version = [UIDevice currentDevice].systemVersion;
    if ([version floatValue] == 6.0f || [version floatValue] == 6.1f) {
        return YES;
    }
    else{
        return NO;
    }
}
+(BOOL)currentDeviceVersionAfterSix{
    NSString *version = [UIDevice currentDevice].systemVersion;
    if ([version floatValue] >= 6.0) {
        return YES;
    }
    else{
        return NO;
    }
}
+(BOOL)currentDeviceVersionBeforeSeven{
    NSString *version = [UIDevice currentDevice].systemVersion;
    if ([version floatValue] < 7.0f) {
        return YES;
    }
    else{
        return NO;
    }
}

+(BOOL)currentDeviceVersionSeven{
    NSString *version = [UIDevice currentDevice].systemVersion;
    if (([version floatValue] >= 7.0f) && ([version floatValue] < 8.0f)) {
        return YES;
    }
    else{
        return NO;
    }
}

+(BOOL)currentDeviceVersionAfterSeven{
    NSString *version = [UIDevice currentDevice].systemVersion;
    if ([version floatValue] >= 7.0f) {
        return YES;
    }
    else{
        return NO;
    }
}


+(NSString *)GetThePinYinString:(NSString *)title
{
    if([RFUtility NSStringIsNULL:title]) return nil;
    
    NSString * strPinyin = @"";
    for (int i = 0; i < [title length]; i++)
    {
        NSString * tempText=[NSString stringWithFormat:@"%c", [RFPOAPinyin pinyinFirstLetter:[title characterAtIndex:i]]];
        if(tempText == nil) continue;
        tempText=[tempText uppercaseString];
        strPinyin = [strPinyin stringByAppendingString:tempText];
    }
    
    return strPinyin;
}

+(BOOL) IsImageByExt:(NSString *)fileName
{
    NSString * extStr=@"|jpg|jpeg|bmp|gif|png|";
    NSString * fileExt=[fileName pathExtension];
    
    if([extStr rangeOfString:fileExt options:NSCaseInsensitiveSearch].location != NSNotFound)
        return YES;
    else return NO;
}

+(NSString *) GetTheFileTypeImgNameByType:(NSString *)fileType
{
    if([RFUtility NSStringIsNULL:fileType]) return @"mat_unknown.png";
    
    if ([fileType hasSuffix:@"jpg"]) {
        return @"mat_jpg.png";
    }else if ([fileType hasSuffix:@"doc"] || [fileType hasSuffix:@"docx"]) {
        return @"mat_doc.png";
    }else if ([fileType hasSuffix:@"bmp"]) {
        return @"mat_bmp.png";
    }else if ([fileType hasSuffix:@"gif"]) {
        return @"mat_gif.png";
    }else if ([fileType hasSuffix:@"pdf"]) {
        return @"mat_pdf.png";
    }else if ([fileType hasSuffix:@"png"]) {
        return @"mat_png.png";
    }else if ([fileType hasSuffix:@"ppt"]) {
        return @"mat_ppt.png";
    }else if ([fileType hasSuffix:@"txt"]) {
        return @"mat_txt.png";
    }else if ([fileType hasSuffix:@"xls"] || [fileType hasSuffix:@"xlsx"]) {
        return @"mat_xls.png";
    }
    //    else if ([fileType hasSuffix:@"zip"] || [fileType hasSuffix:@"rar"]) {
    //        return @"mat_xls.png";
    //    }
    else if ([fileType hasSuffix:@"htm"] || [fileType hasSuffix:@"html"]) {
        return @"mat_xls.png";
    }
    else
    {
        return @"mat_unknown.png";
    }
}

//判断手机号类型
+ (MOBILETYPE) GetMobileType:(NSString *)mobileNum
{
    /**
     10	     * 中国移动：China Mobile
     11	     * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12	     */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[2378])\\d)\\d{7}$";
    /**
     15	     * 中国联通：China Unicom
     16	     * 130,131,132,152,155,156,185,186
     17	     */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20	     * 中国电信：China Telecom
     21	     * 133,1349,153,180,189
     22	     */
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    /**
     25	     * 大陆地区固话及小灵通
     26	     * 区号：010,020,021,022,023,024,025,027,028,029
     27	     * 号码：七位或八位
     28	     */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if ([regextestcm evaluateWithObject:mobileNum] == YES)
	{
        return MOBILE_CM;
    }
    else if([regextestct evaluateWithObject:mobileNum] == YES)
    {
        return MOBILE_CT;
    }
	else
	{
        if([regextestcu evaluateWithObject:mobileNum] == YES)
        {
            return MOBILE_CU;
        }
    }
    return MOBILE_UNKNOWN;
}

// 正则判断手机号码地址格式
+ (BOOL)isMobileNumber:(NSString *)mobileNum
{
    NSString *destMobile = [mobileNum stringByReplacingOccurrencesOfString:@"-" withString:@""];
    destMobile = [destMobile stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSRange rang = [destMobile rangeOfString:@"+86"];
    if (rang.length > 0) {
     destMobile =   [destMobile stringByReplacingOccurrencesOfString:@"+86" withString:@""];
    }
    
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[0235-9])\\d{8}$";
    /**
     10	     * 中国移动：China Mobile
     11	     * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12	     */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[2378])\\d)\\d{7}$";
    /**
     15	     * 中国联通：China Unicom
     16	     * 130,131,132,152,155,156,185,186
     17	     */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20	     * 中国电信：China Telecom
     21	     * 133,1349,153,180,189
     22	     */
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    /**
     25	     * 大陆地区固话及小灵通
     26	     * 区号：010,020,021,022,023,024,025,027,028,029
     27	     * 号码：七位或八位
     28	     */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:destMobile] == YES)
        || ([regextestcm evaluateWithObject:destMobile] == YES)
        || ([regextestct evaluateWithObject:destMobile] == YES))
	{
        if([destMobile length] == 11){
            return YES;
        }
        else{
            return NO;
        }
    }
	else
	{
        if([regextestcu evaluateWithObject:destMobile] == YES)
        {
            if([destMobile length] == 8 || [destMobile length] == 7)
                return YES;
            else
                return NO;
        }
    }
    return NO;
}

// 正则判断电邮地址格式
+ (BOOL)isEmailValid:(NSString*)email
{
    //    NSString *Regex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    //    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", Regex];
    //    return [emailTest evaluateWithObject:email];
    
    
    NSString* regex = @"^[A-Za-z0-9._%+-]+@[A-Za-z0-9._%+-]+\\.[A-Za-z0-9._%+-]+$";
    NSPredicate *regextest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    if ([regextest evaluateWithObject:email] == YES)
	{
        return YES;
    }
	else
	{
        return NO;
    }
    return NO;
    
}

+ (NSString*)stringWithDate:(NSDate*)date withFormat:(NSString*)formatStr{
    if (date == nil) {
        date = [NSDate date];
    }
    if (formatStr == nil) {
        formatStr = @"yyyy-MM-dd";
    }
    
    NSDateFormatter *formatter =[[NSDateFormatter alloc] init];
    [formatter setDateFormat:formatStr];
    [formatter setTimeZone:[NSTimeZone systemTimeZone]];
    NSString *dateStr = [formatter stringFromDate:date];
    return dateStr;
}

+(NSString*)getLocaleDataStringWithTimerInterval:(NSTimeInterval)val{
    if (val  <= 10000) {
        return nil;
    }
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:val];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: date];
    
    NSString *localeDateStr = [[date  dateByAddingTimeInterval: interval] description];
    if (localeDateStr.length >= 16) {
        localeDateStr = [localeDateStr substringToIndex:16];
    }
    return localeDateStr;
}


+ (void)showMessage:(NSString*)msg{
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
														message:msg
													   delegate:nil
											  cancelButtonTitle:nil
											  otherButtonTitles:@"确定", nil];
	[alertView show];
	
}

+(UIImageView *) GetCurrentScreen:(UIView *)layView
{
    if(layView == nil) return nil;
    
    //CGContextRef context=UIGraphicsGetCurrentContext();
    UIGraphicsBeginImageContextWithOptions(layView.bounds.size, NO, 0.0f);
    //UIGraphicsBeginImageContext(layView.bounds.size);
    CALayer *layer = layView.layer;
    
    CGContextRef context=UIGraphicsGetCurrentContext();
    if(context == nil) return nil;
    
    
    [layer renderInContext:context];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIImageView * imgView2=[[UIImageView alloc] initWithImage:image];
    [imgView2 setFrame:layView.bounds];
    [imgView2 setTag:1000];
    //[imgView autorelease];
    return imgView2;
}


NSString *GetUUID() {
    CFUUIDRef theUUID = CFUUIDCreate(NULL);
    CFStringRef string = CFUUIDCreateString(NULL, theUUID);
    
    CFRelease(theUUID);
    
    return (__bridge NSString *)string;
}

@end
