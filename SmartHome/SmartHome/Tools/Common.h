//
//  Common.h
//  SmartHome
//
//  Created by micheal on 15/3/5.
//  Copyright (c) 2015年 renren. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Common : NSObject

//获取已连接WiFi
+(NSDictionary *)fetchSSIDInfo;

//IOS8下跳转到设置界面
+(void)openSetting;

//获取wifi ip
+ (NSString *)localWiFiIPAddress;

//获取当前时间 时、分、秒
+(NSArray *)getCurrentTime;

//将十进制转化为十六进制
+(NSString *)ToHex:(uint16_t)tmpid;

//16进制数－>Byte数组
+(NSData *)hexBytesWithOriginMacString:(NSString *)hexString;

//字符串->Byte数组
+(NSData *)hexBytesWithString:(NSString *)hexString;

//UART数据帧格式 配置
/**
 *开始符
 **/
+(NSData *)getBeginCode;

/**
 *配置网络、数据同步、下载数据 目标Mac
 **/
+(NSData *)getTargetMac;

//信息码
+(NSData *)getInfomationCode;
@end
