//
//  Comon.h
//  SmartHome
//
//  Created by micheal on 15/2/5.
//  Copyright (c) 2015年 renren. All rights reserved.
//

#import <Foundation/Foundation.h>

#define DEVICE_TABLE @"DevicesRegister"
#define LIGHT_TABLE @"Light"
#define SOCKET_TABLE @"Socket"

// DB type macro
#define TYPE_TEXT           @"text"
#define TYPE_BOOLEAN        @"integer"
#define TYPE_INT            @"integer"
#define TYPE_DOUBLE         @"double"
#define TYPE_vChar(s)       ([NSString stringWithFormat:@"varchar(%d)",s])

#define TYPE_DATE           @"date"
#define TYPE_TIME           @"time"
#define TYPE_TIMESTAMP      @"timestamp"
#define TYPE_Decimal(p,s)   ([NSString stringWithFormat:@"decimal(%d,%d)",p,s])

#define TYPE_INT_DEFAULT    @"integer default 0"

#define DEVICE_TABLE_FIELD ({\
[NSDictionary dictionaryWithObjectsAndKeys:\
                            TYPE_INT, @"socketId ",\
                            TYPE_INT,@"lightId",\
                            TYPE_TEXT,@"deviceName",\
                            TYPE_INT, @"roomId",\
                            TYPE_TEXT,@"roomName",\
                            TYPE_INT,@"state",\
                            nil];\
})

#define LIGHT_TABLE_FIELD ({\
[NSDictionary dictionaryWithObjectsAndKeys:\
                            TYPE_TEXT, @"mac",\
                            TYPE_INT,@"netWorkType",\
                            TYPE_TEXT,@"onTime ",\
                            TYPE_TEXT,@"offTime",\
                            TYPE_INT, @"onTimeState",\
                            TYPE_INT,@"offTimeState",\
                            TYPE_INT,@"rgb",\
                            TYPE_INT,@"luminance",\
                            TYPE_INT,@"color_Temp",\
                            TYPE_INT,@"mode",\
                            nil];\
})

#define SOCKET_TABLE_FIELD ({\
[NSDictionary dictionaryWithObjectsAndKeys:\
                            TYPE_TEXT, @"onTime",\
                            TYPE_TEXT,@"offTime",\
                            TYPE_INT, @"netWorkType",\
                            TYPE_TEXT,@"mac",\
                            TYPE_INT,@"onTimeState",\
                            TYPE_INT,@"offTimeState",\
                            nil];\
})


@interface Comon : NSObject

@end
