//
//  CCDBConfig.m
//
//
//  Created by  on 12-5-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
//本地数据配置库
#import "CDBConfig.h"
#include <sys/xattr.h>


@implementation CCDBConfig
@synthesize dbPath;

static CCDBConfig* dbconfigShareInstance;

+(CCDBConfig*) shareInstace{
	if (dbconfigShareInstance == nil) {
		dbconfigShareInstance = [[ CCDBConfig alloc] init];
	}
	return dbconfigShareInstance;
}

-(id) init
{
	if ((self = [super init])) {
	}
	return self;
}

#pragma mark - 数据库基本操作。
- (void)AddSkipBackupAttributeToFilePath: (NSString *)strFile
{
    u_int8_t b = 1;
    setxattr([strFile fileSystemRepresentation], "com.apple.MobileBackup", &b, 1, 0, 0);
}

-(void)initDBPath:(NSString *)path{
	if (path== nil && path.length  <= 0) {
		return;
	}
	else{
		self.dbPath = path;
	}
}
- (CDatabase *)getDbWithAccount:(NSString*)account
{
	NSString *filePath=@"";
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
	filePath=[paths objectAtIndex:0];
	[self AddSkipBackupAttributeToFilePath:filePath];
	
	NSMutableString * aTPath=[NSMutableString stringWithString:filePath];
	[aTPath appendString:@"/"];
	NSMutableString * tempPath =[NSMutableString stringWithString:aTPath];
	[tempPath appendString:[NSString stringWithFormat:@"%@/",account]];
	
	// 判断文件夹是否存在，不存在则创建对应文件夹
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir = FALSE;
    BOOL isDirExist = [fileManager fileExistsAtPath:tempPath isDirectory:&isDir];
    if(!(isDirExist && isDir))
    {
        BOOL bCreateDir = [fileManager createDirectoryAtPath:tempPath withIntermediateDirectories:YES attributes:nil error:nil];
        if(!bCreateDir){
            NSLog(@"Create Audio Directory Failed.");
        }
    }

	//创建对应的帐号数据库文件。
	if (account) {
		[tempPath appendString:[NSString stringWithFormat:@"%@.db",account]];
	}
	else{
		[tempPath appendString:@"Caccount.db"];
	}
	filePath = tempPath;
	CDatabase *curDB =[CDatabase databaseWithPath:filePath];
    return curDB;
}


//根据表名往表中插入一条记录
-(BOOL) InsertIntoTableByName:(NSDictionary*)dic tableName:(NSString*)tableName :(CDatabase*)m_db
{
		if(dic==nil || [dic count]==0) return NO;
		
		NSArray * arrKeys=[dic allKeys];
		NSArray * arrValues=[dic allValues];
		NSInteger count=[arrKeys count];
		NSString *sql = [NSString stringWithFormat:@"insert into %@(",tableName];
		NSMutableString * tempsql=[NSMutableString stringWithString:sql];
		for (int i=0; i<count; i++)
		{
			[tempsql appendString:[arrKeys objectAtIndex:i]];
			if(i != count-1)
			{
				[tempsql appendString:@","];
			}
		}
		[tempsql appendString:@") values("];
		for(int k=0; k<count; k++)
		{
			[tempsql appendString:@"?"];
			if(k != count-1)
			{
				[tempsql appendString:@","];
			}
		}
		[tempsql appendString:@")"];
		[m_db executeUpdate:tempsql withArgumentsInArray:arrValues];
		if([m_db hadError])
		{
			NSLog(@"Insert into %@ table has Error, %@",tableName, [m_db lastError]);
			return NO;
		}
		return YES;
}

//更新满足所有条件的记录
-(BOOL)UpdateByTableName:(NSDictionary*)dic condition:(NSDictionary*)dicCondtion tableName:(NSString*)name :(CDatabase*)m_db
{

		if(dicCondtion==nil || [dicCondtion count]==0) return NO;
		NSInteger count=[dic count];
		if(dic==nil || count==0) return NO;
		NSArray * keyArray=[dic allKeys];
		NSString *sql = [NSString stringWithFormat:@"update %@ set ",name];
		NSMutableString * tempsql=[NSMutableString stringWithString:sql];
		
		for (int i=0; i<count; i++) {
			[tempsql appendString:[keyArray objectAtIndex:i]];
			[tempsql appendString:@"=?"];
			if(i != count-1)
			{
				[tempsql appendString:@", "];
			}
		}
		count=[dicCondtion count];
		[tempsql appendString:@" where "];
		keyArray=[dicCondtion allKeys];
		for (int i=0; i<count; i++) {
			[tempsql appendString:[keyArray objectAtIndex:i]];
			[tempsql appendString:@"=?"];
			if(i != count-1)
			{
				[tempsql appendString:@" and "];
			}
		}
		
		NSMutableArray * valArray=[NSMutableArray arrayWithArray:[dic allValues]];
		NSArray *conditionValArray=[dicCondtion allValues];
		for(int i=0;i<[conditionValArray count];i++)
		{
			[valArray addObject:[conditionValArray objectAtIndex:i]];
		}
		
		[m_db executeUpdate:tempsql withArgumentsInArray:valArray];
		if([m_db hadError])
		{
			return NO;
		}
	    return YES;
}

