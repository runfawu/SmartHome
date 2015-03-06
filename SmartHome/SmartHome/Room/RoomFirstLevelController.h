//
//  RoomFirstLevelController.h
//  SmartHome
//
//  Created by Oliver on 15/3/2.
//  Copyright (c) 2015年 renren. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RoomFirstLevelController;
@protocol RoomFirstLevelDelegate <NSObject>

- (void)roomFirstLevelControllerAddSwitch:(RoomFirstLevelController *)aController;

@end

@interface RoomFirstLevelController : UIViewController

@property (nonatomic, weak) id<RoomFirstLevelDelegate> delegate;

@end
