//
//  CCDBConfig.h
//
//
//  Created by  on 12-5-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "CDatabase.h"
#import "CResultSet.h"
#import "CDatabaseQueue.h"
#import "../NetWork/CUserInfo.h"
#define CYDSWError     -1
#define CYDSWNotExist  0
#define CYDSWExist     1

#define Table_mailAccount                    @"mailAccount"

#define Table_attachment                    @"attachment"        //附件表结构
#define Table_message                       @"Mail_message"      //邮件摘要表结构
#define Table_messageInfo                   @"Mail_messageInfo"  //邮件详情表结构
#define Table_folder                        @"mail_Floder"       //文件夹表结构。

@interface CCDBConfig : NSObject
{
}

@property (nonatomic, strong) NSString *dbPath;

//数据库静态接口
+(CCDBConfig*) shareInstace;

/**
 *  获取对应帐号的数据库
 *
 *  @param account 帐号信息 ： account为nil  则返回 帐号管理 否则返回对应数据库
 *
 *  @return 数据库
 */
- (CDatabase *)getDbWithAccount:(NSString*)account;


//数据库基本操作。
-(void)initDBPath:(NSString*)path;
-(BOOL) MakeAccountDBIsExistAndOpen:(CDatabase*)db;
-(BOOL)createTable:(NSString*)sql :(CDatabase*)db;
-(BOOL)deleteTableWithAccount:(NSString *)account;
-(BOOL) InsertIntoTableByName:(NSDictionary*)dic tableName:(NSString*)tableName :(CDatabase*)m_db;
-(BOOL)UpdateByTableName:(NSDictionary*)dic condition:(NSDictionary*)dicCondtion tableName:(NSString*)name :(CDatabase*)db;

-(void)insertMessage:(CSMSData*)message;
-(NSMutableArray*)qureyMailMessage;

@end
