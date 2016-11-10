//
//  ViewController.m
//  saveDataTest
//
//  Created by Lufangying on 16/10/20.
//  Copyright © 2016年 Lufangying. All rights reserved.
//

#import "ViewController.h"
#import "AddressCard.h"
#import "KCDbManager.h"
#import <CoreData/CoreData.h>
#import "Person+CoreDataClass.h"
#import "Person+CoreDataProperties.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    static NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if(!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    
    NSString *title = nil;
    if(row == 0)
    {
        title = @"归档";
    }
    else if(row == 1)
    {
        title = @"属性列表";
    }
    else if(row == 2)
    {
        title = @"保存文件";
    }
    else if(row == 3)
    {
        title = @"SQLite";
    }
    else if(row == 4)
    {
        title = @"coredata";
    }
    [[cell textLabel] setText:title];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    // NSKeyedArchiver
    if(row == 0)
    {
        [self archiverTest];
    }
    // 属性列表
    else if(row == 1)
    {
        [self userDefaultTest];
    }
    // 保存文件
    else if(row == 2)
    {
        [self fileTest];
    }
    // sqlite数据库
    else if(row == 3)
    {
        [self sqliteTest];
    }
    // coredata
    else if(row == 4)
    {
        [self coredataTest];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:NO];

}

-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    if(row == 0)
    {
        [self unarchiverTest];
    }
    // 属性列表
    else if(row == 1)
    {
        [self readPlistTest];
    }
    else if(row == 2)
    {
        [self readFileTest];
    }
    else if(row == 3)
    {
        [self readSqlTest];
    }
    else if(row == 4)
    {
        [self readCoreDataTest];
    }
}

- (NSString *)getDocumentPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths firstObject];
    return documentDirectory;
}

#pragma mark - 归档
- (void)archiverTest
{
    AddressCard *obj = [[AddressCard alloc] init];
    obj.name = @"test";
    obj.emailObj = [[Email alloc] init];
    obj.emailObj.email = @"1234789456@qq.com";
    obj.emailObj.emailDisplay = @"1234***456@qq.com";
    obj.salary = 1000;
    
    NSString *appSettingPath = [[self getDocumentPath] stringByAppendingPathComponent:@"test"];
    BOOL isSuccess = [NSKeyedArchiver archiveRootObject:obj toFile:appSettingPath];
    if(isSuccess)
    {
        NSLog(@"Sucess");
    }
    else
    {
        NSLog(@"False");
    }
}

- (void)unarchiverTest
{
    NSString *appSettingPath = [[self getDocumentPath] stringByAppendingPathComponent:@"test"];
    AddressCard *theCard = [NSKeyedUnarchiver unarchiveObjectWithFile:appSettingPath];
    NSLog(@"%@, %@, %@, %ld", theCard.name, theCard.emailObj.email,  theCard.emailObj.emailDisplay, (long)theCard.salary);
}

#pragma mark - 保存文件
- (void)fileTest
{
    NSString *filePath = [[self getDocumentPath] stringByAppendingString:@"fileTest.txt"];
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:@"798293@qq.com", @"email", @"787907@qq.com", @"emailDisplay", nil];
    [dictionary writeToFile:filePath atomically:YES];
}

- (void)readFileTest
{
    NSString *filePath = [[self getDocumentPath] stringByAppendingString:@"fileTest.txt"];
    if([[NSFileManager defaultManager] fileExistsAtPath:filePath])
    {
        NSDictionary *dictionary = [[NSDictionary alloc] initWithContentsOfFile:filePath];
        Email *email = [[Email alloc] init];
        [email setValuesForKeysWithDictionary:dictionary];
        NSLog(@"%@, %@", email.email, email.emailDisplay);
    }
}

#pragma mark - 属性列表
- (void)userDefaultTest
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"jack" forKey:@"firstName"];
    [defaults setInteger:10 forKey:@"Age"];
    [defaults synchronize];
}

- (void)readPlistTest
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *firstName = [defaults objectForKey:@"firstName"];
    NSInteger age = [defaults integerForKey:@"Age"];
    NSLog(@"%@, %ld", firstName, age);
    
    NSDictionary* defaults1 = [[NSUserDefaults standardUserDefaults] dictionaryRepresentation];
    NSLog(@"Defaults: %@", defaults1);
    
    NSArray *array = [[NSUserDefaults standardUserDefaults] objectForKey:@"ApplePasscodeKeyboards"];
    NSLog(@"Keyboards: %@", array);
    
    NSString*appDomain = [[NSBundle mainBundle] bundleIdentifier];
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
    
    NSDictionary* defaults2 = [[NSUserDefaults standardUserDefaults] dictionaryRepresentation];
    NSLog(@"Defaults: %@", defaults2);
}

