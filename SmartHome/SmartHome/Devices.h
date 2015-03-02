//
//  Devices.h
//  SmartHome
//
//  Created by micheal on 15/2/4.
//  Copyright (c) 2015年 renren. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Devices : NSObject

@property (nonatomic,assign) int inscreaseId;
@property(nonatomic,assign) int socketId; //插座id→对应Socket表的id（唯一）
@property (nonatomic,assign) int lightId;  //灯id→对应Light表的id（唯一）
@property (nonatomic,assign) int roomId; //房间id（不为null）
@property (nonatomic,assign) int state; //灯状态→设备状态：0关，1开
@property (nonatomic,strong) NSString *deviceName; //设备名称（唯一且不为null）
@property (nonatomic,strong) NSString *roomName; //房间名称（不为null）

@end
