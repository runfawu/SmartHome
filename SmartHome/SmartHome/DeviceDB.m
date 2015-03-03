//
//  DeviceDB.m
//  SmartHome
//
//  Created by micheal on 15/2/5.
//  Copyright (c) 2015年 renren. All rights reserved.
//

#import "DeviceDB.h"
#import "FMDatabase.h"
#import "FMDatabaseQueue.h"
#import "FMDatabaseAdditions.h"

#define DB_name @"qinqi_smart_db.db"

@interface DeviceDB ()

@property (nonatomic,strong) NSString *dbPath;
@property (nonatomic,strong) FMDatabase *db;

@end

@implementation DeviceDB

@synthesize db;

+(DeviceDB *)sharedInstance{
    static DeviceDB *instance=nil;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        instance=[[self alloc] init];
    });
    return instance;
}


#pragma mark -
#pragma mark life cycle

-(id)init{
    self=[super init];
    if (self) {
        NSString *fileName=DB_name;
        NSArray *pathArray=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *path=[pathArray objectAtIndex:0];
        self.dbPath=[path stringByAppendingPathComponent:fileName];
        NSLog(@"data path :%@",self.dbPath);
        
        self.db=nil;
        self.fmdbQueen=nil;
        
        self.dbQuene=dispatch_queue_create("com.db.queue", DISPATCH_QUEUE_SERIAL);
    }
    return self;
}

#pragma mark -
#pragma mark connect or close database
-(BOOL)connect{
    @synchronized(self){
        if (!self.db) {
            self.db=[[FMDatabase alloc] initWithPath:self.dbPath];
        }
        if (!self.fmdbQueen) {
            self.fmdbQueen=[FMDatabaseQueue databaseQueueWithPath:self.dbPath];
        }
        if (![db open]) {
            return NO;
        }else{
            return YES;
        }
    }
}

-(BOOL)close{
    @synchronized(self){
        if (self.db!=nil) {
            return [self.db close];
        }
    }
    return NO;
}

-(BOOL)isTableExist:(NSString *)tableName{
    BOOL isExist=NO;
    @synchronized(self){
        if ((!self.db)||(!tableName)|| (tableName.length == 0)) {
            isExist=NO;
        }else
            isExist=[self.db tableExists:tableName];
    }
    return isExist;
}

-(BOOL)renameTable:(NSString *)oldName newName:(NSString *)newName{
    if (!oldName||oldName.length==0) {
        return NO;
    }
    if (!newName||newName.length==0) {
        return NO;
    }
    @synchronized(self){
        if ([self isTableExist:newName])
            [self dropTable:newName];
        
        NSString *sql=[NSString stringWithFormat:@"ALERT TABLE %@ RENAME TO %@",oldName,newName];
            
        if (self.db&&[self.db goodConnection]) {
            return [self.db executeUpdate:sql];
        }else
            return NO;
    }
}

-(BOOL)createTable:(NSString *)tableName values:(NSDictionary *)values{
    if(! tableName || tableName.length == 0)
        return NO;
    if(! values)
        return NO;
    
    NSString* SQL = @"";
    
    NSArray* keys = values.allKeys;
    for (int i = 0; i < keys.count - 1; i++)
    {
        id key = [keys objectAtIndex:i];
        id value = [values objectForKey:key];
        if (value)
        {
            NSString* temp = [NSString stringWithFormat:@"%@ %@, ", key, value];
            SQL = [NSString stringWithFormat:@"%@%@", SQL, temp];
        }
    }
    
    id lastkey = [keys objectAtIndex:keys.count - 1];
    id lastvalue = [values objectForKey:lastkey];
    if (lastvalue)
    {
        SQL = [NSString stringWithFormat:@"%@%@ %@", SQL, lastkey, lastvalue];
    }
    
    SQL = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(_id INTEGER PRIMARY KEY AUTOINCREMENT  NOT NULL, %@)", tableName, SQL];
    
    BOOL a = [self.db executeUpdate:SQL];
    return a;
}

-(BOOL)createTableWithSQL:(NSString *)sql{
    return [self.db executeUpdate:sql];
}

-(BOOL)dropTable:(NSString *)tableName{
    if(!tableName || tableName.length == 0)
        return NO;
    
    @synchronized(self)
    {
        if(self.db && [self.db goodConnection])
        {
            NSString* sql = [NSString stringWithFormat:@"DROP TABLE IF EXISTS %@",tableName];
            return  [self.db executeUpdate:sql];
        }else
            return NO;
    }
}

