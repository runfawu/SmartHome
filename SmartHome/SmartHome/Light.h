//
//  Light.h
//  SmartHome
//
//  Created by micheal on 15/2/4.
//  Copyright (c) 2015年 renren. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Light : NSObject

@property (nonatomic,assign) int inscreaseId;
@property (nonatomic,strong) NSString *mac; //MAC地址
@property (nonatomic,assign) int networkType; //标识内网还是外网 0:内网 1：外网
@property (nonatomic,strong) NSString *onTime; //定时开时间
@property (nonatomic,strong) NSString *offTime; //定时关时间
@property (nonatomic,assign) int *rgb;  //RGB的值
@property (nonatomic,assign) int luminance;  //亮度值
@property (nonatomic,assign) int colorTemp;  //色温值
@property (nonatomic,assign) int mode;  //灯光模式

@end
