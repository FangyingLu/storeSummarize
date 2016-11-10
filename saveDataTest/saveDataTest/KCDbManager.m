//
//  KCDbManager.m
//  Test
//
//  Created by Lufangying on 16/9/26.
//  Copyright © 2016年 Lufangying. All rights reserved.
//

#import "KCDbManager.h"
#define kDatabaseName @"myDatabase.db"

#pragma mark - KCDbManager
@implementation KCDbManager
define_singleton_implementation(KCDbManager);

- (instancetype)init
{
    if(self = [super init])
    {
        [self openDb:kDatabaseName];
    }
    return self;
}

- (void)openDb:(NSString *)dbname
{
    NSString *directory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *filePath = [directory stringByAppendingString:dbname];
    if(sqlite3_open(filePath.UTF8String, &_database) == SQLITE_OK)
    {
        NSLog(@"数据库打开成功");
    }
    else
    {
        NSLog(@"数据库打开失败");
    }
}

- (void)executeNonQuery:(NSString *)sql
{
    char *error;
    if(sqlite3_exec(_database, sql.UTF8String, NULL, NULL, &error) != SQLITE_OK)
    {
        NSLog(@"执行SQL语句过程中发生错误，错误信息:%s", error);
    }
}

- (NSArray *)executeQuery:(NSString *)sql
{
    NSMutableArray *rows = [[NSMutableArray alloc] init];
    sqlite3_stmt *stmt;
    if(sqlite3_prepare_v2(_database, sql.UTF8String, -1, &stmt, NULL) == SQLITE_OK)
    {
        while(sqlite3_step(stmt) == SQLITE_ROW)
        {
            int columnCount = sqlite3_column_count(stmt);
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            for(int i = 0; i < columnCount; i++)
            {
                const char *name = sqlite3_column_name(stmt, i);
                const unsigned char *value = sqlite3_column_text(stmt, i);
                [dic setValue:[NSString stringWithUTF8String:(const char *)value] forKey:[NSString stringWithUTF8String:name]];
            }
            [rows addObject:dic];
        }
        sqlite3_finalize(stmt);
    }
    
    return rows;
}
@end

#pragma mark - KCDatabaseCreator
@implementation KCDatabaseCreator
+(void)initDatabase{
    NSString *key=@"IsCreatedDb";
    NSUserDefaults *defaults=[[NSUserDefaults alloc]init];
    if ([[defaults valueForKey:key] intValue]!=1) {
        [self createUserTable];
        [self createStatusTable];
        [defaults setValue:@1 forKey:key];
    }
}
+(void)createUserTable{
    NSString *sql=@"CREATE TABLE User (Id integer PRIMARY KEY AUTOINCREMENT,name text,screenName text, profileImageUrl text,mbtype text,city text)";
    [[KCDbManager sharedKCDbManager] executeNonQuery:sql];
}
+(void)createStatusTable{
    NSString *sql=@"CREATE TABLE Status (Id integer PRIMARY KEY AUTOINCREMENT,source text,createdAt date,\"text\" text,user integer REFERENCES User (Id))";
    [[KCDbManager sharedKCDbManager] executeNonQuery:sql];
}

@end

#pragma mark - KCUser
@implementation KCUser
-(KCUser *)initWithName:(NSString *)name screenName:(NSString *)screenName profileImageUrl:(NSString *)profileImageUrl mbtype:(NSString *)mbtype city:(NSString *)city{
    if (self=[super init]) {
        self.name=name;
        self.screenName=screenName;
        self.profileImageUrl=profileImageUrl;
        self.mbtype=mbtype;
        self.city=city;
    }
    return self;
}
-(KCUser *)initWithDictionary:(NSDictionary *)dic{
    if (self=[super init]) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}
+(KCUser *)userWithName:(NSString *)name screenName:(NSString *)screenName profileImageUrl:(NSString *)profileImageUrl mbtype:(NSString *)mbtype city:(NSString *)city{
    KCUser *user=[[KCUser alloc]initWithName:name screenName:screenName profileImageUrl:profileImageUrl mbtype:mbtype city:city];
    return user;
}
@end

#pragma mark - KCStatus
@implementation KCStatus
-(KCStatus *)initWithDictionary:(NSDictionary *)dic{
    if (self=[super init]) {
        [self setValuesForKeysWithDictionary:dic];
        self.user=[[KCUser alloc]init];
        self.user.Id=dic[@"user"];
    }
    return self;
}
-(KCStatus *)initWithCreateAt:(NSString *)createAt source:(NSString *)source text:(NSString *)text user:(KCUser *)user{
    if (self=[super init]) {
        self.createdAt=createAt;
        self.source=source;
        self.text=text;
        self.user=user;
    }
    return self;
}
-(KCStatus *)initWithCreateAt:(NSString *)createAt source:(NSString *)source text:(NSString *)text userId:(int)userId{
    if (self=[super init]) {
        self.createdAt=createAt;
        self.source=source;
        self.text=text;
        KCUser *user=[[KCUser alloc]init];
        user.Id=[NSNumber numberWithInt:userId];
        self.user=user;
    }
    return self;
}
-(NSString *)source{
    return [NSString stringWithFormat:@"来自 %@",_source];
}
+(KCStatus *)statusWithCreateAt:(NSString *)createAt source:(NSString *)source text:(NSString *)text user:(KCUser *)user{
    KCStatus *status=[[KCStatus alloc]initWithCreateAt:createAt source:source text:text user:user];
    return status;
}
+(KCStatus *)statusWithCreateAt:(NSString *)createAt source:(NSString *)source text:(NSString *)text userId:(int)userId{
    KCStatus *status=[[KCStatus alloc]initWithCreateAt:createAt source:source text:text userId:userId];
    return status;
}
@end