#pragma mark -
#pragma mark insert database
-(BOOL)insertWithTable:(NSString*)table values:(NSDictionary*)values
{
    NSParameterAssert(table && table.length > 0);
    NSParameterAssert(values);
    
    if(! table || table.length == 0)
        return NO;
    
    if(!values)
        return NO;
    
    @synchronized(self)
    {
        
        NSString* fieldStr = @"";
        NSString* valueStr = @"";
        
        NSMutableArray* argumentsInArray = [NSMutableArray array];
        
        NSArray* keys = values.allKeys;
        for (int i = 0;i<keys.count-1;i++)
        {
            id key = [keys objectAtIndex:i];
            id value = [values objectForKey:key];
            
            NSString* tempKey = [NSString stringWithFormat:@"%@,",key];
            fieldStr = [NSString stringWithFormat:@"%@%@",fieldStr,tempKey];
            
            NSString* tempValue = @"?,";
            valueStr = [NSString stringWithFormat:@"%@%@",valueStr,tempValue];
            
            [argumentsInArray addObject:value];
        }
        
        id lastKey = [keys objectAtIndex:keys.count-1];
        id lastValue = [values objectForKey:lastKey];
        
        fieldStr = [NSString stringWithFormat:@"%@%@",fieldStr,lastKey];
        valueStr = [NSString stringWithFormat:@"%@?",valueStr];
        
        [argumentsInArray addObject:lastValue];
        
        NSString* insertSQL = [NSString stringWithFormat:@"INSERT INTO %@(%@) values(%@)",table,fieldStr,valueStr];
        
        return [self.db executeUpdate:insertSQL withArgumentsInArray:argumentsInArray];
    }
    return NO;
}

-(BOOL)insertWithTable:(NSString*)tableName fields:(NSArray*)fields values:(NSArray*)values
{
    if(nil == self.db || !fields || fields.count == 0 || !values || values.count == 0 || fields.count != values.count)
    {
        return NO;
    }
    
    if(!tableName || tableName.length == 0)
        return NO;
    
    @synchronized(self)
    {
        NSString* SQL = [NSString stringWithFormat:@"INSERT INTO %@(", tableName];
        
        NSString* fieldStr = @"";
        NSString* valueStr = @"";
        
        NSUInteger len = [fields count];
        for (int n = 0; n < len - 1; n++)
        {
            NSString* temp1 = [NSString stringWithFormat:@"%@,", (NSString*)[fields objectAtIndex:n]];
            fieldStr = [NSString stringWithFormat:@"%@%@", fieldStr, temp1];
            
            NSString* temp2 = @"?,";
            valueStr = [NSString stringWithFormat:@"%@%@", valueStr, temp2];
        }
        
        fieldStr = [NSString stringWithFormat:@"%@%@", fieldStr, [fields objectAtIndex:(len-1)]];
        valueStr = [NSString stringWithFormat:@"%@?", valueStr];
        
        SQL = [NSString stringWithFormat:@"%@%@) values(%@)", SQL, fieldStr, valueStr];
        
        return [self.db executeUpdate:SQL withArgumentsInArray:values];
    }
}

#pragma mark -
#pragma mark Query Methods
-(FMResultSet*)queryWithTable:(NSString*)table values:(NSDictionary*)values sortField:(NSString *)sortField inorder:(BOOL)inoder
{
    NSParameterAssert(table && table.length > 0);
    if(! table || table.length == 0)
        return nil;
    
    @synchronized(self)
    {
        NSString* querySql = @"";
        
        if(values && (values.count > 0))
        {
            NSString* tempSql = @"";
            
            NSArray* keys = values.allKeys;
            for(int i = 0; i<keys.count;i++)
            {
                id key = [keys objectAtIndex:i];
                id value = [values objectForKey:key];
                
                if(0 == i)
                {
                    tempSql = [NSString stringWithFormat:@"%@ = '%@'",key,value];
                }
                else
                {
                    tempSql = [NSString stringWithFormat:@"%@ AND %@ = '%@'",tempSql,key,value];
                }
            }
            querySql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@",table,tempSql];
        }
        else
        {
            querySql = [NSString stringWithFormat:@"SELECT * FROM %@",table];
        }
        
        if(sortField && sortField.length > 0)
        {
            querySql = [querySql stringByAppendingString:[NSString stringWithFormat:@" ORDER BY %@",sortField]];
            
            if(! inoder)
            {
                querySql = [querySql stringByAppendingString:@" DESC"];
                
            }
        }
        
        FMResultSet* rs = [self.db executeQuery:querySql];
        
        if(rs == nil)
        {
            
        }
        return rs;
    }
}


