//
//  RFPOAPinyin.h
//  POA
//
//  Created by haung he on 11-7-18.
//  Copyright 2011年 huanghe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RFChineseToPinyin.h"

@interface RFPOAPinyin : NSObject {
    
}

+ (NSString *) convert:(NSString *) hzString;//输入中文，返回拼音。

//  added by setimouse ( setimouse@gmail.com )
+ (NSString *)quickConvert:(NSString *)hzString;
+ (void)clearCache;

//  ------------------
+(BOOL) IsHz:(unichar)str;

+(const char*) get_pin:(unsigned short)char_zh;
+(char) pinyinFirstLetter:(unsigned short) hanzi;
@end