#pragma mark - 数据库
- (void)sqliteTest
{
    [KCDatabaseCreator initDatabase];
    
    [self addUsers];
    [self removeUser];
    [self modifyUserInfo];
    
    [self addStatus];
}

-(void)addUsers{
    KCUser *user1=[KCUser userWithName:@"Binger" screenName:@"冰儿" profileImageUrl:@"binger.jpg" mbtype:@"mbtype.png" city:@"北京"];
    [[KCUserService sharedKCUserService] addUser:user1];
    KCUser *user2=[KCUser userWithName:@"Xiaona" screenName:@"小娜" profileImageUrl:@"xiaona.jpg" mbtype:@"mbtype.png" city:@"北京"];
    [[KCUserService sharedKCUserService] addUser:user2];
    KCUser *user3=[KCUser userWithName:@"Lily" screenName:@"丽丽" profileImageUrl:@"lily.jpg" mbtype:@"mbtype.png" city:@"北京"];
    [[KCUserService sharedKCUserService] addUser:user3];
    KCUser *user4=[KCUser userWithName:@"Qianmo" screenName:@"阡陌" profileImageUrl:@"qianmo.jpg" mbtype:@"mbtype.png" city:@"北京"];
    [[KCUserService sharedKCUserService] addUser:user4];
    KCUser *user5=[KCUser userWithName:@"Yanyue" screenName:@"炎月" profileImageUrl:@"yanyue.jpg" mbtype:@"mbtype.png" city:@"北京"];
    [[KCUserService sharedKCUserService] addUser:user5];
}

-(void)removeUser{
    //注意在SQLite中区分大小写
    [[KCUserService sharedKCUserService] removeUserByName:@"Yanyue"];
}

-(void)modifyUserInfo{
    KCUser *user1= [[KCUserService sharedKCUserService]getUserByName:@"Xiaona"];
    user1.city=@"上海";
    [[KCUserService sharedKCUserService] modifyUser:user1];
    
    KCUser *user2= [[KCUserService sharedKCUserService]getUserByName:@"Lily"];
    user2.city=@"深圳";
    [[KCUserService sharedKCUserService] modifyUser:user2];
}

-(void)addStatus{
    KCStatus *status1=[KCStatus statusWithCreateAt:@"9:00" source:@"iPhone 6" text:@"一只雪猴在日本边泡温泉边玩iPhone的照片，获得了\"2014年野生动物摄影师\"大赛特等奖。一起来为猴子配个词" userId:1];
    [[KCStatusService sharedKCStatusService] addStatus:status1];
    KCStatus *status2=[KCStatus statusWithCreateAt:@"9:00" source:@"iPhone 6" text:@"一只雪猴在日本边泡温泉边玩iPhone的照片，获得了\"2014年野生动物摄影师\"大赛特等奖。一起来为猴子配个词" userId:1];
    [[KCStatusService sharedKCStatusService] addStatus:status2];
    KCStatus *status3=[KCStatus statusWithCreateAt:@"9:30" source:@"iPhone 6" text:@"【我们送iPhone6了 要求很简单】真心回馈粉丝，小编觉得现在最好的奖品就是iPhone6了。今起到12月31日，关注我们，转发微博，就有机会获iPhone6(奖品可能需要等待)！每月抽一台[鼓掌]。不费事，还是试试吧，万一中了呢" userId:2];
    [[KCStatusService sharedKCStatusService] addStatus:status3];
    KCStatus *status4=[KCStatus statusWithCreateAt:@"9:45" source:@"iPhone 6" text:@"重大新闻：蒂姆库克宣布出柜后，ISIS战士怒扔iPhone，沙特神职人员呼吁人们换回iPhone 4。[via Pan-Arabia Enquirer]" userId:3];
    [[KCStatusService sharedKCStatusService] addStatus:status4];
    KCStatus *status5=[KCStatus statusWithCreateAt:@"10:05" source:@"iPhone 6" text:@"小伙伴们，有谁知道怎么往Iphone4S里倒东西？倒入的东西又该在哪里找？用了Iphone这么长时间，还真的不知道怎么弄！有谁知道啊？谢谢！" userId:4];
    [[KCStatusService sharedKCStatusService] addStatus:status5];
    KCStatus *status6=[KCStatus statusWithCreateAt:@"10:07" source:@"iPhone 6" text:@"在音悦台iPhone客户端里发现一个悦单《Infinite 金明洙》，推荐给大家! " userId:1];
    [[KCStatusService sharedKCStatusService] addStatus:status6];
    KCStatus *status7=[KCStatus statusWithCreateAt:@"11:20" source:@"iPhone 6" text:@"如果sony吧mp3播放器产品发展下去，不贪图手头节目源的现实利益，就木有苹果的ipod，也就木有iphone。柯达类似的现实利益，不自我革命的案例也是一种巨头的宿命。" userId:2];
    [[KCStatusService sharedKCStatusService] addStatus:status7];
    KCStatus *status8=[KCStatus statusWithCreateAt:@"13:00" source:@"iPhone 6" text:@"【iPhone 7 Plus】新买的iPhone 7 Plus ，如何？够酷炫么？" userId:2];
    [[KCStatusService sharedKCStatusService] addStatus:status8];
    KCStatus *status9=[KCStatus statusWithCreateAt:@"13:24" source:@"iPhone 6" text:@"自拍神器#卡西欧TR500#，tr350S～价格美丽，行货，全国联保～iPhone6 iPhone6Plus卡西欧TR150 TR200 TR350 TR350S全面到货 招收各种代理！[给力]微信：39017366" userId:3];
    [[KCStatusService sharedKCStatusService] addStatus:status9];
    KCStatus *status10=[KCStatus statusWithCreateAt:@"13:26" source:@"iPhone 6" text:@"猜到猴哥玩手机时所思所想者，再奖iPhone一部。（奖品由“2014年野生动物摄影师”评委会颁发）" userId:3];
    [[KCStatusService sharedKCStatusService] addStatus:status10];
}

