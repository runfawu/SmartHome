//
//  Socket.m
//  SmartHome
//
//  Created by micheal on 15/2/4.
//  Copyright (c) 2015年 renren. All rights reserved.
//

#import "Socket.h"

@implementation Socket

@synthesize socketId;
@synthesize onTime;
@synthesize offTime;
@synthesize networkType;
@synthesize mac;
@synthesize onTimeState;
@synthesize offTimeState;

-(id)initWithSocketId:(int)skId andOnTime:(NSString *)ontime andOffTime:(NSString *)offtime andNetworkType:(int)nkType andMac:(NSString *)mac andOnTimeState:(int)onState andOffTimeState:(int)offState{
    self=[super init];
    if (self) {
        self.socketId=skId;
        self.onTime=ontime;
        self.offTime=offtime;
        self.networkType=nkType;
        self.mac=mac;
        self.onTimeState=onState;
        self.offTimeState=offState;
    }
    return self;
}

@end