- (BOOL)deleteTable:(NSString *)tableName :(CDatabase*)m_db
{
		[m_db executeUpdate: [NSString stringWithFormat:@"DELETE FROM %@", tableName]];
		if ([m_db hadError]) {
			return NO;
		}
		else{
			return YES;
		}
}

-(BOOL)createTable:(NSString*)sql :(CDatabase*)db{
	if (![db open]) {
		[db open];
	}
		[db executeUpdate:sql];
		if([db hadError])
		{
			return NO;
		
		}
		return YES;
}


-(BOOL) MakeAccountDBIsExistAndOpen:(CDatabase*)db
{
	if(![db open]){
		return NO;
	}
	else{
		@try {
			[self CreateMessageTable:db];
		}
		@catch (NSException *exception) {
			return NO;
		}
		return YES;
	}
}


#pragma mark -  表操作
-(BOOL)deleteTableWithAccount:(NSString *)account{
	CDatabase*  m_db = [self getDbWithAccount:account];
	BOOL success = YES;
	if (![self deleteTable:Table_message :m_db]) {
		success = NO;
		NSLog(@"delete table_Message fail!");
	}
	
	if (![self deleteTable:Table_folder :m_db]) {
		success = NO;
		NSLog(@"delete table_Message fail!");
	}
	
	if (![self deleteTable:Table_attachment:m_db]) {
		success = NO;
		NSLog(@"delete table_Message fail!");
	}
	
	if (![self deleteTable:Table_messageInfo:m_db]) {
		success = NO;
		NSLog(@"delete table_Message fail!");
	}
	NSString *filePath=@"";
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
	filePath=[paths objectAtIndex:0];
	[self AddSkipBackupAttributeToFilePath:filePath];
	
	NSMutableString * aTPath=[NSMutableString stringWithString:filePath];
	[aTPath appendString:@"/"];
	NSMutableString * tempPath =[NSMutableString stringWithString:aTPath];
	
	NSFileManager *fileManager = [NSFileManager defaultManager];
	[tempPath appendString:[NSString stringWithFormat:@"%@/",account]];
	NSError *error = nil;
	[fileManager removeItemAtPath:tempPath error:&error];

	if (error) {
		return NO;
	}
	return YES;
}


//创建邮件表
-(BOOL)CreateMessageTable:(CDatabase*)db
{
    NSString *sql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, serialId text,userNumber text, sendMsg text, createTime text, sendTime text,  recUserNumber text, groupId text, startSendTime text, sended text, sendStatus text, comeFrom text, sendedTime text ,remark1 varchar(255),remark2 varchar(255) ,remark3 varchar(255)) ",Table_message];
	return [self createTable:sql :db];
	
}
-(CSMSData*)messageDataFromResultset:(CResultSet*)rs{

	CSMSData* data = [[CSMSData alloc] init];
	data.serialId = [rs stringForColumn:@"serialId"];
	data.userNumber = [rs stringForColumn:@"userNumber"];
	data.sendMsg = [rs stringForColumn:@"sendMsg"];
	data.createTime = [rs stringForColumn:@"createTime"];
	data.sendTime = [rs stringForColumn:@"sendTime"];

	data.recUserNumber = [rs stringForColumn:@"recUserNumber"];
	data.groupId = [rs intForColumn:@"groupId"];
	data.startSendTime = [rs stringForColumn:@"startSendTime"];
	data.sended = [rs intForColumn:@"sended"];
	data.sendStatus = [rs intForColumn:@"sendStatus"];

	data.comeFrom = [rs intForColumn:@"comeFrom"];
	data.sendedTime = [rs stringForColumn:@"sendedTime"];

	return  data;
}


-(void)insertMessage:(CSMSData*)message{
	CDatabase *_db = [self getDbWithAccount:[CUserInfo sharedInstance].strAccount];
	[self MakeAccountDBIsExistAndOpen:_db];
	[_db open];
	NSDictionary *msgDict = [NSMutableDictionary CreateDictionaryData:message];
	
	NSMutableDictionary *conditiondict = [[NSMutableDictionary alloc] init];
	[conditiondict setValue:message.serialId forKey:@"serialId"];
	
	if ([self QueryMessageIsExistById:message.serialId :_db]) {
		[self UpdateByTableName:msgDict
					  condition:conditiondict
					  tableName:Table_message
							   :_db];
	}
	else{
		[self InsertIntoTableByName:msgDict tableName:Table_message:_db];
	}
	[_db close];

}
-(BOOL)QueryMessageIsExistById:(NSString*)serialId :(CDatabase*)db{
	NSString *sql = [NSString stringWithFormat:@"select * from %@ where serialId=?",Table_message];
	CResultSet * rs=[db executeQuery:sql,serialId];
	if([rs next])
	{
		[rs close];
		return YES;
	}
	[rs close];
	return NO;
}

-(NSMutableArray*)qureyMailMessage{
	
	CDatabase *m_db = [self getDbWithAccount:[CUserInfo sharedInstance].strAccount];
	[self MakeAccountDBIsExistAndOpen:m_db];
	[m_db open];
	NSString *sql = [NSString stringWithFormat:@"select * from %@ ",Table_message];
	NSMutableArray *arrMessage = [[NSMutableArray alloc] initWithCapacity:1];
	CResultSet * rs=[m_db executeQuery:sql];
	while([rs next])
	{
		CSMSData *item = [self messageDataFromResultset:rs];
		[arrMessage addObject:item];
	}
	
	[rs close];
	[m_db close];
	return arrMessage;

}


//

@end