-(void)readSqlTest{
    NSArray *status = [[KCStatusService sharedKCStatusService] getAllStatus];
    NSLog(@"%@",[status lastObject]);
}

#pragma mark - coredata
- (void)coredataTest
{
    // 从应用程序包中加载模型文件
    NSManagedObjectModel *model = [NSManagedObjectModel mergedModelFromBundles:nil];
    // 传入模型对象，初始化持久化存储协调器
    NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
    // 构建SQLite数据库文件的路径
    NSString *docs = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSURL *url = [NSURL fileURLWithPath:[docs stringByAppendingString:@"person"]];
    // 添加持久化存储器，用sqlite作为存储库
    NSError *error = nil;
    NSPersistentStore *store = [psc addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:url options:nil error:&error];
    if(store == nil)
    {
        [NSException raise:@"添加数据库错误" format:@"%@", [error localizedDescription]];
    }
    // 创建托管对象上下文
    NSManagedObjectContext *context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    context.persistentStoreCoordinator = psc;
    
    // 添加数据到数据库
    // 传入上下文，创建person实体
    Person *person = [NSEntityDescription insertNewObjectForEntityForName:@"Person" inManagedObjectContext:context];
    person.name = @"MJ55";
    //[person setValue:@"MJ55" forKey:@"name"];
    //[person setValue:[NSNumber numberWithInt:27] forKey:@"age"];
    // 创建Card实体
    NSManagedObject *card = [NSEntityDescription insertNewObjectForEntityForName:@"Card" inManagedObjectContext:context];
    [card setValue:@"4768558865" forKey:@"no"];
    [person setValue:card forKey:@"card"];
    // 利用上下文对象，将数据同步到持久化存储库
    NSError *errorSave = nil;
    BOOL sucess = [context save:&errorSave];
    if(sucess == NO)
    {
        [NSException raise:@"访问数据库错误" format:@"%@", [errorSave localizedDescription]];
    }
}

- (void)readCoreDataTest
{
    // 从应用程序包中加载模型文件
    NSManagedObjectModel *model = [NSManagedObjectModel mergedModelFromBundles:nil];
    // 传入模型对象，初始化持久化存储协调器
    NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
    // 构建SQLite数据库文件的路径
    NSString *docs = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSURL *url = [NSURL fileURLWithPath:[docs stringByAppendingString:@"person"]];
    // 添加持久化存储器，用sqlite作为存储库
    NSError *error = nil;
    NSPersistentStore *store = [psc addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:url options:nil error:&error];
    if(store == nil)
    {
        [NSException raise:@"添加数据库错误" format:@"%@", [error localizedDescription]];
    }
    // 创建托管对象上下文
    NSManagedObjectContext *context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    context.persistentStoreCoordinator = psc;
    
    // 从数据库查询数据
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    request.entity = [NSEntityDescription entityForName:@"Person" inManagedObjectContext:context];
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"age" ascending:NO];
    request.sortDescriptors = [NSArray arrayWithObject:sort];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name like %@", @"MJ55*"];
    request.predicate = predicate;
    // 执行请求
    NSError *errorFetch = nil;
    NSArray *objs = [context executeFetchRequest:request error:&errorFetch];
    if(errorFetch)
    {
        [NSException raise:@"查询错误" format:@"%@", [errorFetch localizedDescription]];
    }
    for(NSManagedObject *obj in objs)
    {
        NSLog(@"name=%@", [obj valueForKey:@"name"]);
    }
}
@end
