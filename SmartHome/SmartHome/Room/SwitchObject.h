//
//  SwitchObject.h
//  SmartHome
//
//  Created by Oliver on 15/3/2.
//  Copyright (c) 2015年 renren. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, SwitchType) {
    SwitchTypeLight, // 灯开关
    SwitchTypeSocket // 插座开关
};

@interface SwitchObject : NSObject

@property (nonatomic, strong) NSString *switchName;
@property (nonatomic, strong) NSString *switchImageName;
@property (nonatomic, assign) BOOL switchFlag;
@property (nonatomic, assign) SwitchType switchType;

@end
