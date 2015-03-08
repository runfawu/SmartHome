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

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.orderCode=0;
    
    DeviceDB *db=[DeviceDB sharedInstance];
    [db connect];
    BOOL isHaveTable=YES;
    if (![db isTableExist:DEVICE_TABLE]) {
        isHaveTable=NO;
        if ([db createTable:DEVICE_TABLE values:DEVICE_TABLE_FIELD]) {
            isHaveTable=YES;
        }
    }
    
    NSMutableArray* fields = [[NSMutableArray alloc]init];
    NSMutableArray* values = [[NSMutableArray alloc]init];

    [fields addObject:@"socketId"];
    [fields addObject:@"lightId"];
    [fields addObject:@"deviceName"];
    [fields addObject:@"roomId"];
    [fields addObject:@"roomName"];
    [fields addObject:@"state"];
    
    [values addObject:[NSNumber numberWithInt:001]];
    [values addObject:[NSNumber numberWithInt:001]];
    [values addObject:@"灯光01"];
    [values addObject:[NSNumber numberWithInt:123]];
    [values addObject:@"客厅"];
    [values addObject:[NSNumber numberWithInt:1]];
    
    if(! [db insertWithTable:DEVICE_TABLE fields:fields values:values])
    {
        NSLog(@"health table 存储记录失败");
    }
    
    Devices *deviece=[[Devices alloc] init];
    deviece.socketId=0;
    deviece.lightId=5;
    deviece.deviceName=@"jdj";
    deviece.roomId=6;
    deviece.roomName=@"goood";
    deviece.state=3;
    
    if(![db insertDevicesRegisterTableWithDevices:deviece]){
        NSLog(@"lsjlkfkjlskldfkklsd");
    }
    
    NSArray *devices=[db getDevicesRegister];
    
    [db deleteWithTable:@"DevicesRegister" field:@"roomId" value:@"123"];

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
