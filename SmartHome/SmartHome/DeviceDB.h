//
//  DeviceDB.h
//  SmartHome
//
//  Created by micheal on 15/2/5.
//  Copyright (c) 2015年 renren. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMResultSet.h"
#import "Devices.h"
#import "Light.h"
#import "Socket.h"

@class FMDatabaseQueue;

@interface DeviceDB : NSObject

@property (nonatomic) dispatch_queue_t dbQuene;
@property (nonatomic,strong) FMDatabaseQueue *fmdbQueen;

+(DeviceDB *)sharedInstance;

/*
 *连接数据库
 */
-(BOOL)connect;

/*
 *关闭数据库
 */
-(BOOL)close;

/*
 *@brief 判断表是否存在
 *
 *@param tableName 表名
 *@return YES 存在,NO 不存在
 */
-(BOOL)isTableExist:(NSString *)tableName;


/**
 * @brief 重命名表
 *
 * @param oldName 原表名
 * @param newName 新表名
 * @return 成功／失败
 */
-(BOOL)renameTable:(NSString*)oldName newName:(NSString*)newName;

//增
/**
 * @brief 创建表
 *
 * @param table 表名
 * @param values 列名及类型 比如：a text, b integer, c double, d date
 * @return 成功／失败
 */
-(BOOL)createTable:(NSString*)tableName values:(NSDictionary*)values;

-(BOOL)createTableWithSQL:(NSString *)sql;

//删
/**
 * @brief 删除表
 *
 * @param table 表名
 * @return 成功／失败
 */
-(BOOL)dropTable:(NSString*)tableName;

/**
 * @brief 插入数据到表单 （field1 ＝ value1, field2 ＝ value2, ...）
 *
 * @param table 表名
 * @param values 列名及列对应的值   field1 value1, field2 value2, ...
 * @return 成功／失败
 */
-(BOOL)insertWithTable:(NSString*)table values:(NSDictionary*)values;

-(BOOL)insertWithTable:(NSString*)tableName fields:(NSArray*)fields values:(NSArray*)values;

/**
 * @brief 插入数据到表单
 *
 * @param table 表名
 * @param values 列名及列对应的值   field1 value1, field2 value2, ...
 * @return 成功／失败
 */
-(BOOL)insertDevicesRegisterTableWithDevices:(Devices *)device;

//查
/**
 * @brief 查找表单数据 （field1 ＝ value1 And field2 ＝ value2 And ...）
 *
 * @param table 表名
 * @param values 列名及列对应的值   field1 value1, field2 value2, ...
 * @param sortField 排序的列名, 如果不需要排序, 填nil即可
 * @param inorder Yes代表升序, No代表降序
 * @return FMResultSet  记得close哦
 */
-(FMResultSet*)queryWithTable:(NSString*)table values:(NSDictionary*)values sortField:(NSString *)sortField inorder:(BOOL)inoder;


/**
 * @brief 查找表单数据 （field ＝ value）
 *
 * @param table 表名
 * @param field 列名
 * @param value 列对应的值
 * @param sortField 排序的列名, 如果不需要排序, 填nil即可
 * @param inorder Yes代表升序, No代表降序
 * @return FMResultSet  记得close哦
 */
-(FMResultSet*)queryWithTable:(NSString*)table field:(NSString*)field value:(NSString*)value sortField:(NSString *)sortField inorder:(BOOL)inoder;
/**
 * @brief 查找表单数据 （field1 ＝ value1 And field2 ＝ value2 And ...）
 *
 * @param table 表名
 * @param fields 列名数组
 * @param values 列对应的值数组
 * @param sortField 排序的列名, 如果不需要排序, 填nil即可
 * @param inorder Yes代表升序, No代表降序
 * @return FMResultSet  记得close哦
 */
-(FMResultSet*)queryWithTable:(NSString*)table fields:(NSArray*)fields values:(NSArray*)values sortField:(NSString *)sortField inorder:(BOOL)inoder;

/**
 * @brief 查找表单数据 （
 *
 * @param sql 查询用sql语句
 * @return FMResultSet  记得close哦
 */
-(FMResultSet* )queryWithSql:(NSString*)sql;

/**
 * @brief 删除表单数据 （field1 ＝ value1 And field2 ＝ value2 And ...）
 *
 * @param table 表名
 * @param values 列名及列对应的值   field1 value1, field2 value2, ...
 * @return 成功／失败
 */
-(BOOL)deleteWithTable:(NSString*)table values:(NSDictionary*)values;

-(BOOL)deleteWithTable:(NSString *)table field:(NSString*)field value:(NSString *)value;

/**
 * @brief 查询表行数
 *
 * @param table 表名
 **/
-(int)queryWithTable:(NSString *)table;

//获取房间数量
-(NSArray *)getDevicesRegister;



@end
