//
//  Common.m
//  SmartHome
//
//  Created by micheal on 15/3/5.
//  Copyright (c) 2015年 renren. All rights reserved.
//

#import "Common.h"
#import <UIKit/UIKit.h>
#import <SystemConfiguration/CaptiveNetwork.h>
#import <arpa/inet.h>
#import <netdb.h>
#import <ifaddrs.h>
#import <dlfcn.h>
#import <net/if.h>



@implementation Common

+(NSDictionary *)fetchSSIDInfo
{
    NSArray *interfaceNames = CFBridgingRelease(CNCopySupportedInterfaces());
    NSLog(@"%s: Supported interfaces: %@", __func__, interfaceNames);
    
    NSDictionary *SSIDInfo;
    for (NSString *interfaceName in interfaceNames) {
        SSIDInfo = CFBridgingRelease(
                                     CNCopyCurrentNetworkInfo((__bridge CFStringRef)interfaceName));
        NSLog(@"%s: %@ => %@", __func__, interfaceName, SSIDInfo);
        
        BOOL isNotEmpty = (SSIDInfo.count > 0);
        if (isNotEmpty) {
            break;
        }
    }
    return SSIDInfo;
}

+(void)openSetting{
    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url];
    }
}

+ (NSString *)localWiFiIPAddress
{
    BOOL success;
    struct ifaddrs * addrs;
    const struct ifaddrs * cursor;
    
    success = getifaddrs(&addrs) == 0;
    if (success) {
        cursor = addrs;
        while (cursor != NULL) {
            // the second test keeps from picking up the loopback address  (cursor->ifa_flags & IFF_LOOPBACK)
            if (cursor->ifa_addr->sa_family == AF_INET && (cursor->ifa_flags & IFF_LOOPBACK) == 0)
            {
                NSString *name = [NSString stringWithUTF8String:cursor->ifa_name];
                if ([name isEqualToString:@"en0"])  // Wi-Fi adapter
                    return [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)cursor->ifa_addr)->sin_addr)];
            }
            cursor = cursor->ifa_next;
        }
        freeifaddrs(addrs);
    }
    return nil;
}


+(NSString *)getCurrentTime{
    NSDate *date=[NSDate date];
    NSMutableString *timeStr=[NSMutableString string];
    
    NSCalendar *cal=[NSCalendar currentCalendar];
    unsigned int unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit |NSSecondCalendarUnit;
    NSDateComponents *dd = [cal components:unitFlags fromDate:date];
    
    NSString *hour= [self ToHex:[dd hour]];
    NSString *min=[self ToHex:[dd minute]];
    NSString *sec=[self ToHex:[dd second]];
    
    [timeStr appendString:@"02"];
    [timeStr appendString:hour];
    [timeStr appendString:min];
    [timeStr appendString:sec];
    
//    return [NSArray arrayWithObjects:hour,min,sec,nil];
    return timeStr;
}


+(NSString *)ToHex:(uint16_t)tmpid
{
    NSString *nLetterValue;
    NSString *str =@"";
    uint16_t ttmpig;
    for (int i = 0; i<9; i++) {
        ttmpig=tmpid%16;
        tmpid=tmpid/16;
        switch (ttmpig)
        {
            case 10:
                nLetterValue =@"A";break;
            case 11:
                nLetterValue =@"B";break;
            case 12:
                nLetterValue =@"C";break;
            case 13:
                nLetterValue =@"D";break;
            case 14:
                nLetterValue =@"E";break;
            case 15:
                nLetterValue =@"F";break;
            default:
                nLetterValue = [NSString stringWithFormat:@"%u",ttmpig];
                
        }
        str = [nLetterValue stringByAppendingString:str];
        if (tmpid == 0) {
            break;
        }
    }
    return str;
}

// 将16进制数据转化成Byte 数组
+(NSData *)hexBytesWithOriginMacString:(NSString *)hexString{
    int j=0;
    Byte bytes[4];  ///3ds key的Byte 数组， 128位
    for(int i=0;i<[hexString length];i++)
    {
        int int_ch;  /// 两位16进制数转化后的10进制数
        
        unichar hex_char1 = [hexString characterAtIndex:i]; ////两位16进制数中的第一位(高位*16)
        int int_ch1;
        if(hex_char1 >= '0' && hex_char1 <='9')
            int_ch1 = (hex_char1-48)*16;   //// 0 的Ascll - 48
        else if(hex_char1 >= 'A' && hex_char1 <='F')
            int_ch1 = (hex_char1-55)*16; //// A 的Ascll - 65
        else
            int_ch1 = (hex_char1-87)*16; //// a 的Ascll - 97
        i++;
        
        if(i>=[hexString length]){
//            break;
        }else{
            unichar hex_char2 = [hexString characterAtIndex:i]; ///两位16进制数中的第二位(低位)
            int int_ch2;
            if(hex_char2 >= '0' && hex_char2 <='9')
                int_ch2 = (hex_char2-48); //// 0 的Ascll - 48
            else if(hex_char2 >= 'A' && hex_char2 <='F')
                int_ch2 = hex_char2-55; //// A 的Ascll - 65
            else
                int_ch2 = hex_char2-87; //// a 的Ascll - 97
            
            int_ch = int_ch1+int_ch2;
            NSLog(@"int_ch=%d",int_ch);
            bytes[j] = int_ch; //将转化后的数放入Byte数组里
            j++;
        }
        
    }
    return [NSData dataWithBytes:bytes length:4];
}

//字符串->Byte数组
+(NSData *)hexBytesWithString:(NSString *)hexString{
    NSData *data=[hexString dataUsingEncoding:NSUTF8StringEncoding];
    return data;
}

//开始符
+(NSData *)getBeginCode{
    //开始符
    Byte beginCodeByte[2]={0xAA,0x55};
    NSData *beginData=[NSData dataWithBytes:beginCodeByte length:2];
    
    return beginData;
}

//目标Mac
+(NSData *)getTargetMac:(NSString *)targetMac{
    return [self hexBytesWithString:targetMac];
}

//信息码
+(NSData *)getInfomationCode{
    Byte infoByte[]={0x80};
    NSData *infoData=[NSData dataWithBytes:infoByte length:1];
    return infoData;
}

@end
