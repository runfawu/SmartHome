//
//  AppDelegate.m
//  SmartHome
//
//  Created by micheal on 15/1/27.
//  Copyright (c) 2015年 renren. All rights reserved.
//

#import "AppDelegate.h"
#import "DeviceDB.h"
#import "Comon.h"
#import "Common.h"
#import "SwitchEntity.h"

@interface AppDelegate ()

@end
@implementation AppDelegate

@synthesize orderCode;
@synthesize roomID;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //顺序码
    self.orderCode=0;
    //RoomId
    self.roomID=100;
    
    
    //数据库创建表
    DeviceDB *db=[DeviceDB sharedInstance];
    [db connect];
    BOOL isHaveTable=YES;
    if (![db isTableExist:DEVICE_TABLE]) {
        isHaveTable=NO;
        if ([db createTable:DEVICE_TABLE values:DEVICE_TABLE_FIELD]) {
            isHaveTable=YES;
        }
    }
    
    // ! 确保只初始化一次默认数据
    NSArray *roomArray=[db getDevicesRegister];
    if ( ! roomArray.count > 0) {
        NSMutableArray *deviceFields = [[NSMutableArray alloc]init];
        NSMutableArray *deviceValues = [[NSMutableArray alloc]init];
        
        [deviceFields addObject:@"roomId"];
        [deviceFields addObject:@"roomName"];
        
        [deviceValues addObject:[NSNumber numberWithInteger:self.roomID]];
        [deviceValues addObject:@"客厅"];
        if(! [db insertWithTable:DEVICE_TABLE fields:deviceFields values:deviceValues])
        {
            NSLog(@"health table 存储记录失败");
        }else{
            [self createAddButtonWithRoomID:self.roomID];
            self.roomID+=1;
        }
        
        [deviceValues removeAllObjects];
        [deviceValues addObject:[NSNumber numberWithInteger:self.roomID]];
        [deviceValues addObject:@"厨房"];
        
        if(! [db insertWithTable:DEVICE_TABLE fields:deviceFields values:deviceValues])
        {
            NSLog(@"health table 存储记录失败");
        }else{
            [self createAddButtonWithRoomID:self.roomID];
            self.roomID+=1;
        }
        
        [deviceValues removeAllObjects];
        [deviceValues addObject:[NSNumber numberWithInteger:self.roomID]];
        [deviceValues addObject:@"卧室"];
        
        if(! [db insertWithTable:DEVICE_TABLE fields:deviceFields values:deviceValues])
        {
            NSLog(@"health table 存储记录失败");
        }else{
            [self createAddButtonWithRoomID:self.roomID];
            self.roomID+=1;
            NSLog(@"current roomID=%d",self.roomID);
        }
    }
    
    return YES;
}

// 默认先添加每个房间的“添加设备”按钮
- (void)createAddButtonWithRoomID:(NSInteger)theRoomID
{
    SwitchEntity *switchOne = [NSEntityDescription insertNewObjectForEntityForName:@"SwitchEntity" inManagedObjectContext:self.managedObjectContext];
    switchOne.name = @"添加设备";
    switchOne.isOn = @NO;
    switchOne.roomID = @(theRoomID);
    switchOne.type = SWITCH_TYPE_ADD;
    switchOne.imageName = kAddImageName;
    switchOne.code = @"";
    switchOne.roomImageData = UIImagePNGRepresentation([UIImage imageNamed:@"Account_Cloud"]);
    
    [self saveContext];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"SwitchModel" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"SwitchModel.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}


@end
