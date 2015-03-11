//
//  AppDelegate.h
//  SmartHome
//
//  Created by micheal on 15/1/27.
//  Copyright (c) 2015年 renren. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

//顺序码
@property (nonatomic) NSInteger orderCode;

//房间ID
@property (nonatomic,assign) NSInteger roomID;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (void)createAddButtonWithRoomID:(NSInteger)theRoomID;

@end

