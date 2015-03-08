//
//  Devices.m
//  SmartHome
//
//  Created by micheal on 15/2/4.
//  Copyright (c) 2015年 renren. All rights reserved.
//

#import "Devices.h"

@implementation Devices

@synthesize devicesId;
@synthesize socketId;
@synthesize lightId;
@synthesize roomId;
@synthesize state;
@synthesize deviceName;
@synthesize roomName;

-(id)initWithDevicesId:(int)devId andSocketId:(int)sckId andLightId:(int)ltId andRoomId:(int)rmId andState:(int)sta andDeviceName:(NSString *)devName andRoomName:(NSString *)rmName{
        self=[super init];
        if (self) {
            self.devicesId=devId;
            self.socketId=sckId;
            self.lightId=ltId;
            self.roomId=rmId;
            self.state=sta;
            self.deviceName=devName;
            self.roomName=rmName;
        }
        return self;
}

@end