#pragma mark - KCUserService
@implementation KCUserService
define_singleton_implementation(KCUserService)
-(void)addUser:(KCUser *)user{
    NSString *sql=[NSString stringWithFormat:@"INSERT INTO User (name,screenName, profileImageUrl,mbtype,city) VALUES('%@','%@','%@','%@','%@')",user.name,user.screenName, user.profileImageUrl,user.mbtype,user.city];
    [[KCDbManager sharedKCDbManager] executeNonQuery:sql];
}
-(void)removeUser:(KCUser *)user{
    NSString *sql=[NSString stringWithFormat:@"DELETE FROM User WHERE Id='%@'",user.Id];
    [[KCDbManager sharedKCDbManager] executeNonQuery:sql];
}
-(void)removeUserByName:(NSString *)name{
    NSString *sql=[NSString stringWithFormat:@"DELETE FROM User WHERE name='%@'",name];
    [[KCDbManager sharedKCDbManager] executeNonQuery:sql];
}
-(void)modifyUser:(KCUser *)user{
    NSString *sql=[NSString stringWithFormat:@"UPDATE User SET name='%@',screenName='%@',profileImageUrl='%@',mbtype='%@',city='%@' WHERE Id='%@'",user.name,user.screenName,user.profileImageUrl,user.mbtype,user.city,user.Id];
    [[KCDbManager sharedKCDbManager] executeNonQuery:sql];
}
-(KCUser *)getUserById:(int)Id{
    KCUser *user=[[KCUser alloc]init];
    NSString *sql=[NSString stringWithFormat:@"SELECT name,screenName,profileImageUrl,mbtype,city FROM User WHERE Id='%i'", Id];
    NSArray *rows= [[KCDbManager sharedKCDbManager] executeQuery:sql];
    if (rows&&rows.count>0) {
        [user setValuesForKeysWithDictionary:rows[0]];
    }
    return user;
}
-(KCUser *)getUserByName:(NSString *)name{
    KCUser *user=[[KCUser alloc]init];
    NSString *sql=[NSString stringWithFormat:@"SELECT Id, name,screenName,profileImageUrl,mbtype,city FROM User WHERE name='%@'", name];
    NSArray *rows= [[KCDbManager sharedKCDbManager] executeQuery:sql];
    if (rows&&rows.count>0) {
        [user setValuesForKeysWithDictionary:rows[0]];
    }
    return user;
}
@end


#pragma mark - KCStatusService
@implementation KCStatusService
define_singleton_implementation(KCStatusService);
-(void)addStatus:(KCStatus *)status{
    NSString *sql=[NSString stringWithFormat:@"INSERT INTO Status (source,createdAt,\"text\" ,user) VALUES('%@','%@','%@','%@')",status.source,status.createdAt,status.text,status.user.Id];
    [[KCDbManager sharedKCDbManager] executeNonQuery:sql];
}
-(void)removeStatus:(KCStatus *)status{
    NSString *sql=[NSString stringWithFormat:@"DELETE FROM Status WHERE Id='%@'",status.Id];
    [[KCDbManager sharedKCDbManager] executeNonQuery:sql];
}
-(void)modifyStatus:(KCStatus *)status{
    NSString *sql=[NSString stringWithFormat:@"UPDATE Status SET source='%@',createdAt='%@',\"text\"='%@' ,user='%@' WHERE Id='%@'",status.source,status.createdAt,status.text,status.user, status.Id];
    [[KCDbManager sharedKCDbManager] executeNonQuery:sql];
}
-(KCStatus *)getStatusById:(int)Id{
    KCStatus *status=[[KCStatus alloc]init];
    NSString *sql=[NSString stringWithFormat:@"SELECT Id, source,createdAt,\"text\" ,user FROM Status WHERE Id='%i'", Id];
    NSArray *rows= [[KCDbManager sharedKCDbManager] executeQuery:sql];
    if (rows&&rows.count>0) {
        [status setValuesForKeysWithDictionary:rows[0]];
        status.user=[[KCUserService sharedKCUserService] getUserById:[(NSNumber *)rows[0][@"user"] intValue]] ;
    }
    return status;
}

-(NSArray *)getAllStatus{
    NSMutableArray *array=[NSMutableArray array];
    NSString *sql=@"SELECT Id, source,createdAt,\"text\" ,user FROM Status ORDER BY Id";
    NSArray *rows= [[KCDbManager sharedKCDbManager] executeQuery:sql];
    for (NSDictionary *dic in rows) {
        KCStatus *status=[self getStatusById:[(NSNumber *)dic[@"Id"] intValue]];
        [array addObject:status];
    }
    return array;
}
@end