-(FMResultSet*)queryWithTable:(NSString*)table field:(NSString*)field value:(NSString*)value sortField:(NSString *)sortField inorder:(BOOL)inoder
{
    if(nil == self.db)
    {
        return nil;
    }
    
    @synchronized(self)
    {
        [self.db setShouldCacheStatements:YES];
        
        NSString *SQL = nil;
        
        if (field && value)
        {
            SQL= [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ ='%@'", table, field, value];
        }
        else
        {
            SQL= [NSString stringWithFormat:@"SELECT * FROM %@", table];
        }
        
        if (sortField && sortField.length > 0)
        {
            SQL = [SQL stringByAppendingString:[NSString stringWithFormat:@" ORDER BY %@", sortField]];
            
            if (!inoder)
            {
                SQL = [SQL stringByAppendingString:@" DESC"];
            }
        }
        
        FMResultSet* rs = [self.db executeQuery:SQL];
        return rs;
    }
}


-(FMResultSet*)queryWithTable:(NSString*)table fields:(NSArray*)fields values:(NSArray*)values sortField:(NSString *)sortField inorder:(BOOL)inoder
{
    if(nil == self.db)
    {
        return nil;
    }
    
    @synchronized(self)
    {
        [self.db setShouldCacheStatements:YES];
        
        NSString *SQL = nil;
        
        if (fields && fields.count > 0 && values && values.count > 0 && fields.count == values.count)
        {
            SQL= [NSString stringWithFormat:@"SELECT * FROM %@ WHERE ", table];
            
            NSString* condStr = @"";
            
            for (int i = 0; i < [fields count]; i++)
            {
                if (i == 0)
                {
                    condStr = [NSString stringWithFormat:@"%@ = '%@'", (NSString *)[fields objectAtIndex:i], (NSString *)[values objectAtIndex:i]];
                }
                else
                {
                    condStr = [NSString stringWithFormat:@"%@ and %@ = '%@'", condStr, (NSString *)[fields objectAtIndex:i], (NSString *)[values objectAtIndex:i]];
                }
            }
            
            SQL = [NSString stringWithFormat:@"%@%@", SQL, condStr];
        }
        else
        {
            SQL= [NSString stringWithFormat:@"SELECT * FROM %@", table];
        }
        
        if (sortField && sortField.length > 0)
        {
            SQL = [SQL stringByAppendingString:[NSString stringWithFormat:@" ORDER BY %@", sortField]];
            
            if (!inoder)
            {
                SQL = [SQL stringByAppendingString:@" DESC"];
            }
        }
        
        FMResultSet* rs = [self.db executeQuery:SQL];
        return rs;
    }
}

-(FMResultSet* )queryWithSql:(NSString*)sql
{
    if(!sql || sql.length==0)
        return nil;
    
    if(self.db==nil)
        return nil;
    
    FMResultSet* rs = [self.db executeQuery:sql];
    return  rs;
}


#pragma mark -
#pragma mark delete database
-(BOOL)deleteWithTable:(NSString*)table values:(NSDictionary*)values
{
    NSParameterAssert(table && table.length >0);
    NSParameterAssert(values);
    
    if(! table || table.length == 0)
        return NO;
    if(! values)
        return NO;
    
    @synchronized(self)
    {
        if( (!self.db) || (![self.db goodConnection]) )
            return NO;
        
        NSString* delSql = nil;
        if(values.count >0)
        {
            NSString* tempSql = @"";
            NSArray* keys = values.allKeys;
            
            for (int i = 0;i<keys.count;i++)
            {
                id key = [keys objectAtIndex:i];
                id value = [values objectForKey:key];
                
                if(0 == i)
                {
                    tempSql =[NSString stringWithFormat:@"%@ = '%@'",key,value];
                }
                else
                {
                    tempSql = [NSString stringWithFormat:@"%@ AND %@ = '%@'",tempSql,key,value];
                }
                
                delSql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE %@",table,tempSql];
                
            }
            
        }
        else
        {
            delSql = [NSString stringWithFormat:@"DELETE FROM %@",table];
        }
        
        return [self.db executeUpdate:delSql];
        
    }
    return NO;
}


-(BOOL)deleteWithTable:(NSString *)table field:(NSString*)field value:(NSString *)value
{
    NSParameterAssert(table && table.length > 0);
    if(!table || table.length == 0)
        return NO;
    
    @synchronized(self)
    {
        NSString* query = nil;
        if(field && value)
        {
            query = [NSString stringWithFormat:@"DELETE FROM %@ WHERE %@ ='%@'", table, field, value];
        }
        else
        {
            query = [NSString stringWithFormat:@"DELETE FROM %@", table];
        }
        
        return [self.db executeUpdate:query];
        
    }
}

-(int)queryWithTable:(NSString *)table{
    NSParameterAssert(table && table.length > 0);
    if(!table || table.length == 0)
        return NO;
    
    @synchronized(self)
    {
        NSString* query = [NSString stringWithFormat:@"select count(distinct roomId) from %@",table];
        
        return [self.db intForQuery:query];
        
    }
}


@end
