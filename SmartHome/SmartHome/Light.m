//
//  Light.m
//  SmartHome
//
//  Created by micheal on 15/2/4.
//  Copyright (c) 2015年 renren. All rights reserved.
//

#import "Light.h"

@implementation Light

@synthesize lightId;
@synthesize mac;
@synthesize networkType;
@synthesize onTime;
@synthesize offTime;
@synthesize onTimeState;
@synthesize offTimeState;
@synthesize rgb;
@synthesize luminance;
@synthesize colorTemp;
@synthesize mode;


-(id)initWithLightId:(int)ltId andMac:(NSString *)mac andNetworkType:(int)nkType andOnTime:(NSString *)ontime andOffTime:(NSString *)offtime andOnTimeState:(int)onState andOffTimeState:(int)offState andRGB:(int)rgb andLuminance:(int)luminance andColorTemp:(int)colorTemp andMode:(int)mode{
        self=[super init];
        if (self) {
            self.lightId=ltId;
            self.mac=mac;
            self.networkType=nkType;
            self.onTime=ontime;
            self.offTime=offtime;
            self.onTimeState=onState;
            self.offTimeState=offState;
            self.rgb=rgb;
            self.luminance=luminance;
            self.colorTemp=colorTemp;
            self.mode=mode;
        }
    return self;
}

@end
