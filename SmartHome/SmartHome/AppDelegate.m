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
        self.roomID+=1;
    }
    
    [deviceValues removeAllObjects];
    [deviceValues addObject:[NSNumber numberWithInteger:self.roomID]];
    [deviceValues addObject:@"厨房"];
    
    if(! [db insertWithTable:DEVICE_TABLE fields:deviceFields values:deviceValues])
    {
        NSLog(@"health table 存储记录失败");
    }else{
        self.roomID+=1;
    }
    
    [deviceValues removeAllObjects];
    [deviceValues addObject:[NSNumber numberWithInteger:self.roomID]];
    [deviceValues addObject:@"卧室"];
    
    if(! [db insertWithTable:DEVICE_TABLE fields:deviceFields values:deviceValues])
    {
        NSLog(@"health table 存储记录失败");
    }else{
        self.roomID+=1;
        NSLog(@"current roomID=%d",self.roomID);
    }
    
    return YES;
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

@end
