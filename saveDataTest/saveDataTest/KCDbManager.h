//
//  KCDbManager.h
//  Test
//
//  Created by Lufangying on 16/9/26.
//  Copyright © 2016年 Lufangying. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

#define define_singleton_header(className) + (instancetype)shared##className;
#define define_singleton_implementation(className) \
\
static className *shared##className = nil; \
+ (className *)shared##className { \
    static dispatch_once_t pred; \
    dispatch_once(&pred, ^{ \
        shared##className = [[super allocWithZone:nil] init]; \
    }); \
    return shared##className; \
} \
\
+ (id)allocWithZone:(NSZone *)zone { \
    return [self shared##className];\
} \
\
- (id)copyWithZone:(NSZone *)zone { \
    return self; \
} 

#pragma mark - KCDbManager
@interface KCDbManager : NSObject
@property (nonatomic) sqlite3 *database;

define_singleton_header(KCDbManager)
- (void)openDb:(NSString *)dbname;
- (void)executeNonQuery:(NSString *)sql;
- (NSArray *)executeQuery:(NSString *)sql;

@end

#pragma mark - KCDatabaseCreator
@interface KCDatabaseCreator : NSObject
+(void)initDatabase;
+(void)createUserTable;
+(void)createStatusTable;
@end

#pragma mark - KCUser
@interface KCUser : NSObject
#pragma mark 编号
@property (nonatomic,strong) NSNumber *Id;
#pragma mark 用户名
@property (nonatomic,copy) NSString *name;
#pragma mark 用户昵称
@property (nonatomic,copy) NSString *screenName;
#pragma mark 头像
@property (nonatomic,copy) NSString *profileImageUrl;
#pragma mark 会员类型
@property (nonatomic,copy) NSString *mbtype;
#pragma mark 城市
@property (nonatomic,copy) NSString *city;
#pragma mark - 动态方法
/**
 *  初始化用户
 *
 *  @param name 用户名
 *  @param city 所在城市
 *
 *  @return 用户对象
 */
-(KCUser *)initWithName:(NSString *)name screenName:(NSString *)screenName profileImageUrl:(NSString *)profileImageUrl mbtype:(NSString *)mbtype city:(NSString *)city;
/**
 *  使用字典初始化用户对象
 *
 *  @param dic 用户数据
 *
 *  @return 用户对象
 */
-(KCUser *)initWithDictionary:(NSDictionary *)dic;
#pragma mark - 静态方法
+(KCUser *)userWithName:(NSString *)name screenName:(NSString *)screenName profileImageUrl:(NSString *)profileImageUrl mbtype:(NSString *)mbtype city:(NSString *)city;
@end

#pragma mark - KCStatus
@interface KCStatus : NSObject
#pragma mark - 属性
@property (nonatomic,strong) NSNumber *Id;//微博id
@property (nonatomic,strong) KCUser *user;//发送用户
@property (nonatomic,copy) NSString *createdAt;//创建时间
@property (nonatomic,copy) NSString *source;//设备来源
@property (nonatomic,copy) NSString *text;//微博内容
#pragma mark - 动态方法
/**
 *  初始化微博数据
 *
 *  @param createAt        创建日期
 *  @param source          来源
 *  @param text            微博内容
 *  @param user            发送用户
 *
 *  @return 微博对象
 */
-(KCStatus *)initWithCreateAt:(NSString *)createAt source:(NSString *)source text:(NSString *)text user:(KCUser *)user;
/**
 *  初始化微博数据
 *
 *  @param profileImageUrl 用户头像
 *  @param mbtype          会员类型
 *  @param createAt        创建日期
 *  @param source          来源
 *  @param text            微博内容
 *  @param userId          用户编号
 *
 *  @return 微博对象
 */
-(KCStatus *)initWithCreateAt:(NSString *)createAt source:(NSString *)source text:(NSString *)text userId:(int)userId;
/**
 *  使用字典初始化微博对象
 *
 *  @param dic 字典数据
 *
 *  @return 微博对象
 */
-(KCStatus *)initWithDictionary:(NSDictionary *)dic;
#pragma mark - 静态方法
/**
 *  初始化微博数据
 *
 *  @param createAt        创建日期
 *  @param source          来源
 *  @param text            微博内容
 *  @param user            发送用户
 *
 *  @return 微博对象
 */
+(KCStatus *)statusWithCreateAt:(NSString *)createAt source:(NSString *)source text:(NSString *)text user:(KCUser *)user;
/**
 *  初始化微博数据
 *
 *  @param profileImageUrl 用户头像
 *  @param mbtype          会员类型
 *  @param createAt        创建日期
 *  @param source          来源
 *  @param text            微博内容
 *  @param userId          用户编号
 *
 *  @return 微博对象
 */
+(KCStatus *)statusWithCreateAt:(NSString *)createAt source:(NSString *)source text:(NSString *)text userId:(int)userId;
@end

#pragma mark - KCUserService
@interface KCUserService : NSObject
define_singleton_header(KCUserService)
/**
 *  添加用户信息
 *
 *  @param user 用户对象
 */
-(void)addUser:(KCUser *)user;
/**
 *  删除用户
 *
 *  @param user 用户对象
 */
-(void)removeUser:(KCUser *)user;
/**
 *  根据用户名删除用户
 *
 *  @param name 用户名
 */
-(void)removeUserByName:(NSString *)name;
/**
 *  修改用户内容
 *
 *  @param user 用户对象
 */
-(void)modifyUser:(KCUser *)user;
/**
 *  根据用户编号取得用户
 *
 *  @param Id 用户编号
 *
 *  @return 用户对象
 */
-(KCUser *)getUserById:(int)Id;
/**
 *  根据用户名取得用户
 *
 *  @param name 用户名
 *
 *  @return 用户对象
 */
-(KCUser *)getUserByName:(NSString *)name;
@end

#pragma mark - KCStatusService
@interface KCStatusService : NSObject
define_singleton_header(KCStatusService)
/**
 *  添加微博信息
 *
 *  @param status 微博对象
 */
-(void)addStatus:(KCStatus *)status;
/**
 *  删除微博
 *
 *  @param status 微博对象
 */
-(void)removeStatus:(KCStatus *)status;
/**
 *  修改微博内容
 *
 *  @param status 微博对象
 */
-(void)modifyStatus:(KCStatus *)status;
/**
 *  根据编号取得微博
 *
 *  @param Id 微博编号
 *
 *  @return 微博对象
 */
-(KCStatus *)getStatusById:(int)Id;
/**
 *  取得所有微博对象
 *
 *  @return 所有微博对象
 */
-(NSArray *)getAllStatus;
@end
